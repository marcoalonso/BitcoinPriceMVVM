//
//  BitcoinPriceMVVMTests.swift
//  BitcoinPriceMVVMTests
//
//  Created by Marco Alonso Rodriguez on 07/06/23.
//

import XCTest
@testable import BitcoinPriceMVVM

final class BitcoinPriceViewControllerTests: XCTestCase {

    func test_createViewController(){
        let sut = BitcoinPriceViewController()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.view.backgroundColor, .white)
    }
    
    ///El view controller contiene un elemento
    func test_createGradient() throws {
        let sut = BitcoinPriceViewController()
        sut.loadViewIfNeeded()
        
        let gradient = sut.gradientLayer
        ///view.layer.addSublayer(gradientLayer)
        let viewContainsGradient = try XCTUnwrap(sut.view.layer.sublayers?.contains(gradient))
        XCTAssert(viewContainsGradient)
    }
    
    //Probar que la vista tiene un elemento
    func test_createPicker() throws {
        let sut = BitcoinPriceViewController()
        sut.loadViewIfNeeded()
        
        let picker = sut.currencyPickerView
        let viewContainsPicker = try XCTUnwrap(sut.view.subviews.contains(picker))
        XCTAssert(viewContainsPicker)
    }
    
    
    
    //Probar que la vista tiene un elemento
    func test_createLabelTitle() throws {
        let sut = BitcoinPriceViewController()
        sut.loadViewIfNeeded()
        
        let label = sut.labelTitle
        let viewContainsLabel = try XCTUnwrap(sut.view.subviews.contains(label))
        XCTAssert(viewContainsLabel)
    }
    
    //Probar que la vista tiene un elemento
    func test_createLabelPrice() throws {
        let sut = BitcoinPriceViewController()
        sut.loadViewIfNeeded()
        
        let label = sut.labelPrice
        let viewContainsLabel = try XCTUnwrap(sut.view.subviews.contains(label))
        XCTAssert(viewContainsLabel)
    }
    
    //Probar que la vista tiene un elemento
    func test_createLabelDate() throws {
        let sut = BitcoinPriceViewController()
        sut.loadViewIfNeeded()
        
        let label = sut.labelDate
        let viewContainsLabel = try XCTUnwrap(sut.view.subviews.contains(label))
        XCTAssert(viewContainsLabel)
    }
    
    //Probar que la vista tiene un elemento
    func test_createImage() throws {
        let sut = BitcoinPriceViewController()
        sut.loadViewIfNeeded()
        
        let image = sut.bitcoinImage
        let viewContainsImage = try XCTUnwrap(sut.view.subviews.contains(image))
        XCTAssert(viewContainsImage)
    }

}
