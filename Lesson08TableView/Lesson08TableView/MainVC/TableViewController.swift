//
//  TableViewController.swift
//  Lesson08TableView
//
//  Created by Orest on 14.11.17.
//  Copyright © 2017 Orest Patlyka. All rights reserved.
//

import UIKit
import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

class TableViewController: UITableViewController, UITextFieldDelegate, KeyboardCurrencyConverterDelegate {
    
    let keyboardView = KeyboardCurrencyConverter(frame: CGRect(x: 0, y: 0, width: 0, height: 203))
    let formatter: NumberFormatter = {
        let _formatter = NumberFormatter()
        _formatter.numberStyle = .decimal
        _formatter.maximumFractionDigits = 2
        return _formatter
    }()
    
    var currencyNamesArray = [String]()
    var textFieldsDict = [UITextField: String]()
    var currentResultsDict = [String: Double]()
    
    var currentCurrencyCC = "UAH"
    var currentTextField = UITextField()
    
    var firstTimeChangedTrigger = true
    
    lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.backgroundColor = .clear
        refresher.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        return refresher
    }()
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //CurrencyData.loadCurrencyData()
        //self.title = "Currency exchange"
        self.keyboardView.delegate = self
        
        let array = UserDefaults.standard.object(forKey: "currencyNamesArray") as! [String]
        self.currencyNamesArray = array
        tableView.reloadData()
        
        for cc in self.currencyNamesArray {
            self.currentResultsDict[cc] = 0.0
        }
        
        tableView.addSubview(refresher)

        tableView.isUserInteractionEnabled = false
        
        print("I AM VIEW DID LOAD!")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        chooseFirstVisibleCell{
            let deadline = DispatchTime.now() + .milliseconds(500)

            DispatchQueue.main.asyncAfter(deadline: deadline, execute: {
                self.tableView.isUserInteractionEnabled = true
            })
        }
    }
    
    // MARK: - Table view creation

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currencyNamesArray.count
    }

    // Configure the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        // Configure the cell
        cell.ccLabel?.text = currencyNamesArray[indexPath.row]
        cell.imageViewFlag?.image = UIImage(named: currencyNamesArray[0 /*indexPath.row*/]) //CHANGES FOR DEV
        cell.textField.tintColor = .clear
        
        // Replace system keyboard with custom keyboard
        cell.textField.inputView = keyboardView
        
        let doubleValueForCurrentTextField = self.currentResultsDict[currencyNamesArray[indexPath.row]]!
        let stringValueForCurrentTextField = formatter.string(from: NSNumber(value: doubleValueForCurrentTextField))!
        cell.textField.text = stringValueForCurrentTextField
    
        // Current 14 cells
        textFieldsDict[cell.textField] = currencyNamesArray[indexPath.row]
        print("newCell")
        
        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Methods
    
    func myFormatter(_ text: String) -> (textForTextField: String, numberForCalculations: Double) {
        let separatedText = text.components(separatedBy: ".")
        
        var left = separatedText[0].replacingOccurrences(of: ",", with: "")
        var leftFormatted = separatedText[0].replacingOccurrences(of: ",", with: "")
        var right = ""
        
        if text != "" {
            
            if left.count > 12 {
                left.removeLast()
            }
            
            leftFormatted = formatter.string(from: NSNumber(value: Int(left) ?? 0))!
            
            if separatedText.count > 1 {
                right = separatedText[1]
                
                if right.count > 2 {
                    right.removeLast()
                }
            }
            
        } else {
            return ("", 0.0)
        }
        
        return separatedText.count > 1 ? (leftFormatted + "." + right, Double(left + "." + right) ?? 0.0)
            : (leftFormatted, Double(left) ?? 0.0)
    }
    
    // To choose the 1st row by default and helps the user to get keyboard already
    func chooseFirstVisibleCell( completionHandler: @escaping () -> () ) {
        let topVisibleIndexPath: IndexPath = self.tableView.indexPathsForVisibleRows![0]
        let cell = self.tableView.cellForRow(at: topVisibleIndexPath) as! CustomTableViewCell
        
        self.tableView.selectRow(at: topVisibleIndexPath, animated: true, scrollPosition: .none)
        cell.textField.isEnabled = true
        cell.textField.becomeFirstResponder()
        self.currentTextField = cell.textField
        
        completionHandler()
    }
    
    // Refresher target
    @objc func refreshData() {
        CurrencyData.loadCurrencyData{
            let deadline = DispatchTime.now() + .milliseconds(700)
            
            DispatchQueue.main.asyncAfter(deadline: deadline, execute: {
                self.refresher.endRefreshing()
            })
        }
    }
    
    // Entering point from EditViewController
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue) {
        
        // Append into the dict All new currencies
        for cc in self.currencyNamesArray {
            self.currentResultsDict[cc] = 0.0
        }
        
        tableView.reloadData()
        self.keyboardView.enableAllNumberKeys()
    }
    
    // Select a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell selected")
        
        let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
        cell.textField.isEnabled = true
        cell.textField.becomeFirstResponder()
        currentTextField = cell.textField
        
        self.keyboardView.enableAllNumberKeys()
        //print("cell selected") //, cell.textField)
    }
    
    // Moving
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Moving
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let cc = self.currencyNamesArray[sourceIndexPath.row]
        self.currencyNamesArray.remove(at: sourceIndexPath.row)
        self.currencyNamesArray.insert(cc, at: destinationIndexPath.row)
    }
    
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    
    // MARK: - TextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("begin editing")
        
        // Set the choosen currency
        if let cc = self.textFieldsDict[textField] {
            self.currentCurrencyCC = cc
        }
        
        // Remove from dict current TextFeild
        textFieldsDict.removeValue(forKey: textField)
    }
    
    @IBAction func editingChange(_ sender: UITextField) {
        print("editing changed")
        
        let text = sender.text!
        let resultTuple = myFormatter(text)
        
        sender.text = resultTuple.textForTextField
        let value: Double = resultTuple.numberForCalculations
        
        self.currentResultsDict[self.currentCurrencyCC] = value
        var tempCurrentResultsDict = currentResultsDict
        tempCurrentResultsDict.removeValue(forKey: self.currentCurrencyCC)
        
        let exchangeValueOfCurrencyChoosenTextField = CurrencyData.currencyDict[self.currentCurrencyCC]!

        for someCurrencyTextField in self.textFieldsDict.keys {
            let ccKey = self.textFieldsDict[someCurrencyTextField]!
            let exchangeValueForCCKey = CurrencyData.currencyDict[ccKey]!
            
            // All transformations via UAH [Chosen currency -> UAH -> direct currency]
            let result = (value * exchangeValueOfCurrencyChoosenTextField / exchangeValueForCCKey).rounded(toPlaces: 2)
            print("result = \(result)")
            
            if result == 0.0 {
                someCurrencyTextField.text = "0"
                currentResultsDict[ccKey] = 0.0
            } else {
                someCurrencyTextField.text = formatter.string(from: NSNumber(value: result))
                currentResultsDict[ccKey] = result
            }
            
            tempCurrentResultsDict.removeValue(forKey: ccKey)
        }
        
        for ccKey in tempCurrentResultsDict.keys {
            let valueForCCKey = CurrencyData.currencyDict[ccKey]!
            
            //all transformations via UAH [Chosen currency -> UAH -> direct currency]
            let result = (value * exchangeValueOfCurrencyChoosenTextField / valueForCCKey).rounded(toPlaces: 2)
            
            if result == 0.0 {
                currentResultsDict[ccKey] = 0.0
            } else {
                currentResultsDict[ccKey] = result
            }
        }

        print(sender.text! ,value)
        
        print(tempCurrentResultsDict)
    }
    

    func textFieldDidEndEditing(_ textField: UITextField) {
        print("end editing")
        
        self.textFieldsDict[currentTextField] = self.currentCurrencyCC
        textField.isEnabled = false
        self.firstTimeChangedTrigger = true
    }
    
    
    // MARK: - Methods of custom keyboard delegate
    
    func numberKeyWasTapped(character: String) {
        if self.firstTimeChangedTrigger && character != "" {
            self.currentTextField.text = ""
            self.currentTextField.insertText("0")
            self.firstTimeChangedTrigger = false
        }
        
        if character == "0" && currentTextField.text != "" {
            currentTextField.insertText(character)
            print("inserting 0")
        } else {
            self.currentTextField.insertText(character)
            print("Inserting = \(character)")
        }
    }
   
    func hideKeyWasTapped() {
        self.view.endEditing(true)
    }
    
    func dotKeyWasTapped() {
        if self.firstTimeChangedTrigger {
            self.currentTextField.text = ""
            self.firstTimeChangedTrigger = false
        }
        
        if currentTextField.text == "" {
            currentTextField.insertText("0.")
        }
        
        if currentTextField.text?.range(of: ".") == nil {
            self.currentTextField.insertText(".")
        }
    }
    
    func backspaceKeyWasTapped() {
        self.currentTextField.deleteBackward()
    }
    
    func clearKeyWasTapped() {
        currentTextField.text = ""
        currentTextField.insertText("0")
        
        firstTimeChangedTrigger = false
    }
    
    func editKeyWasTapped() {
        tableView.isUserInteractionEnabled = false
        
        let editVC = self.storyboard?.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        editVC.chosenCurrencyNamesArray = self.currencyNamesArray
        
        self.present(editVC, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
