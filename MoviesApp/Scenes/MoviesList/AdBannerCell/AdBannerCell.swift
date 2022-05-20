//
//  AdBannerCell.swift
//  MoviesApp
//
//  Created by Mostafa Abd ElFatah on 5/18/22.
//

import UIKit

class AdBannerCell: UITableViewCell {

    @IBOutlet weak var bannerImageView: UIImageView!
    
    
    func config(imageNamed:String){
        bannerImageView.image = UIImage(named: imageNamed)
    }
    
    
}
