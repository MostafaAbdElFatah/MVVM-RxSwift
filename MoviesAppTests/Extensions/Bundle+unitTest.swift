//
//  Bundle+unitTest.swift
//  MoviesAppTests
//
//  Created by Mostafa Abd ElFatah on 5/18/22.
//

import Foundation


extension Bundle{
    
    public class var unitTest:Bundle{
        Bundle(for: MoviesAPIsManagerTests.self)
    }
}
