//
//  HotelsForDWTableViewController.swift
//  DostavkaUIkit
//
//  Created by Artem Vorobev on 16.08.2022.
//

import UIKit
import RealmSwift

class HotelsForDWTableViewController: UITableViewController {
    var notificationToken: NotificationToken?
    let localRealm = try! Realm()
    
    let cellID = "CellForDWorkTableViewCell"
    
    @ObservedResults(HotelPoint.self, where: {$0.selected == true}) var hotelsIsSelected
    @ObservedResults(HotelPoint.self, where: {$0.isntSelected == true}) var hotelsIsntSelected
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "background"))
        self.tableView.tableHeaderView?.backgroundColor = UIColor.black
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "background"), for: .default)
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            if hotelsIsSelected.isEmpty == false{
                return hotelsIsSelected.count
            }else{
                return 1
            }
            
        }else{
            if hotelsIsntSelected.isEmpty == false{
                return hotelsIsntSelected.count
            }else{
                return 1
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "В Работе"
        }else{
            return "Список Отелей"
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            if hotelsIsSelected.isEmpty == false{
                let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! CellForDWorkTableViewCell
                let model = hotelsIsSelected[indexPath.row]
                cell.configure(model: model)
                cell.compliteOrNotecomplite.image = UIImage(systemName: "plus.circle.fill")
                cell.compliteOrNotecomplite.tag = indexPath.row
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "IfCellIsEmpty") as! IfCellIsEmpty
                cell.textIfIsEmpty.text = "Выбери отель из списка"
                return cell
            }
            
        case 1:
            if hotelsIsntSelected.isEmpty == false{
                let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! CellForDWorkTableViewCell
                let model = hotelsIsntSelected[indexPath.row]
                cell.configure(model: model)
                cell.compliteOrNotecomplite.image = UIImage(systemName: "plus.circle")
                cell.compliteOrNotecomplite.tag = indexPath.row
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "IfCellIsEmpty") as! IfCellIsEmpty
                cell.textIfIsEmpty.text = "Все отели выбраны"
                return cell
            }
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! CellForDWorkTableViewCell
            
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section{
        case 0:
            let model = hotelsIsSelected[indexPath.row]
            GlobalVar.vars.complite = GlobalVar.vars.complite - 1
            try! model.realm?.write{
                model.selected = !model.selected
                model.isntSelected = !model.isntSelected
                model.inWork = !model.inWork
            }
            
            tableView.reloadData()
        case 1:
            let model = hotelsIsntSelected[indexPath.row]
            GlobalVar.vars.complite = GlobalVar.vars.complite + 1
            try! model.realm?.write{
                model.selected = !model.selected
                model.isntSelected = !model.isntSelected
                model.inWork = !model.inWork
            }
            tableView.reloadData()
        default:
            tableView.reloadData()
        }
    }

}
