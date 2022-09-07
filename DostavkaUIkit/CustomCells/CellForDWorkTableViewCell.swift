//
//  CellForDWorkTableViewCell.swift
//  DostavkaUIkit
//
//  Created by Artem Vorobev on 10.08.2022.
//

import UIKit
import RealmSwift

//protocol CellForDWorkTableViewCellDelegate: AnyObject{
//    func compliteOrNotcompliteAction(whith image: UIImage)
//}

class CellForDWorkTableViewCell: UITableViewCell {
//    weak var delegate: CellForDWorkTableViewCellDelegate?
    
    let localRealm = try! Realm()
    var hotelPoint = HotelPoint()

    @IBOutlet weak var compliteOrNotecomplite: UIImageView!
    @IBOutlet weak var infoHotelButton: UIButton!
    @IBOutlet weak var hotelName: UILabel!
    override func awakeFromNib() {
        
        super.awakeFromNib()

    }

    @IBAction func infoHotelButtonAction(_ sender: Any) {
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
  
    }

    func configure(model: HotelPoint){
        
        hotelName.text = model.nameHotel
        
    }
    
   
}
