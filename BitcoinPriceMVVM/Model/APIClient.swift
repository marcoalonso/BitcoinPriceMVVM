//
//  APIClient.swift
//  BitcoinPriceMVVM
//
//  Created by Marco Alonso Rodriguez on 29/05/23.
//

import Foundation

 public class APIClient {
    public static let shared = APIClient()
    
    init() {}
    
    func getPriceBitcoin(currency: String, completionHandler: @escaping (_ price: BitcoinModel?, _ error: Error?) -> ()) {
        let urlString = "https://rest.coinapi.io/v1/exchangerate/BTC/\(currency)/?apikey=762DEF17-B7CD-49B7-96EC-57D995E9E339"
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, respuesta, error in
                guard let data = data else { return }
                
                let decodificador = JSONDecoder()
                
                do {
                    let dataDecodificada = try decodificador.decode(BitcoinModel.self, from: data)
                    print(dataDecodificada)
                    completionHandler(dataDecodificada, nil)
                } catch {
                    print("Debug: error \(error.localizedDescription)")
                    completionHandler(nil, error)
                }
            }.resume()
        }
    }
}