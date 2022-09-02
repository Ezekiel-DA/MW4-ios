////
////  BLEManager.swift
////  MW4-Savannah
////
////  Created by Nicolas LEFEBVRE on 8/30/22.
////
//
//import Foundation
//import CoreBluetooth
//
//// Main (advertised) service exposed by the costume
//let MWNEXT_BLE_COSTUME_CONTROL_SERVICE_UUID                 = CBUUID(string: "47191881-ebb3-4a9f-9645-3a5c6dae4900")
//let MW4_BLE_COSTUME_CONTROL_FW_VERSION_CHARACTERISTIC_UUID  = CBUUID(string: "55cf24c7-7a28-4df4-9b53-356b336bab71")
//let MW4_BLE_COSTUME_CONTROL_OTA_CHARACTERISTIC_UUID         = CBUUID(string: "1083b9a4-fdc0-4aa6-b027-a2600c8837c4")
//
//// As far as I can tell CoreBluetooth doesn't define constants for the official SIG UUIDs?
//let SIG_BLE_OBJECTNAME_CHARACTERISTIC_UUID      = CBUUID(string: "0x2ABE")
//
//let allMW4CostumeControlCharacteristicUUIDs = [
//    MW4_BLE_COSTUME_CONTROL_FW_VERSION_CHARACTERISTIC_UUID,
//    MW4_BLE_COSTUME_CONTROL_OTA_CHARACTERISTIC_UUID
//]
//
//class BLEManager : NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject {
//    var mwPeripheral: CBPeripheral?
//    
//    @Published var bluetoothUnavailable = false
//    @Published var bluetoothOff = false
//    @Published var connected = false
//            
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        switch central.state {
//        case .poweredOn:
//            print("BLE Central ready, scanning...")
//            bluetoothOff = false
//            central.scanForPeripherals(withServices: [MWNEXT_BLE_COSTUME_CONTROL_SERVICE_UUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
//        case .unknown:
//            print("CBCentralManager state changed to: unknown")
//        case .resetting:
//            print("reset")
//        case .unsupported:
//            print("unsupported")
//        case .unauthorized:
//            print("unauthorized")
//            bluetoothUnavailable = true
//        case .poweredOff:
//            bluetoothOff = true
//        @unknown default:
//            print("WTF")
//        }
//    }
//    
//    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
//        print("Disconnected from \(peripheral.name!)")
//        mwPeripheral = nil
//        connected = false
//        central.scanForPeripherals(withServices: [MWNEXT_BLE_COSTUME_CONTROL_SERVICE_UUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
//    }
//    
//    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
//        guard RSSI.intValue >= -90
//        else {
//            print("Connection too weak; RSSI is \(RSSI)")
//            return
//        }
//        
//        if ((mwPeripheral == nil)) {
//            mwPeripheral = peripheral
//            central.connect(peripheral, options: nil)
//            print("Connecting to MW peripheral...")
//        }
//    }
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
////        let device = service.uuid == MWNEXT_BLE_COSTUME_CONTROL_SERVICE_UUID ? nil : costumeController.getDeviceByUUID(service.uuid)
////
////        for characteristic in service.characteristics! {
////            switch characteristic.uuid {
////            // controller characteristics
////            case MWNEXT_BLE_TAG_PRESENT_CHARACTERISTIC_UUID:
////                costumeController._tagPresentCharacteristic = characteristic
////            case MWNEXT_BLE_TAG_WRITE_REQUEST_CHARACTERISTIC_UUID:
////                costumeController._tagWriteRequestCharacteristic = characteristic
////            case MWNEXT_BLE_TAG_WRITE_ERROR_CHARACTERISTIC_UUID:
////                costumeController._tagWriteErrorCharacteristic = characteristic
////
////            // individual light device characteristics
////            case MWNEXT_BLE_MODE_CHARACTERISTIC_UUID:
////                device!._modeCharacteristic = characteristic
////            case MWNEXT_BLE_HUE_CHARACTERISTIC_UUID:
////                device!._hueCharacteristic = characteristic
////            case MWNEXT_BLE_CYCLE_COLOR_CHARACTERISTIC_UUID:
////                device!._rainbowModeCharacteristic = characteristic
////            case MWNEXT_BLE_SATURATION_CHARACTERISTIC_UUID:
////                device!._saturationCharacteristic = characteristic
////            default:
////                break
////            }
////            peripheral.setNotifyValue(true, for: characteristic)
////            peripheral.readValue(for: characteristic)
////        }
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
//        
////        let device = characteristic.service!.uuid == MWNEXT_BLE_COSTUME_CONTROL_SERVICE_UUID ? nil : costumeController.getDeviceByUUID(characteristic.service!.uuid)
////
////        if characteristic.uuid == SIG_BLE_OBJECTNAME_CHARACTERISTIC_UUID { // object name is the only characteristic that needs decoding as a UTF8 string...
////            let name = String(decoding: characteristic.value!, as: UTF8.self)
////            device!.name = name
////        } else { // ... everything else is just a 1 byte value
////            assert(characteristic.value!.count == 1)
////            let val = characteristic.value!.first!
////
////            switch characteristic.uuid {
////            // controller characteristics
////            case MWNEXT_BLE_TAG_PRESENT_CHARACTERISTIC_UUID:
////                costumeController.tagPresent = val != 0
////            case MWNEXT_BLE_TAG_WRITE_REQUEST_CHARACTERISTIC_UUID:
////                costumeController.tagWriteRequest = val != 0
////            case MWNEXT_BLE_TAG_WRITE_ERROR_CHARACTERISTIC_UUID:
////                costumeController.tagWriteError = val
////
////            // individual light device characteristics
////            case MWNEXT_BLE_DEVICE_TYPE_CHARACTERISTIC_UUID:
////                device!.type = val
////            case MWNEXT_BLE_MODE_CHARACTERISTIC_UUID:
////                device!.mode = val
////            case MWNEXT_BLE_HUE_CHARACTERISTIC_UUID:
////                device!.hue = val
////            case MWNEXT_BLE_SATURATION_CHARACTERISTIC_UUID:
////                device!.saturation = val
////            case MWNEXT_BLE_CYCLE_COLOR_CHARACTERISTIC_UUID:
////                device!.rainbowMode = val != 0
////            default:
////                assert(false, "Unexpected characteristic")
////            }
////        }
//    }
//}
