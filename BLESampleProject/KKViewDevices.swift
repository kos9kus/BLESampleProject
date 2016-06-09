//
//  UIViewDevices.swift
//  BLESampleProject
//
//  Created by KONSTANTIN KUSAINOV on 09/06/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

import UIKit

class KKViewDevices: UIView {
    
    let statusLabel: UILabel = {
        let label = UILabel(forAutoLayout: ())
        label.font = UIFont.boldSystemFontOfSize(14)
        label.text = "BLE Status"
        return label
    }()
    
    init(buttonHandler: (isStart: Bool) -> Bool) {
        self.buttonHandler = buttonHandler
        super.init(frame: CGRectZero)
        self.configureForAutoLayout()
        
        self.addSubview(statusLabel)
        self.addSubview(scanButton)
        
        self.scanButton.addTarget(self, action: #selector(didTapButton), forControlEvents: .TouchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var didUpdateLayout = false
    override func updateConstraints() {
        if !didUpdateLayout {
            statusLabel.autoPinEdgeToSuperviewEdge(.Left)
            statusLabel.autoPinEdgeToSuperviewEdge(.Right)
            
            ([statusLabel, scanButton] as NSArray).autoDistributeViewsAlongAxis(.Vertical, alignedTo: .Vertical, withFixedSpacing: 10, insetSpacing: true)
            didUpdateLayout = true
        }
        super.updateConstraints()
    }
    
    func didTapButton() {
        guard buttonHandler(start: !scanButton.selected) else {
            return
        }
        
        if !scanButton.selected {
            scanButton.setTitle("Stop scanning", forState: .Normal)
            scanButton.backgroundColor = .greenColor()
            
        } else {
            scanButton.setTitle("Scan", forState: .Normal)
            scanButton.backgroundColor = .redColor()
        }
        
        scanButton.selected = !scanButton.selected
    }
    
    // MARK: - Private
    var buttonHandler: (start: Bool) -> Bool
    private let scanButton: UIButton = {
        let btn = UIButton(forAutoLayout: ())
        btn.autoSetDimensionsToSize(CGSize(width: 250, height: 35) )
        btn.setTitle("SCAN", forState: .Normal)
        btn.backgroundColor = .redColor()
        return btn
    }()
    
    
}
