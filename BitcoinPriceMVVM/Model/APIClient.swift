//
//  APIClient.swift
//  BitcoinPriceMVVM
//
//  Created by Marco Alonso Rodriguez on 29/05/23.
//

import Foundation

enum NetworkError: Error {
    case badRequest
    case decodingError
    case badURL
}

 public class APIClient {
    public static let shared = APIClient()
    
    init() {}
    
    func getPriceBitcoin(currency: String, completionHandler: @escaping (_ price: BitcoinModel?, _ error: Error?) -> ()) {
        let urlString = "https://rest.coinapi.io/v1/exchangerate/BTC/\(currency)/?apikey=88E5E5A4-F87E-4FDE-A0CB-7E3664ADDBC0"
        
        guard let url = URL(string: urlString) else {
            completionHandler(nil, NetworkError.badURL)
            return
        }
        
        print("Debug: \(url)")

            URLSession.shared.dataTask(with: url) { data, respuesta, error in
                
                if error != nil {
                    completionHandler(nil, NetworkError.badRequest)
                }
                
                guard let data = data else { return }
                
                 ///Mostrar data decodificada usando utf8
                let str = String(decoding: data, as: UTF8.self)
                print("Data : \(str)")
                
                let decodificador = JSONDecoder()
                
                do {
                    let dataDecodificada = try decodificador.decode(BitcoinModel.self, from: data)
                    print(dataDecodificada)
                    completionHandler(dataDecodificada, nil)
                } catch {
                    print("Debug: error \(error.localizedDescription)")
                    completionHandler(nil, NetworkError.decodingError)
                }
            }.resume()
        
    }
}
