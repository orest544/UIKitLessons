//
//  CurrencyData.swift
//  Lesson08TableView
//
//  Created by Orest on 30.11.17.
//  Copyright © 2017 Orest Patlyka. All rights reserved.
//

import UIKit

struct Currency: Codable {
    let r030: Int
    let txt: String
    let rate: Double
    let cc: String
    let exchangedate: String
}

class CurrencyData: NSObject {
    
    static var check = true
    static var currencys: [Currency] = []
    //Default values
    static var currencyDict: [String: Double] = ["RON": 1,
                                                 "MYR": 1,
                                                 "IRR": 1,
                                                 "XAU": 1,
                                                 "MDL": 1,
                                                 "GBP": 1,
                                                 "MAD": 1,
                                                 "CZK": 1,
                                                 "SGD": 1,
                                                 "XAG": 1,
                                                 "SEK": 1,
                                                 "AMD": 1,
                                                 "USD": 27.014,
                                                 "HRK": 1,
                                                 "GEL": 1,
                                                 "NZD": 1,
                                                 "TWD": 1,
                                                 "XPD": 1,
                                                 "BGN": 1,
                                                 "KGS": 1,
                                                 "EGP": 1,
                                                 "BDT": 1,
                                                 "HUF": 1,
                                                 "INR": 1,
                                                 "KRW": 1,
                                                 "NOK": 1,
                                                 "DZD": 1,
                                                 "THB": 1,
                                                 "CNY": 1,
                                                 "ZAR": 1,
                                                 "AUD": 1,
                                                 "XDR": 1,
                                                 "PKR": 1,
                                                 "LBP": 1,
                                                 "EUR": 31.949,
                                                 "XPT": 1,
                                                 "AED": 1,
                                                 "TJS": 1,
                                                 "SAR": 1,
                                                 "UAH": 1,
                                                 "IQD": 1,
                                                 "VND": 1,
                                                 "AZN": 1,
                                                 "CAD": 1,
                                                 "DKK": 1,
                                                 "JPY": 1,
                                                 "TND": 1,
                                                 "PLN": 1,
                                                 "BRL": 1,
                                                 "KZT": 1,
                                                 "RUB": 0.463,
                                                 "TMT": 1,
                                                 "HKD": 1,
                                                 "TRY": 1,
                                                 "RSD": 1,
                                                 "BYN": 1,
                                                 "MXN": 1,
                                                 "UZS": 1,
                                                 "ILS": 1,
                                                 "IDR": 1,
                                                 "CHF": 1]
    
    
    static func loadCurrencyData() {
        let jsonCurrencyUrlString = "https://bank.gov.ua/NBUStatService/v1/statdirectory/exchange?json"
        guard let currencyUrl = URL(string: jsonCurrencyUrlString) else { return }
        
        URLSession.shared.dataTask(with: currencyUrl) { (data, response, err) in
            if let err = err {
                CurrencyData.check = false
                print(err.localizedDescription)
            }
            
            guard let data = data else {
                CurrencyData.check = false
                return
            }
            
            do {
                CurrencyData.currencys = try JSONDecoder().decode([Currency].self, from: data)
                
                //fill the dict
                for i in 0..<CurrencyData.currencys.count {
                    CurrencyData.currencyDict[CurrencyData.currencys[i].cc] = CurrencyData.currencys[i].rate
                }
                CurrencyData.currencyDict["UAH"] = 1.0
                //print(CurrencyData.currencyDict)
            } catch let jsonErr {
                CurrencyData.check = false
                print("Error from do catch", jsonErr)
            }
        }.resume()
    }
}

