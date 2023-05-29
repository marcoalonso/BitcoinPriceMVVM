//
//  BitcoinViewModel.swift
//  BitcoinPriceMVVM
//
//  Created by Marco Alonso Rodriguez on 29/05/23.
//

import Foundation
import Combine

class BitcoinViewModel {
    @Published var bitcoinPrice = "0.0"
    @Published var showLoading = false
    
    var cancellables = Set<AnyCancellable>()
    
    let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getPrice(with currency: String) {
        showLoading = true
        apiClient.getPriceBitcoin(currency: currency) { [weak self] price, error in
            guard let price = price?.rate else { return }
            
            let precioFormato = String(format: "%.1f", price)
            
            DispatchQueue.main.async {
                self?.bitcoinPrice = "$\(precioFormato)"
                self?.showLoading = false
            }
        }
    }
}
