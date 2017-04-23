//
//  Database.swift
//  AutonomousCore
//
//  Created by Trong_iOS on 3/16/17.
//  Copyright © 2017 Autonomous Inc. All rights reserved.
//

import Foundation
import RealmSwift

public class Database {
    
    fileprivate var realm : Realm?
    public static let sharedInstance = Database()
    
    
    fileprivate init() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        try! realm = Realm.init()
    }
    
    func clearDatabase() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func saveWater(water: WaterModel) {
        try! realm?.write {
            realm?.add(water)
        }
    }
    
    func allWaterLogs() -> Results<WaterModel>? {
        return realm?.objects(WaterModel.self)
    }
}
