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
    
    init() {
        super.init(nibName: nil, bundle: nil)
        centralManager = KKCentralManager(delegate: self)
        tableDataSource = KKTableViewDataProvider(tableView: super.tableView, dataProvider: centralManager, delegate: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK - Private
    typealias Data = KKCentralManager<KKDevicesViewController>
    private var centralManager: KKCentralManager<KKDevicesViewController>!
    private var tableDataSource: KKTableViewDataProvider<KKDevicesViewController, KKTableViewDeviceCell, Data>!
}

extension KKDevicesViewController: KKCentralManagerProtocolDelegate {
    func didDiscoverNewPeripheral(peripheral: CBPeripheral) {
        tableDataSource.update(.Insert(peripheral))
    }
    
    func didStateUpdate(managerState: KKCentralManagerStateType) {
        
    }
    
    func didConnectKKPerephiralType(perephiralType: KKCentralManagerPerephiralType) {
        
    }
}

extension KKDevicesViewController: KKTableViewDataProviderDelegate {
    func cellIdentiferForObject(object: CBPeripheral) -> String {
        return "CBPeripheralCellId"
    }
}
