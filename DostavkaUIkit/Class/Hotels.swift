//
//  Hotels.swift
//  DostavkaUIkit
//
//  Created by Artem Vorobev on 10.08.2022.
//

import Foundation
import UIKit
import RealmSwift


class HotelPoint: Object, ObjectKeyIdentifiable {

    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var nameHotel: String = ""
    @Persisted var adresHotel: String = ""
    @Persisted var descriptionHotel: String = ""
    @Persisted var codeArky: String = ""
    @Persisted var codeParadny: String = ""
    @Persisted var locker: String = ""
    @Persisted var selected = false
    @Persisted var isntSelected = true
    @Persisted var inWork = false
    @Persisted var complete = false
    @Persisted var count: String = ""
    
}
