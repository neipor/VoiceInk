import Foundation
import AppKit

@MainActor
class LicenseViewModel: ObservableObject {
    enum LicenseState: Equatable {
        case licensed
    }

    @Published private(set) var licenseState: LicenseState = .licensed
    @Published var licenseKey: String = ""
    @Published var isValidating = false
    @Published var validationMessage: String?
    @Published var validationSuccess: Bool = false
    @Published private(set) var activationsLimit: Int = 0

    private let userDefaults = UserDefaults.standard

    init() {
        licenseState = .licensed
    }

    func startTrial() {
        licenseState = .licensed
        NotificationCenter.default.post(name: .licenseStatusChanged, object: nil)
    }
    
    var canUseApp: Bool {
        true
    }
    
    func openPurchaseLink() {
        if let url = URL(string: "https://tryvoiceink.com") {
            NSWorkspace.shared.open(url)
        }
    }
    
    func validateLicense() async {
        licenseState = .licensed
        validationSuccess = true
        validationMessage = "VoiceInk is free to use. No license key is required."
        NotificationCenter.default.post(name: .licenseStatusChanged, object: nil)
    }
    
    func removeLicense() {
        userDefaults.set(false, forKey: "VoiceInkLicenseRequiresActivation")
        userDefaults.set(true, forKey: "VoiceInkHasLaunchedBefore")

        licenseState = .licensed
        licenseKey = ""
        validationMessage = "VoiceInk is free to use. No license key is required."
        validationSuccess = true
        activationsLimit = 0
        NotificationCenter.default.post(name: .licenseStatusChanged, object: nil)
    }
}
