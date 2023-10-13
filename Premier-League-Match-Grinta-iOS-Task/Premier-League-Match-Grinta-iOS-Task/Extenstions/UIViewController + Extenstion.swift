//
//  UIViewController + Extenstion.swift
//  Premier-League-Match-Grinta-iOS-Task
//
//  Created by Mohamed Salah on 13/10/2023.
//

import UIKit

extension UIViewController {
    func show(messageAlert title: String, message: String? = "", actionTitle: String? = nil, action: ((UIAlertAction) -> Void)? = nil) {
        show(title, message: message, actionTitle: actionTitle, action: action)
    }
    
    fileprivate func show(_ title: String,  message: String? = "", actionTitle: String? = nil , action: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let _actionTitle = actionTitle {
            alert.addAction(UIAlertAction(title: _actionTitle , style: .default, handler: action))
        }
        
        alert.addAction(UIAlertAction(title:"close" , style: .cancel,  handler: action))
        
        present(alert, animated: true, completion: nil)
    }
}
