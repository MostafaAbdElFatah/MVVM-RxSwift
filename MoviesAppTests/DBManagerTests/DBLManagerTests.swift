//
//  SQLManagerTests.swift
//  MoviesAppTests
//
//  Created by Mostafa Abd ElFatah on 5/21/22.
//

import XCTest
@testable import MoviesApp

class DBLManagerTests: XCTestCase {
    
    var sut:DBManagerProtocolMock!
    
    override func setUp() {
        super.setUp()
        sut = DBManagerProtocolMock()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    
    // MARK: - testFetchMoviesList -
    func testFetchMoviesList() {
        //Given:
        guard let photoList = MoviesGenerator().moviesPhotos() else {
            XCTFail("Failed to generate photos")
            return
        }
        sut.photoList = photoList.photosList.photos
        
        //When:
        let fetchedPhotoList = sut.fetchMoviesList(currentOffset: 1)
        
        //Then:
        XCTAssertTrue(sut.fetchMoviesIsCalled)
        XCTAssertFalse(fetchedPhotoList.isEmpty)
    }
    
    
    // MARK: - testSaveMovies -
    func testSaveMovie() {
        //Given:
        guard let photoList = MoviesGenerator().moviesPhotos() else {
            XCTFail("Failed to generate photos")
            return
        }
        //When:
        sut.saveMovie(photoList.photosList.photos.first!)
        
        //Then:
        XCTAssertTrue(sut.isSaveMovie)
    }
    
    // MARK: - testSaveMovies -
    func testSaveMovies() {
        //Given:
        guard let photoList = MoviesGenerator().moviesPhotos() else {
            XCTFail("Failed to generate photos")
            return
        }
        //When:
        
        sut.saveMovies(photoList.photosList.photos)
        
        //Then:
        XCTAssertTrue(sut.isSaveMovies)
    }
    
    
    // MARK: - testDelete -
    func testDelete() {
        //Given:
        let id  = "1354584264315"
        //When:
        sut.delete(id: id)
        //Then:
        XCTAssertTrue(sut.isDeleteMovie)
    }
    
    // MARK: - testDelete -
    func testDeleteMovies() {
        //Given:
        //When:
        sut.deleteMovies()
        //Then:
        XCTAssertTrue(sut.isDeleteAllMovies)
    }
    
   
    
}
