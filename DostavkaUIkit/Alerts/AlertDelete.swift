//
//  AlertDelete.swift
//  DostavkaUIkit
//
//  Created by Artem Vorobev on 17.08.2022.
//

import UIKit

extension UIViewController{
    func alertDelete(title: String){
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            self.navigationController?.popViewController(animated: true)
            })
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
