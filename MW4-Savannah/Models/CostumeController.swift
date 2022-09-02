//
//  CostumeController.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 8/30/22.
//

import Foundation
import CoreBluetooth

let maxCharacteristicSize = 512

class CostumeController: ObservableObject {
    @Published var fwVersion: UInt8?
    
    internal var _fwVersionCharacteristic: CBCharacteristic?
    internal var _otaUpdateCharacteristic: CBCharacteristic?
        
    func sendFWUpdate(_ fw: Data) {
//        guard bleMgr.mwPeripheral != nil && self._otaUpdateCharacteristic != nil else { return }
//        
//        var curPos = 0
//        var remaining = fw.count
//        
//        while remaining > 0 && bleMgr.mwPeripheral!.canSendWriteWithoutResponse {
//            let sz = remaining >= maxCharacteristicSize ? maxCharacteristicSize : remaining
//            let slice = fw[curPos..<curPos + sz]
//            curPos += sz
//            remaining -= sz
//            
//            bleMgr.mwPeripheral!.writeValue(slice, for: self._otaUpdateCharacteristic!, type: .withResponse)
//        }
    }
}

let costumeController = CostumeController()
