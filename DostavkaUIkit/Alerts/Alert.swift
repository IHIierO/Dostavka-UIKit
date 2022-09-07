//
//  Alert.swift
//  DostavkaUIkit
//
//  Created by Artem Vorobev on 12.08.2022.
//

import UIKit

extension UIViewController{
    func alert(title: String){
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in

            })
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
