//
//  UIViewController+Extension.swift
//  MoviesApp
//
//  Created by Mostafa Abd ElFatah on 5/17/22.
//

import UIKit

extension UIViewController{

    func showAlert(title:String, message:String, btnTitle:String = "OK".localized, hanlder: ((UIAlertAction)-> Void)? = nil){
        let alert = UIAlertController(title: title, message:message , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: btnTitle, style: UIAlertAction.Style.default,handler: hanlder))
        present(alert, animated: true)
    }
    
}
