//
//  KKCentralManager.swift
//  BLESampleProject
//
//  Created by Konstantin on 6/7/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

import UIKit
import CoreBluetooth

protocol DataProtocol {
    
}

protocol KKCentralManagerProtocolProvider {
    associatedtype ObjectCentralManager
    func updatePeripheral(newUpdate: DataProviderUpdate<ObjectCentralManager>)
}

protocol KKCentralManagerProtocolDelegate: class {
    var sourcePresenter: KKCentralManagerProtocolProvider { get }
    func didStateUpdate(managerState: KKCentralManagerStateType)
    func didConnectKKPerephiralType(perephiralType:KKCentralManagerPerephiralType)
}

protocol KKCentralManagerProtocol: class {
    func startScanning()
    func stopScanning()
    func connectPeripheral(peripheral: CBPeripheral)
}

class KKCentralManager<Delegate: KKCentralManagerProtocolDelegate>: NSObject, CBCentralManagerDelegate, KKCentralManagerProtocol {
    
    init(delegate: Delegate) {
        self.delegate = delegate
        super.init()
        centralManager = CBCentralManager(delegate: self, queue:nil)
    }
    
    // MARK - KKCentralManagerProtocol 
    func startScanning() {
        centralManager.scanForPeripheralsWithServices(nil, options: nil)
    }
    
    func stopScanning() {
        centralManager.stopScan()
    }
    
    func connectPeripheral(peripheral: CBPeripheral) {
        centralManager.connectPeripheral(peripheral, options: nil)
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
            delegate.didStateUpdate(.BLEErrorOccur(error: KKCentralManagerStateType.defaultErrorDesctoption ) )
        }
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        guard centralManager == central else {
            return
        }
        print("peripheral devices + \(peripheral.name)"  )
        print("advertisementData  \(advertisementData)" )
//        delegate.sourcePresenter.didDiscoverNewPeripheral(peripheral)
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        guard centralManager == central else {
            return
        }
        delegate.didConnectKKPerephiralType(.didConnect(peripheral: peripheral))
    }
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        guard centralManager == central else {
            return
        }
        delegate.didConnectKKPerephiralType(.didDisconnect(peripheral: peripheral))
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        guard centralManager == central else {
            return
        }
        delegate.didConnectKKPerephiralType(.didFailedConnectPeripheral(peripheral: peripheral))
    }
    
    // MARK: Private
    
    private var centralManager: CBCentralManager!
    weak private var delegate: Delegate!
}


enum KKCentralManagerPerephiralType {
    case didConnect(peripheral: CBPeripheral)
    case didDisconnect(peripheral: CBPeripheral)
    case didFailedConnectPeripheral(peripheral: CBPeripheral)
}

enum KKCentralManagerStateType {
    case BLEOn, BLEOff, BLEErrorOccur(error: NSError)
}

extension KKCentralManagerStateType {
    static var defaultErrorDesctoption: NSError {
        return  NSError(domain: "Try to switch on/Off a bluetooth module", code: 105, userInfo: nil)
    }
}