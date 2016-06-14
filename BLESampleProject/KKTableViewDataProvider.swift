//
//  KKTableViewDataProvider.swift
//  BLESampleProject
//
//  Created by Konstantin on 6/7/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

import UIKit

enum DataProviderUpdate<Object> {
    case Insert(Object)
    case Delete(Object)
}

protocol KKTableViewDataProviderDelegate: class {
    associatedtype Object: Equatable
    func cellIdentiferForObject(object: Object) -> String
}

class KKTableViewDataProvider<Delegate: KKTableViewDataProviderDelegate, Cell: UITableViewCell, DataProvider: KKManagerProtocolProvider where Delegate.Object == DataProvider.Object, Cell: KKTableConfigurableCell, Cell.ObjectCell == Delegate.Object>: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    typealias Data = Delegate.Object
    
    init(tableView: UITableView, dataProvider: DataProvider, delegate: Delegate) {
        self.tableView = tableView
        self.delegate = delegate
        self.dataProviderCentral = dataProvider
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Public
    
    func cleanUp() {
        guard self.dataArray.count > 0 else {
            return
        }
        self.dataArray.removeAll()
        self.tableView.reloadData()
    }
    
    func update(newUpdate: DataProviderUpdate<Data>) {
        tableView.beginUpdates()
        switch newUpdate {
        case .Delete(let item):
            var indexForDelete = 0
            for (indexItem, itemArr) in dataArray.enumerate() {
                if itemArr == item {
                    indexForDelete = indexItem
                }
            }
            tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: indexForDelete, inSection: 0)], withRowAnimation: .Fade)
            dataArray.removeAtIndex(indexForDelete)
            break
        case .Insert(let item):
            dataArray.append(item)
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: tableView.numberOfRowsInSection(0), inSection: 0)], withRowAnimation: .Fade)
            break
        }
        tableView.endUpdates()
    }
    
    // MARK: UITableViewDataSource 
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let object = dataArray[indexPath.row]
        self.dataProviderCentral.connectToService(object)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let object = dataArray[indexPath.row]
        let reuseId = delegate.cellIdentiferForObject(object)
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseId) as! Cell!
        if cell == nil {
            cell = Cell(style: .Subtitle, reuseIdentifier: reuseId)
        }
        cell.configureCell(object)
        return cell
    }
    
    // MARK: Private
    
    private let tableView: UITableView
    private var dataArray = [Data]()
    unowned var delegate: Delegate
    unowned var dataProviderCentral: DataProvider
    
}