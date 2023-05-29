//
//  Bitcoin.swift
//  Bitcoin Precio
//
//  Created by Marco Alonso Rodriguez on 29/05/23.
//

import Foundation

struct BitcoinModel: Codable {
    let time: String
    let asset_id_quote: String
    let rate: Double
}
