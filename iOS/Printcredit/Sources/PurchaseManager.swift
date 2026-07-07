import Foundation
import StoreKit

@MainActor
final class PurchaseManager: ObservableObject {
    static let productID = "com.shimondeitel.printcredit.pro"

    @Published var isPro: Bool = false
    @Published var product: Product?

    private var updatesTask: Task<Void, Never>?

    init() {
        updatesTask = Task { [weak self] in
            for await result in Transaction.updates {
                await self?.handle(result: result)
            }
        }
        Task { await self.loadProduct() }
        Task { await self.refreshEntitlements() }
    }

    deinit {
        updatesTask?.cancel()
    }

    func loadProduct() async {
        do {
            let products = try await Product.products(for: [Self.productID])
            product = products.first
        } catch {
            print("Failed to load product: \(error)")
        }
    }

    func purchase() async {
        guard let product else { return }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                await handle(result: verification)
            default:
                break
            }
        } catch {
            print("Purchase failed: \(error)")
        }
    }

    func restore() async {
        try? await AppStore.sync()
        await refreshEntitlements()
    }

    func refreshEntitlements() async {
        var proFound = false
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result, transaction.productID == Self.productID {
                proFound = true
            }
        }
        isPro = proFound
    }

    private func handle(result: VerificationResult<Transaction>) async {
        if case .verified(let transaction) = result {
            if transaction.productID == Self.productID {
                isPro = true
            }
            await transaction.finish()
        }
    }
}
