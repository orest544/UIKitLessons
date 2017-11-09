//
//  ViewController.swift
//  Lesson07SegmentControl
//
//  Created by Orest on 04.11.17.
//  Copyright © 2017 Orest Patlyka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Elements from storyboard
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var segmentControll: UISegmentedControl!
    @IBOutlet weak var buyButton: UIButton!
    
    //MARK: - Properties
    let imageArray = [UIImage(named: "keds1.jpg"),
                      UIImage(named: "keds2.jpg"),
                      UIImage(named: "keds3.jpg")]
    let costArray = [300, 500, 700]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buyButton.layer.cornerRadius = 5.0
        
        imageView.image = imageArray[0]
    }
    
    //MARK: - Actions
    @IBAction func segmentControllAction(_ sender: UISegmentedControl) {
        let index = segmentControll.selectedSegmentIndex
        imageView.image = imageArray[index]
    }
    
    //MARK: - Methods
    
    //prepare data when buyButton tochedUpInside
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let buyVC = segue.destination as! BuyViewController
        let index = segmentControll.selectedSegmentIndex
        
        buyVC.cost = costArray[index]
        buyVC.image = imageArray[index]
    }
}

