//
//  SettingsStoreViewModel.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 13/11/2026.
//

import StoreKit

@MainActor
@Observable
class SettingsStoreViewModel {
    var products: [Product] = []
    var purchased = Set<String>()
    
    private var updates: Task<Void, Never>? = nil
    
    func loadProducts() async {
        do {
            products = try await Product.products(for: ["hp4", "hp5", "hp6", "hp7"])
            products.sort {
                $0.displayName < $1.displayName
            }
        } catch {
            print("ERROR: unable to load products. \(error)")
        }
    }
    
    func purchase(product: Product) async {
        do {
            let result = try await product.purchase()
            switch result {
                
            case .success(let verification):
                switch verification {
                    
                case .unverified(let transaction, let verifyError):
                    print("ERROR: cannot verify \(transaction). \(verifyError)")
                    
                case .verified(let transaction):
                    purchased.insert(transaction.productID)
                    await transaction.finish()
                }
                
            case .userCancelled:
                print("INFO: user cancelled purchase of product \(product.id).")
                break
            case .pending:
                print("INFO: pending result for purchase of product \(product.id).")

            @unknown default:
                print("WARNING: unknown result while purchasing product \(product.id).")
            }
        } catch {
            print("ERROR: unable to purchase product \(product.id). \(error)")
        }
    }
}
