//
//  Constant.swift
//  SmartDesk
//
//  Created by sa on 3/2/17.
//  Copyright © 2017 Autonomous Inc. All rights reserved.
//

import UIKit


//MARK: NOTIFICATION
extension Notification.Name {
    static let RefreshFeedPageNotification = Notification.Name("RefreshFeedPageNotification")
    static let RefreshDownloadedPageNotification = Notification.Name("RefreshDownloadedPageNotification")
    static let RefreshLikeItemNotification = Notification.Name("RefreshLikeItemNotification")
    static let RefreshPageNotification = Notification.Name("RefreshPageNotification")
    static let SelectMenuIndexNotification = Notification.Name("SelectMenuIndexNotification")
    static let kNOTI_APP_OPEN = Notification.Name("kNOTI_APP_OPEN")
    static let kNOTI_FINISH_SETUP = Notification.Name("kNOTI_FINISH_SETUP")
    static let kNOTI_ADDING_DEVICE = Notification.Name("kNOTI_ADDING_DEVICE")
    static let kNOTI_PING_SUCCESS = Notification.Name("kNOTI_PING_SUCCESS")
    static let kNOTI_GET_SYSTEM_VERSION = Notification.Name("kNOTI_GET_SYSTEM_VERSION")
}

struct KEY {
    static let DATE = "Date"
    static let OFFSET = "Offset"
    static let WEIGHT = 72
    static let HEIGHT = 172
    static let CEIL = 30
    static let WORK_CONDITION = 2
    static let AGE = 32
    static let GENDER = 1
}

