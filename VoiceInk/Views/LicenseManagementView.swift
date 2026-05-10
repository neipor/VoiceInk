import SwiftUI

struct LicenseManagementView: View {
    @Environment(\.colorScheme) private var colorScheme
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero Section
                heroSection
                
                // Main Content
                VStack(spacing: 32) {
                    activatedContent
                }
                .padding(32)
            }
        }
        .background(Color(NSColor.controlBackgroundColor))
    }
    
    private var heroSection: some View {
        VStack(spacing: 24) {
            // App Icon
            AppIconView()
            
            // Title Section
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(.blue)
                    
                    HStack(alignment: .lastTextBaseline, spacing: 8) { 
                        Text("VoiceInk")
                            .font(.system(size: 32, weight: .bold))
                        
                        Text("v\(appVersion)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 4)
                    }
                }
                
                Text("Free to use. No license key required.")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                HStack(spacing: 40) {
                    Button {
                        if let url = URL(string: "https://github.com/Beingpax/VoiceInk/releases") {
                            NSWorkspace.shared.open(url)
                        }
                    } label: {
                        featureItem(icon: "list.bullet.clipboard.fill", title: "Changelog", color: .blue)
                    }
                    .buttonStyle(.plain)

                    Button {
                        if let url = URL(string: "https://discord.gg/xryDy57nYD") {
                            NSWorkspace.shared.open(url)
                        }
                    } label: {
                        featureItem(icon: "bubble.left.and.bubble.right.fill", title: "Discord", color: .purple)
                    }
                    .buttonStyle(.plain)

                    Button {
                        EmailSupport.openSupportEmail()
                    } label: {
                        featureItem(icon: "envelope.fill", title: "Email Support", color: .orange)
                    }
                    .buttonStyle(.plain)

                    Button {
                        if let url = URL(string: "https://tryvoiceink.com/docs") {
                            NSWorkspace.shared.open(url)
                        }
                    } label: {
                        featureItem(icon: "book.fill", title: "Docs", color: .indigo)
                    }
                    .buttonStyle(.plain)

                    Button {
                        if let url = URL(string: "https://buymeacoffee.com/beingpax") {
                            NSWorkspace.shared.open(url)
                        }
                    } label: {
                        animatedTipJarItem()
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 8)
            }
        }
        .padding(.vertical, 60)
    }
    
    private var activatedContent: some View {
        VStack(spacing: 32) {
            // Status Card
            VStack(spacing: 24) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.green)
                    Text("Free Version Active")
                        .font(.headline)
                    Spacer()
                    Text("Free")
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(.green))
                        .foregroundStyle(.white)
                }
                
                Divider()
                
                Text("All VoiceInk features are available with no activation or trial limits.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(32)
            .background(CardBackground(isSelected: false))
            .shadow(color: .black.opacity(0.05), radius: 10)
            
        }
    }
    
    private func featureItem(icon: String, title: String, color: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(color)
            
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.primary)
        }
    }
    
    @State private var heartPulse = false
    
    private func animatedTipJarItem() -> some View {
        HStack(spacing: 8) {
            Image(systemName: "heart.fill")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.pink)
                .scaleEffect(heartPulse ? 1.3 : 1.0)
                .animation(
                    Animation.easeInOut(duration: 1.2)
                        .repeatForever(autoreverses: true),
                    value: heartPulse
                )
                .onAppear {
                    heartPulse = true
                }
            
            Text("Tip Jar")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.primary)
        }
    }
}
