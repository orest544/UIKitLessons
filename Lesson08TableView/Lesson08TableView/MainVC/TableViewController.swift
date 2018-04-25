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

func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
    let result = NSMutableAttributedString()
    result.append(left)
    result.append(right)
    return result
}

class TableViewController: UITableViewController, UITextFieldDelegate, KeyboardCurrencyConverterDelegate {
    let keyboardView = KeyboardCurrencyConverter(frame: CGRect(x: 0, y: 0, width: 0, height: 230))
    
    var currencyNamesArray = [String]()
    var allActiveTextFieldsArray = [UITextField]()
    var textFieldsDict = [UITextField: String]()
    
    var currentCurrencyCC = "UAH"
    var currentTextField = UITextField()
    
    var firstTimeChangedTrigger = true
    
    let formatter: NumberFormatter = {
        let _formatter = NumberFormatter()
        _formatter.numberStyle = .decimal
        _formatter.maximumFractionDigits = 2
        return _formatter
    }()
    
    let myAttributeGray = [NSAttributedStringKey.foregroundColor: UIColor.gray]
    
//    override func loadView() {
//        super.loadView()
//        print("I AM LOADVIEW!")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.center.y = 0
        
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

        //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//       
//        //fetch
//        do {
//            CurrencyData.currencysDatabase = try context.fetch(CurrencyDatabase.fetchRequest())
//            for currency in CurrencyData.currencysDatabase {
//                print(currency.cc, currency.rate)
//            }
//        } catch {
//            print(error.localizedDescription as Any)
//        }
        
        // options for animation
        //self.view.frame.origin.y = -250
        
        print("I AM VIEW DID LOAD!")
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        self.tableView.frame.origin.y = -200
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
//        UIView.animate(withDuration: 0.5) {
//            self.allActiveTextFieldsArray[0].becomeFirstResponder()
//            self.view.frame.origin.y = 0.0
//        }
        
//        UIView.animate(withDuration: 0.7) {
//            self.tableView.frame.origin.y = 0
//            let index = IndexPath(row: 0, section: 0)
//            print(self.firstCellIndexPath)
//            let cell = self.tableView.cellForRow(at: index) as! CustomTableViewCell
//
//            self.tableView.selectRow(at: index, animated: true, scrollPosition: .top)
//            cell.textField.isEnabled = true
//            cell.textField.becomeFirstResponder()
//            self.currentTextField = cell.textField
//        }
        
       
//        let index = IndexPath(row: 0, section: 0)
//        print(self.firstCellIndexPath)
//        let cell = self.tableView.cellForRow(at: index) as! CustomTableViewCell
//
//        self.tableView.selectRow(at: index, animated: true, scrollPosition: .top)
//        cell.textField.isEnabled = true
//        cell.textField.becomeFirstResponder()
//        self.currentTextField = cell.textField
        
        //to choose the 1st row by default and helps the user to get keyboard already
        let topVisibleIndexPath: IndexPath = self.tableView.indexPathsForVisibleRows![0]
        let cell = self.tableView.cellForRow(at: topVisibleIndexPath) as! CustomTableViewCell
        
        self.tableView.selectRow(at: topVisibleIndexPath, animated: true, scrollPosition: .none	)
        cell.textField.isEnabled = true
        cell.textField.becomeFirstResponder()
        self.currentTextField = cell.textField
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
        
        // replace system keyboard with custom keyboard
        cell.textField.inputView = keyboardView
        
        allActiveTextFieldsArray.append(cell.textField) //all textfield has unique code
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
            
            leftFormatted = formatter.string(from: NSNumber(value: Int(left)!))!
            
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
    
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    // Entering point from editing tableView
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue) {
        //currencyNamesArray = ["UAH", "RUB"]
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
        
        let text = sender.text!
        let resultTuple = myFormatter(text)
        
        sender.text = resultTuple.textForTextField
        
        let value: Double = resultTuple.numberForCalculations
    
        let ccKeyOfChoosenTextField = self.textFieldsDict[sender]!
        let exchangeValueOfCurrencyChoosenTextField = CurrencyData.currencyDict[ccKeyOfChoosenTextField]!
        
        for someCurrencyTextField in self.allActiveTextFieldsArray {
            let ccKey = self.textFieldsDict[someCurrencyTextField]!
            let valueForCCKey = CurrencyData.currencyDict[ccKey]!
            
            //all transformations via UAH [Chosen currency -> UAH -> direct currency]
            let result = (value * exchangeValueOfCurrencyChoosenTextField / valueForCCKey).rounded(toPlaces: 2)
            print("result = \(result)")
            
            if result == 0.0 {
                someCurrencyTextField.text = "0"
            } else {
                someCurrencyTextField.text = formatter.string(from: NSNumber(value: result))
            }
        }
         print(sender.text! ,value)
        
        print("allActiveTextFieldArr = \(allActiveTextFieldsArray.count), textFieldsDict: \n\(textFieldsDict.count, " ", textFieldsDict)")
    }
    

    func textFieldDidEndEditing(_ textField: UITextField) {
        print("end editing")
        
        textField.isEnabled = false
        self.firstTimeChangedTrigger = true
    }
    
    
    // MARK - Methods of custom keyboard delegate
    
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

