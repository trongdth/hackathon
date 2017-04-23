//
//  WaterModel.swift
//  hackathon
//
//  Created by Trong_iOS on 4/20/17.
//  Copyright © 2017 Autonomous Inc. All rights reserved.
//

import Foundation
import RealmSwift

class WaterModel: Object {
    dynamic var time: String = ""
    dynamic var weight: Int = 0
    dynamic var celc: Int = 0
    dynamic var humidity: Int = 0
}
