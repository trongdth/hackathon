//
//  MyXAxis.swift
//  hackathon
//
//  Created by Trong_iOS on 4/21/17.
//  Copyright © 2017 Autonomous Inc. All rights reserved.
//

import Foundation

import UIKit
import Foundation
import Charts

@objc(MyXAxis)
public class MyXAxis: NSObject, IAxisValueFormatter {
    
    var months: [String]! = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return months[Int(value)]
    }
}
