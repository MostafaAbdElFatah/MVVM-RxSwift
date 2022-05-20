//
//  UITableView+Extesion.swift
//  MoviesApp
//
//  Created by Mostafa Abd ElFatah on 5/17/22.
//

import UIKit

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        backgroundView = messageLabel
        separatorStyle = .none
    }

    func hiddenEmptyMessage() {
        backgroundView = nil
        separatorStyle = .singleLine
    }
}
