//
//  Config.swift
//  AutonomousUtil
//
//  Created by Trong_iOS on 3/27/17.
//  Copyright © 2017 Autonomous Inc. All rights reserved.
//

//
//  Constant.swift
//  Pods
//
//  Created by sa on 3/8/17.
//
//
import UIKit

public let AUTHORIZATION_FORMAT = "Autonomous %@"

//Define color for each project
public struct APP_COLOR {
    public static let NAVIGATION_TITLE_COLOR = UIColor(red: 139/255.0, green: 139/255.0, blue: 139/255.0, alpha: 1.0) // change navigation title to each product color, default gray
    public static let BARBUTTON_TITLE_COLOR = UIColor(red: 139/255.0, green: 139/255.0, blue: 139/255.0, alpha: 1.0) // change navigation title to each product color, default gray
}

//Define font for each project// Change the font name for your project
public struct APP_FONT {
    static let fRegular = "AvenirNext-Regular"
    static let fSemiBold = "AvenirNext-Medium"
    static let fBold = "AvenirNext-DemiBold"
    static let fItalic = "AvenirNext-Italic"
}

// MARK:- FONT
public protocol CustomFontsProtocol {
    var fontName: String { get }
}

extension CustomFontsProtocol {
    public func size(size: CGFloat) -> UIFont {
        return UIFont(name: fontName, size: size)!
    }
}

public enum CUSTOM_FONT: CustomFontsProtocol{
    case fREGULAR
    case fSEMIBOLD
    case fBOLD
    case fITALIC
    
    public var fontName: String {
        switch self {
        case .fREGULAR: return APP_FONT.fRegular
        case .fSEMIBOLD: return APP_FONT.fSemiBold
        case .fBOLD: return APP_FONT.fBold
        case .fITALIC: return APP_FONT.fItalic
        }
    }
    
}

//MARK:- VERSION
public func SYSTEM_VERSION_EQUAL_TO(_ version : String) -> Bool {
    return UIDevice.current.systemVersion.compare(version) == .orderedSame
}

public func SYSTEM_VERSION_GREATER_THAN(_ version : String) -> Bool {
    return UIDevice.current.systemVersion.compare(version) == .orderedDescending
}

public func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(_ version : String) -> Bool {
    return UIDevice.current.systemVersion.compare(version) == .orderedAscending
}

public func SYSTEM_VERSION_LESS_THAN(_ version : String) -> Bool {
    return UIDevice.current.systemVersion.compare(version) == .orderedAscending
}

public func SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(_ version : String) -> Bool {
    return UIDevice.current.systemVersion.compare(version) == .orderedDescending
}

//MARK:- GCD
public var GlobalMainQueue: DispatchQueue {
    return DispatchQueue.main
}

public var GlobalUserInteractiveQueue: DispatchQueue {
    return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
}

public var GlobalUserInitiatedQueue: DispatchQueue {
    return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
}

public var GlobalUtilityQueue: DispatchQueue {
    return DispatchQueue.global(qos: DispatchQoS.QoSClass.utility)
}

public var GlobalBackgroundQueue: DispatchQueue {
    return DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
}

