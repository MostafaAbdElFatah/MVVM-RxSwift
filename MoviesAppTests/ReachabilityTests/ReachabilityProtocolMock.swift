//
//  ReachabilityProtocol.swift
//  MoviesAppTests
//
//  Created by Mostafa Abd ElFatah on 5/21/22.
//

import Foundation
@testable import MoviesApp


class ReachabilityProtocolMock: ReachabilityProtocol{
    
    var isConnectToNetwork = false
    var isConnectedToNetworkCalled = false
    
    func isConnectedToNetwork() -> Bool {
        isConnectedToNetworkCalled = true
        return isConnectToNetwork
    }
    
}
