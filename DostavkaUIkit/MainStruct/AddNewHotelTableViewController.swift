//
//  AddNewHotelTableViewController.swift
//  DostavkaUIkit
//
//  Created by Artem Vorobev on 10.08.2022.
//

import UIKit
import RealmSwift

class AddNewHotelTableViewController: UITableViewController{

    let localRealm = try! Realm()
    
    
    @IBOutlet weak var adressHotelTextField: UITextField!
    @IBOutlet weak var nameHotelTextField: UITextField!
    @IBOutlet weak var codeLockerTextField: UITextField!
    @IBOutlet weak var codeParadnyTextField: UITextField!
    @IBOutlet weak var codeArkyTextField: UITextField!
    @IBOutlet weak var descripHotelTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        textFieldConfig()

    }

    @IBAction func saveButton(_ sender: Any) {
        saveData()
        view.endEditing(true)
        alert(title: "Сохранено")
        clearTextField()
        
    }
    private func textFieldConfig(){
        nameHotelTextField.delegate = self
        adressHotelTextField.delegate = self
        descripHotelTextField.delegate = self
        codeArkyTextField.delegate = self
        codeParadnyTextField.delegate = self
        codeLockerTextField.delegate = self
    }
    private func saveData(){
        let hotelPoint = HotelPoint()
        
        hotelPoint.nameHotel = self.nameHotelTextField.text!
        hotelPoint.adresHotel = self.adressHotelTextField.text!
        hotelPoint.descriptionHotel = self.descripHotelTextField.text!
        hotelPoint.codeArky = self.codeArkyTextField.text!
        hotelPoint.codeParadny = self.codeParadnyTextField.text!
        hotelPoint.locker = self.codeLockerTextField.text!
      
        RealmManager.shared.saveHotelPoint(model: hotelPoint)
    }
    private func clearTextField(){
        nameHotelTextField.text = ""
        adressHotelTextField.text = ""
        descripHotelTextField.text = ""
        codeArkyTextField.text = ""
        codeParadnyTextField.text = ""
        codeLockerTextField.text = ""
    }
    
}

extension AddNewHotelTableViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if text.isEmpty{
            saveButton.isEnabled = false
        }else{
            saveButton.isEnabled = true
        }
        return true
    }
    
}
