//
//  BTServices.swift
//  hackathon
//
//  Created by Trong_iOS on 4/20/17.
//  Copyright © 2017 Autonomous Inc. All rights reserved.
//

import Foundation

class BTServices {
    
    fileprivate let highQueue, backgroundQueue: DispatchQueue?
    public static let sharedInstance = BTServices()
    
    init() {
        highQueue = DispatchQueue(label: "com.autonomous.high_queue", qos: DispatchQoS.default)
        backgroundQueue = DispatchQueue(label: "com.autonomous.bg_queue", qos: DispatchQoS.background, attributes: .concurrent)
    }
    
    func synced(_ lock: Any, closure: () -> ()) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    
    func addAction(action: String, onSuccess:@escaping (_ value: Int)->(Void)) {
        highQueue?.async {
            BT.sharedInstance.sendData(data: action, onSuccess: { (value) -> (Void) in
                if (action.contains("d:")) {
                    print("Saved d: action -> ", value)
                    UserDefaults.standard.set(1, forKey: KEY.DATE)
                    UserDefaults.standard.synchronize()
                    
                } else if (action.contains("s:")) {
                    print("Saved s: action -> ", value)
                    if Int(value) != 0 {
                        UserDefaults.standard.set(Int(value), forKey: KEY.OFFSET)
                        UserDefaults.standard.synchronize()
                    }
                    
                    
                } else if (action.contains("t:")) {
                    self.backgroundQueue?.async {
                        self.parseData(data: value)
                    }
                    
                } else if (action.contains("l:")) {
                    // do nothing
                    
                } else if (action.contains("clear-all")) {
                    // do nothing
                    
                }
                
                onSuccess(1)
            })
        }
    }
    
    func parseData(data: String) {
        if data.characters.count > 0 {
            let arr = data.components(separatedBy: "\r\n") as? [String]
            for str in arr! {
                if str.characters.count > 0 {
                    if isValidData(str: str) {
                        let arr = str.components(separatedBy: "#")
                        let waterModel = WaterModel()
                        waterModel.time = arr[0]
                        waterModel.weight = Int(arr[1])!
                        waterModel.celc = Int(arr[2])!
                        waterModel.humidity = Int(arr[3])!
                        
                        GlobalMainQueue.async {
                            Database.sharedInstance.saveWater(water: waterModel)
                        }
                        
                    }
                }
            }
            
            BTServices.sharedInstance.addAction(action: "clear-all", onSuccess: { (value) -> (Void) in
            })
        }
    }
    
    private func isValidData(str: String) -> Bool {
        let arr = str.components(separatedBy: "#")
        if arr.count == 4 {
            return true
        }
        return false
    }
}
