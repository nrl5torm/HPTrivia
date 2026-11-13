//
//  StoreViewModel.swift
//  HPTrivia
//
//  Created by Olivier Sbg on 13/11/2026.
//

import StoreKit

@MainActor
@Observable
class StoreViewModel {
    var questionPacks: [Product] = []
    var purchased = Set<String>()
    
    private var updates: Task<Void, Never>? = nil
    
    init() {
        updates = watchForUpdates()
    }
    
    func loadOptionalQuestionPacks() async {
        do {
            let productIds = ["hp4", "hp5", "hp6", "hp7"]
            questionPacks = try await Product.products(for: productIds)
        } catch {
            print("ERROR: unable to load question pack products. \(error)")
        }
    }
    
    func getQuestionPack(for book: Book) -> Product {
        questionPacks.first { $0.id == book.imageName }!
    }
    
    func purchase(questionPack: Product) async {
        do {
            let result = try await questionPack.purchase()
            switch result {
                
            case .success(let verification):
                switch verification {
                    
                case .unverified(let transaction, let verifyError):
                    print("ERROR: cannot verify \(transaction). \(verifyError)")
                    
                case .verified(let transaction):
                    purchased.insert(transaction.productID)
                    await transaction.finish()
                    print("INFO: successfully purchased question pack \(transaction.productID).")
                }
                
            case .userCancelled:
                print("INFO: user cancelled purchase of question pack \(questionPack.id).")
                break
            case .pending:
                print("INFO: pending result for purchase of question pack \(questionPack.id).")

            @unknown default:
                print("WARNING: unhandled result while purchasing question pack \(questionPack.id).")
            }
        } catch {
            print("ERROR: unable to purchase question pack \(questionPack.id). \(error)")
        }
    }
    
    private func checkPurchased() async -> Void {
        for pack in questionPacks {
            for await entitlement in pack.currentEntitlements {
                switch entitlement {
                    
                case .unverified(let transaction, let verifyError):
                    print("ERROR: cannot verify \(transaction). \(verifyError)")
                    
                case .verified(let transaction):
                    if transaction.revocationDate == nil {
                        purchased.insert(transaction.productID)
                    } else {
                        purchased.remove(transaction.productID)
                        
                        print("INFO: purchase of question pack \(transaction.productID) was revoked on \(transaction.revocationDate!).")
                    }
                }
            }
        }
    }
    
    private func watchForUpdates() -> Task<Void, Never> {
        Task(priority: .background) {
            for await _ in Transaction.updates {
                await checkPurchased()
            }
        }
    }
}
