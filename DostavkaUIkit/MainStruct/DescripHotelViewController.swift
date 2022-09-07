//
//  DescripHotelTableViewController.swift
//  DostavkaUIkit
//
//  Created by Artem Vorobev on 08.08.2022.
//

import UIKit
import RealmSwift

class DescripHotelTableViewController: UITableViewController {
    let localRealm = try! Realm()
    var hotelPoint = HotelPoint()
    var isUpdating = true
    
    var indexPath:IndexPath!
    
    @IBOutlet weak var saveOrChangeButton: UIBarButtonItem!
    @IBOutlet weak var adressHotelTextField: UITextField!
    @IBOutlet weak var nameHotelTextField: UITextField!
    @IBOutlet weak var codeLockerTextField: UITextField!
    @IBOutlet weak var codeParadnyTextField: UITextField!
    @IBOutlet weak var codeArkyTextField: UITextField!
    @IBOutlet weak var descripHotelTextField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        textFieldConfig()
        saveOrChangeButton.title = "Изменить"
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "background"))
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "background"), for: .default)
        
        
    }
     
    @IBAction func saveOrChangeAction(_ sender: Any) {
        if isUpdating == true {
            textFieldEnabled()
            isUpdating = false
            buttonTitle()
            deleteButton.isHidden = false
      } else {
          saveChanseData()
          alert(title: "Сохранено")
          textFieldNoneEnabled()
          view.endEditing(true)
          isUpdating = true
          buttonTitle()
          deleteButton.isHidden = true
      }
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        
        try! localRealm.write {
            let deleteHotelPoint = localRealm.objects(HotelPoint.self).where{$0.nameHotel == nameHotelTextField.text!}
            localRealm.delete(deleteHotelPoint)
        }
        
        alertDelete(title: "Удалено")
        
    }
    
    private func textFieldConfig(){
        nameHotelTextField.delegate = self
        adressHotelTextField.delegate = self
        descripHotelTextField.delegate = self
        codeArkyTextField.delegate = self
        codeParadnyTextField.delegate = self
        codeLockerTextField.delegate = self
        
        nameHotelTextField.isEnabled = false
        adressHotelTextField.isEnabled = false
        descripHotelTextField.isEnabled = false
        codeArkyTextField.isEnabled = false
        codeParadnyTextField.isEnabled = false
        codeLockerTextField.isEnabled = false
        
        nameHotelTextField.text = hotelPoint.nameHotel
        adressHotelTextField.text = hotelPoint.adresHotel
        descripHotelTextField.text = hotelPoint.descriptionHotel
        codeArkyTextField.text = hotelPoint.codeArky
        codeParadnyTextField.text = hotelPoint.codeParadny
        codeLockerTextField.text = hotelPoint.locker
    }
    private func saveChanseData(){
        try! localRealm.write {
            hotelPoint.nameHotel = self.nameHotelTextField.text!
            hotelPoint.adresHotel = self.adressHotelTextField.text!
            hotelPoint.descriptionHotel = self.descripHotelTextField.text!
            hotelPoint.codeArky = self.codeArkyTextField.text!
            hotelPoint.codeParadny = self.codeParadnyTextField.text!
            hotelPoint.locker = self.codeLockerTextField.text!
            localRealm.add(hotelPoint)
        }
    }
    private func textFieldEnabled(){
        nameHotelTextField.isEnabled = true
        adressHotelTextField.isEnabled = true
        descripHotelTextField.isEnabled = true
        codeArkyTextField.isEnabled = true
        codeParadnyTextField.isEnabled = true
        codeLockerTextField.isEnabled = true
    }
    private func textFieldNoneEnabled(){
        nameHotelTextField.isEnabled = false
        adressHotelTextField.isEnabled = false
        descripHotelTextField.isEnabled = false
        codeArkyTextField.isEnabled = false
        codeParadnyTextField.isEnabled = false
        codeLockerTextField.isEnabled = false
    }
    private func buttonTitle(){
        if isUpdating{
            saveOrChangeButton.title = "Изменить"
        }else{
            saveOrChangeButton.title = "Сохранить"
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 0.0
        }
        return UITableView.automaticDimension
    }
}

extension DescripHotelTableViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
