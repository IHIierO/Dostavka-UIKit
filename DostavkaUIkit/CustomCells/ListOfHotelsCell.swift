//
//  ListOfHotelsCell.swift
//  DostavkaUIkit
//
//  Created by Artem Vorobev on 11.08.2022.
//

import UIKit

class ListOfHotelsCell: UICollectionViewCell {
    @IBOutlet weak var nameHotelLabel: UILabel!
    
    func configure(model: HotelPoint){
        nameHotelLabel.text = model.nameHotel
        nameHotelLabel.layer.cornerRadius = 10
        nameHotelLabel.layer.masksToBounds = true
        nameHotelLabel.backgroundColor = UIColor.clear
        nameHotelLabel.layer.borderWidth = 2.5
        nameHotelLabel.layer.borderColor = UIColor(hue: 0.754, saturation: 0.964, brightness: 0.604, alpha: 1).cgColor
    }
    
}
