import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "sparkles")
                .font(.system(size: 56))
                .foregroundStyle(Theme.accent)
            Text("Printcredit Pro")
                .font(Theme.titleFont)
            Text("Per-course print spend breakdown")
                .font(Theme.bodyFont)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            if let product = purchases.product {
                Button {
                    Task { await purchases.purchase() }
                } label: {
                    Text("Unlock for \(product.displayPrice)")
                        .font(Theme.bodyFont.weight(.bold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.accent)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .accessibilityIdentifier("purchaseButton")
                .padding(.horizontal)
            } else {
                ProgressView()
            }

            Button("Restore Purchases") {
                Task { await purchases.restore() }
            }
            .accessibilityIdentifier("paywallRestoreButton")

            Button("Not Now") {
                dismiss()
            }
            .accessibilityIdentifier("paywallDismissButton")
            .padding(.top, 4)
        }
        .padding()
        .background(Theme.background.ignoresSafeArea())
        .onChange(of: purchases.isPro) { _, newValue in
            if newValue { dismiss() }
        }
    }
}
