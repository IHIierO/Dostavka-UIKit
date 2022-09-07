//
//  MapViewController.swift
//  DostavkaUIkit
//
//  Created by Artem Vorobev on 18.08.2022.
//

import UIKit
import YandexMapsMobile
import CoreLocation

class MapViewController: UIViewController {

    let searchController = UISearchController(searchResultsController: nil)
    var search = false
    
    
    var searchManager: YMKSearchManager?
    var searchSession: YMKSearchSession?
    var searchLayer: YMKSearchLayer?
    
    
    @IBOutlet weak var mapView: YMKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    
        userLocationConfigurate()
        
        
    }
    
    private func userLocationConfigurate(){
        mapView.mapWindow.map.isRotateGesturesEnabled = false
        
        mapView.mapWindow.map.move(with:
            YMKCameraPosition(target: YMKPoint(latitude: 0, longitude: 0), zoom: 14, azimuth: 0, tilt: 0))
        
        let scale = UIScreen.main.scale
        let mapKit = YMKMapKit.sharedInstance()
        let userLocationLayer = mapKit.createUserLocationLayer(with: mapView.mapWindow)
        
        userLocationLayer.setVisibleWithOn(true)
        userLocationLayer.isHeadingEnabled = true
        userLocationLayer.setAnchorWithAnchorNormal(
            CGPoint(x: 0.5 * mapView.frame.size.width * scale, y: 0.5 * mapView.frame.size.height * scale),
            anchorCourse: CGPoint(x: 0.5 * mapView.frame.size.width * scale, y: 0.83 * mapView.frame.size.height * scale))
        userLocationLayer.setObjectListenerWith(self)
        
    }
    
}

extension MapViewController: UISearchBarDelegate, UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!

        if !searchText.isEmpty{
            searchManager = YMKSearch.sharedInstance().createSearchManager(with: .combined)
            
            mapView.mapWindow.map.addCameraListener(with: self)
            
//            mapView.mapWindow.map.move(with:
//                YMKCameraPosition(target: YMKPoint(latitude: 59.953570, longitude: 30.264660), zoom: 14, azimuth: 0, tilt: 0))
        }else{
            
        }

    }
    
   
}

extension MapViewController: YMKMapCameraListener, YMKUserLocationObjectListener{
    
   
    func onCameraPositionChanged(with map: YMKMap,
                                 cameraPosition: YMKCameraPosition,
                                 cameraUpdateReason: YMKCameraUpdateReason,
                                 finished: Bool) {
        
        if finished {
            let searchText = searchController.searchBar.text!
            let responseHandler = {(searchResponse: YMKSearchResponse?, error: Error?) -> Void in
                if let response = searchResponse {
                    self.onSearchResponse(response)
                } else {
                    self.onSearchError(error!)
                }
            }
            
            searchSession = searchManager?.submit(
                withText: searchText,
                geometry: YMKVisibleRegionUtils.toPolygon(with: map.visibleRegion),
                searchOptions: YMKSearchOptions(),
                responseHandler: responseHandler)
        }
    }
    
    func onSearchResponse(_ response: YMKSearchResponse) {
        let mapObjects = mapView.mapWindow.map.mapObjects
        mapObjects.clear()
        for searchResult in response.collection.children {
            if let point = searchResult.obj?.geometry.first?.point {
                let placemark = mapObjects.addPlacemark(with: point)
                placemark.setIconWith(UIImage(named: "SearchResult")!)
                
            }
        }
    }
    
    func onSearchError(_ error: Error) {
        let searchError = (error as NSError).userInfo[YRTUnderlyingErrorKey] as! YRTError
        var errorMessage = "Unknown error"
        if searchError.isKind(of: YRTNetworkError.self) {
            errorMessage = "Network error"
        } else if searchError.isKind(of: YRTRemoteError.self) {
            errorMessage = "Remote server error"
        }
        
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func onObjectAdded(with view: YMKUserLocationView) {
        view.arrow.setIconWith(UIImage(named:"UserArrow")!)
        
        let pinPlacemark = view.pin.useCompositeIcon()
        
        pinPlacemark.setIconWithName(
            "pin",
            image: UIImage(named:"SearchResult")!,
            style:YMKIconStyle(
                anchor: CGPoint(x: 0.5, y: 0.5) as NSValue,
                rotationType:YMKRotationType.rotate.rawValue as NSNumber,
                zIndex: 1,
                flat: true,
                visible: true,
                scale: 1,
                tappableArea: nil))

        view.accuracyCircle.fillColor = UIColor.blue.withAlphaComponent(0.2)
    }

    func onObjectRemoved(with view: YMKUserLocationView) {}

    func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {}
    
}
