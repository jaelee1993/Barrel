//
//  BarrelTests.swift
//  BarrelTests
//
//  Created by Jae Lee on 1/23/21.
//  Copyright © 2021 Jae Lee. All rights reserved.
//

import XCTest
@testable import Barrel

class BarrelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    
    func testExample() throws {
        TestSurfMaxHeight()
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

    
    
    
    fileprivate func TestSurfMaxHeight() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let s1 = Surf()
        s1.max = 10
        
        let s2 = Surf()
        s2.max = 11
        
        let s3 = Surf()
        s3.max = 3
        
        XCTAssertTrue([s1,s2,s3].maxHeight == 11)
    }
    
    
    
}
