//
//  MovieDetailsVC.swift
//  MoviesApp
//
//  Created by Mostafa Abd ElFatah on 5/18/22.
//
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

final class MovieDetailsVC: UIViewController {

    // MARK: - Public properties -
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    var viewModel = MovieDetailsViewModel()
    
    
    // MARK: - Private properties -
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle -
    init() {
        super.init(nibName: "MovieDetails", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayoutUI()
    }
    
    func setupLayoutUI() {
        title = "Movie Details".localized
        viewModel.movieTitle.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.imageURL.bind { [weak self] (imageUrl) in
            guard let self = self else { return }
            self.imageView.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
            self.imageView.sd_setImage(with: URL(string: imageUrl))
        }.disposed(by: disposeBag)
    }

}

// MARK: - Extensions -
extension MovieDetailsVC {
    
}
