import SwiftUI
import AppKit

struct ModelCardView: View {
    let model: any TranscriptionModel
    let fluidAudioModelManager: FluidAudioModelManager
    let transcriptionModelManager: TranscriptionModelManager
    let isDownloaded: Bool
    let isCurrent: Bool
    let downloadProgress: [String: Double]
    let modelURL: URL?
    let isWarming: Bool

    // Actions
    var deleteAction: () -> Void
    var setDefaultAction: () -> Void
    var downloadAction: () -> Void
    var editAction: ((CustomCloudModel) -> Void)?
    var body: some View {
        Group {
            switch model.provider {
            case .whisper:
                if let whisperModel = model as? WhisperModel {
                    WhisperModelCardView(
                        model: whisperModel,
                        isDownloaded: isDownloaded,
                        isCurrent: isCurrent,
                        downloadProgress: downloadProgress,
                        modelURL: modelURL,
                        isWarming: isWarming,
                        deleteAction: deleteAction,
                        setDefaultAction: setDefaultAction,
                        downloadAction: downloadAction
                    )
                } else if let importedModel = model as? ImportedWhisperModel {
                    ImportedWhisperModelCardView(
                        model: importedModel,
                        isDownloaded: isDownloaded,
                        isCurrent: isCurrent,
                        modelURL: modelURL,
                        deleteAction: deleteAction,
                        setDefaultAction: setDefaultAction
                    )
                }
            case .fluidAudio:
                if let fluidAudioModel = model as? FluidAudioModel {
                    FluidAudioModelCardView(
                        model: fluidAudioModel,
                        fluidAudioModelManager: fluidAudioModelManager,
                        transcriptionModelManager: transcriptionModelManager
                    )
                }
            case .nativeApple:
                if let nativeAppleModel = model as? NativeAppleModel {
                    NativeAppleModelCardView(
                        model: nativeAppleModel,
                        isCurrent: isCurrent,
                        setDefaultAction: setDefaultAction
                    )
                }
            case .huggingFaceASR, .mlxASR, .ggufASR:
                if let plannedModel = model as? PlannedASRModel {
                    PlannedASRModelCardView(
                        model: plannedModel,
                        isCurrent: isCurrent,
                        isAvailable: transcriptionModelManager.isAvailableOnCurrentOS(plannedModel),
                        setDefaultAction: setDefaultAction
                    )
                }
            case .custom:
                if let customModel = model as? CustomCloudModel {
                    CustomModelCardView(
                        model: customModel,
                        isCurrent: isCurrent,
                        setDefaultAction: setDefaultAction,
                        deleteAction: deleteAction,
                        editAction: editAction ?? { _ in }
                    )
                }
            default:
                if let cloudModel = model as? CloudModel {
                    CloudModelCardView(
                        model: cloudModel,
                        isCurrent: isCurrent,
                        setDefaultAction: setDefaultAction
                    )
                }
            }
        }
    }
}

struct PlannedASRModelCardView: View {
    let model: PlannedASRModel
    let isCurrent: Bool
    let isAvailable: Bool
    var setDefaultAction: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(model.displayName)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(.labelColor))

                    Text(statusLabel)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(isAvailable ? .green : .orange)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background((isAvailable ? Color.green : Color.orange).opacity(0.12))
                        .clipShape(Capsule())

                    Spacer()
                }

                HStack(spacing: 12) {
                    Label(model.backend, systemImage: "cpu")
                    Label(model.parameterCount, systemImage: "slider.horizontal.3")
                    Label(model.precision, systemImage: "dial.low")
                    Label(model.size, systemImage: "internaldrive")
                }
                .font(.system(size: 11))
                .foregroundColor(Color(.secondaryLabelColor))
                .lineLimit(1)

                Text(model.description)
                    .font(.system(size: 11))
                    .foregroundColor(Color(.secondaryLabelColor))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 4)

                Text(model.repository)
                    .font(.system(size: 11, weight: .medium, design: .monospaced))
                    .foregroundColor(Color(.secondaryLabelColor))
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            actionSection
        }
        .padding(16)
        .background(CardBackground(isSelected: isCurrent, useAccentGradientWhenSelected: isCurrent))
    }

    private var statusLabel: String {
        if model.provider == .mlxASR && isAvailable { return "MLX" }
        return "Planned"
    }

    private var actionSection: some View {
        HStack(spacing: 8) {
            if isCurrent {
                Text("Default Model")
                    .font(.system(size: 12))
                    .foregroundColor(Color(.secondaryLabelColor))
            } else if model.provider == .mlxASR && isAvailable {
                Button(action: setDefaultAction) {
                    Text("Set as Default")
                        .font(.system(size: 12))
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .help("Requires python3 and mlx-audio on this Mac")
            } else {
                Text("Not wired")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(.secondaryLabelColor))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.secondary.opacity(0.08))
                    .clipShape(Capsule())
            }
        }
    }
}
