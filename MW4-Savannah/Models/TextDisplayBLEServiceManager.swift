//
//  TextDisplayBLEServiceManager.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 10/26/22.
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

let MW4_BLE_TEXT_DISPLAY_TEXT_ALT_CHARACTERISTIC_UUID            = "5830efb7-819e-42db-8d4e-e9e19f096a20"
let MW4_BLE_TEXT_DISPLAY_OFFSET_ALT_CHARACTERISTIC_UUID          = "0ef6a5e1-9f5c-41ba-b1d6-39139cc8e721"
let MW4_BLE_TEXT_DISPLAY_SCROLLING_ALT_CHARACTERISTIC_UUID       = "15b01f47-fe52-4851-8835-e97b09906443"
let MW4_BLE_TEXT_DISPLAY_SCROLL_SPEED_ALT_CHARACTERISTIC_UUID    = "ee361bc6-09cc-47af-b5b8-7e035b92e339"
let MW4_BLE_TEXT_DISPLAY_PAUSE_TIME_ALT_CHARACTERISTIC_UUID      = "920879e1-b132-4326-ad22-7daf4bd4f037"
let MW4_BLE_TEXT_DISPLAY_BRIGHTNESS_ALT_CHARACTERISTIC_UUID      = "a682dc43-8039-402e-a5cb-4c1b41075bf4"
let MW4_BLE_TEXT_DISPLAY_FG_COLOR_ALT_CHARACTERISTIC_UUID        = "de7cc85a-7df9-416b-be56-76c5ac8faa89"
let MW4_BLE_TEXT_DISPLAY_BG_COLOR_ALT_CHARACTERISTIC_UUID        = "fe344d11-3bc2-4511-841b-05f69f80b17f"

@MainActor class TextDisplayBLEServiceManager {
    
    @ObservedObject var modelView: CostumeModelView
    
    internal var device: Peripheral?
    
    private var valueUpdateSubscription: AnyCancellable?
    private var appSideUpdates: Set<AnyCancellable> = []
        
    init(modelView: CostumeModelView) {
        self.modelView = modelView
        
        self.modelView.$textScreen.throttle(for: .milliseconds(500), scheduler: DispatchQueue.main, latest: true).sink { val in
            Task {
                try await self.writeTextSettings(textSettings: val)
            }
        }.store(in: &appSideUpdates)
        
        self.modelView.$textScreenAlt.throttle(for: .milliseconds(500), scheduler: DispatchQueue.main, latest: true).sink { val in
            Task {
                try await self.writeTextSettings(textSettings: val, alt: true)
            }
        }.store(in: &appSideUpdates)
    }
    
