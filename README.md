# VoiceInk

VoiceInk is my macOS voice-to-text app for fast local transcription, global shortcuts, and writing workflows.

## neipor patch

This repository is maintained as the `neipor patch` build of VoiceInk.

The paid/Pro license requirement has been removed. This build runs as a free app with all features available, no trial limits, purchase flow, or license activation required.

Future work will focus on expanding ASR model support and improving local/offline transcription workflows.

## Features

- Accurate local speech-to-text transcription
- Privacy-focused offline processing
- Global shortcuts for recording and push-to-talk
- Power Mode for app-aware transcription settings
- Context-aware writing and enhancement workflows
- Personal dictionary and text replacement support
- Smart modes for different writing styles
- AI assistant workflows

## Planned ASR Work

This patch starts with Apple Silicon friendly ASR options. MLX presets are wired through the local `mlx-audio` Python/MLX backend, while GGUF entries remain visible as future CPU backend candidates.

Current planned presets:

- `Qwen/Qwen3-ASR-0.6B` and `Qwen/Qwen3-ASR-1.7B` as the official Hugging Face baselines
- `mlx-community/Qwen3-ASR-0.6B-4bit`, `mlx-community/Qwen3-ASR-0.6B-8bit`, `mlx-community/Qwen3-ASR-1.7B-4bit`, and `mlx-community/Qwen3-ASR-1.7B-bf16` for MLX acceleration through `mlx-audio`
- `mlx-community/whisper-large-v3-turbo-asr-6bit` for MLX Whisper comparison work
- `cstr/qwen3-asr-1.7b-GGUF` and `cstr/mimo-asr-GGUF` for future pure CPU or llama.cpp-style GGUF experiments

To run the MLX presets on Apple Silicon, install the local runtime first:

```shell
python3 -m pip install -U mlx-audio "huggingface_hub[hf_xet]"
```

The first transcription with a selected MLX model may download the model from Hugging Face. GGUF presets are shown in the UI as planned models and cannot be selected until a matching audio-capable GGUF backend is implemented.

## Build From Source

Follow the project build guide:

```shell
open BUILDING.md
```

Typical local build flow:

```shell
make whisper
xcodebuild -project VoiceInk.xcodeproj -scheme VoiceInk -configuration Release build
```

## Requirements

- macOS 14.4 or later
- Xcode
- Swift Package Manager dependencies resolved by Xcode

## License

This project is licensed under the GNU General Public License v3.0. See [LICENSE](LICENSE) for details.

## Acknowledgments

VoiceInk uses and builds on open source technologies including:

- [whisper.cpp](https://github.com/ggerganov/whisper.cpp)
- [FluidAudio](https://github.com/FluidInference/FluidAudio)
- [Sparkle](https://github.com/sparkle-project/Sparkle)
- [KeyboardShortcuts](https://github.com/sindresorhus/KeyboardShortcuts)
- [LaunchAtLogin](https://github.com/sindresorhus/LaunchAtLogin)
- [MediaRemoteAdapter](https://github.com/ejbills/mediaremote-adapter)
- [Zip](https://github.com/marmelroy/Zip)
- [SelectedTextKit](https://github.com/tisfeng/SelectedTextKit)
- [Swift Atomics](https://github.com/apple/swift-atomics)
