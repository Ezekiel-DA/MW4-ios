//
//  FrontTextService.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/1/22.
//

import Foundation
import SwiftUI
import Combine
import CoreBluetooth
import AsyncBluetooth

let MW4_BLE_TEXT_DISPLAY_SERVICE_UUID                            = "aafca82b-95ae-4f33-9cf3-7ee0ef15ddf4"
let MW4_BLE_TEXT_DISPLAY_TEXT_CHARACTERISTIC_UUID                = "c5b56d2e-b6e9-49c7-b098-5af9a75f46cd"
let MW4_BLE_TEXT_DISPLAY_OFFSET_CHARACTERISTIC_UUID              = "a0f348d3-5c80-420f-bb5f-1732824ac215"
let MW4_BLE_TEXT_DISPLAY_SCROLLING_CHARACTERISTIC_UUID           = "966c3d0d-493c-4b59-ae1d-d3768ff9ada8"
let MW4_BLE_TEXT_DISPLAY_SCROLL_SPEED_CHARACTERISTIC_UUID        = "1fc1cf59-0e88-4dda-81fc-818a14da216b"
let MW4_BLE_TEXT_DISPLAY_PAUSE_TIME_CHARACTERISTIC_UUID          = "7a991117-a277-46ae-8d73-0a7e7e6ae7e8"
let MW4_BLE_TEXT_DISPLAY_BRIGHTNESS_CHARACTERISTIC_UUID          = "48387eca-eedf-40ee-ab37-b4fb3a18cdf1"
let MW4_BLE_TEXT_DISPLAY_FG_COLOR_CHARACTERISTIC_UUID            = "4119bf67-6295-4ec9-b596-5b32a3f2fda5"
let MW4_BLE_TEXT_DISPLAY_BG_COLOR_CHARACTERISTIC_UUID            = "1b56faa0-376a-432a-a79a-e1a4f12dd493"

func parse(data: Data) -> Bool? {
    return String(data: data, encoding: .utf8).flatMap(Bool.init)
}

extension UInt8: PeripheralDataConvertible {}

@MainActor class TextDisplayService: ObservableObject {
    @Published var text: String?
    @Published var bgColor: Color?
    @Published var fgCOlor: Color?
    @Published var scrolling: UInt8?
    @Published var scrollSpeed: UInt8?
    @Published var pauseTime: UInt8?
    @Published var brightness: UInt8?
    
    internal var device: Peripheral?
    
    private var valueUpdateSubscription: AnyCancellable?
    
    private var appSideUpdates: Set<AnyCancellable> = []
    
    init() {
        $text.sink { val in
            Task {
                guard let device = self.device else {
                    print("NO DEVICE CONNECTED!!")
                    return
                }
                try await device.writeValue(self.text ?? "", forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_TEXT_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SERVICE_UUID)!)
            }
        }.store(in: &appSideUpdates)
        
        $scrolling.sink { val in
            Task {
                guard let device = self.device else {
                    print("NO DEVICE CONNECTED!")
                    return
                }
                try await device.writeValue(Data([self.scrolling!]), forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SCROLLING_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SERVICE_UUID)!)
            }
        }.store(in: &appSideUpdates)
    }
    
    func setDevice(_ peripheral: Peripheral) async {
        device = peripheral
                
        do {
            
            text = try await device!.readValue(forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_TEXT_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SERVICE_UUID)!)
            scrolling = try await device!.readValue(forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SCROLLING_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SERVICE_UUID)!)
            
            try await device!.setNotifyValue(true, forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_TEXT_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SERVICE_UUID)!)
            
            valueUpdateSubscription = device!.characteristicValueUpdatedPublisher.sink(
                receiveValue: { value in
                    Task {
                        switch value.uuid {
                        case CBUUID(string: MW4_BLE_TEXT_DISPLAY_TEXT_CHARACTERISTIC_UUID):
                            self.text = String(decoding: value.value!, as: UTF8.self)
                            break
                        case CBUUID(string: MW4_BLE_TEXT_DISPLAY_SCROLLING_CHARACTERISTIC_UUID):
                            self.scrolling = value.value![0]
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

class TextDisplayServiceMock: TextDisplayService {
    init(text dummyText: String, scrolling isScrolling: UInt8) {
        super.init()
        text = dummyText
        scrolling = isScrolling
    }
}