    private func writeTextSettings(textSettings val: TextModelView, alt: Bool = false) async throws {
        guard let device = self.device else {
            print("NO DEVICE CONNECTED!")
            return
        }
        
        var textCharacteristicUUID: UUID
        var scrollingCharacteristicUUID: UUID
        var fgColorCharacteristicUUID: UUID
        
        if alt {
            textCharacteristicUUID = UUID(uuidString: MW4_BLE_TEXT_DISPLAY_TEXT_ALT_CHARACTERISTIC_UUID)!
            scrollingCharacteristicUUID = UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SCROLLING_ALT_CHARACTERISTIC_UUID)!
            fgColorCharacteristicUUID = UUID(uuidString: MW4_BLE_TEXT_DISPLAY_FG_COLOR_ALT_CHARACTERISTIC_UUID)!
        } else {
            textCharacteristicUUID = UUID(uuidString: MW4_BLE_TEXT_DISPLAY_TEXT_CHARACTERISTIC_UUID)!
            scrollingCharacteristicUUID = UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SCROLLING_CHARACTERISTIC_UUID)!
            fgColorCharacteristicUUID = UUID(uuidString: MW4_BLE_TEXT_DISPLAY_FG_COLOR_CHARACTERISTIC_UUID)!
        }
        
        try await device.writeValue(val.string, forCharacteristicWithUUID: textCharacteristicUUID, ofServiceWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SERVICE_UUID)!)
        try await device.writeValue(val.scrolling, forCharacteristicWithUUID: scrollingCharacteristicUUID, ofServiceWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SERVICE_UUID)!)
  
        let uiColor = UIColor(val.color)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        try await device.writeValue(Data([UInt8(r*255), UInt8(g*255), UInt8(b*255)]), forCharacteristicWithUUID: fgColorCharacteristicUUID, ofServiceWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SERVICE_UUID)!)
    }
        
    func setDevice(_ peripheral: Peripheral) async {
        device = peripheral
                
        do {
            let text: String? = try await device!.readValue(forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_TEXT_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SERVICE_UUID)!)
            let scrolling: Bool? = try await device!.readValue(forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SCROLLING_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SERVICE_UUID)!)
            let fgColor: Data? = try await device!.readValue(forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_FG_COLOR_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SERVICE_UUID)!)
            let textAlt: String? = try await device!.readValue(forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_TEXT_ALT_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SERVICE_UUID)!)
            let scrollingAlt: Bool? = try await device!.readValue(forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SCROLLING_ALT_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SERVICE_UUID)!)
            let fgColorAlt: Data? = try await device!.readValue(forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_FG_COLOR_ALT_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SERVICE_UUID)!)
            
            modelView.textScreen.string = text!
            modelView.textScreen.scrolling = scrolling!
            modelView.textScreen.color = Color(red: Double(fgColor![0]) / 255, green: Double(fgColor![1]) / 255, blue: Double(fgColor![2]) / 255)
            modelView.textScreenAlt.string = textAlt!
            modelView.textScreenAlt.scrolling = scrollingAlt!
            modelView.textScreenAlt.color = Color(red: Double(fgColorAlt![0]) / 255, green: Double(fgColorAlt![1]) / 255, blue: Double(fgColorAlt![2]) / 255)
            
            try await device!.setNotifyValue(true, forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_TEXT_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SERVICE_UUID)!)
            try await device!.setNotifyValue(true, forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_TEXT_ALT_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SERVICE_UUID)!)
            try await device!.setNotifyValue(true, forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SCROLLING_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SERVICE_UUID)!)
            try await device!.setNotifyValue(true, forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SCROLLING_ALT_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SERVICE_UUID)!)
            try await device!.setNotifyValue(true, forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_FG_COLOR_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SERVICE_UUID)!)
            try await device!.setNotifyValue(true, forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_FG_COLOR_ALT_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SERVICE_UUID)!)
            
            valueUpdateSubscription = device!.characteristicValueUpdatedPublisher.sink(
                receiveValue: { value in
                    Task {
                        switch value.uuid {
                        case CBUUID(string: MW4_BLE_TEXT_DISPLAY_TEXT_CHARACTERISTIC_UUID):
                            self.modelView.textScreen.string = String(decoding: value.value!, as: UTF8.self)
                            break
                        case CBUUID(string: MW4_BLE_TEXT_DISPLAY_SCROLLING_CHARACTERISTIC_UUID):
                            self.modelView.textScreen.scrolling = value.value![0] != 0
                            break
                        case CBUUID(string: MW4_BLE_TEXT_DISPLAY_FG_COLOR_CHARACTERISTIC_UUID):
                            self.modelView.textScreen.color = Color(red: Double(value.value![0]) / 255, green: Double(value.value![1]) / 255, blue: Double(value.value![2]) / 255)
                            break
                        case CBUUID(string: MW4_BLE_TEXT_DISPLAY_TEXT_ALT_CHARACTERISTIC_UUID):
                            self.modelView.textScreenAlt.string = String(decoding: value.value!, as: UTF8.self)
                            break
                        case CBUUID(string: MW4_BLE_TEXT_DISPLAY_SCROLLING_ALT_CHARACTERISTIC_UUID):
                            self.modelView.textScreenAlt.scrolling = value.value![0] != 0
                            break
                        case CBUUID(string: MW4_BLE_TEXT_DISPLAY_FG_COLOR_ALT_CHARACTERISTIC_UUID):
                            self.modelView.textScreenAlt.color = Color(red: Double(value.value![0]) / 255, green: Double(value.value![1]) / 255, blue: Double(value.value![2]) / 255)
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
