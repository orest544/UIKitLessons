//
//  BuyViewController.swift
//  Lesson07SegmentControl
//
//  Created by Orest on 09.11.17.
//  Copyright © 2017 Orest Patlyka. All rights reserved.
//

import UIKit

class BuyViewController: UIViewController {
    
    //MARK: - Properties:
    var cost = 0
    var image: UIImage?
    
    //MARK: - Elements from storyboard:
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var costLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = self.image
       
        costLabel.text = "Cost: " + String(self.cost) + "$"
    }
    
    //MARK: - Actions:
    
    //alert
    @IBAction func buyButtonAction(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: "Insert information to order:", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            if alertController.textFields?.first?.text == "" {
                self.showAlert(title: "Warning!", message: "Text field is empty, please try again and fill the information.", okActionHandler: nil)
            } else {
                self.showAlert(title: "Thanks for order!", message: "Your order will be delivered tomorrow.") { _ in
                    self.performSegue(withIdentifier: "backToMain", sender: nil)
                }
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(ok)
        alertController.addAction(cancel)
        
        alertController.addTextField { textField in
            textField.placeholder = "First name"
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Methods: 
    func showAlert(title: String?, message: String?, okActionHandler: ((UIAlertAction) -> Void)? ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: okActionHandler)
        
        
        alertController.addAction(ok)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
