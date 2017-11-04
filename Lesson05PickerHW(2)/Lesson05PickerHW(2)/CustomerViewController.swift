//
//  CustomerViewController.swift
//  Lesson05PickerHW(2)
//
//  Created by Orest on 31.10.17.
//  Copyright © 2017 Orest Patlyka. All rights reserved.
//

import UIKit

class CustomerViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var backToMainMenuButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.delegate = self // якшо підписати делегата тоді буде працювати return на клаві і буде закривати клаву
        
        saveButton.layer.cornerRadius = 5.0
        
        backToMainMenuButton.layer.cornerRadius = 5.0
        backToMainMenuButton.layer.borderWidth = 1.0
        backToMainMenuButton.layer.borderColor = UIColor.blue.cgColor
        
        passwordTextField.isSecureTextEntry = true
    }
    
    //MARK: - Actions
    @IBAction func saveButton(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(action)
        
        if !isEmptyAllTextFields() && checkCardNumberInput() {
            alertController.title = "Registration is complete!"
        } else if isEmptyAllTextFields() {
            alertController.title = "WARNING!"
            alertController.message = "Some fields are empty!"
        } else {
            alertController.title = "WARNING!"
            alertController.message = "Card number is invalid"
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
   
    //MARK: - Methods
    private func isEmptyAllTextFields() -> Bool {
        let arrayTextField = [firstNameTextField,lastNameTextField,passwordTextField, cardNumberTextField, emailTextField]
        
        for i in 0..<arrayTextField.count {
            if arrayTextField[i]?.text == "" {
                return true
            }
        }
        
        return false
    }
    
    private func checkCardNumberInput() -> Bool {
        guard let text = cardNumberTextField.text else { return false }
        
        let textSeparatedComponents = text.components(separatedBy: " ")
        var separatedText = ""
        
        for i in 0..<textSeparatedComponents.count {
            separatedText += textSeparatedComponents[i]
        }

        return Int(separatedText) != nil ? true : false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //to hide keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }
}
