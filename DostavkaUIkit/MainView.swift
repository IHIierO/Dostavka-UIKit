//
//  MainView.swift
//  DostavkaUIkit
//
//  Created by Artem Vorobev on 08.08.2022.
//

import UIKit
import RealmSwift
import YandexMapsMobile

class MainView: UIViewController {
    var notificationToken: NotificationToken?
    let localRealm = try! Realm()
    
    @ObservedResults(HotelPoint.self) var hotelPoint
    @ObservedResults(HotelPoint.self, where: {$0.inWork == true}) var hotelsInWork
    @ObservedResults(HotelPoint.self, where: {$0.complete == true}) var hotelsEnded
    
    let cellID = "CellForDWorkTableViewCell"
    let countCellsForListOfHotels = 2
    let offsetCellsForListOfHotels: CGFloat = 10.0
    
    @IBOutlet weak var compliteStatus: UILabel!
    
    @IBOutlet weak var listOfHotels: UICollectionView!
    @IBOutlet weak var hotels: UIView!
    @IBOutlet weak var listOfHotelsNavigationBar: UINavigationBar!
    @IBOutlet weak var hotelsBackground: UIView!
    
    @IBOutlet weak var map: YMKMapView!
    @IBOutlet weak var backgroundToMapNavBar: UIView!
    @IBOutlet weak var backgroundMap: UIView!
    @IBOutlet weak var mapViewNavigationBar: UINavigationBar!
    
    @IBOutlet weak var DWork: UIView!
    @IBOutlet weak var presentDWorkTableView: UITableView!
    @IBOutlet weak var backgroundDWork: UIView!
    @IBOutlet weak var dWorkNavBar: UINavigationBar!
    
    override func viewWillAppear(_ animated: Bool) {
        presentDWorkTableView.reloadData()
        compliteStatus.text = "\(GlobalVar.vars.inProgress) из \(GlobalVar.vars.complite)"
        listOfHotels.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        dWorkConfig()
        hotelsConfig()
        mapConfig()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
       
    }
    private func dWorkConfig(){
        presentDWorkTableView.delegate = self
        presentDWorkTableView.dataSource = self
        compliteStatus.layer.cornerRadius = 10
        compliteStatus.text = "\(GlobalVar.vars.inProgress) из \(GlobalVar.vars.complite)"
        compliteStatus.layer.masksToBounds = true
        compliteStatus.layer.borderWidth = 2.5
        compliteStatus.layer.borderColor = UIColor(hue: 0.754, saturation: 0.964, brightness: 0.604, alpha: 1).cgColor
        
        DWork.layer.cornerRadius = 10
        DWork.layer.masksToBounds = false
        DWork.layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
        DWork.layer.shadowOpacity = 0.5
        DWork.layer.shadowRadius = 15.0
        DWork.layer.shadowOffset = CGSize.zero
        DWork.layer.compositingFilter = "darkenBlendMode"
        
        backgroundDWork.layer.cornerRadius = 10
        backgroundDWork.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        
        dWorkNavBar.layer.cornerRadius = 10
        dWorkNavBar.layer.masksToBounds = true
        dWorkNavBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        dWorkNavBar.shadowImage = UIImage()
        dWorkNavBar.isTranslucent = true
        
        presentDWorkTableView.layer.cornerRadius = 10
    }
    private func hotelsConfig(){
        listOfHotels.delegate = self
        listOfHotels.dataSource = self
        listOfHotels.backgroundColor = UIColor.clear
        
        hotels.layer.cornerRadius = 10
        hotels.layer.masksToBounds = false
        hotels.layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
        hotels.layer.shadowOpacity = 0.5
        hotels.layer.shadowRadius = 15.0
        hotels.layer.shadowOffset = CGSize.zero
        hotels.layer.compositingFilter = "darkenBlendMode"
        
        hotelsBackground.layer.cornerRadius = 10
        hotelsBackground.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        
        listOfHotelsNavigationBar.layer.cornerRadius = 10
        listOfHotelsNavigationBar.layer.masksToBounds = true
        listOfHotelsNavigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        listOfHotelsNavigationBar.shadowImage = UIImage()
        listOfHotelsNavigationBar.isTranslucent = true
        
    }
    private func mapConfig(){
        backgroundToMapNavBar.layer.cornerRadius = 10
        backgroundToMapNavBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        backgroundToMapNavBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
        backgroundToMapNavBar.layer.shadowOpacity = 0.5
        backgroundToMapNavBar.layer.shadowRadius = 15.0
        backgroundToMapNavBar.layer.shadowOffset = CGSize.zero
        backgroundToMapNavBar.layer.compositingFilter = "darkenBlendMode"
        
        backgroundMap.layer.cornerRadius = 10
        backgroundMap.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        backgroundMap.layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
        backgroundMap.layer.shadowOpacity = 0.5
        backgroundMap.layer.shadowRadius = 15.0
        backgroundMap.layer.shadowOffset = CGSize(width: 0, height: 10)
        
        map.layer.cornerRadius = 10
        map.layer.masksToBounds = true
        map.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

        mapViewNavigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        mapViewNavigationBar.shadowImage = UIImage()
        mapViewNavigationBar.isTranslucent = true
        
        map.mapWindow.map.move(
            with: YMKCameraPosition.init(target: YMKPoint(latitude: 59.953570, longitude: 30.264660), zoom: 15, azimuth: 0, tilt: 0),animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
                cameraCallback: nil)
    }
    
