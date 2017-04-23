//
//  BT.swift
//  hackathon
//
//  Created by Trong_iOS on 4/20/17.
//  Copyright © 2017 Autonomous Inc. All rights reserved.
//

import Foundation
import CoreBluetooth

class BT: NSObject {
    var centralManager: CBCentralManager?
    var peripheral: CBPeripheral!
    var onCallback: ((_ value: String)->(Void))? = nil
    var onDisconver: ((_ value: Int)->(Void))? = nil
    var characteristic: CBCharacteristic?
    var myData: String = ""
    
    public static let sharedInstance = BT()
    
    override private init() {
    }
    
    func run(onSuccess:@escaping (_ value: Int)-> (Void)) {
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated))
        onDisconver = onSuccess
    }
    
    func sendData(data: String, onSuccess: @escaping (_ value: String)->(Void)) {
        onCallback = onSuccess
        
        if peripheral != nil && peripheral.state == .connected && (characteristic != nil) {
            peripheral.writeValue(data.data(using: .ascii)!, for: characteristic!, type: .withoutResponse)
            
        } else {
            onCallback!("-1")
        }
    }
    
}

extension BT: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == .poweredOn){
            self.centralManager?.scanForPeripherals(withServices: nil, options: nil)
        }
        else {
            // do something like alert the user that ble is not on
            print("Please turn on BLE")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let device = (advertisementData as NSDictionary)
            .object(forKey: CBAdvertisementDataLocalNameKey)
            as? NSString
        
        if device?.contains("SmartDock") == true {
            print(peripheral)
            self.centralManager?.stopScan()
            self.peripheral = peripheral
            self.peripheral.delegate = self
            
            self.centralManager?.connect(self.peripheral, options: nil)
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
        print("Disconnect")
    }
    
}

extension BT: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            let thisService = service as CBService
            
            if service.uuid == CBUUID(string: "0000ffe0-0000-1000-8000-00805f9b34fb") {
                peripheral.discoverCharacteristics(
                    nil,
                    for: thisService
                )
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics! {
            self.characteristic = characteristic as CBCharacteristic
            
            if self.characteristic?.uuid == CBUUID(string: "0000ffe1-0000-1000-8000-00805f9b34fb") {
                self.peripheral.setNotifyValue(
                    true,
                    for: self.characteristic!
                )
                
                if ((onDisconver) != nil) {
                    onDisconver!(1)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == CBUUID(string: "0000ffe1-0000-1000-8000-00805f9b34fb") {
            if let _ = characteristic.value {
                let tmp = String(data:characteristic.value!, encoding:.utf8)!
                print(tmp)
                if tmp.contains("end") {
                    var tmp = tmp.replacingOccurrences(of: "end", with: "")
                    tmp = tmp.replacingOccurrences(of: "\r\n", with: "")
                    var myStr = ""
                    myStr = self.myData + tmp
                    onCallback!(myStr)
                    self.myData = ""
                } else {
                    self.myData = self.myData + String(data:characteristic.value!, encoding:.utf8)!
                }
            }
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print(error)
        }
        print("wrote to \(characteristic)")
        if let value = characteristic.value {
            print(String(data:value, encoding:.utf8)!)
        }
    }
}
