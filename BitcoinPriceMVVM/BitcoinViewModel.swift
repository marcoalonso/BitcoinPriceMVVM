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
    @Published var errorMessage = ""
    
    var exchangeRate = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    
    let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getPrice(with currency: String) {
        showLoading = true
        apiClient.getPriceBitcoin(currency: currency) { [weak self] price, error in
            
            if error != nil {
                DispatchQueue.main.async {
                    switch error as! NetworkError {
                    case .badRequest:
                        self?.errorMessage = "Error, el servidor no responde."
                    case .badURL:
                        self?.errorMessage = "Error, la url que intentas acceder no existe."
                    case .decodingError:
                        self?.errorMessage = "Error, no pudo decodificar la informacion."
                    }
                }
            }
            
            guard let price = price else { return }
            
            let precioFormato = price.rate

            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = 1

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM, yy, hh:MM"
            
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


