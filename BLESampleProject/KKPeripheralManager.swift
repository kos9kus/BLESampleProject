//
//  KKPeripheralManager.swift
//  BLESampleProject
//
//  Created by KONSTANTIN KUSAINOV on 11/06/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

import Foundation
import CoreBluetooth


protocol KKPeripheralManagerDelegate: class {
    func didNewPeripheralManagerAction(service: KKPeripheralManagerDelegateType)
    func enableProcessingStatus(enable: Bool)
}

protocol KKPeripheralManagerProvider: KKManagerProtocolProvider {
    associatedtype Object
    func discoverService(service: Object)
//    func discoverCharacteristic(characteristic: Object)
}

class KKPeripheralManager<Delegate: KKPeripheralManagerDelegate>: NSObject, CBPeripheralDelegate, KKManagerProtocolProvider {
    
    init(peripheral: CBPeripheral, delegate: Delegate) {
        self.peripheral = peripheral
        self.delegate = delegate
        super.init()
        self.peripheral.delegate = self
        
        self.peripheral.discoverServices(nil)
        
    }
    
    // MARK: KKPeripheralManagerProvider
    
    func connectToService(service: CBService) {
        processingStatus = true
        peripheral.discoverCharacteristics(nil, forService: service)
    }
    
//    func connectToService(characteristic: CBCharacteristic) {
//        processingStatus = true
////        peripheral.disc
//    }
    
    // MARK: CBPeripheralDelegate
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        defer {
            processingStatus = false
        }
        guard self.peripheral == peripheral else {
            return
        }
        guard error == nil else {
            print("Error: " + #function + "\(error?.description)")
            delegate.didNewPeripheralManagerAction(.Error(error: error!.domain))
            return
        }
        
        if let services = peripheral.services {
            for item in services {
                print(#function + "New service: \(item)")
                delegate.didNewPeripheralManagerAction(.Service(service: item))
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        defer {
            processingStatus = false
        }
        guard self.peripheral == peripheral else {
            return
        }
        guard error == nil else {
            print("Error: " + #function + "\(error?.description)")
            delegate.didNewPeripheralManagerAction(.Error(error: error!.domain))
            return
        }
        if let characteristics = service.characteristics {
            for item in characteristics {
                print(#function + "New characteristic: \(item)")
                delegate.didNewPeripheralManagerAction(.Characteristics(characteristic: item))
            }
        }
    }
    
    
    // MARK: Private
    
    private let peripheral: CBPeripheral
    private unowned let delegate: Delegate
    
    private var processingStatus: Bool = true {
        didSet {
            delegate.enableProcessingStatus(processingStatus)
        }
    }

}


enum KKPeripheralManagerDelegateType {
    case Characteristics(characteristic: CBCharacteristic)
    case Service(service: CBService)
    case Error(error: String)
}