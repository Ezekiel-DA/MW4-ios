//
//  BLE.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 10/20/22.
//

import Foundation
import AsyncBluetooth

extension UInt8: PeripheralDataConvertible {}

func parse(data: Data) -> Bool? {
    return String(data: data, encoding: .utf8).flatMap(Bool.init)
}

// This is probably gross, but it lets SwiftUI components that take bindings to Doubles (looking at you Slider) take UInt8 bindings instead!
extension UInt8 {
    var double: Double {
        get { Double(self) }
        set { self = UInt8(newValue) }
    }
}

let MW4_BLE_STATE_CHARACTERISTIC_UUID                            = "c2af353b-e5fc-4bdf-b743-5d226f1198a2"
let MW4_BLE_STATE_ALT_CHARACTERISTIC_UUID                        = "593d1195-5918-4db4-8077-c2f0fe7cee4c"
