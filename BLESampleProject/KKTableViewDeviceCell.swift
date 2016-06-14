//
//  KKTableViewDeviceCell.swift
//  BLESampleProject
//
//  Created by KONSTANTIN KUSAINOV on 08/06/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

import UIKit

protocol KKTableConfigurableCell {
    associatedtype ObjectCell
    func configureCell(object: ObjectCell)
}

class KKTableViewDeviceCell: UITableViewCell, KKTableConfigurableCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .DisclosureIndicator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(object: KKPeripheral) {
        self.textLabel?.text = object.name
        self.detailTextLabel?.text = object.proximity
    }
}
