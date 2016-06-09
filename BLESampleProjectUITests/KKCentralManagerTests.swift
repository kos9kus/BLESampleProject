//
//  KKCentralManagerTests.swift
//  BLESampleProject
//
//  Created by Konstantin on 6/9/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

import XCTest
import CoreBluetooth
@testable import BLESampleProject
import UIKit

class KKCentralManagerTests: XCTestCase {
    
    let centralManagerUnderTest: KKCentralManagerUnderTest = KKCentralManagerUnderTest()
    
    override func setUp() {
        super.setUp()
        let expectation = expectationWithDescription("KKCentralManagerTests")
        centralManagerUnderTest.asyncExpectation = expectation
    }
    
    // MARK - Peripheral
    
    func testDidGetNewPeripheral() {
        let expectation = expectationWithDescription("testDidGetNewPeripheral")
        centralManagerUnderTest.asyncExpectation = expectation
        waitForExpectationsWithTimeout(5) { (error) in
            XCTAssert(self.centralManagerUnderTest.anyPeripheral != nil, "")
            print(self.centralManagerUnderTest.anyPeripheral)
        }
    }
    
    // MARK - State
    func testStateError() { // Success is on simulator
        waitForExpectationsWithTimeout(2) { (error) in
            XCTAssertTrue(self.centralManagerUnderTest.state == .BLEErrorOccur(error: KKCentralManagerStateType.defaultErrorDesctoption) )
        }
    }
    
    func testStateIsOff() {
        waitForExpectationsWithTimeout(2) { (error) in
            XCTAssertTrue(self.centralManagerUnderTest.state == .BLEOff)
        }
    }
}


public class KKCentralManagerUnderTest: NSObject, KKCentralManagerProtocolDelegate {
    
    var centralProject: KKCentralManager<KKCentralManagerUnderTest>!
    var state: KKCentralManagerStateType?
    var anyPeripheral: CBPeripheral?
    var asyncExpectation: XCTestExpectation?
    
    override init() {
        super.init()
        centralProject = KKCentralManager(delegate: self)
    }
    
    // MARK: Delegation
    
    func didDiscoverNewPeripheral(peripheral: CBPeripheral) {
        anyPeripheral = peripheral
        asyncExpectation?.fulfill()
    }
    
    func didStateUpdate(managerState: KKCentralManagerStateType) {
        state = managerState
        asyncExpectation?.fulfill()
    }
    
    func didConnectKKPerephiralType(perephiralType: KKCentralManagerPerephiralType) {
        
    }
}

extension KKCentralManagerStateType: Equatable {
}

func ==(lhs: KKCentralManagerStateType, rhs: KKCentralManagerStateType) -> Bool {
    switch (lhs, rhs) {
    case (.BLEOn, .BLEOn):
        return true
    case (.BLEOff, .BLEOff):
        return true
    case (let .BLEErrorOccur(errorLhs), let .BLEErrorOccur(errorRhs) ):
        return errorLhs.code == errorRhs.code
    default:
        break
    }
    return false
}
