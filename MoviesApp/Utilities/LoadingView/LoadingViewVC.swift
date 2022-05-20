//
//  LoadingViewVC.swift
//  MoviesApp
//
//  Created by Mostafa Abd ElFatah on 5/17/22.
//
//

import UIKit

final class LoadingViewVC: UIViewController {

    // MARK: - Public properties -

    // MARK: - Private properties -
    
    // MARK: - Lifecycle -
    init() {
        super.init(nibName: "LoadingView", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

// MARK: - Extensions -
extension LoadingViewVC {
    
}
