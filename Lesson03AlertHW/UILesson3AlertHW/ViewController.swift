//
//  ViewController.swift
//  UILesson3AlertHW
//
//  Created by Orest on 18.10.17.
//  Copyright © 2017 Orest Patlyka. All rights reserved.
//
//  ***Currency converter***

import UIKit

class ViewController: UIViewController {
    
    var usd: Double = 0
    var eur: Double = 0
    var uah: Double = 0
    
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var eurLabel: UILabel!
    @IBOutlet weak var uahLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usdLabel.text = "USD:\t0.0"
        self.eurLabel.text = "EUR:\t0.0"
        self.uahLabel.text = "UAH:\t0.0"
    }
    
    //MARK: - Actions
    @IBAction func usdButton(_ sender: Any) {
        
        currency(title: "USD", style: .alert) {(textFromField: String?) -> () in
            if let usdValue = Double(textFromField!) {
                self.usd = usdValue
                self.eur = self.usd * 0.84664537
                self.uah = self.usd * 26.5
            }
        }
    
    }
   
    
    @IBAction func eurButton(_ sender: Any) {
    
        currency(title: "EUR", style: .alert) {(textFromField: String?) -> () in
            if let eurValue = Double(textFromField!) {
                self.eur = eurValue
                self.usd = self.eur * 1.18113208
                self.uah = self.eur * 31.3
            }
        }
    
    }
    
    
    @IBAction func uahButton(_ sender: Any) {
       
        currency(title: "UAH", style: .alert) {(textFromField: String?) -> () in
            if let uanValue = Double(textFromField!) {
                self.uah = uanValue
                self.usd = self.uah / 26.5
                self.eur = self.uah / 31.3
            }
        }
    
    }
    
    //MARK: - Methods
    func currency(title: String, message: String = "Input value", style: UIAlertControllerStyle, countCurrency: @escaping (String?) -> ()) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let action = UIAlertAction(title: "OK", style: .default) { action in
            let textFromField = alertController.textFields?.first?.text
            
            countCurrency(textFromField)
            
            self.usdLabel.text = "USD:\t" + String(self.usd)
            self.eurLabel.text = "EUR:\t" + String(self.eur)
            self.uahLabel.text = "UAH:\t" + String(self.uah)
        }
        
        alertController.addAction(action)
        alertController.addTextField(configurationHandler: nil)
        
        
        self.present(alertController, animated: true, completion: nil)

    }
}
