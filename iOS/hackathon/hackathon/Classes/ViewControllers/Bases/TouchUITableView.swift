//
//  TouchUITableView.swift
//  SmartDesk
//
//  Created by sa on 3/1/17.
//  Copyright © 2017 Autonomous Inc. All rights reserved.
//

import UIKit

open class TouchUITableView: UITableView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }

}
