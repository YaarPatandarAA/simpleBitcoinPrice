//
//  ViewController.swift
//  simpleBitcoinPrice
//
//  Created by Amarjit Singh on 11/30/18.
//  Copyright © 2018 Amarjit Singh. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""
    
    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        getBitcoinPrice(url: (baseURL+currencyArray[0]), currRow: 0)
    }
    
    
    //TODO: Place your 3 UIPickerView delegate methods here
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        getBitcoinPrice(url: finalURL, currRow: row)
    }
    
    
    
        //MARK: - Networking
        /***************************************************************/
    
    func getBitcoinPrice(url: String, currRow: Int) {
            Alamofire.request(url, method: .get)
                .responseJSON { response in
                    if response.result.isSuccess {
                        print("Sucess! Got the data")
                        let bitcoinJSON : JSON = JSON(response.result.value!)
    
                        self.updateBitcoinData(json: bitcoinJSON, currRow: currRow)
    
                    } else {
                        print("Error: \(String(describing: response.result.error))")
                        self.bitcoinPriceLabel.text = "Connection Issues"
                    }
                }
        }
    
    
    
    
    
        //MARK: - JSON Parsing
        /***************************************************************/
    
    func updateBitcoinData(json : JSON, currRow: Int) {
            if json["ask"].double != nil{
                updateUIData(btcPrice: json["ask"].doubleValue, currRow: currRow)
            }
        }
    
    func updateUIData(btcPrice: Double, currRow: Int){
        bitcoinPriceLabel.text = "\(currencySymbolArray[currRow])" + "\(btcPrice)"
    }
    
    
    
    
    
}

