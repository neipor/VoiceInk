import Foundation
import os

/// A protocol defining the interface for a transcription service.
/// This allows for a unified way to handle both local and cloud-based transcription models.
protocol TranscriptionService {
    /// Transcribes the audio from a given file URL.
    ///
    /// - Parameters:
    ///   - audioURL: The URL of the audio file to transcribe.
    ///   - model: The `TranscriptionModel` to use for transcription. This provides context about the provider (local, OpenAI, etc.).
    /// - Returns: The transcribed text as a `String`.
    /// - Throws: An error if the transcription fails.
    func transcribe(audioURL: URL, model: any TranscriptionModel) async throws -> String
}

final class MLXAudioTranscriptionService: TranscriptionService {
    private let logger = Logger(subsystem: "com.prakashjoshipax.voiceink", category: "MLXAudioTranscriptionService")

    enum ServiceError: Error, LocalizedError {
        case invalidModel
        case unsupportedArchitecture
        case processFailed(String)
        case emptyResult

        var errorDescription: String? {
            switch self {
            case .invalidModel:
                return "Invalid MLX ASR model."
            case .unsupportedArchitecture:
                return "MLX ASR requires Apple Silicon."
            case .processFailed(let message):
                return message
            case .emptyResult:
                return "MLX ASR returned an empty transcription."
            }
        }
    }

    func transcribe(audioURL: URL, model: any TranscriptionModel) async throws -> String {
        guard let model = model as? PlannedASRModel, model.provider == .mlxASR else {
            throw ServiceError.invalidModel
        }

        guard !SystemArchitecture.isIntelMac else {
            throw ServiceError.unsupportedArchitecture
        }

        logger.notice("Starting MLX ASR transcription with \(model.repository, privacy: .public)")

        let output = try await runMLXAudio(modelRepository: model.repository, audioURL: audioURL)
        let cleaned = output.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleaned.isEmpty else {
            throw ServiceError.emptyResult
        }

        return cleaned
    }

    private func runMLXAudio(modelRepository: String, audioURL: URL) async throws -> String {
        let pythonScript = """
import os
import sys
import tempfile

model_repo = sys.argv[1]
audio_path = sys.argv[2]

try:
    from mlx_audio.stt.utils import load_model
    from mlx_audio.stt.generate import generate_transcription
except Exception as exc:
    raise SystemExit(
        "mlx-audio is required for MLX ASR. Install it with: "
        "python3 -m pip install -U mlx-audio huggingface_hub[hf_xet]\\n"
        f"Import error: {exc}"
    )

output_path = tempfile.NamedTemporaryFile(delete=False, suffix=".txt").name
try:
    loaded_model = load_model(model_repo)
    result = generate_transcription(
        model=loaded_model,
        audio_path=audio_path,
        output_path=output_path,
        format="txt",
        verbose=False,
    )

    text = getattr(result, "text", None)
    if not text and os.path.exists(output_path):
        with open(output_path, "r", encoding="utf-8") as handle:
            text = handle.read()

    print(str(text or "").strip())
finally:
    try:
        os.remove(output_path)
    except OSError:
        pass
"""

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["python3", "-c", pythonScript, modelRepository, audioURL.path]
        process.environment = ProcessInfo.processInfo.environment.merging([
            "PATH": "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin",
            "PYTHONUNBUFFERED": "1"
        ]) { current, _ in current }

        let outputPipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = errorPipe

        return try await withCheckedThrowingContinuation { continuation in
            process.terminationHandler = { finishedProcess in
                let stdout = String(data: outputPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
                let stderr = String(data: errorPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""

                if finishedProcess.terminationStatus == 0 {
                    continuation.resume(returning: stdout)
                } else {
                    let message = stderr.trimmingCharacters(in: .whitespacesAndNewlines)
                    continuation.resume(throwing: ServiceError.processFailed(message.isEmpty ? "MLX ASR failed." : message))
                }
            }

            do {
                try process.run()
            } catch {
                continuation.resume(throwing: ServiceError.processFailed(error.localizedDescription))
            }
        }
    }
}
