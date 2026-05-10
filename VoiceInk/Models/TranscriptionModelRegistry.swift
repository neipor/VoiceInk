import Foundation

enum TranscriptionModelRegistry {

    static var models: [any TranscriptionModel] {
        return predefinedModels + CustomCloudModelManager.shared.customModels
    }
    
    private static let predefinedModels: [any TranscriptionModel] = {
        let nonCloudModels: [any TranscriptionModel] = [
            // Native Apple Model
            NativeAppleModel(
                name: "apple-speech",
                displayName: "Apple Speech",
                description: "Uses the native Apple Speech framework for transcription. Requires macOS 26",
                isMultilingualModel: true,
                supportedLanguages: LanguageDictionary.forProvider(isMultilingual: true, provider: .nativeApple)
            ),

            // Parakeet Models
            FluidAudioModel(
                name: "parakeet-tdt-0.6b-v2",
                displayName: "Parakeet V2",
                description: "NVIDIA's Parakeet V2 model optimized for lightning-fast English-only transcription",
                size: "474 MB",
                speed: 0.99,
                accuracy: 0.94,
                ramUsage: 0.8,
                supportsStreaming: true,
                supportedLanguages: LanguageDictionary.forProvider(isMultilingual: false, provider: .fluidAudio)
            ),
            FluidAudioModel(
                name: "parakeet-tdt-0.6b-v3",
                displayName: "Parakeet V3",
                description: "Parakeet V3 with English and 25 European language support",
                size: "494 MB",
                speed: 0.99,
                accuracy: 0.94,
                ramUsage: 0.8,
                supportsStreaming: true,
                supportedLanguages: LanguageDictionary.forProvider(isMultilingual: true, provider: .fluidAudio)
            ),

            // Planned ASR presets. These are visible as roadmap entries only; runtime/download support is not wired yet.
            PlannedASRModel(
                name: "qwen3-asr-0.6b-official",
                displayName: "Qwen3 ASR 0.6B",
                description: "Official Hugging Face checkpoint reserved for a future Transformers/Core ML style backend.",
                provider: .huggingFaceASR,
                size: "0.9B params",
                parameterCount: "0.6B",
                precision: "Original",
                repository: "Qwen/Qwen3-ASR-0.6B",
                backend: "Hugging Face",
                supportedLanguages: LanguageDictionary.forProvider(isMultilingual: true, provider: .huggingFaceASR)
            ),
            PlannedASRModel(
                name: "qwen3-asr-1.7b-official",
                displayName: "Qwen3 ASR 1.7B",
                description: "Official larger Qwen3 ASR checkpoint reserved for future high-accuracy local transcription.",
                provider: .huggingFaceASR,
                size: "2B params",
                parameterCount: "1.7B",
                precision: "Original",
                repository: "Qwen/Qwen3-ASR-1.7B",
                backend: "Hugging Face",
                supportedLanguages: LanguageDictionary.forProvider(isMultilingual: true, provider: .huggingFaceASR)
            ),
            PlannedASRModel(
                name: "mlx-community-qwen3-asr-0.6b-4bit",
                displayName: "Qwen3 ASR 0.6B MLX 4bit",
                description: "Apple Silicon friendly MLX Community conversion; likely first target for low-memory MLX support.",
                provider: .mlxASR,
                size: "0.3B params",
                parameterCount: "0.6B",
                precision: "4bit",
                repository: "mlx-community/Qwen3-ASR-0.6B-4bit",
                backend: "MLX",
                supportedLanguages: LanguageDictionary.forProvider(isMultilingual: true, provider: .mlxASR)
            ),
            PlannedASRModel(
                name: "mlx-community-qwen3-asr-0.6b-8bit",
                displayName: "Qwen3 ASR 0.6B MLX 8bit",
                description: "Higher precision MLX preset for a small Qwen3 ASR model on Apple Silicon.",
                provider: .mlxASR,
                size: "0.4B params",
                parameterCount: "0.6B",
                precision: "8bit",
                repository: "mlx-community/Qwen3-ASR-0.6B-8bit",
                backend: "MLX",
                supportedLanguages: LanguageDictionary.forProvider(isMultilingual: true, provider: .mlxASR)
            ),
            PlannedASRModel(
                name: "mlx-community-qwen3-asr-1.7b-4bit",
                displayName: "Qwen3 ASR 1.7B MLX 4bit",
                description: "MLX Community 1.7B preset for balanced accuracy and Apple Silicon acceleration.",
                provider: .mlxASR,
                size: "0.6B params",
                parameterCount: "1.7B",
                precision: "4bit",
                repository: "mlx-community/Qwen3-ASR-1.7B-4bit",
                backend: "MLX",
                supportedLanguages: LanguageDictionary.forProvider(isMultilingual: true, provider: .mlxASR)
            ),
            PlannedASRModel(
                name: "mlx-community-qwen3-asr-1.7b-bf16",
                displayName: "Qwen3 ASR 1.7B MLX bf16",
                description: "Fuller precision MLX preset for quality-focused local ASR experiments.",
                provider: .mlxASR,
                size: "2 GB",
                parameterCount: "1.7B",
                precision: "bf16",
                repository: "mlx-community/Qwen3-ASR-1.7B-bf16",
                backend: "MLX",
                supportedLanguages: LanguageDictionary.forProvider(isMultilingual: true, provider: .mlxASR)
            ),
            PlannedASRModel(
                name: "mlx-community-whisper-large-v3-turbo-asr-6bit",
                displayName: "Whisper Large v3 Turbo MLX 6bit",
                description: "MLX Community Whisper ASR preset for comparing MLX audio pipelines with whisper.cpp.",
                provider: .mlxASR,
                size: "TBD",
                parameterCount: "Large v3 Turbo",
                precision: "6bit",
                repository: "mlx-community/whisper-large-v3-turbo-asr-6bit",
                backend: "MLX",
                supportedLanguages: LanguageDictionary.forProvider(isMultilingual: true, provider: .mlxASR)
            ),
            PlannedASRModel(
                name: "cstr-qwen3-asr-1.7b-gguf",
                displayName: "Qwen3 ASR 1.7B GGUF",
                description: "GGUF preset for future pure CPU or llama.cpp-style backend experiments.",
                provider: .ggufASR,
                size: "2B params",
                parameterCount: "1.7B",
                precision: "GGUF",
                repository: "cstr/qwen3-asr-1.7b-GGUF",
                backend: "GGUF",
                supportedLanguages: LanguageDictionary.forProvider(isMultilingual: true, provider: .ggufASR)
            ),
            PlannedASRModel(
                name: "cstr-mimo-asr-gguf",
                displayName: "MiMo ASR GGUF",
                description: "MiMo ASR GGUF candidate for future CPU-first transcription support.",
                provider: .ggufASR,
                size: "TBD",
                parameterCount: "TBD",
                precision: "GGUF",
                repository: "cstr/mimo-asr-GGUF",
                backend: "GGUF",
                supportedLanguages: LanguageDictionary.forProvider(isMultilingual: true, provider: .ggufASR)
            ),

            // Local Models
            WhisperModel(
                name: "ggml-tiny",
                displayName: "Tiny",
                size: "75 MB",
                supportedLanguages: LanguageDictionary.forProvider(isMultilingual: true, provider: .whisper),
                description: "Tiny model, fastest, least accurate",
                speed: 0.95,
                accuracy: 0.6,
                ramUsage: 0.3
            ),
            WhisperModel(
                name: "ggml-tiny.en",
                displayName: "Tiny (English)",
                size: "75 MB",
                supportedLanguages: LanguageDictionary.forProvider(isMultilingual: false, provider: .whisper),
                description: "Tiny model optimized for English, fastest, least accurate",
                speed: 0.95,
                accuracy: 0.65,
                ramUsage: 0.3
            ),
            WhisperModel(
                name: "ggml-base",
                displayName: "Base",
                size: "142 MB",
                supportedLanguages: LanguageDictionary.forProvider(isMultilingual: true, provider: .whisper),
                description: "Base model, good balance between speed and accuracy, supports multiple languages",
                speed: 0.85,
                accuracy: 0.72,
                ramUsage: 0.5
            ),
            WhisperModel(
                name: "ggml-base.en",
                displayName: "Base (English)",
                size: "142 MB",
                supportedLanguages: LanguageDictionary.forProvider(isMultilingual: false, provider: .whisper),
                description: "Base model optimized for English, good balance between speed and accuracy",
                speed: 0.85,
                accuracy: 0.75,
                ramUsage: 0.5
            ),
            WhisperModel(
                name: "ggml-large-v2",
                displayName: "Large v2",
                size: "2.9 GB",
                supportedLanguages: LanguageDictionary.forProvider(isMultilingual: true, provider: .whisper),
                description: "Large model v2, slower than Medium but more accurate",
                speed: 0.3,
                accuracy: 0.96,
                ramUsage: 3.8
            ),
            WhisperModel(
                name: "ggml-large-v3",
                displayName: "Large v3",
                size: "2.9 GB",
                supportedLanguages: LanguageDictionary.forProvider(isMultilingual: true, provider: .whisper),
                description: "Large model v3, very slow but most accurate",
                speed: 0.3,
                accuracy: 0.98,
                ramUsage: 3.9
            ),
            WhisperModel(
                name: "ggml-large-v3-turbo",
                displayName: "Large v3 Turbo",
                size: "1.5 GB",
                supportedLanguages: LanguageDictionary.forProvider(isMultilingual: true, provider: .whisper),
                description: "Large model v3 Turbo, faster than v3 with similar accuracy",
                speed: 0.75,
                accuracy: 0.97,
                ramUsage: 1.8
            ),
            WhisperModel(
                name: "ggml-large-v3-turbo-q5_0",
                displayName: "Large v3 Turbo (Quantized)",
                size: "547 MB",
                supportedLanguages: LanguageDictionary.forProvider(isMultilingual: true, provider: .whisper),
                description: "Quantized version of Large v3 Turbo, faster with slightly lower accuracy",
                speed: 0.75,
                accuracy: 0.95,
                ramUsage: 1.0
            )
        ]

        let cloudModels: [any TranscriptionModel] = CloudProviderRegistry.allProviders.flatMap { $0.models }
        return nonCloudModels + cloudModels
    }()
}
