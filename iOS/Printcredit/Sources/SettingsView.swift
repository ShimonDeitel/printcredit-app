import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) var dismiss
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("weeklySummaryEnabled") private var weeklySummaryEnabled = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Preferences") {
                    Toggle("Notifications", isOn: $notificationsEnabled)
                        .accessibilityIdentifier("notificationsToggle")
                    Toggle("Weekly Summary", isOn: $weeklySummaryEnabled)
                        .accessibilityIdentifier("weeklySummaryToggle")
                }
                Section("Subscription") {
                    if purchases.isPro {
                        Label("Pro Unlocked", systemImage: "checkmark.seal.fill")
                            .foregroundStyle(Theme.accent)
                    } else {
                        Button("Restore Purchases") {
                            Task { await purchases.restore() }
                        }
                        .accessibilityIdentifier("restorePurchasesButton")
                    }
                }
                Section("About") {
                    Link("Privacy Policy", destination: URL(string: "https://shimondeitel.github.io/printcredit-app/privacy.html")!)
                    Link("Terms of Use", destination: URL(string: "https://shimondeitel.github.io/printcredit-app/terms.html")!)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .accessibilityIdentifier("settingsDoneButton")
                }
            }
        }
    }
}
