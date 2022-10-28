//
//  CostumeModelView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 10/25/22.
//

import Foundation

import SwiftUI

enum LightMode: Int, CaseIterable, Identifiable {
    case steady
    case pulse
    case cycle
    case wave
        
    var title: String {
        switch self {
        case .steady: return "Steady"
        case .pulse: return "Pulse"
        case .cycle: return "Cycle"
        case .wave: return "Wave"
        }
    }
    
    var id: Self { self }
}

enum ColorMode: Int, CaseIterable, Identifiable {
    case White
    case Red
    case Custom
    
    var title: String {
        switch self {
        case .White: return "White"
        case .Red: return "Red"
        case .Custom: return "Custom"
        }
    }
    
    var id: Self { self }
}

struct LightsModelView {
    var state = true
    var color: Color
    var mode = LightMode.steady
}

struct TextModelView {
    var state = true
    var color = Color.white
    var scrolling = true
    var string: String
}

struct MusicModelView {
    var volume: Double = 21
}

let costumeModelView = CostumeModelView()

class CostumeModelView: ObservableObject {
    @Published var connected = false
    @Published var ready = false
    @Published var bluetoothUnavailable = false
    @Published var bluetoothOff = false
    
    @Published var fwVersion: Int = 0
    @Published var updateAvailable = false
    
    @Published var isButtonPressed = false
    
    @Published var chairLights = LightsModelView(color: .red)
    @Published var chairLightsAlt = LightsModelView(color: .white)
    
    @Published var pedestalLights = LightsModelView(color: .white)
    @Published var pedestalLightsAlt = LightsModelView(color: .red)
    
    @Published var textScreen = TextModelView(string: "")
    @Published var textScreenAlt = TextModelView(string: "I WANT YOU")
    
    @Published var musicControl = MusicModelView()
}
