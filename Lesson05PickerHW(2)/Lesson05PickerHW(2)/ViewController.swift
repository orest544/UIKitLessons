//
//  ViewController.swift
//  Lesson05PickerHW(2)
//
//  Created by Orest on 25.10.17.
//  Copyright © 2017 Orest Patlyka. All rights reserved.
//
//  ***Registration form***

//5 необязательное задание. Только для тех, кто хочет более глубокой прокачки навыков.
//
//Создать шаблон регистрации нового пользователя:
//1 контроллер: выбор между "клиент" и "разработчик".
//Если выбран Клиент - переход на второй контроллер и заполнение 5 текстфилдов: имя, фамилия, пароль, номер банковской карты(4 любых цифры), и емейл.
//+ кнопка Сохранить. После нажатия на неё вылетает alertview с сообщением
//Если выбран Разработчик:
//переход на второй контроллер и заполнение 7 текстфилдов: емейл, имя, фамилия, номер банковской карты, технология(к примеру ios, android, web), язык на котором пишет, опыт в годах.
//+ кнопка Сохранить.
//После нажатия на неё вылетает alertview с сообщением.

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var professionPicker: UIPickerView!
    
    let pickerComponents = ["Developer", "Сustomer"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectButton.layer.borderWidth = 3.0
        selectButton.layer.cornerRadius = 10.0
        selectButton.layer.borderColor = UIColor(white: 1.0, alpha: 0.7).cgColor
        
        professionPicker.dataSource = self
        professionPicker.delegate = self
    }
    
    //MARK: - Actions
    @IBAction func registerButton(_ sender: Any) {
        if professionPicker.selectedRow(inComponent: 0) == 0 {
            performSegue(withIdentifier: "Developer", sender: nil)
        } else {
            performSegue(withIdentifier: "Customer", sender: nil)
        }
    }
}

//MARK: - Extension
extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerComponents.count
    }
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerComponents[row]
    }
}






