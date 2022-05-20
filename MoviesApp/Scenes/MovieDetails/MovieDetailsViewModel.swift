//
//  MovieDetailsViewModel.swift
//  MoviesApp
//
//  Created by Mostafa Abd ElFatah on 5/18/22.
//

import RxSwift
import Foundation


final class MovieDetailsViewModel {
    
    // MARK: - Public properties -
    public var movie = BehaviorSubject<Photo?>(value: nil)
    public var movieTitle = BehaviorSubject<String>(value: "")
    public var imageURL = BehaviorSubject<String>(value: "")
    
    // MARK: - Private properties -
    private let disposeBag = DisposeBag()
    
    
    init(){
        movie.bind{ [weak self] (photo) in
            guard let self = self else { return }
            guard let movie = photo else { return }
            let display = MovieDisplay(movie: movie)
            self.movieTitle.onNext(display.name)
            self.imageURL.onNext(display.image)
        }.disposed(by: disposeBag)
    }
    
    
    
}
