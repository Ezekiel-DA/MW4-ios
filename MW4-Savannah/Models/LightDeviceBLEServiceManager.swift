//
//  LightDeviceBLEServiceManager.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 10/26/22.
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

let ALL_LIGHT_DATA_CHARACTERISTICS = [
    CBUUID(string: MW4_BLE_MODE_CHARACTERISTIC_UUID),
    CBUUID(string: MW4_BLE_HUE_CHARACTERISTIC_UUID),
    CBUUID(string: MW4_BLE_SATURATION_CHARACTERISTIC_UUID),
    CBUUID(string: MW4_BLE_VALUE_CHARACTERISTIC_UUID),
    
    CBUUID(string: MW4_BLE_MODE_ALT_CHARACTERISTIC_UUID),
    CBUUID(string: MW4_BLE_HUE_ALT_CHARACTERISTIC_UUID),
    CBUUID(string: MW4_BLE_SATURATION_ALT_CHARACTERISTIC_UUID),
    CBUUID(string: MW4_BLE_VALUE_ALT_CHARACTERISTIC_UUID),
]

enum WhichLights: Identifiable {
    case Chair
    case Pedestal
    
    var id: Self { self }
}

@MainActor class LightDeviceBLEServiceManager {
    @ObservedObject var modelView: CostumeModelView
    let which: WhichLights
    
    internal var device: Peripheral?
    internal var service: Service?
    
    private var valueUpdateSubscription: AnyCancellable?
    private var appSideUpdates: Set<AnyCancellable> = []
    
    init(modelView: CostumeModelView, which: WhichLights) {
        self.modelView = modelView
        self.which = which
        
        switch which {
        case .Chair:
            self.modelView.$chairLights.throttle(for: .milliseconds(500), scheduler: DispatchQueue.main, latest: true).sink { val in
                Task {
                    try await self.writeLightSettings(lightSettings: val)
                }
            }.store(in: &appSideUpdates)
            
            self.modelView.$chairLightsAlt.throttle(for: .milliseconds(500), scheduler: DispatchQueue.main, latest: true).sink { val in
                Task {
                    try await self.writeLightSettings(lightSettings: val, alt: true)
                }
            }.store(in: &appSideUpdates)
            break
            
        case .Pedestal:
            self.modelView.$pedestalLights.throttle(for: .milliseconds(500), scheduler: DispatchQueue.main, latest: true).sink { val in
                Task {
                    try await self.writeLightSettings(lightSettings: val)
                }
            }.store(in: &appSideUpdates)
            
            self.modelView.$pedestalLightsAlt.throttle(for: .milliseconds(500), scheduler: DispatchQueue.main, latest: true).sink { val in
                Task {
                    try await self.writeLightSettings(lightSettings: val, alt: true)
                }
            }.store(in: &appSideUpdates)
            break
        }
    }
    
    private func writeLightSettings(lightSettings val: LightsModelView, alt: Bool = false) async throws {
        guard let device = self.device else {
            print("NO DEVICE CONNECTED!")
            return
        }
        
        var hueCharacteristicUUID: CBUUID
        var saturationCharacteristicUUID: CBUUID
        var valueCharacteristicUUID: CBUUID
        var modeCharacteristicUUID: CBUUID
        
        if (alt) {
            hueCharacteristicUUID = CBUUID(string: MW4_BLE_HUE_ALT_CHARACTERISTIC_UUID)
            saturationCharacteristicUUID = CBUUID(string: MW4_BLE_SATURATION_ALT_CHARACTERISTIC_UUID)
            valueCharacteristicUUID = CBUUID(string: MW4_BLE_VALUE_ALT_CHARACTERISTIC_UUID)
            modeCharacteristicUUID = CBUUID(string: MW4_BLE_MODE_ALT_CHARACTERISTIC_UUID)
        } else {
            hueCharacteristicUUID = CBUUID(string: MW4_BLE_HUE_CHARACTERISTIC_UUID)
            saturationCharacteristicUUID = CBUUID(string: MW4_BLE_SATURATION_CHARACTERISTIC_UUID)
            valueCharacteristicUUID = CBUUID(string: MW4_BLE_VALUE_CHARACTERISTIC_UUID)
            modeCharacteristicUUID = CBUUID(string: MW4_BLE_MODE_CHARACTERISTIC_UUID)
        }
        
        let uiColor = UIColor(val.color)
        var h: CGFloat = 0
        var s: CGFloat = 0
        var v: CGFloat = 0
        var a: CGFloat = 0
        uiColor.getHue(&h, saturation: &s, brightness: &v, alpha: &a)
        
        let hue = UInt8((Double(h) * 255).rounded())
        let saturation = UInt8((Double(s) * 255).rounded())
        let value = UInt8((Double(v) * 255).rounded())
                        
        try await device.writeValue(hue.toData()!, for: self.service!.discoveredCharacteristics!.first(where: { $0.uuid == hueCharacteristicUUID})!, type: .withResponse)
        try await device.writeValue(saturation.toData()!, for: self.service!.discoveredCharacteristics!.first(where: { $0.uuid == saturationCharacteristicUUID})!, type: .withResponse)
        try await device.writeValue(value.toData()!, for: self.service!.discoveredCharacteristics!.first(where: { $0.uuid == valueCharacteristicUUID})!, type: .withResponse)
        try await device.writeValue(val.mode.rawValue.toData()!, for: self.service!.discoveredCharacteristics!.first(where: { $0.uuid == modeCharacteristicUUID})!, type: .withResponse)
    }
    
