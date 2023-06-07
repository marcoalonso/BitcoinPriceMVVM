//
//  APIClientTests.swift
//  BitcoinPriceMVVMTests
//
//  Created by Marco Alonso Rodriguez on 07/06/23.
//

import XCTest
@testable import BitcoinPriceMVVM

final class APIClientTests: XCTestCase {

    ///Probar que el service devuelva un obj
    func test_apiclient_getObjectData(){
        let sut = APIClient()
        let exp = expectation(description: "Wait for fetch")
        
        sut.getPriceBitcoin(currency: "USD") { price, error in
            XCTAssertNil(error)
            XCTAssertNotNil(price)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
    }
    
    
    ///Probar que el service devuelva un error
    func test_apiclient_getErrorFromBadRequest(){
        let sut = APIClient()
        let exp = expectation(description: "Wait for fetch")
        
        sut.getPriceBitcoin(currency: "***") { price, error in
            XCTAssertNil(price)
            XCTAssertNotNil(error)
            XCTAssertEqual(error as! NetworkError, NetworkError.decodingError)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
    }


}
