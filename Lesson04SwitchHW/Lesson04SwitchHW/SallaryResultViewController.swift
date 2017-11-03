//
//  SallaryResultViewController.swift
//  Lesson04SwitchHW
//
//  Created by Orest on 21.10.17.
//  Copyright © 2017 Orest Patlyka. All rights reserved.
//

import UIKit

class SallaryResultViewController: UIViewController {
   
    @IBOutlet weak var resultSallaryLabel: UILabel!
    var sallaryResult = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resultSallaryLabel.text = String(self.sallaryResult) 
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
