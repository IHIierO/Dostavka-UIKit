//
//  GlobalVar.swift
//  DostavkaUIkit
//
//  Created by Artem Vorobev on 16.08.2022.
//

import Foundation
import UIKit

class GlobalVar {
    
    //creates the instance and guarantees that it's unique
    static let vars = GlobalVar()
    
    private init() {
    }
    
    //creates the global variable
    var inProgress = 0
    var complite = 0
}

