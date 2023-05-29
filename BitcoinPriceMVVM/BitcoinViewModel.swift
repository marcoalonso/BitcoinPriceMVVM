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
    @Published var dateLastPrice = ""
    
    var exchangeRate = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var cancellables = Set<AnyCancellable>()
    
    let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getPrice(with currency: String) {
        showLoading = true
        apiClient.getPriceBitcoin(currency: currency) { [weak self] price, error in
            guard let price = price else { return }
            
            let precioFormato = price.rate

            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = 1

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM, yy, hh:MM:ss"
            
            let dateLastUpdate = dateFormatter.date(from: price.time)
            let date = dateFormatter.string(from: dateLastUpdate ?? Date.now)
            
            DispatchQueue.main.async {
                
                if let formattedAmount = numberFormatter.string(from: NSNumber(value: precioFormato)) {
                    print(formattedAmount)
                    self?.bitcoinPrice = "$\(formattedAmount)"
                }
                self?.showLoading = false
                self?.dateLastPrice = date
            }
        }
    }
}


