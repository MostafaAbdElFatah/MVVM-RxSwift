//
//  MoviesListViewModelTests.swift
//  MoviesAppTests
//
//  Created by Mostafa Abd ElFatah on 5/18/22.
//

import XCTest

@testable import MoviesApp


class MoviesListViewModelTests: XCTestCase {

    var sut: MoviesListViewModel!
    var apisManagerMock:MoviesAPIsManagerMock!

    override func setUp() {
        super.setUp()
        apisManagerMock = MoviesAPIsManagerMock()
        sut = MoviesListViewModel(apisManager: apisManagerMock)
    }
    
    override func tearDown() {
        sut = nil
        apisManagerMock = nil
        super.tearDown()
    }
    
    // MARK: - testCreateCellDispaly -
    func testCreateCellDispaly(){
        // Given:
        let photo = Photo(id: "50397567507", owner: "127728062@N04", secret: "855de8e6a9", server: "65535", farm: 66, title: "Stalker-Shadow-Chernobyl-ELITE-2020-002-escape", ispublic: 1, isfriend: 0, isfamily: 0)
        
        // When:
        let dispayCell = sut.createCellDispaly(photo: photo)
        // Then:
        XCTAssertEqual(dispayCell.image, "https://farm66.static.flickr.com/65535/50397567507_855de8e6a9.jpg")
    }
    
    
    // MARK: - testFetchMoviesList -
    func testFetchMoviesList(){
        // When:
        sut.fetchMoviesList()
        // Then:
        XCTAssert(apisManagerMock.fetchMoviesIsCalled)
    }
    
    // MARK: - testFetchSuceess -
    func testFetchLoading() {
        //Given:
        var state:State = .empty
        
        //When:
        sut.fetchMoviesList()
        
        //Then:
        state = try! sut.state.value()
        XCTAssertEqual(state, .loading)
    }
    
    // MARK: - testFetchSuceess -
    func testFetchSuceess() {
        
        //Given:
        var state:State = .empty
        
        //When:
        sut.fetchMoviesList()
        
        //Then
        apisManagerMock.fetchSuccess()
        state = try! sut.state.value()
        XCTAssertEqual(state, .fetched)
    }
    
    // MARK: - testFetchFailure -
    func testFetchFailure() {
        
        //Given:
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
    
    // MARK: - testPhotoCellTapped -
    func testPhotoCellTapped(){
        // Given:
        guard let response = MoviesGenerator().moviesPhotos() else {
            XCTFail("Failed to generate photos")
            return
        }
        
        
        let indexPath = IndexPath(row: 3, section: 0)
        apisManagerMock.response = response

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
