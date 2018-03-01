//
//  KeyboardCurrencyConverter.swift
//  Lesson08TableView
//
//  Created by Orest on 23.02.18.
//  Copyright © 2018 Orest Patlyka. All rights reserved.
//

import UIKit

protocol KeyboardCurrencyConverterDelegate: class {
    func keyWasTapped(character: String)
    func hideKeyWasTapped()
    func dotKeyWasTapped()
    func backspaceKeyWasTapped()
    func clearKeyWasTapped()
    func editKeyWasTapped()
}

class KeyboardCurrencyConverter: UIView, UIInputViewAudioFeedback {

    @IBOutlet weak var button_1: UIButton!
    @IBOutlet weak var button_2: UIButton!
    @IBOutlet weak var button_3: UIButton!
    @IBOutlet weak var button_4: UIButton!
    @IBOutlet weak var button_5: UIButton!
    @IBOutlet weak var button_6: UIButton!
    @IBOutlet weak var button_7: UIButton!
    @IBOutlet weak var button_8: UIButton!
    @IBOutlet weak var button_9: UIButton!
    @IBOutlet weak var button_0: UIButton!
    @IBOutlet weak var button_dot: UIButton!
    @IBOutlet weak var button_C: UIButton!
    @IBOutlet weak var button_backspace: UIButton!
    @IBOutlet weak var button_hide: UIButton!
    @IBOutlet weak var button_edit: UIButton!
    
    weak var delegate: KeyboardCurrencyConverterDelegate?
    var enableInputClicksWhenVisible = true
    
    // MARK: - Keyboard initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    // MARK: - Methods
    
    func initializeSubviews() {
        let xibFileName = "KeyboardCurrencyConverter" // xib extention not included
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)![0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
    
        buttonConfigurating(button_1)
        buttonConfigurating(button_2)
        buttonConfigurating(button_3)
        buttonConfigurating(button_4)
        buttonConfigurating(button_5)
        buttonConfigurating(button_6)
        buttonConfigurating(button_7)
        buttonConfigurating(button_8)
        buttonConfigurating(button_9)
        buttonConfigurating(button_0)
        buttonConfigurating(button_dot)
        buttonConfigurating(button_C)
        buttonConfigurating(button_backspace)
        buttonConfigurating(button_hide)
        buttonConfigurating(button_edit)
    }
    
    func buttonConfigurating(_ sender: UIButton) {
        // Shadows
        sender.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        sender.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        sender.layer.shadowOpacity = 1.0
        sender.layer.shadowRadius = 0.0
        sender.layer.masksToBounds = false
    }
    
    
    // MARK: - Button actions from .xib file
    
    @IBAction func keyTapped(_ sender: UIButton) {
        UIDevice.current.playInputClick()
        
        // When a button is tapped, send that information to the
        // delegate (ie, the view controller)
        switch sender.tag {
        case 0: // Numbers 0 - 9
            self.delegate?.keyWasTapped(character: sender.titleLabel!.text!)
        case 1: // Dot
            self.delegate?.dotKeyWasTapped()
        case 2: // Edit
            self.delegate?.editKeyWasTapped()
        case 3: // Clear
            self.delegate?.clearKeyWasTapped()
        case 4: // Backspace
            self.delegate?.backspaceKeyWasTapped()
        case 5: // Hide
            self.delegate?.hideKeyWasTapped()
        default:
            break
        }
        
        print("Tapped = \(sender.titleLabel!.text!)")
    }
}
