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

class CostumeModelView: ObservableObject {
    @Published var connected = true
    @Published var ready = true
    @Published var bluetoothUnavailable = false
    @Published var bluetoothOff = false
    
    @Published var updateAvailable = false
    
    @Published var isButtonPressed = false
    
    @Published var chairLights = LightsModelView(color: .red)
    @Published var chairLightsAlt = LightsModelView(color: .white)
    
    @Published var pedestalLights = LightsModelView(color: .white)
    @Published var pedestalLightsAlt = LightsModelView(color: .red)
    
    @Published var textScreen = TextModelView(string: "TEAM SAVANNAH")
    @Published var textScreenAlt = TextModelView(string: "I WANT YOU")
    
//    @Published var chairLightsState = true
//    @Published var chairLightsColor = Color.red
//    @Published var chairLightsMode = LightMode.steady
//
//    @Published var chairLightsStateAlt = true
//    @Published var chairLightsColorAlt = Color.red
//    @Published var chairLightsModeAlt = LightMode.steady
//
//    @Published var pedestalLightsState = true
//    @Published var pedestalLightsColor = Color.red
//    @Published var pedestalLightsMode = LightMode.steady
//
//    @Published var pedestalLightsStateAlt = true
//    @Published var pedestalLightsColorAlt = Color.red
//    @Published var pedestalLightsModeAlt = LightMode.steady
//
//    @Published var textState = true
//    @Published var textScrolling = true
//    @Published var textFgColor = Color.white
//    @Published var textString = "TEAM SAVANNAH"
//
//    @Published var textStateAlt = true
//    @Published var textScrollingAlt = true
//    @Published var textFgColorAlt = Color.white
//    @Published var textStringAlt = "I WANT YOU"
}
