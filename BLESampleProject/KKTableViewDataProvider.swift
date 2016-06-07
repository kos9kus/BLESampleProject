//
//  KKTableViewDataProvider.swift
//  BLESampleProject
//
//  Created by Konstantin on 6/7/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

import UIKit

enum DataProviderUpdate<Object> {
    case Insert(NSIndexPath)
    case Delete(NSIndexPath)
}

class KKTableViewDataProvider: NSObject, UITableViewDataSource {
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        
    }
    
    // MARK: UITableViewDataSource 
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
    }
    
    // MARK: Private
    private let tableView: UITableView
    
}
