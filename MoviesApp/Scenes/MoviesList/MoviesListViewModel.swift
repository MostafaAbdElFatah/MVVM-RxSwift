//
//  MoviesListViewModelVC.swift
//  MoviesApp
//
//  Created by Mostafa Abd ElFatah on 5/17/22.
//
//

import RxSwift
import Foundation


public enum State: Equatable {
    case empty
    case loading
    case fetched
    case error(String)
}

final class MoviesListViewModel {

    // MARK: - Public properties -
    public var searchText = BehaviorSubject<String>(value: "")
    public var state = BehaviorSubject<State>(value: .empty)
    public var movies = BehaviorSubject<[Any]>(value: [])
    
    // MARK: - Private properties -
    private var currentPage:Int = 1
    private var totalPages:Int = 1
    private var allMovies:[Photo] = []
    private var disposeBag = DisposeBag()
    private var networkManager:MoviesAPIsManagerProtocol
    
    // MARK: - Init -
    init(networkManger:MoviesAPIsManagerProtocol = MoviesAPIsManager() ){
        self.networkManager = networkManger
        searchText.bind { [weak self] (text) in
            guard let self = self else { return }
            if text.isBlank { return }
            self.searchingDidChanged(text: text)
        }.disposed(by: disposeBag)
    }
    
    // MARK: - fetchMovies -
    func createCellDispaly(photo:Photo) -> MovieDisplay {
        MovieDisplay(movie: photo)
    }

    func openAdBanner() {
        openLink("https://www.getkoinz.com/")
    }
    
    private func openLink(_ link:String){
        let application = UIApplication.shared
        guard let url = URL(string: link) else { return }
        application.open( url, options: [:])
    }
    
    func isBanner(row:Int)-> Bool {
        guard let moviesList = try? self.movies.value() else { return false }
        return moviesList[row] is String
    }
    
    func object(at row:Int) -> Photo?{
        guard let moviesList = try? self.movies.value() else { return nil }
        return moviesList[row] as? Photo
    }
    
    
    func searchingDidChanged(text:String){
        let filterList = allMovies.filter({ $0.title.contains(text)})
        //inject adBanner every five item
        let moviesList = filterList.injectAdBanners()
        self.movies.onNext(moviesList)
    }
    
    // MARK: - fetchMovies -
    func fetchMoviesList() {
        if currentPage > totalPages {
            state.onNext(.fetched)
            return
        }
        
        if let currentState = try? state.value(), case .empty = currentState {
            state.onNext(.loading)
        }
        
        let urlString = URLs.flickrURL(page: currentPage)
        
        guard let url = URL(string: urlString) else {
            self.state.onNext(.error(NetworkAPIError.invalidURL.localizedDescription))
            return
        }
        
        networkManager.fetchMovies(from: url) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.state.onNext(.fetched)
                self.totalPages = response.photosList.pages
                self.currentPage = response.photosList.page + 1
                self.allMovies.append(contentsOf: response.photosList.photos)
                //inject adBanner every five item
                let moviesList = self.allMovies.injectAdBanners()
                self.movies.onNext(moviesList)
            case .failure(let error):
                self.state.onNext(.error(error.localizedDescription))
            }
        }
    }

}

// MARK: - Extensions -
extension MoviesListViewModel {
    
}

extension Array {
    
    
    func injectAdBanners()->[Any]{
        let insertions:[String] = [Int](0...7).map({ "adBanner\($0)" })
        
        var list:[Any] = self
        for index in self.indices.dropFirst().reversed() where index.isMultiple(of: 4) {
            list.insert(insertions.randomItem(), at: index)
        }
        return list
    }
    
    func randomItem() -> Element{
        self[Int.random(in: 0...7)]
    }
    
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
