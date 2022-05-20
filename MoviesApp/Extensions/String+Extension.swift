//
//  String+Extension.swift
//  MoviesApp
//
//  Created by Mostafa Abd ElFatah on 5/17/22.
//

import Foundation


extension String{
    
    var localized:String{
        NSLocalizedString(self, comment: "")
    }
    
    func ifBlank(use string: String) -> String {
        isBlank ? string : self
    }
    
    var isBlank: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == "null"
    }
    
}
