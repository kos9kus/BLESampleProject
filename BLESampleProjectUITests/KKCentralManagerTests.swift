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
    
    let centralManagerUnderTest = KKCentralManagerUnderTest()
    
    override func setUp() {
        super.setUp()
    }
    
    // MARK - Peripheral
    
    func testDidGetNewPeripheral() {
        centralManagerUnderTest.asyncExpectationDidStateUpdate = expectationWithDescription("testDidStateManager")
        
        waitForExpectationsWithTimeout(2) { (error) in
            XCTAssertTrue(self.centralManagerUnderTest.state == .BLEOn)
        }
        
        centralManagerUnderTest.asyncExpectationDidStateUpdate = expectationWithDescription("testDidGetNewPeripheral")
        centralManagerUnderTest.centralProject.startScanning()
        
        self.waitForExpectationsWithTimeout(3) { (error) in
            XCTAssert(self.centralManagerUnderTest.anyPeripheral != nil, "")
            print(self.centralManagerUnderTest.anyPeripheral)
        }
    }
    
    // MARK - State
    func testStateError() { // Success is on simulator
        centralManagerUnderTest.asyncExpectationDidStateUpdate = expectationWithDescription("testStateError")
        waitForExpectationsWithTimeout(2) { (error) in
            XCTAssertTrue(self.centralManagerUnderTest.state == .BLEErrorOccur(error: KKCentralManagerStateType.defaultErrorDescription) )
        }
    }
    
    func testStateIsOff() {
        centralManagerUnderTest.asyncExpectationDidStateUpdate = expectationWithDescription("testStateIsOff")
        waitForExpectationsWithTimeout(2) { (error) in
            XCTAssertTrue(self.centralManagerUnderTest.state == .BLEOff)
        }
    }
}


public class KKCentralManagerUnderTest: NSObject, KKCentralManagerProtocolDelegate {
    
    var centralProject: KKCentralManager<KKCentralManagerUnderTest>!
    var state: KKCentralManagerStateType?
    
    var anyPeripheral: CBPeripheral?
    
    var asyncExpectationDidStateUpdate: XCTestExpectation?
    var asyncExpectationDidDiscoverNewPeripheral: XCTestExpectation?
    
    override init() {
        super.init()
        centralProject = KKCentralManager(delegate: self)
    }
    
    // MARK: Delegation
    
    func didDiscoverNewPeripheral(peripheral: CBPeripheral) {
        anyPeripheral = peripheral
        asyncExpectationDidStateUpdate?.fulfill()
    }
    
    func didStateUpdate(managerState: KKCentralManagerStateType) {
        state = managerState
        asyncExpectationDidStateUpdate?.fulfill()
    }
    
    func didConnectKKPerephiralType(perephiralType: KKCentralManagerPerephiralType) {
        
    }
}