/*

print("editing changed")

var oldText = sender.text!.replacingOccurrences(of: ",", with: "")

if sender.text?.last != "." {
    let formattedText = self.formatter.string(from: NSNumber(value: Double(oldText) ?? 0))
    
    sender.text = formattedText
}

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
    let result = (value * exchangeValueOfCurrencyChoosenTextField / valueForCCKey).rounded(toPlaces: 2)
    print("result = \(result)")
    
    if result == 0.0 {
        someCurrencyTextField.text = "0"
    } else {
        //                var resultStr = String(result)
        //                let twoLast = "5"
        //                print("twoLast = \(String(describing: twoLast))")
        //
        //                let myAttribute = [NSAttributedStringKey.foregroundColor: UIColor.gray/*, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 22.0)*/]
        //                let myAttribute2 = [NSAttributedStringKey.foregroundColor: UIColor.black]
        //
        //                let twoLastAttributed = NSAttributedString(string: String(twoLast), attributes: myAttribute)
        //                let resultStrAtt = NSAttributedString(string: resultStr, attributes: myAttribute2)
        //                //resultStr += String(twoLastAttributed)
        
        
        someCurrencyTextField.text = String(result)//resultStrAtt + twoLastAttributed//String(result)
    }
}
print(sender.text! ,value)*/


/*print("editing changed")
 
 let oldText = sender.text!.replacingOccurrences(of: ",", with: "")
 
 if sender.text?.last != "." {
 let formattedText = self.formatter.string(from: NSNumber(value: Double(oldText) ?? 0))
 
 sender.text = formattedText
 }
 
 if oldText == "0" {
 sender.text = ""
 }
 
 var value: Double = 0.0
 
 if let _value = Double(oldText) {
 value = _value
 }
 
 let ccKeyOfChoosenTextField = self.textFieldsDict[sender]!
 let exchangeValueOfCurrencyChoosenTextField = CurrencyData.currencyDict[ccKeyOfChoosenTextField]!
 
 for someCurrencyTextField in self.allActiveTextFieldsArray {
 let ccKey = self.textFieldsDict[someCurrencyTextField]!
 let valueForCCKey = CurrencyData.currencyDict[ccKey]!
 
 //all transformations via UAH [Chosen currency -> UAH -> direct currency]
 let result = (value * exchangeValueOfCurrencyChoosenTextField / valueForCCKey).rounded(toPlaces: 2)
 print("result = \(result)")
 
 if result == 0.0 {
 someCurrencyTextField.text = "0"
 } else {
 someCurrencyTextField.text = formatter.string(from: NSNumber(value: result))
 }
 }
 print(sender.text! ,value)*/



/* @IBAction func editingChange(_ sender: UITextField) {
 print("editing changed")
 
 let text = sender.text!
 
 let separatedStr = text.components(separatedBy: ".")
 print("separatedStr: ", separatedStr)
 
 var twoLast: String?
 if text.index(of: ".") != nil {
 twoLast = separatedStr[1]
 }
 
 if (sender.text?.count)! > 14 && !(twoLast != nil && (twoLast?.count ?? 0) < 2) {
 self.keyboardView.disableAllNumberKeys()
 } else {
 self.keyboardView.enableAllNumberKeys()
 }
 
 let oldText = sender.text!.replacingOccurrences(of: ",", with: "")
 
 if !(twoLast != nil && (twoLast?.count ?? 0) < 2) { //sender.text?.last != "." {
 let formattedText = self.formatter.string(from: NSNumber(value: Double(oldText) ?? 0))
 
 sender.text = formattedText
 }
 
 if oldText == "0" {
 sender.text = ""
 }
 
 var value: Double = 0.0
 
 if let _value = Double(oldText) {
 value = _value
 }
 
 let ccKeyOfChoosenTextField = self.textFieldsDict[sender]!
 let exchangeValueOfCurrencyChoosenTextField = CurrencyData.currencyDict[ccKeyOfChoosenTextField]!
 
 for someCurrencyTextField in self.allActiveTextFieldsArray {
 let ccKey = self.textFieldsDict[someCurrencyTextField]!
 let valueForCCKey = CurrencyData.currencyDict[ccKey]!
 
 //all transformations via UAH [Chosen currency -> UAH -> direct currency]
 let result = (value * exchangeValueOfCurrencyChoosenTextField / valueForCCKey).rounded(toPlaces: 2)
 print("result = \(result)")
 
 if result == 0.0 {
 someCurrencyTextField.text = "0"
 } else {
 someCurrencyTextField.text = formatter.string(from: NSNumber(value: result))
 }
 }
 print(sender.text! ,value)
 }*/
