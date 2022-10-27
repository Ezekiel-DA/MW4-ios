//
//  Extensions.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 10/26/22.
//

import Foundation
import SwiftUI

fileprivate func UInt8To01Range(_ x: UInt8) -> Double {
    return Double(x) / 255
}

extension Color {
    init(hueByte h: UInt8, saturationByte s: UInt8, valueByte v: UInt8) {
        self.init(hue: UInt8To01Range(h), saturation: UInt8To01Range(s), brightness: UInt8To01Range(v))
    }
        
    static let fullRed = Color(red: 1.0, green: 0.0, blue: 0.0)
    static let costumeWhite = Color(hueByte: 255, saturationByte: 0, valueByte: 180)
}
