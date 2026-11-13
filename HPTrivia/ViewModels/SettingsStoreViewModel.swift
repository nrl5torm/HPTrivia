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
}
