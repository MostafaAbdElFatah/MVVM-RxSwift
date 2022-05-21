//
//  Reachability.swift
//  MoviesAppTests
//
//  Created by Mostafa Abd ElFatah on 5/21/22.
//

import XCTest
@testable import MoviesApp

class ReachabilityTests: XCTestCase {

    
    var sut:ReachabilityProtocolMock!
    
    override func setUp() {
        super.setUp()
        sut = ReachabilityProtocolMock()
    }
    
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    
    func testIsConnectedToNetworkSuceess(){
        //Given:
        sut.isConnectToNetwork = true
        //When:
        let isConnected = sut.isConnectedToNetwork()
        //Then:
        XCTAssertTrue(isConnected)
    }
    
    func testIsConnectedToNetworkFail(){
        //Given:
        sut.isConnectToNetwork = false
        //When:
        let isConnected = sut.isConnectedToNetwork()
        //Then:
        XCTAssertFalse(isConnected)
    }
    
}