    @IBAction func compliteButton(_ sender: Any) {
        
        GlobalVar.vars.inProgress = 0
        GlobalVar.vars.complite = 0
        
        let realm = try! Realm()
        let hotelsComplete = realm.objects(HotelPoint.self).where{$0.complete == true}
        let hotelsInWork = realm.objects(HotelPoint.self).where{$0.inWork == true}
        let hotelsIsSelected = realm.objects(HotelPoint.self).where{$0.selected == true}
        let hotelsIsntSelected = realm.objects(HotelPoint.self).where{$0.isntSelected == false}
        
        try! realm.write {
            hotelsComplete.setValue(false, forKey: "complete")
            hotelsInWork.setValue(false, forKey: "inWork")
            hotelsIsSelected.setValue(false, forKey: "selected")
            hotelsIsntSelected.setValue(true, forKey: "isntSelected")
        }
        presentDWorkTableView.reloadData()
        compliteStatus.text = "\(GlobalVar.vars.inProgress) из \(GlobalVar.vars.complite)"
    }
}

extension MainView: UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource{
    
    //MARK: PresentListOfHotels
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotelPoint.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellForListOfHotels", for: indexPath) as! ListOfHotelsCell
        let model = hotelPoint[indexPath.row]
        cell.configure(model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frameCV = listOfHotels.frame
        
        let widthCell = frameCV.width / CGFloat(countCellsForListOfHotels)
        let heightCell = frameCV.height / CGFloat(countCellsForListOfHotels)
        
        let spasing = CGFloat((countCellsForListOfHotels + 1)) * offsetCellsForListOfHotels / CGFloat(countCellsForListOfHotels)
        
        return CGSize(width: widthCell - spasing, height: heightCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let vc = storyboard?.instantiateViewController(withIdentifier: "DescripHotelTableViewController") as! DescripHotelTableViewController
        
        let goHotel = hotelPoint[indexPath.row]
        vc.hotelPoint = goHotel
        vc.indexPath = indexPath
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: PresentDWork
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
                indexPath = self.presentDWorkTableView.indexPath(for: cell)! as NSIndexPath
                
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
            presentDWorkTableView.reloadData()
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
            presentDWorkTableView.reloadData()
        default:
            presentDWorkTableView.reloadData()
        }
    }
}


