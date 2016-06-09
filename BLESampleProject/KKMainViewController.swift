//
//  ViewController.swift
//  BLESampleProject
//
//  Created by Konstantin on 6/7/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

import UIKit
import PureLayout

class KKMainViewController: UIViewController {
    
    var tableView: UITableView = UITableView.newAutoLayoutView()
    
    var headerView: UIView = {
        let view = UIView.newAutoLayoutView()
        view.backgroundColor = .whiteColor()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(headerView)
        self.view.addSubview(tableView)
        self.view.setNeedsUpdateConstraints()
    }
    
    private var didUpdateConstraint = false
    override func updateViewConstraints() {
        if !didUpdateConstraint {
            
            tableView.autoPinEdgeToSuperviewEdge(.Left)
            tableView.autoPinEdgeToSuperviewEdge(.Right)
            
            ([headerView, tableView] as NSArray).autoMatchViewsDimension(.Width)
            ([headerView, tableView] as NSArray).autoDistributeViewsAlongAxis(.Vertical, alignedTo: .Vertical, withFixedSpacing: 0)
            didUpdateConstraint = true
        }
        super.updateViewConstraints()
    }
}

extension KKMainViewController {
    func alertViewController(message: String) {
        let alertController = UIAlertController(title: "BLE", message: message, preferredStyle: .Alert)
        let actionOk = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
        alertController.addAction(actionOk)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

