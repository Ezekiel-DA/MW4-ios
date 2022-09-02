//
//  AsyncBLEManager.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 8/31/22.
//

import Foundation

import CoreBluetooth
import AsyncBluetooth


// Main (advertised) service exposed by the costume
let MWNEXT_BLE_COSTUME_CONTROL_SERVICE_UUID                 = "47191881-ebb3-4a9f-9645-3a5c6dae4900"
let MW4_BLE_COSTUME_CONTROL_FW_VERSION_CHARACTERISTIC_UUID  = "55cf24c7-7a28-4df4-9b53-356b336bab71"
let MW4_BLE_COSTUME_CONTROL_OTA_CHARACTERISTIC_UUID         = "1083b9a4-fdc0-4aa6-b027-a2600c8837c4"

// As far as I can tell CoreBluetooth doesn't define constants for the official SIG UUIDs?
let SIG_BLE_OBJECTNAME_CHARACTERISTIC_UUID      = "0x2ABE"

let allMW4CostumeControlCharacteristicUUIDs = [
    MW4_BLE_COSTUME_CONTROL_FW_VERSION_CHARACTERISTIC_UUID,
    MW4_BLE_COSTUME_CONTROL_OTA_CHARACTERISTIC_UUID
]

let centralManager = CentralManager()

class BLEState: ObservableObject {
    @Published var bluetoothUnavailable = false
    @Published var bluetoothOff = false
}

let bleState = BLEState()

@MainActor func getBLEDevice() async throws -> Peripheral? {
    do {
        try await centralManager.waitUntilReady()
    }    
    catch {
        switch centralManager.bluetoothState {
        case .unauthorized:
            print("unauthorized")
            bleState.bluetoothUnavailable = true
        case .poweredOff:
            bleState.bluetoothOff = true
        default:
            break
        }
        
        return nil
    }
    
    var peripheral: Peripheral?
    
    let scannedPeripherals = try await centralManager.scanForPeripherals(withServices: [CBUUID(string: MWNEXT_BLE_COSTUME_CONTROL_SERVICE_UUID)])
    for await scannedPeripheral in scannedPeripherals {
        peripheral = scannedPeripheral.peripheral
        break
    }
    await centralManager.stopScan()
    try await centralManager.connect(peripheral!, options: [CBCentralManagerOptionShowPowerAlertKey: true])
    return peripheral
}

func getFWVersion(_ peripheral: Peripheral) async -> Int? {
    do {
        let res: Int? = try await peripheral.readValue(forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_COSTUME_CONTROL_FW_VERSION_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MWNEXT_BLE_COSTUME_CONTROL_SERVICE_UUID)!)
        return res
    } catch {
        return nil
    }
}

//class BLEManager : NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject {
//    var mwPeripheral: CBPeripheral?

//
//
//    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        connected = true
//        central.stopScan()
//        peripheral.delegate = self
//        peripheral.discoverServices([MWNEXT_BLE_COSTUME_CONTROL_SERVICE_UUID])
////        peripheral.discoverServices(allMWNextLightControlServiceUUIDs)
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        if (error != nil) {
//            print(error!)
//        }
//
//        print("Found MW4 services")
//        assert(peripheral.services != nil)
//        for service in peripheral.services! {
//            if (service.uuid == MWNEXT_BLE_COSTUME_CONTROL_SERVICE_UUID) { // treat the "main" control service differently; it has a separate set of characteristics from the services controlling light devices
//                peripheral.discoverCharacteristics(allMW4CostumeControlCharacteristicUUIDs, for: service)
//            }
//        }
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//        for characteristic in service.characteristics! {
//            var subscribe = false
//            var read = false
//            switch characteristic.uuid {
//            case MW4_BLE_COSTUME_CONTROL_OTA_CHARACTERISTIC_UUID:
//                costumeController._otaUpdateCharacteristic = characteristic
//                subscribe = false
//            case MW4_BLE_COSTUME_CONTROL_FW_VERSION_CHARACTERISTIC_UUID:
//                costumeController._fwVersionCharacteristic = characteristic
//                subscribe = true
//                read = true
//            default:
//                break
//            }
//            if subscribe {
//                peripheral.setNotifyValue(true, for: characteristic)
//            }
//            if read {
//                peripheral.readValue(for: characteristic)
//            }
//        }
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        assert(error == nil)
//        assert(characteristic.value != nil)
//        assert(characteristic.service != nil)
//
//        switch characteristic.uuid {
//        case MW4_BLE_COSTUME_CONTROL_FW_VERSION_CHARACTERISTIC_UUID:
//            costumeController.fwVersion = characteristic.value!.first!
//        default:
//            break
//        }
//    }
//}
