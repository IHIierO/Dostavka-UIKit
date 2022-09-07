//
//  DWorkViewController.swift
//  DostavkaUIkit
//
//  Created by Artem Vorobev on 09.08.2022.
//

import UIKit
import RealmSwift

class DWorkViewController: UIViewController {
    let localRealm = try! Realm()
    var notificationToken: NotificationToken?
    
    let cellID = "CellForDWorkTableViewCell"
    
    @ObservedResults(HotelPoint.self, where: {$0.inWork == true}) var hotelsInWork
    @ObservedResults(HotelPoint.self, where: {$0.complete == true}) var hotelsEnded
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var compliteStatus: UILabel!
    @IBOutlet weak var choseHotel: UIButton!
    @IBOutlet weak var background: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        compliteStatus.text = "\(GlobalVar.vars.inProgress) из \(GlobalVar.vars.complite)"
    }
    override func viewDidLoad() {
        navigationController?.hidesBarsOnSwipe = false
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "background"), for: .default)
        background.layer.backgroundColor = UIColor.white.withAlphaComponent(0.2).cgColor
        compliteStatusConfig()
        tableViewConfig()
        choseHotelConfig()
    }
    
    private func compliteStatusConfig(){
        compliteStatus.layer.cornerRadius = 10
        compliteStatus.text = "\(GlobalVar.vars.inProgress) из \(GlobalVar.vars.complite)"
        compliteStatus.layer.masksToBounds = true
        compliteStatus.layer.borderWidth = 2.5
        compliteStatus.layer.borderColor = UIColor(hue: 0.754, saturation: 0.964, brightness: 0.604, alpha: 1).cgColor
    }
    private func tableViewConfig(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.layer.compositingFilter = "darkenBlendMode"
    }
    private func choseHotelConfig(){
        choseHotel.layer.cornerRadius = 10
        choseHotel.layer.masksToBounds = true
        choseHotel.layer.borderWidth = 2.5
        choseHotel.layer.borderColor = UIColor(hue: 0.754, saturation: 0.964, brightness: 0.604, alpha: 1).cgColor
    }
}


extension DWorkViewController: UITableViewDelegate, UITableViewDataSource{
   
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            if hotelsInWork.isEmpty == false{
                return hotelsInWork.count
            }else{
                return 1
            }
            
        }else{
            if hotelsEnded.isEmpty == false{
                return hotelsEnded.count
            }else{
                return 1
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "В Работе"
        }else{
            return "Выполнено"
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            if hotelsInWork.isEmpty == false{
                let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! CellForDWorkTableViewCell
                let model = hotelsInWork[indexPath.row]
                cell.configure(model: model)
                cell.compliteOrNotecomplite.image = UIImage(systemName: "plus.circle.fill")
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "IfCellIsEmpty") as! IfCellIsEmpty
                cell.textIfIsEmpty.text = "Выбери отель из списка"
                return cell
            }
            
        case 1:
            if hotelsEnded.isEmpty == false{
                let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! CellForDWorkTableViewCell
                let model = hotelsEnded[indexPath.row]
                cell.configure(model: model)
                cell.compliteOrNotecomplite.image = UIImage(systemName: "plus.circle")
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "IfCellIsEmpty") as! IfCellIsEmpty
                cell.textIfIsEmpty.text = "Доставь завтраки"
                return cell
            }
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! CellForDWorkTableViewCell
            
            return cell
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCardHotel"{
            let vc = segue.destination as! DescripHotelTableViewController
            let indexPath: NSIndexPath
            
            if let button = sender as? UIButton {
                let cell = button.superview?.superview as! UITableViewCell
                indexPath = self.tableView.indexPath(for: cell)! as NSIndexPath
                
                switch indexPath.section{
                case 0:
                    let goHotel = hotelsInWork[indexPath.row]
                    vc.hotelPoint = goHotel
                case 1:
                    let goHotel = hotelsEnded[indexPath.row]
                    vc.hotelPoint = goHotel
                default:
                    let goHotel = hotelsInWork[indexPath.row]
                    vc.hotelPoint = goHotel
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section{
        case 0:
            let model = hotelsInWork[indexPath.row]
            GlobalVar.vars.inProgress = GlobalVar.vars.inProgress + 1
            compliteStatus.text = "\(GlobalVar.vars.inProgress) из \(GlobalVar.vars.complite)"
            try! model.realm?.write{
                model.inWork = !model.inWork
                model.complete = !model.complete
                model.selected = !model.selected
                model.isntSelected = !model.isntSelected
            }
            
            tableView.reloadData()
        case 1:
            let model = hotelsEnded[indexPath.row]
            GlobalVar.vars.inProgress = GlobalVar.vars.inProgress - 1
            compliteStatus.text = "\(GlobalVar.vars.inProgress) из \(GlobalVar.vars.complite)"
            try! model.realm?.write{
                model.inWork = !model.inWork
                model.complete = !model.complete
                model.selected = !model.selected
                model.isntSelected = !model.isntSelected
            }
            tableView.reloadData()
        default:
            tableView.reloadData()
        }
    }
 
    
}
