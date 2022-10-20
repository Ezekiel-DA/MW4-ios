//
//  LightControlService.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 10/20/22.
//

import Foundation
import SwiftUI
import Combine
import CoreBluetooth
import AsyncBluetooth

let MW4_BLE_LIGHT_DEVICE_SERVICE_UUID                            = "0ba35e90-f55f-4f15-9347-3dc4a0287881"

let MW4_BLE_ID_CHARACTERISTIC_UUID                               = "63c62656-807f-4db4-97d3-94095962acf8"

let MW4_BLE_MODE_CHARACTERISTIC_UUID                             = "b54fc13b-4374-4a6f-861f-dd198f88f299"
let MW4_BLE_HUE_CHARACTERISTIC_UUID                              = "19dfe175-aa12-404b-843d-b625937cffff"
let MW4_BLE_SATURATION_CHARACTERISTIC_UUID                       = "946d22e6-2b2f-49e7-b941-150b023f2261"
let MW4_BLE_VALUE_CHARACTERISTIC_UUID                            = "6c5df188-2e69-4f2f-b4ab-9d2b76ef7aa9"

let MW4_BLE_MODE_ALT_CHARACTERISTIC_UUID                         = "757a6893-19ec-4d29-aed0-93a72deea093"
let MW4_BLE_HUE_ALT_CHARACTERISTIC_UUID                          = "d69b013f-9495-4809-924c-367b1a35f565"
let MW4_BLE_SATURATION_ALT_CHARACTERISTIC_UUID                   = "e27a37e8-fd5e-47f3-bff2-b07a357cb8e4"
let MW4_BLE_VALUE_ALT_CHARACTERISTIC_UUID                        = "52f49348-347b-46b9-ba39-3a2c7dfd51a2"

@MainActor class LightDeviceService: ObservableObject {
    @Published var id: UInt8?
    @Published var state: Bool?
    @Published var stateAlt: Bool?
    @Published var mode: UInt8?
    @Published var modeAlt: UInt8?
    @Published var hue: UInt8?
    @Published var hueAlt: UInt8?
    @Published var saturation: UInt8?
    @Published var saturationAlt: UInt8?
    @Published var value: UInt8?
    @Published var valueAlt: UInt8?
    
    internal var device: Peripheral?
    
    private var valueUpdateSubscription: AnyCancellable?
    
    private var appSideUpdates: Set<AnyCancellable> = []
    
    init() {
        $hue.sink { val in
            Task {
                guard let device = self.device else {
                    return
                }
                
                try await device.writeValue(self.hue ?? 0, forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_HUE_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_LIGHT_DEVICE_SERVICE_UUID)!)
            }
        }.store(in: &appSideUpdates)
        
        $saturation.sink { val in
            Task {
                guard let device = self.device else {
                    return
                }
                
                try await device.writeValue(self.saturation ?? 0, forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_SATURATION_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_LIGHT_DEVICE_SERVICE_UUID)!)
            }
        }.store(in: &appSideUpdates)
        
        $value.sink { val in
            Task {
                guard let device = self.device else {
                    return
                }
                
                try await device.writeValue(self.value ?? 0, forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_VALUE_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_LIGHT_DEVICE_SERVICE_UUID)!)
            }
        }.store(in: &appSideUpdates)
        
        $mode.sink { val in
            Task {
                guard let device = self.device else {
                    return
                }
                
                try await device.writeValue(self.mode ?? 0, forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_MODE_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_LIGHT_DEVICE_SERVICE_UUID)!)
            }
        }.store(in: &appSideUpdates)
    }
    
    func setDevice(_ peripheral: Peripheral) async {
        device = peripheral
        
//        for service in device!.discoveredServices ?? [] {
//            for characteristic in service.discoveredCharacteristics ?? [] {
//                if (characteristic.uuid == CBUUID(string: MW4_BLE_ID_CHARACTERISTIC_UUID)) {
//                    print("FOUND")
//                    print(characteristic)
//                }
//            }
//        }
                
        do {
            hue = try await device!.readValue(forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_HUE_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_LIGHT_DEVICE_SERVICE_UUID)!)
            saturation = try await device!.readValue(forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_SATURATION_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_LIGHT_DEVICE_SERVICE_UUID)!)
            value = try await device!.readValue(forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_VALUE_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_LIGHT_DEVICE_SERVICE_UUID)!)
            mode = try await device!.readValue(forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_MODE_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_LIGHT_DEVICE_SERVICE_UUID)!)
            
            try await device!.setNotifyValue(true, forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_HUE_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_LIGHT_DEVICE_SERVICE_UUID)!)
            try await device!.setNotifyValue(true, forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_SATURATION_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_LIGHT_DEVICE_SERVICE_UUID)!)
            try await device!.setNotifyValue(true, forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_VALUE_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_LIGHT_DEVICE_SERVICE_UUID)!)
            try await device!.setNotifyValue(true, forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_MODE_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_LIGHT_DEVICE_SERVICE_UUID)!)
                        
            valueUpdateSubscription = device!.characteristicValueUpdatedPublisher.sink(
                receiveValue: { value in
                    Task {
                        switch value.uuid {
                        case CBUUID(string: MW4_BLE_HUE_CHARACTERISTIC_UUID):
                            self.hue = value.value![0]
                            break
                        case CBUUID(string: MW4_BLE_SATURATION_CHARACTERISTIC_UUID):
                            self.saturation = value.value![0]
                            break
                        case CBUUID(string: MW4_BLE_VALUE_CHARACTERISTIC_UUID):
                            self.value = value.value![0]
                            break
                        case CBUUID(string: MW4_BLE_MODE_CHARACTERISTIC_UUID):
                            self.mode = value.value![0]
                            break
                        default:
                            break
                        }
                    }
                }
            )
        } catch {
            assert(false)
            return
        }
    }
}

//class LightControlServiceMock: LightControlService {
//    init(text dummyText: String, scrolling isScrolling: UInt8) {
//        super.init()
//        text = dummyText
//        scrolling = isScrolling
//    }
//}
