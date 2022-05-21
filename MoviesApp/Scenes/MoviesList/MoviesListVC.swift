//
//  MoviesListVC.swift
//  MoviesApp
//
//  Created by Mostafa Abd ElFatah on 5/17/22.
//
//

import UIKit
import RxSwift
import RxCocoa
import KafkaRefresh

class MoviesListVC: UIViewController {

    // MARK: - Public properties -
    @IBOutlet weak var searchText: UITextField!
    
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Private properties -
    private let disposeBag = DisposeBag()
    private var viewModel = MoviesListViewModel()
    
    // MARK: - Dim View
    private let dimViewAlpha: CGFloat = 0.5
    private lazy var dimView: UIView = {
        let v = UIView(frame: .zero)
        v.alpha = 0
        v.backgroundColor = .black.withAlphaComponent(dimViewAlpha)
        v.isUserInteractionEnabled = false
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.style = .large
        activityIndicatorView.startAnimating()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: v.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: v.centerYAnchor)
        ])
        return v
    }()
    
    // MARK: - Lifecycle -
    init() {
        super.init(nibName: "MoviesList", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayoutUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchMoviesList()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.bringSubviewToFront( dimView)
    }
    
    func setupLayoutUI() {
        addDimView()
        bindTableView()
        bindNavigation()
        bindLoadingView()
        bindSearchTextField()
        title = "Movies List"
        view.backgroundColor = .white
        tableView.bindFootRefreshHandler({ [weak self] in
            guard let self = self else { return }
            self.viewModel.fetchMoviesList()
        }, themeColor: .blue, refreshStyle: .replicatorAllen)
    }
    
    func bindSearchTextField() {
        searchText.rx.text
            .orEmpty
            .throttle(.seconds(5), scheduler: MainScheduler.instance)
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
    }
    
    func bindNavigation() {
        viewModel.selectedPhoto.bind{ [weak self]  photo in
            guard let self = self else { return }
            self.moveTo(photo: photo)
        }.disposed(by: disposeBag)
    }
    
    func bindLoadingView()  {
        viewModel.state.bind { state in
            DispatchQueue.main.async {
                switch state {
                case .empty:
                    //show empty text
                    self.showingLoadingView(isLoading: false)
                    self.tableView.setEmptyMessage("No Data Found".localized)
                    break
                case .loading:
                    // show loading view
                    self.tableView.hiddenEmptyMessage()
                    self.showingLoadingView(isLoading: true)
                    break
                case .fetched:
                    //loading tableView and hiddenEmptyMessag
                    self.tableView.hiddenEmptyMessage()
                    self.showingLoadingView(isLoading: false)
                case .error(let error):
                    // show error message
                    self.showingLoadingView(isLoading: false)
                    self.tableView.setEmptyMessage("No Data Found".localized)
                    self.showAlert(title: "Error".localized, message: error)
                }
                self.tableView.footRefreshControl.endRefreshing()
            }
        }.disposed(by: disposeBag)
    }
    
    
    func bindTableView(){
        tableView.register(UINib(nibName: "AdBannerCell", bundle: nil), forCellReuseIdentifier: "AdBannerCell")
        tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.rx.itemSelected.subscribe(onNext:{ [weak self] indexPath in
            guard let self = self else { return }
            self.viewModel.cellSelected(indexPath: indexPath)
        }).disposed(by: disposeBag)
        
//        viewModel.movies.bind(to: tableView.rx.items(cellIdentifier: "MovieCell", cellType: MovieCell.self)){
//            [weak self](row, item, cell) in
//            guard let self = self else { return }
//            cell.config(movie: self.viewModel.createCellDispaly(photo: item))
//        }.disposed(by: disposeBag)
        
        viewModel.movies.bind(to: tableView.rx.items){
            [weak self](tbv, row, item) in
            guard let self = self else { return UITableViewCell() }
            if !self.viewModel.isBanner(row: row){
                let cell = tbv.dequeueReusableCell(withIdentifier: "MovieCell", for: IndexPath(row: row, section: 0)) as! MovieCell
                cell.config(movie: self.viewModel.createCellDispaly(photo: item as! Photo))
                return cell
            }else {
                let cell = tbv.dequeueReusableCell(withIdentifier: "AdBannerCell", for: IndexPath(row: row, section: 0)) as! AdBannerCell
                cell.config(imageNamed: item as! String)
                return cell
            }
        }.disposed(by: disposeBag)
    }
    
    
    private func addDimView() {
        dimView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dimView)
        view.bringSubviewToFront(dimView)
        pinToFour(dimView, view)
    }
    
    func showingLoadingView(isLoading:Bool){
        UIView.animate(withDuration: 0.5) {
            self.dimView.alpha = isLoading ? 1:0
        }
    }
    
    func pinToFour(_ view1: UIView, _ view2: UIView) {
        NSLayoutConstraint.activate([
            view1.leadingAnchor.constraint(equalTo: view2.leadingAnchor),
            view1.trailingAnchor.constraint(equalTo: view2.trailingAnchor),
            view1.topAnchor.constraint(equalTo: view2.topAnchor),
            view1.bottomAnchor.constraint(equalTo: view2.bottomAnchor)
        ])
    }
    
    func moveTo(photo:Photo?) {
        let vc = MovieDetailsVC()
        vc.viewModel.movie.onNext(photo)
        navigationController?.pushViewController(vc, animated: true)
    }

}

// MARK: - Extensions -
extension MoviesListVC : UITableViewDelegate{
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        return cell
//    }
//    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            tableView.footRefreshControl.beginRefreshing()
        }
    }
}
