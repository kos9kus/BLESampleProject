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
    var headerView: UIView = UIView.newAutoLayoutView()
    
//    init() {
//        super.init(nibName: nil, bundle: nil)
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        self.view.addSubview(headerView)
    }
    
    private var didUpdateConstraint = false
    override func updateViewConstraints() {
        if !didUpdateConstraint {
            ([tableView, headerView] as NSArray).autoDistributeViewsAlongAxis(.Horizontal, alignedTo: .Left, withFixedSpacing: 0)
            didUpdateConstraint = true
        }
        super.updateViewConstraints()
    }
}

