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
        self.title = "Devices"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerCustomView = KKViewDevices(buttonHandler: {  [unowned self] (start) in
            guard self.status == .BLEOn else {
                self.alertViewController("BLE is unable")
                return false
            }
            if (start) {
                self.tableDataSource.cleanUp()
                self.centralManager.startScanning()
            } else {
                self.centralManager.stopScanning()
            }
            return true
            })
        super.headerView.addSubview(headerCustomView)
    }
    
    private var didUpdateConstraint = false
    override func updateViewConstraints() {
        if !didUpdateConstraint {
            headerCustomView.autoPinEdgesToSuperviewEdges()
            didUpdateConstraint = true
        }
        super.updateViewConstraints()
    }
    
    // MARK - Private
    
    
    private var headerCustomView: KKViewDevices! {
        didSet {
            self.headerCustomView.statusLabel.text = "BLE \(status.titleType)"
        }
    }
    
    private var status: KKCentralManagerStateType = .BLEOff {
        didSet {
            self.headerCustomView.statusLabel.text = "BLE \(status.titleType)"
        }
    }
    
    typealias Data = KKCentralManager<KKDevicesViewController>
    private var centralManager: KKCentralManager<KKDevicesViewController>!
    private var tableDataSource: KKTableViewDataProvider<KKDevicesViewController, KKTableViewDeviceCell, Data>!
}

extension KKDevicesViewController: KKCentralManagerProtocolDelegate {
    
    func didDiscoverNewPeripheral(peripheral: KKPeripheral) {
        tableDataSource.update(.Insert(peripheral))
        
    }
    
    func didStateUpdate(managerState: KKCentralManagerStateType) {
        status = managerState
    }
    
    func didConnectKKPerephiralType(perephiralType: KKCentralManagerPerephiralType) {
        switch perephiralType {
        case .DidConnect(let peripheral):
            break
        case .DidDisconnect(let peripheral):
            break
        case .DidFailedConnectPeripheral(let peripheral):
            break
        }
    }
    
    func centralManagerProcessing(enable: Bool) {
        self.enableLoadingIndeicatorProcessing(enable)
    }
}

extension KKDevicesViewController: KKTableViewDataProviderDelegate {
    func cellIdentiferForObject(object: KKPeripheral) -> String {
        return "CBPeripheralCellId"
    }
}
