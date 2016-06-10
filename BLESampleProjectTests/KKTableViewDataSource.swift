//
//  KKTableViewDataSource.swift
//  BLESampleProject
//
//  Created by Konstantin on 6/10/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

import XCTest
import CoreBluetooth
@testable import BLESampleProject
import UIKit

class KKTableViewDataSource: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}



class KKTableViewDataSourceUnderTest: NSObject, KKTableViewDataProviderDelegate {
    
//    var tableDataSource: KKTableViewDataProvider<KKTableViewDataSourceUnderTest, KKTableViewDeviceCell, Data>!
    class CBPeripheralUnderTest : CBPeripheral {
        
    }
    
    override init() {
        super.init()
        
    }
    
    func cellIdentiferForObject(object: CBPeripheralUnderTest) -> String {
        return "CBPeripheralUnderTestIdentifer"
    }
}