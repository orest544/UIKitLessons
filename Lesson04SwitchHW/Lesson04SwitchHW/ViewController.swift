//
//  ViewController.swift
//  Lesson04SwitchHW
//
//  Created by Orest on 21.10.17.
//  Copyright © 2017 Orest Patlyka. All rights reserved.
//
//  ***Salary calculator***

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sallaryPerHourTextField: UITextField!
    @IBOutlet weak var hoursTextField: UITextField!
    
    @IBOutlet weak var armyFee10Switch: UISwitch!
    @IBOutlet weak var taxFee20Switch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.taxFee20Switch.setOn(false, animated: false)
        self.armyFee10Switch.setOn(false, animated: false)

    }

    //MARK: - Actions
    @IBAction func calculateButton(_ sender: Any) {
        let sallaryResultVC = self.storyboard?.instantiateViewController(withIdentifier: "SallaryResultViewController") as! SallaryResultViewController
       
        sallaryResultVC.sallaryResult = self.calculateSallary()
       
        self.present(sallaryResultVC, animated: true, completion: nil)
    }

    
    //MARK: - Methonds
    func checkFeeSwitches() -> Double {
        if self.armyFee10Switch.isOn && self.taxFee20Switch.isOn {
            return 0.7
        } else if self.taxFee20Switch.isOn {
            return 0.8
        } else if self.armyFee10Switch.isOn {
            return 0.9
        } else {
            return 1
        }
    }
    
    func calculateSallary() -> Double {
        var sallary = 0.0
        
        if let sallaryPerHourValue = Double(self.sallaryPerHourTextField.text!) {
            if let hoursValue = Double(self.hoursTextField.text!) {
                sallary = sallaryPerHourValue * hoursValue
            }
        }
        
        sallary *= checkFeeSwitches()
        
        return sallary
    }
    
    //to hide a keyboar
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}


