//
//  RealmManager.swift
//  DostavkaUIkit
//
//  Created by Artem Vorobev on 12.08.2022.
//

import RealmSwift




class RealmManager {
    
    static let shared = RealmManager()
    
    private init() {}
    
    let localRealm = try! Realm()
    
    func saveHotelPoint(model: HotelPoint) {
        
        try! localRealm.write {
            localRealm.add(model)
        }
    }
}