    func setDevice(_ peripheral: Peripheral, service uniqueService: Service) async {
        device = peripheral
        service = uniqueService
        
        do {
            try await device!.discoverCharacteristics(ALL_LIGHT_DATA_CHARACTERISTICS, for: service!)
            
            for characteristic in service!.discoveredCharacteristics ?? [] {
                try await device!.readValue(for: characteristic)
            }
            
            for characteristic in ALL_LIGHT_DATA_CHARACTERISTICS {
                try await device!.setNotifyValue(true, for: service!.discoveredCharacteristics!.first(where: { $0.uuid == characteristic })!)
            }
            
            let hue: UInt8? = try service!.discoveredCharacteristics!.first(where: { $0.uuid == CBUUID(string: MW4_BLE_HUE_CHARACTERISTIC_UUID)})?.parsedValue()
            let saturation: UInt8? = try service!.discoveredCharacteristics!.first(where: { $0.uuid == CBUUID(string: MW4_BLE_SATURATION_CHARACTERISTIC_UUID)})?.parsedValue()
            let value: UInt8? = try service!.discoveredCharacteristics!.first(where: { $0.uuid == CBUUID(string: MW4_BLE_VALUE_CHARACTERISTIC_UUID)})?.parsedValue()
            let mode: UInt8? = try service!.discoveredCharacteristics!.first(where: { $0.uuid == CBUUID(string: MW4_BLE_MODE_CHARACTERISTIC_UUID)})?.parsedValue()
            
            let hueAlt: UInt8? = try service!.discoveredCharacteristics!.first(where: { $0.uuid == CBUUID(string: MW4_BLE_HUE_ALT_CHARACTERISTIC_UUID)})?.parsedValue()
            let saturationAlt: UInt8? = try service!.discoveredCharacteristics!.first(where: { $0.uuid == CBUUID(string: MW4_BLE_SATURATION_ALT_CHARACTERISTIC_UUID)})?.parsedValue()
            let valueAlt: UInt8? = try service!.discoveredCharacteristics!.first(where: { $0.uuid == CBUUID(string: MW4_BLE_VALUE_ALT_CHARACTERISTIC_UUID)})?.parsedValue()
            let modeAlt: UInt8? = try service!.discoveredCharacteristics!.first(where: { $0.uuid == CBUUID(string: MW4_BLE_MODE_ALT_CHARACTERISTIC_UUID)})?.parsedValue()
            
            let lightOptions = LightsModelView(color: Color(hueByte: hue!, saturationByte: saturation!, valueByte: value!), mode: LightMode(rawValue: Int(mode!))!)
            let lightOptionsAlt = LightsModelView(color: Color(hueByte: hueAlt!, saturationByte: saturationAlt!, valueByte: valueAlt!), mode: LightMode(rawValue: Int(modeAlt!))!)
            
            switch which {
            case .Chair:
                modelView.chairLights = lightOptions
                modelView.chairLightsAlt = lightOptionsAlt
            case .Pedestal:
                modelView.pedestalLights = lightOptions
                modelView.pedestalLightsAlt = lightOptionsAlt
            }
                                                
//            valueUpdateSubscription = device!.characteristicValueUpdatedPublisher.sink(
//                receiveValue: { value in
//                    Task {
//                        switch value.uuid {
//                        case CBUUID(string: MW4_BLE_HUE_CHARACTERISTIC_UUID):
//                            self.hue = value.value![0]
//                            break
//                        case CBUUID(string: MW4_BLE_SATURATION_CHARACTERISTIC_UUID):
//                            self.saturation = value.value![0]
//                            break
//                        case CBUUID(string: MW4_BLE_VALUE_CHARACTERISTIC_UUID):
//                            self.value = value.value![0]
//                            break
//                        case CBUUID(string: MW4_BLE_MODE_CHARACTERISTIC_UUID):
//                            self.mode = value.value![0]
//                            break
//                        case CBUUID(string: MW4_BLE_HUE_ALT_CHARACTERISTIC_UUID):
//                            self.hueAlt = value.value![0]
//                            break
//                        case CBUUID(string: MW4_BLE_SATURATION_ALT_CHARACTERISTIC_UUID):
//                            self.saturationAlt = value.value![0]
//                            break
//                        case CBUUID(string: MW4_BLE_VALUE_ALT_CHARACTERISTIC_UUID):
//                            self.valueAlt = value.value![0]
//                            break
//                        case CBUUID(string: MW4_BLE_MODE_ALT_CHARACTERISTIC_UUID):
//                            self.modeAlt = value.value![0]
//                            break
//                        default:
//                            break
//                        }
//                    }
//                }
//            )
        } catch {
            assert(false)
            return
        }
    }
}
