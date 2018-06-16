//
//  EditViewController.swift
//  Lesson08TableView
//
//  Created by Orest on 28.02.18.
//  Copyright © 2018 Orest Patlyka. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var chosenCurrencyNamesArray = [String]()
    var allCurrencyNamesArray = [String]()
    var sortedCurrencyNamesArray = [String]()
    
    // Arr for search
    var filteredCurrencyNamesArray = [String]()
    var currencyArrayForSearch = [String]()
    
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
        
        filteredCurrencyNamesArray = sortedCurrencyNamesArray
        
        for cc in filteredCurrencyNamesArray {
            let fullname = CurrencyData.currencyFullnameDict[cc] ?? ""
            currencyArrayForSearch.append(cc + " - " + fullname)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)) , name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)) , name: .UIKeyboardWillHide, object: nil)
        
        
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height - 50
            
            var contentInsets = UIEdgeInsets()
            
            contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardHeight, 0.0)
            
            tableView.contentInset = contentInsets
            tableView.scrollIndicatorInsets = contentInsets
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        tableView.contentInset = UIEdgeInsets.zero
        tableView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    // MARK: - TableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCurrencyNamesArray.count
    }
    
    // Creating a cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "EditCell")
        
        let fullname = CurrencyData.currencyFullnameDict[filteredCurrencyNamesArray[indexPath.row]] ?? ""
        cell.textLabel?.text = filteredCurrencyNamesArray[indexPath.row] + " - " + fullname
        cell.tintColor = .black
        cell.backgroundColor = UIColor(red: 239, green: 239, blue: 244)
        cell.contentView.backgroundColor = UIColor(red: 239, green: 239, blue: 244)
        cell.accessoryView?.backgroundColor = UIColor(red: 239, green: 239, blue: 244)
    
        if chosenCurrencyNamesArray.index(of: filteredCurrencyNamesArray[indexPath.row]) != nil {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    // MARK: - Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let chosenCell = tableView.cellForRow(at: indexPath)
            
            if chosenCell?.accessoryType == .checkmark && chosenCurrencyNamesArray.count > 2 {
                chosenCell?.accessoryType = .none
                let index = chosenCurrencyNamesArray.index(of: String((chosenCell?.textLabel?.text?.prefix(3))!))
                chosenCurrencyNamesArray.remove(at: index!)
            } else if chosenCell?.accessoryType != .checkmark {
                chosenCell?.accessoryType = .checkmark
                chosenCurrencyNamesArray.append(String((chosenCell?.textLabel?.text?.prefix(3))!))
            }
    }
    
    // MARK: - SearchBar delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            filteredCurrencyNamesArray = sortedCurrencyNamesArray
            tableView.reloadData()
            return
        }
        
        
        filteredCurrencyNamesArray = currencyArrayForSearch.filter {
            return $0.lowercased().contains(searchText.lowercased())
        }
        
        for i in 0..<filteredCurrencyNamesArray.count {
            filteredCurrencyNamesArray[i] = String(filteredCurrencyNamesArray[i].prefix(3))
        }
        print(filteredCurrencyNamesArray)
        tableView.reloadData()
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
