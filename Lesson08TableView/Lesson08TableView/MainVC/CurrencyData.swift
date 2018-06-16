//
//  CurrencyData.swift
//  Lesson08TableView
//
//  Created by Orest on 30.11.17.
//  Copyright © 2017 Orest Patlyka. All rights reserved.
//

import UIKit

struct Currency: Codable {
    let r030: Int // Individual number
    let txt: String // Full name
    let rate: Double // Exchange rate
    let cc: String // Abbreviation
    let exchangedate: String
}

class CurrencyData: NSObject {
    
    static var check = true
    static var currencys: [Currency] = []
    
    static var currencysDatabase: [CurrencyDatabase] = []
    
    
    static var currencyFullnameDict = [String: String]()
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
                                                 "USD": 1,
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
                                                 "EUR": 1,
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
                                                 "RUB": 1,
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
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate

    static func loadCurrencyData(completionHandler: @escaping () -> () ) {
        let jsonCurrencyUrlString = "https://bank.gov.ua/NBUStatService/v1/statdirectory/exchange?json"
        guard let currencyUrl = URL(string: jsonCurrencyUrlString) else { return }
        
        URLSession.shared.dataTask(with: currencyUrl) { (data, response, err) in
            if let err = err {
                CurrencyData.check = false
                completionHandler()
                print(err.localizedDescription)
            }
            
            guard let data = data else {
                CurrencyData.check = false
                completionHandler()
                return
            }
            
            do {
                CurrencyData.currencys = try JSONDecoder().decode([Currency].self, from: data)
                
                let uahCurrencyObj = Currency(r030: 0, txt: "Ukrainian Hryvnia", rate: 1.0, cc: "UAH", exchangedate: "23.06.1997")
                CurrencyData.currencys.append(uahCurrencyObj)
                
                DispatchQueue.main.async {
                    let context = self.appDelegate.persistentContainer.viewContext
                
                    //fetch and clear
                    do {
                        CurrencyData.currencysDatabase = try context.fetch(CurrencyDatabase.fetchRequest())
                        for currency in CurrencyData.currencysDatabase {
                            context.delete(currency)
                            //print(currency.cc ,"\n", currency.rate)
                        }
                        appDelegate.saveContext()
                    } catch {
                        print(err?.localizedDescription as Any)
                    }
                    
                    //inserting
                    for currency in CurrencyData.currencys {
                        let curObjForDatabase = CurrencyDatabase(context: context)

                        curObjForDatabase.r030 = Int64(currency.r030)
                        curObjForDatabase.txt = currency.txt
                        curObjForDatabase.rate = currency.rate
                        curObjForDatabase.cc = currency.cc
                        curObjForDatabase.exchangedate = currency.exchangedate

                        appDelegate.saveContext()
                    }

                    //fetch
                    do {
                        CurrencyData.currencysDatabase = try context.fetch(CurrencyDatabase.fetchRequest())
                        
                        for currency in CurrencyData.currencysDatabase {
                            print("Currencies from DATABASE: ", currency.cc ,"\n", currency.rate)
                        }
                    } catch {
                        print(err?.localizedDescription as Any)
                    }
                }
        
                //fill the dict
                for i in 0..<CurrencyData.currencys.count {
                    CurrencyData.currencyDict[CurrencyData.currencys[i].cc] = CurrencyData.currencys[i].rate
                }
                CurrencyData.currencyDict["UAH"] = 1.0
                
                for i in 0..<CurrencyData.currencys.count {
                    CurrencyData.currencyFullnameDict[CurrencyData.currencys[i].cc] = CurrencyData.currencys[i].txt
                }
                CurrencyData.currencyFullnameDict["UAH"] = "Українська гривня"
                
                print("LOADING ENDED")
                //print(CurrencyData.currencyDict)
            } catch let jsonErr {
                CurrencyData.check = false
                print("Error from do catch", jsonErr)
                completionHandler()
            }
            
            print("LOAD FUNC ENDED")
            
            completionHandler()
            
        }.resume()
    }
}

