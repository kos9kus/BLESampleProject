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
    associatedtype ObjectForCell
    func cellIdentiferForObject(object: ObjectForCell) -> String
}

class KKTableViewDataProvider<Delegate: KKTableViewDataProviderDelegate, Cell: UITableViewCell where Cell: KKTableConfigurableCell, Cell.ObjectCell == Delegate.ObjectForCell>: NSObject, UITableViewDataSource {
    
    typealias Data = Delegate.ObjectForCell
    
    init(tableView: UITableView, delegate: Delegate) {
        self.tableView = tableView
        self.delegate = delegate
        super.init()
    }
    
    func update(newUpdate: DataProviderUpdate<Data>) {
        tableView.beginUpdates()
        switch newUpdate {
        case .Delete( _):
            tableView.deselectRowAtIndexPath(NSIndexPath(forRow: dataArray.count - 1, inSection: 0), animated: false)
            dataArray.removeLast()
            break
        case .Insert(let item):
            dataArray.append(item)
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: dataArray.count, inSection: 0)], withRowAnimation: .Fade)
            break
        }
        tableView.endUpdates()
    }
    
    // MARK: UITableViewDataSource 
    
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
    weak var delegate: Delegate!
}