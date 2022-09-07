//
//  ListOfHotelsViewController.swift
//  DostavkaUIkit
//
//  Created by Artem Vorobev on 11.08.2022.
//

import UIKit
import RealmSwift

class ListOfHotelsViewController: UIViewController{
    
    let localRealm = try! Realm()
    
    let test = HotelPoint()
    @ObservedResults(HotelPoint.self) var hotelPoint
   
    let countCellsForListOfHotels = 2
    let offsetCellsForListOfHotels: CGFloat = 10.0
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var search = false
    
    @IBOutlet weak var listOfHotelsBackground: UIView!
    @IBOutlet weak var listOfHotels: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        listOfHotels.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        listOfHotelsBackground.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        listOfHotels.delegate = self
        listOfHotels.dataSource = self
        listOfHotels.backgroundColor = UIColor.clear
      
    }
    
}

extension ListOfHotelsViewController: UISearchBarDelegate, UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        
        if !searchText.isEmpty{
            search = true
        }else{
            search = false
        }
        
        listOfHotels.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        search = false
        listOfHotels.reloadData()
    }
}

extension ListOfHotelsViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if search{
            let searchText = searchController.searchBar.text!
            
            return hotelPoint.filter("nameHotel CONTAINS[cd] %@", searchText).count
        }else{
            return hotelPoint.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellForListOfHotels2", for: indexPath) as! ListOfHotelsCell
        
        if search{
            let searchText = searchController.searchBar.text!
            let model = hotelPoint.filter("nameHotel CONTAINS[cd] %@", searchText)[indexPath.row]
            cell.configure(model: model)
        }else{
            
            let model = hotelPoint[indexPath.row]
            cell.configure(model: model)
        }
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
                
        if search{
            let searchText = searchController.searchBar.text!
            let searchGoHotel = hotelPoint.filter("nameHotel CONTAINS[cd] %@", searchText)[indexPath.row]
            vc.hotelPoint = searchGoHotel
        }else{
            let goHotel = hotelPoint[indexPath.row]
            vc.hotelPoint = goHotel
        }
        
        vc.indexPath = indexPath
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
