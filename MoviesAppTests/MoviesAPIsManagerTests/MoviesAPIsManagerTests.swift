//
//  MoviesAPIsManagerTests.swift
//  MoviesAppTests
//
//  Created by Mostafa Abd ElFatah on 5/21/22.
//

import XCTest
@testable import MoviesApp

class MoviesAPIsManagerTests: XCTestCase {

    var sut:MoviesAPIsManager!
    
    override func setUp() {
        super.setUp()
        sut = MoviesAPIsManager()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - testFetchMovies -
    func testFetchMovies(){
        // Given:
        let promise = XCTestExpectation(description:  "Fetch Movies completed")
        
        var responseError:Error?
        var responseMovies:MoviesReponse?
        // When:
        guard let path = Bundle.unitTest.path(forResource: "movies", ofType: "json") else {
            XCTFail("Error: file not found")
            return
        }
        
        sut.fetchMovies(from: URL(fileURLWithPath: path)) { [weak self] result in
            guard self != nil else { return }
            switch result{
            case .success(let response):
                responseMovies = response
            case .failure(let error):
                responseError = error
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 1)
        // Then:
        XCTAssertNil(responseError)
        XCTAssertNotNil(responseMovies)
    }
    

}
