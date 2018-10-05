//
//  UIViewController+Alert.swift
//  PairRandomizer
//
//  Created by Jason Goodney on 10/5/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlert(withTitle title: String, message: String, completion: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Full name"
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            guard let name = alertController.textFields?[0].text else { return }
            let item = Item(name: name)
            ItemController.shared.add(item: item)
            completion(true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        [okAction, cancelAction].forEach { alertController.addAction($0) }
        
        present(alertController, animated: true, completion: nil)

    }
}
