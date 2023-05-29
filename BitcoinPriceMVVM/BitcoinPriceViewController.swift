//
//  ViewController.swift
//  BitcoinPriceMVVM
//
//  Created by Marco Alonso Rodriguez on 29/05/23.
//

import UIKit
import SwiftUI
import Combine

class BitcoinPriceViewController: UIViewController {
    
    private let bitcoinVieModel = BitcoinViewModel(apiClient: APIClient())
    
    var cancellables = Set<AnyCancellable>()
    
    private let gradientLayer : CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.orange.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        return gradientLayer
    }()
    
    private let currencyPickerView: UIPickerView = {
       let picker = UIPickerView()
        picker.layer.cornerRadius = 15
        picker.layer.borderWidth = 1
        picker.layer.borderColor = UIColor.white.cgColor
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let labelTitle : UILabel = {
        let label = UILabel()
        label.text = "Bitcoin Price"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .systemFont(ofSize: 40, weight: .regular, width: .standard)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let labelPrice : UILabel = {
        let label = UILabel()
        label.text = "$123456.45"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .systemFont(ofSize: 50, weight: .bold, width: .standard)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var bitcoinImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bitcoin")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    var exchangeRate = ["USD", "MXN", "EUR", "JPY", "BRL", "CAD"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
        
        createBindingsWithViewModel()
        
        configUIElements()
        
    }
    
    private func createBindingsWithViewModel() {
        ///Se crea un binding del viewModel hacia el labelPrice
        bitcoinVieModel.$bitcoinPrice
            .assign(to: \UILabel.text!, on: labelPrice)
            .store(in: &cancellables)
        
        ///Se crea el binding para escuchar cuando cambia el valor de $bitcoinPrice y poder actualizar la vista
        bitcoinVieModel.$bitcoinPrice.sink { [weak self] price in
            DispatchQueue.main.async {
                self?.labelPrice.text = price
            }
        }.store(in: &cancellables)
    }
    
    private func configUIElements(){
        
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
        
        [currencyPickerView,
            labelTitle,
            labelPrice,
            bitcoinImage
        ].forEach(view.addSubview)
        
        NSLayoutConstraint.activate([
            
            labelTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelTitle.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            labelTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            labelTitle.heightAnchor.constraint(equalToConstant: 60),
            
            labelPrice.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelPrice.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 30),
            labelPrice.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelPrice.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            labelPrice.heightAnchor.constraint(equalToConstant: 60),
            
            currencyPickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currencyPickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            currencyPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            currencyPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            currencyPickerView.heightAnchor.constraint(equalToConstant: 100),
            
            bitcoinImage.heightAnchor.constraint(equalToConstant: 200),
            bitcoinImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bitcoinImage.centerYAnchor.constraint(equalTo: currencyPickerView.bottomAnchor, constant: 150),
            bitcoinImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            bitcoinImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
        ])
    }


}

extension BitcoinPriceViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return exchangeRate.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return exchangeRate[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //call viewModel to get the price
        let selectedValue = exchangeRate[row]
        print("selectedValue : \(selectedValue)")
        bitcoinVieModel.getPrice(with: selectedValue)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = exchangeRate[row]
        
        let color = UIColor.white
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color
        ]
        
        return NSAttributedString(string: title, attributes: attributes)
    }

}

struct ViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = BitcoinPriceViewController
    
    func makeUIViewController(context: Context) -> BitcoinPriceViewController {
        BitcoinPriceViewController()
    }
    
    func updateUIViewController(_ uiViewController: BitcoinPriceViewController, context: Context) {
        
    }
}

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerRepresentable()
    }
}
