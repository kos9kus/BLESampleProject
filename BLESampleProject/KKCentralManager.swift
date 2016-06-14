//
//  KKCentralManager.swift
//  BLESampleProject
//
//  Created by Konstantin on 6/7/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

import UIKit
import CoreBluetooth

protocol KKCentralManagerProtocolDelegate: class {
    func didDiscoverNewPeripheral(peripheral: KKPeripheral)
    func didStateUpdate(managerState: KKCentralManagerStateType)
    func didConnectKKPerephiralType(perephiralType:KKCentralManagerPerephiralType)
    func centralManagerProcessing(enable: Bool)
}

protocol KKManagerProtocolProvider: class {
    associatedtype Object
    func connectToService(connectToItem: Object)
}

protocol KKCentralManagerProtocol {
    func startScanning()
    func stopScanning()
}

class KKCentralManager<Delegate: KKCentralManagerProtocolDelegate>: NSObject, CBCentralManagerDelegate, KKCentralManagerProtocol, KKManagerProtocolProvider {
    
    init(delegate: Delegate) {
        self.delegate = delegate
        super.init()
        centralManager = CBCentralManager(delegate: self, queue:nil)
    }
    
    // MARK - KKCentralManagerProtocol
    func startScanning() {
        delegate.centralManagerProcessing(true)
        centralManager.scanForPeripheralsWithServices(nil, options: nil)
    }
    
    func stopScanning() {
        delegate.centralManagerProcessing(false)
        centralManager.stopScan()
    }
    
    func connectToService(connectToItem: KKPeripheral) {
        delegate.centralManagerProcessing(true)
        centralManager.connectPeripheral(connectToItem.object, options: nil)
    }
    
    // MARK - CBCentralManager delegate
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        guard centralManager == central else {
            return
        }
        switch central.state {
        case .PoweredOn:
            delegate.didStateUpdate(.BLEOn)
        case .PoweredOff:
            delegate.didStateUpdate(.BLEOff)
        default:
            delegate.didStateUpdate(.BLEErrorOccur(error: KKCentralManagerStateType.defaultErrorDescription ) )
        }
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        guard centralManager == central else {
            return
        }
        print("peripheral devices + \(peripheral.name)"  )
        print("advertisementData  \(advertisementData)" )
        
        let item = KKPeripheral(name: peripheral.name, udid: peripheral.identifier.UUIDString, proximity: RSSI.stringValue, object: peripheral)
        delegate.didDiscoverNewPeripheral(item)
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        guard centralManager == central else {
            return
        }
        delegate.didConnectKKPerephiralType(.DidConnect(peripheral: peripheral))
        delegate.centralManagerProcessing(false)
    }
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        guard centralManager == central else {
            return
        }
        delegate.didConnectKKPerephiralType(.DidDisconnect(peripheral: peripheral))
        delegate.centralManagerProcessing(false)
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        guard centralManager == central else {
            return
        }
        delegate.didConnectKKPerephiralType(.DidFailedConnectPeripheral(peripheral: peripheral))
        delegate.centralManagerProcessing(false)
    }
    
    // MARK: Private
    
    private var centralManager: CBCentralManager!
    weak private var delegate: Delegate!
}

enum KKCentralManagerPerephiralType {
    case DidConnect(peripheral: CBPeripheral)
    case DidDisconnect(peripheral: CBPeripheral)
    case DidFailedConnectPeripheral(peripheral: CBPeripheral)
}

enum KKCentralManagerStateType {
    case BLEOn, BLEOff, BLEErrorOccur(error: NSError)
}

extension KKCentralManagerStateType: Equatable {
    static var defaultErrorDescription: NSError {
        return  NSError(domain: "Try to switch on/Off a bluetooth module", code: 105, userInfo: nil)
    }
    
    var titleType: String {
        switch self {
        case .BLEOn:
            return "ON"
        case .BLEOff:
            return "OFF"
        case .BLEErrorOccur(let error):
            print(error.domain)
            return "Error"
        }
    }
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