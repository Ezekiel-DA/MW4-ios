//
//  CostumeController.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 8/30/22.
//

import Foundation
import Combine
import CoreBluetooth
import AsyncBluetooth

// Main (advertised) service exposed by the costume
let MWNEXT_BLE_COSTUME_CONTROL_SERVICE_UUID                 = "47191881-ebb3-4a9f-9645-3a5c6dae4900"
let MW4_BLE_COSTUME_CONTROL_FW_VERSION_CHARACTERISTIC_UUID  = "55cf24c7-7a28-4df4-9b53-356b336bab71"
let MW4_BLE_COSTUME_CONTROL_OTA_DATA_CHARACTERISTIC_UUID    = "1083b9a4-fdc0-4aa6-b027-a2600c8837c4"
let MW4_BLE_COSTUME_CONTROL_OTA_CONTROL_CHARACTERISTIC_UUID = "d1627dbe-b6ae-421f-b2eb-5878576410c0"

let OTA_CONTROL_NOP   = 0x00
let OTA_CONTROL_ACK   = 0x01
let OTA_CONTROL_NACK  = 0x02
let OTA_CONTROL_START = 0x04
let OTA_CONTROL_END   = 0x08
let OTA_CONTROL_ERR   = 0xFF

@MainActor class CostumeBLEServiceManager : ObservableObject {
    @Published var fwVersion: UInt8?
    
    @Published var otaProgress = 0.0
    @Published var otaElapsed = 0.0
    @Published var otaKBps = 0.0
    
    internal var device: Peripheral?
    
            
    func setDevice(_ peripheral: Peripheral) async {
        device = peripheral
        let res = await getFWVersion(device!)
        fwVersion = UInt8(res!)
    }
        
    func sendFWUpdate(_ fw: Data) async {
        var dataToSend = fw
        
        guard let device = device else {
            return
        }
        
        do {
            try await device.setNotifyValue(true, forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_COSTUME_CONTROL_OTA_CONTROL_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MWNEXT_BLE_COSTUME_CONTROL_SERVICE_UUID)!)
            
            Task {  // Start OTA in a task so we can await the Publisher immediately, instead of being stuck waiting for the response until it's too late
                    // NB: doing a write .withoutResponse for the start message might work as well and make more sense? But AsyncBluetooth doesn't seem to expose this
                try await sendOTAControlMessage(OTA_CONTROL_START, device: device)
            }
            
            // convert Publisher to async sequence and wait for 1st element in sequence, which should be an ACK for the above start
            for try await val in device.characteristicValueUpdatedPublisher.values {
                let msg = val.value![0]
                guard (msg == OTA_CONTROL_ACK) else {
                    print("TODO: HANDLE OTA FAILURE; device did not respond to OTA_CONTROL_START with OTA_CONTROL_ACK")
                    return
                }
                
                // reset CTRL to NOP
                try await sendOTAControlMessage(OTA_CONTROL_NOP, device: device)
                
                // chunk and send OTA update
                let msgSize = device.maximumWriteValueLength(for: .withResponse)
                var range: Range<Data.Index>
                var remaining = true
                var sentBytes = 0
                let startTime = CFAbsoluteTimeGetCurrent()
                                        
                while remaining {
                    range = (0..<min(msgSize, dataToSend.count))
                    
                    let chunk = dataToSend.subdata(in: range)
                    
                    if !dataToSend.isEmpty {
                        try await sendOTAData(chunk, device: device)
                    } else {
                        remaining = false
                    }
                    
                    dataToSend.removeSubrange(range)
                    
                    self.otaProgress = (1 - (Double(dataToSend.count) / Double(fw.count))) * 100
                    sentBytes = sentBytes + msgSize
                    self.otaElapsed = CFAbsoluteTimeGetCurrent() - startTime
                    let rate = Double(sentBytes) / self.otaElapsed
                    self.otaKBps = rate / 1000
                }
                
                // notify END of OTA
                Task {
                    try await sendOTAControlMessage(OTA_CONTROL_END, device: device)
                }
                
                return // return without waiting for the OTA_END message to complete; it might not, since the ESP will restart
            }
        } catch {
            print("ERROR IN OTA UPLOAD")
            return
        }
    }
}

private func getFWVersion(_ peripheral: Peripheral) async -> Int? {
    do {
        let res: Int? = try await peripheral.readValue(forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_COSTUME_CONTROL_FW_VERSION_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MWNEXT_BLE_COSTUME_CONTROL_SERVICE_UUID)!)
        return res
    } catch {
        return nil
    }
}

private func sendOTAControlMessage(_ msg: Int, device: Peripheral) async throws {
    try await device.writeValue(msg, forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_COSTUME_CONTROL_OTA_CONTROL_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MWNEXT_BLE_COSTUME_CONTROL_SERVICE_UUID)!)
}

private func sendOTAData(_ data: Data, device: Peripheral) async throws {
    try await device.writeValue(data, forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_COSTUME_CONTROL_OTA_DATA_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MWNEXT_BLE_COSTUME_CONTROL_SERVICE_UUID)!)
}
