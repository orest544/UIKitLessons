//
//  TableViewController.swift
//  Lesson08TableView
//
//  Created by Orest on 14.11.17.
//  Copyright © 2017 Orest Patlyka. All rights reserved.
//

import UIKit

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

class TableViewController: UITableViewController, UITextFieldDelegate, KeyboardCurrencyConverterDelegate {
    let keyboardView = KeyboardCurrencyConverter(frame: CGRect(x: 0, y: 0, width: 0, height: 230))
    
    var currencyNamesArray = [String]()
    var allActiveTextFieldsArray = [UITextField]()
    var textFieldsDict = [UITextField: String]()
    
    var currentCurrencyCC = "UAH"
    var currentTextField = UITextField()
    
    var firstTimeChangedTrigger = true


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        CurrencyData.loadCurrencyData()
        //self.title = "Currency exchange"
        self.keyboardView.delegate = self
        
        let array = UserDefaults.standard.object(forKey: "currencyNamesArray") as! [String]
        self.currencyNamesArray = array
        tableView.reloadData()
       
        // options for animation
        //self.view.frame.origin.y = -250
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

//        UIView.animate(withDuration: 0.5) {
//            self.allActiveTextFieldsArray[0].becomeFirstResponder()
//            self.view.frame.origin.y = 0.0
//        }
        
        //to choose the 1st row by default and helps the user to get keyboard already
        let index = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: index) as! CustomTableViewCell
       
        tableView.selectRow(at: index, animated: true, scrollPosition: .top)
        cell.textField.isEnabled = true
        cell.textField.becomeFirstResponder()
        self.currentTextField = cell.textField
    }

    // MARK: - Table view creation
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

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
        
        // replace system keyboard with custom keyboard
        cell.textField.inputView = keyboardView
        
        allActiveTextFieldsArray.append(cell.textField) //all textfield has unique code
        textFieldsDict[cell.textField] = currencyNamesArray[indexPath.row]

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
    
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    // Entering point from editing tableView
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue) {
        currencyNamesArray = ["UAH", "RUB"]
        tableView.reloadData()
    }
    
    // Select a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell selected")
        
        let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
        cell.textField.isEnabled = true
        cell.textField.becomeFirstResponder()
        currentTextField = cell.textField
        //print("cell selected") //, cell.textField)
    }
    
    // MARK: - TextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("begin editing")
        //textField.text = ""
        
        //clean the array with all other textFields exept the choosen
        self.allActiveTextFieldsArray = []
        
        //set the choosen currency
        if let cc = self.textFieldsDict[textField] {
            self.currentCurrencyCC = cc
        }
        
        //fill an array with all other textFields exept the choosen
        for value in self.textFieldsDict.keys {
            self.allActiveTextFieldsArray.append(value)
        }
        self.allActiveTextFieldsArray = self.allActiveTextFieldsArray.filter {
            return $0 == textField ? false : true
        }
    }
    
    @IBAction func editingChange(_ sender: UITextField) {
        print("editing changed")
        
        if sender.text == "0" {
            sender.text = ""
        }
        
        var value: Double = 0.0
        if let text = sender.text {
            if let _value = Double(text) {
                value = _value
            }
        }
        let ccKeyOfChoosenTextField = self.textFieldsDict[sender]!
        let exchangeValueOfCurrencyChoosenTextField = CurrencyData.currencyDict[ccKeyOfChoosenTextField]!
        
        for someCurrencyTextField in self.allActiveTextFieldsArray {
            let ccKey = self.textFieldsDict[someCurrencyTextField]!
            let valueForCCKey = CurrencyData.currencyDict[ccKey]!
            
            //all transformations via UAH [Chosen currency -> UAH -> direct currency]
            let result = (value * exchangeValueOfCurrencyChoosenTextField / valueForCCKey).rounded(toPlaces: 3)
            print("result = \(result)")
            
            if result == 0.0 {
                someCurrencyTextField.text = "0"
            } else {
                someCurrencyTextField.text = String(result)
            }
        }
         print(sender.text! ,value)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("end editing")
        
        textField.isEnabled = false
        self.firstTimeChangedTrigger = true
    }
    
    
    // MARK - Methods of custom keyboard delegate
    
    func keyWasTapped(character: String) {
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
        let editVC = self.storyboard?.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        
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
