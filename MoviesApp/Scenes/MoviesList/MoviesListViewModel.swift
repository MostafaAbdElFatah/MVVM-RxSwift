//
//  MoviesListViewModelVC.swift
//  MoviesApp
//
//  Created by Mostafa Abd ElFatah on 5/17/22.
//
//

import RxSwift
import Foundation


final class MoviesListViewModel {

    // MARK: - Public properties -
    public var movies = BehaviorSubject<[Any]>(value: [])
    public var state = BehaviorSubject<State>(value: .empty)
    public var searchText = BehaviorSubject<String>(value: "")
    public var selectedPhoto = BehaviorSubject<Photo?>(value: nil)
    public var selectedLink = BehaviorSubject<String?>(value: nil)
   
    
    // MARK: - Private properties -
    private var currentPage:Int = 1
    private var totalPages:Int = 1
    private var allMovies:[Photo] = []
    private var disposeBag = DisposeBag()
    private var dbManager:DBManagerProtocol
    private var reachability:ReachabilityProtocol
    private var apisManager:MoviesAPIsManagerProtocol
    
    // MARK: - Init -
    init(apisManager:MoviesAPIsManagerProtocol = MoviesAPIsManager(),
         dbManager:DBManagerProtocol = SQLManager(),
         reachability:ReachabilityProtocol = Reachability()) {
            
        
        self.dbManager = dbManager
        self.apisManager = apisManager
        self.reachability = reachability
        self.apisManager = apisManager
        searchText.bind { [weak self] (text) in
            guard let self = self else { return }
            if text.isBlank { return }
            self.searchingDidChanged(text: text)
        }.disposed(by: disposeBag)
        selectedLink.bind{ [weak self] url in
            guard let self = self else { return }
            guard let url = url else { return  }
            self.openLink(url ?? "")
        }.disposed(by: disposeBag)
    }
    
    // MARK: - searchingDidChanged -
    func searchingDidChanged(text:String){
        let filterList = allMovies.filter({ $0.title.contains(text)})
        //inject adBanner every five item
        let moviesList = filterList.injectAdBanners()
        self.movies.onNext(moviesList)
    }
    
    // MARK: - fetchMovies -
    func fetchMoviesList() {
        if reachability.isConnectedToNetwork() {
            fetchMoviesListFromAPIs()
        }else{
            fetchMoviesListFromDB()
        }
    }
    
    // MARK: - fetchMoviesListFromDB -
    private func fetchMoviesListFromDB(){
        self.state.onNext(.fetched)
        totalPages += 1
        currentPage += 1
        
        guard var moviesList = try? self.movies.value() else { return }
        moviesList.append(contentsOf: dbManager.fetchMoviesList(currentOffset: currentPage))
        moviesList = moviesList.filter({ $0 is Photo })
        // inject ad banners between movies
        let list = moviesList.injectAdBanners()
        self.movies.onNext(list)
    }
    
    
    // MARK: - fetchMoviesListFromAPIs -
    private func fetchMoviesListFromAPIs(){
        if currentPage > totalPages {
            state.onNext(.fetched)
            return
        }
        
        let urlString = URLs.moviesListURL(page: currentPage)
        guard let url = URL(string: urlString) else {
            state.onNext(.error(NetworkAPIError.invalidURL.localizedDescription))
            return
        }
        
        if let currentState = try? state.value(), case .empty = currentState {
            state.onNext(.loading)
        }
        
        apisManager.fetchMovies(from: url) { [weak self] result in
            guard let self = self else { return }
            self.state.onNext(.fetched)
            
            switch result {
            case .success(let response):
                self.state.onNext(.fetched)
                self.totalPages = response.photosList.pages
                self.currentPage = response.photosList.page + 1
                guard var moviesList = try? self.movies.value() else { return }
                moviesList.append(contentsOf: response.photosList.photos)
                moviesList = moviesList.filter({ $0 is Photo })
                
                //save movies
                self.saveNewMovies(photos: moviesList)
                
                // inject ad banners between movies
                let list = moviesList.injectAdBanners()
                
                self.movies.onNext(list)
            case .failure(let error):
                self.state.onNext(.error(error.localizedDescription))
            }
            
        }
    }
    
    // MARK: - save new Movies  -
    private func saveNewMovies(photos:[Any]) {
        guard let movies = photos as? [Photo] else { return }
        dbManager.saveMovies(movies)
    }
    
    // MARK: - create movie cell display object -
    func createCellDispaly(photo:Photo) -> MovieDisplay {
        MovieDisplay(movie: photo)
    }

    // MARK: - isAdBanner cell at this row -
    func isBanner(row:Int)-> Bool {
        guard let moviesList = try? self.movies.value() else { return false }
        return moviesList[row] is String
    }
    
    // MARK: - get photo object at this row -
    private func getPhoto(at row:Int) -> Photo?{
        guard let moviesList = try? self.movies.value() else { return nil }
        return moviesList[row] as? Photo
    }
    
    // MARK: - cellSelected -
    func cellSelected(indexPath:IndexPath){
        if isBanner(row: indexPath.row) {
            //open adBanner link
            selectedLink.onNext("https://www.getkoinz.com/")
        }else{
            // move to movie details with selected photo
            selectedPhoto.onNext(getPhoto(at: indexPath.row))
        }
    }
    
    private func openLink(_ link:String){
        let application = UIApplication.shared
        guard let url = URL(string: link) else { return }
        application.open( url, options: [:])
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
