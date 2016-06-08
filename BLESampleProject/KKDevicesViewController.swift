//
//  KKDevicesViewController.swift
//  BLESampleProject
//
//  Created by Konstantin on 6/8/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

import UIKit
import CoreBluetooth

class KKDevicesViewController: KKMainViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension KKDevicesViewController: KKTableViewDataProviderDelegate {
    func cellIdentiferForObject(object: CBPeripheral) -> String {
        return "CBPeripheralCellId"
    }
}
