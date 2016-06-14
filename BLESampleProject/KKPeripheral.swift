//
//  KKPeripheral.swift
//  BLESampleProject
//
//  Created by KONSTANTIN KUSAINOV on 10/06/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

import Foundation
import CoreBluetooth

struct KKPeripheral: Equatable {
    var name: String
    var proximity: String
    var object: CBPeripheral
    var udid: String
    
    init(name: String?, udid: String, proximity: String, object: CBPeripheral) {
        self.name = name != nil ? name! : udid
        self.udid = udid
        self.proximity = proximity
        self.object = object
    }
}

func ==(lhs: KKPeripheral, rhs: KKPeripheral) -> Bool {
    if lhs.udid == rhs.udid {
        return true
    }
    return false
}