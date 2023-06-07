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
    
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    
    private(set) lazy var gradientLayer : CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.orange.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        return gradientLayer
    }()
    
    private(set) lazy var currencyPickerView: UIPickerView = {
       let picker = UIPickerView()
        picker.layer.cornerRadius = 15
        picker.layer.borderWidth = 1
        picker.layer.borderColor = UIColor.white.cgColor
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private(set) lazy var labelTitle : UILabel = {
        let label = UILabel()
        label.text = "Bitcoin Price"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .systemFont(ofSize: 40, weight: .regular, width: .standard)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var labelPrice : UILabel = {
        let label = UILabel()
        label.text = "$123456.45"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .systemFont(ofSize: 50, weight: .bold, width: .standard)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
     var labelDate : UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .systemFont(ofSize: 25, weight: .bold, width: .standard)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let labelError : UILabel = {
        let label = UILabel()
        label.text = "!Error al obtener la información!"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 25, weight: .bold, width: .standard)
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
        
        createBindingsWithViewModel()
        
        configUIElements()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        getPrice(with: bitcoinVieModel.exchangeRate.first ?? "USD")
    }
    
    private func createBindingsWithViewModel() {
        ///Se crea un binding del viewModel hacia el labelPrice
        bitcoinVieModel.$bitcoinPrice
            .assign(to: \UILabel.text!, on: labelPrice)
            .store(in: &cancellables)
        
        ///Se crea un binding de la propiedad showLoading para mostrar/ocultar un activity indicator
        bitcoinVieModel.$showLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] showLoading in
                if showLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)

        ///Se crea un binding de la propiedad dateLastPrice para mostrar label con la fecha
        bitcoinVieModel.$dateLastPrice
            .assign(to: \UILabel.text!, on: labelDate)
            .store(in: &cancellables)
        
        ///Se crea el binding para escuchar cuando cambia el valor de $bitcoinPrice y poder actualizar la vista
        bitcoinVieModel.$bitcoinPrice.sink { [weak self] price in
            DispatchQueue.main.async {
                self?.labelPrice.text = price
            }
        }.store(in: &cancellables)
        
        ///Se crea el binding para escuchar cuando cambia el valor de $errorMessage y poder actualizar la vista
        bitcoinVieModel.$errorMessage.sink { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.labelError.text = errorMessage
                self?.labelError.isHidden = false
                self?.activityIndicator.stopAnimating()
            }
        }.store(in: &cancellables)
    }
    
    private func configUIElements(){
        view.backgroundColor = .white
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
        
        [currencyPickerView,
            labelTitle,
            labelPrice,
            labelDate,
            bitcoinImage,
            activityIndicator,
            labelError
        ].forEach(view.addSubview)
        
        activityIndicator.center = view.center
        
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
            
            labelDate.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelDate.topAnchor.constraint(equalTo: labelPrice.bottomAnchor, constant: 20),
            
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
            
            labelError.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelError.topAnchor.constraint(equalTo: bitcoinImage.bottomAnchor, constant: 20),
            labelError.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            labelError.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
        ])
    }
    
    private func getPrice(with currency: String){
        labelError.isHidden = true
        bitcoinVieModel.getPrice(with: currency)
    }


}

extension BitcoinPriceViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bitcoinVieModel.exchangeRate.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bitcoinVieModel.exchangeRate[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Vibracion
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
        
        //call viewModel to get the price
        let currency = bitcoinVieModel.exchangeRate[row]
        print("selectedValue : \(currency)")
        getPrice(with: currency)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = bitcoinVieModel.exchangeRate[row]
        
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
