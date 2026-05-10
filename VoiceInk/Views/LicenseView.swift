import SwiftUI

struct LicenseView: View {
    var body: some View {
        VStack(spacing: 15) {
            Text("VoiceInk")
                .font(.headline)

            Text("Free to use. No activation required.")
                .foregroundColor(.green)
                .font(.caption)
        }
        .padding()
    }
}

struct LicenseView_Previews: PreviewProvider {
    static var previews: some View {
        LicenseView()
    }
} 
