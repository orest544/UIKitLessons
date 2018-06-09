//
//  EditViewController.swift
//  Lesson08TableView
//
//  Created by Orest on 28.02.18.
//  Copyright © 2018 Orest Patlyka. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var chosenCurrencyNamesArray = [String]()
    var allCurrencyNamesArray = [String]()
    var sortedCurrencyNamesArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        for currency in CurrencyData.currencys {
            allCurrencyNamesArray.append(currency.cc)
        }
        allCurrencyNamesArray.sort()
        
        sortedCurrencyNamesArray = allCurrencyNamesArray.filter {
            return chosenCurrencyNamesArray.index(of: $0) != nil ? false : true
        }
        
        for cc in chosenCurrencyNamesArray.reversed() {
            sortedCurrencyNamesArray.insert(cc, at: 0)
        }
    }
    
    // MARK: - TableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedCurrencyNamesArray.count
    }
    
    // Creating a cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "EditCell")
        
        cell.textLabel?.text = sortedCurrencyNamesArray[indexPath.row]
        cell.tintColor = .black
        cell.backgroundColor = UIColor(red: 239, green: 239, blue: 244)
        cell.contentView.backgroundColor = UIColor(red: 239, green: 239, blue: 244)
        cell.accessoryView?.backgroundColor = UIColor(red: 239, green: 239, blue: 244)
    
        if chosenCurrencyNamesArray.index(of:
            sortedCurrencyNamesArray[indexPath.row]) != nil {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    // MARK: - Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let chosenCell = tableView.cellForRow(at: indexPath)
            
            if chosenCell?.accessoryType == .checkmark && chosenCurrencyNamesArray.count > 2 {
                chosenCell?.accessoryType = .none
                
                let index = chosenCurrencyNamesArray.index(of: (chosenCell?.textLabel?.text)!)
                chosenCurrencyNamesArray.remove(at: index!)
            } else if chosenCell?.accessoryType != .checkmark {
                chosenCell?.accessoryType = .checkmark
                chosenCurrencyNamesArray.append((chosenCell?.textLabel?.text)!)
            }
    }
    
    // Move
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("sourceIndexPath: ", sourceIndexPath, "destinationIndexPath", destinationIndexPath)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let tableVC = segue.destination as! MainViewController
        tableVC.currencyNamesArray = chosenCurrencyNamesArray
    }
    

}
