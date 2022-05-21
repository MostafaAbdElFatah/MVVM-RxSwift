//
//  MoviesListViewModelTests.swift
//  MoviesAppTests
//
//  Created by Mostafa Abd ElFatah on 5/21/22.
//

import XCTest
@testable import MoviesApp

class MoviesListViewModelTests: XCTestCase {

    var sut:MoviesListViewModel!
    var dbManager:DBManagerProtocolMock!
    var reachability:ReachabilityProtocolMock!
    var apisManagerMock:MoviesAPIsManagerProtocolMock!
    
    
    override func setUp() {
        super.setUp()
        dbManager = DBManagerProtocolMock()
        reachability = ReachabilityProtocolMock()
        apisManagerMock = MoviesAPIsManagerProtocolMock()
        sut = MoviesListViewModel(apisManager: apisManagerMock, dbManager: dbManager, reachability: reachability)
    }

    override func tearDown() {
        sut = nil
        apisManagerMock = nil
        super.tearDown()
    }

    
    // MARK: - Network tests -
    // MARK: - testFetchMoviesListFromAPIs -
    func testFetchMoviesListFromAPIs(){
        //Given:
        reachability.isConnectToNetwork = true
        // When:
        sut.fetchMoviesList()
        let isConnect = reachability.isConnectedToNetwork()
        // Then:
        XCTAssertTrue(isConnect)
        XCTAssert(apisManagerMock.fetchMoviesIsCalled)
    }
    
    // MARK: - testFetchSuceess -
    func testFetchLoadingFromAPIs() {
        //Given:
        var state:State = .empty
        reachability.isConnectToNetwork = true
        
        //When:
        sut.fetchMoviesList()
        
        //Then:
        state = try! sut.state.value()
        XCTAssertEqual(state, .loading)
    }
    
    // MARK: - testFetchSuceess -
    func testFetchSuceessFromAPIs() {
        
        //Given:
        guard let response = MoviesGenerator().moviesPhotos() else {
            XCTFail("Failed to generate photos")
            return
        }
        
        
        var state:State = .empty
        apisManagerMock.response = response
        reachability.isConnectToNetwork = true
        
        //When:
        sut.fetchMoviesList()
        
        //Then
        apisManagerMock.fetchSuccess()
        state = try! sut.state.value()
        XCTAssertEqual(state, .fetched)
    }
    
    // MARK: - testFetchFailure -
    func testFetchFailureFromAPIs() {
        
        //Given:
        reachability.isConnectToNetwork = true
        let networkAPIError:NetworkAPIError = .invalidData
        
        //When:
        sut.fetchMoviesList()
        apisManagerMock.fetchFailure(error: networkAPIError)
        
        //Then:
        let state:State = try! sut.state.value()
        switch state {
        case .error(let error):
            XCTAssertEqual(error, networkAPIError.localizedDescription)
        default:
            XCTFail("Error: Test failed")
        }
    }
    
    
    // MARK: - DB tests -
    // MARK: - testFetchMoviesListFromDB -
    func testFetchMoviesListFromDB(){
        //Given:
        reachability.isConnectToNetwork = false
        // When:
        sut.fetchMoviesList()
        let isConnect = reachability.isConnectedToNetwork()
        // Then:
        XCTAssertFalse(isConnect)
        XCTAssert(dbManager.fetchMoviesIsCalled)
    }
    
    
    // MARK: - testFetchSuceess -
    func testFetchSuceessFromDB() {
        
        //Given:
        guard let response = MoviesGenerator().moviesPhotos() else {
            XCTFail("Failed to generate photos")
            return
        }
        
        reachability.isConnectToNetwork = false
        dbManager.photoList = response.photosList.photos
        
        //When:
        sut.fetchMoviesList()
        let photoList = dbManager.fetchMoviesList(currentOffset: 1)
        
        //Then
        XCTAssertFalse(photoList.isEmpty)
    }
    
    
    // MARK: - testFetchFailure -
    func testFetchFailureFromDB() {
        
        //Given:
        reachability.isConnectToNetwork = false
        //When:
        sut.fetchMoviesList()
        let photoList = dbManager.fetchMoviesList(currentOffset: 1)
        
        //Then:
        XCTAssertTrue(photoList.isEmpty)
    }
    
    // MARK: - Other tests -
    // MARK: - testCreateCellDispaly -
    func testCreateCellDispaly(){
        // Given:
        let photo = Photo(id: "50397567507", owner: "127728062@N04", secret: "855de8e6a9", server: "65535", farm: 66, title: "Stalker-Shadow-Chernobyl-ELITE-2020-002-escape", ispublic: 1, isfriend: 0, isfamily: 0)
        
        //When:
        let displayCell = sut.createCellDispaly(photo: photo)
        
        //Then:
        XCTAssertEqual(displayCell.image, "https://farm66.static.flickr.com/65535/50397567507_855de8e6a9.jpg")
        
    }
    
    // MARK: - testPhotoCellTapped -
    func testPhotoCellTapped(){
        // Given:
        guard let response = MoviesGenerator().moviesPhotos() else {
            XCTFail("Failed to generate photos")
            return
        }
        
        
        let indexPath = IndexPath(row: 3, section: 0)
        apisManagerMock.response = response
        dbManager.photoList = response.photosList.photos
        
        sut.fetchMoviesList()
        apisManagerMock.fetchSuccess()
        
        //When:
        sut.cellSelected(indexPath: indexPath)
        
        //Then:
        let selectedPhoto = try! sut.selectedPhoto.value()
        let selectedAdBannerLink = try! sut.selectedLink.value()
        XCTAssertNotNil(selectedPhoto)
        XCTAssertNil(selectedAdBannerLink)
    }
    
    
    // MARK: - testAdBannerCellTapped -
    func testAdBannerCellTapped(){
        // Given:
        guard let response = MoviesGenerator().moviesPhotos() else {
            XCTFail("Failed to generate photos")
            return
        }
        
        //adBanner in five row
        let indexPath = IndexPath(row: 4, section: 0)
        apisManagerMock.response = response
        dbManager.photoList = response.photosList.photos

        sut.fetchMoviesList()
        apisManagerMock.fetchSuccess()
        
        //When:
        sut.cellSelected(indexPath: indexPath)
        
        //Then:
        let selectedPhoto = try! sut.selectedPhoto.value()
        let selectedAdBannerLink = try! sut.selectedLink.value()
        XCTAssertNil(selectedPhoto)
        XCTAssertNotNil(selectedAdBannerLink)
    }
    
    
    
}
