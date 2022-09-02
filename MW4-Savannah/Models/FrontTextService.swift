//
//  FrontTextService.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/1/22.
//

import Foundation
import SwiftUI

class FrontTextService: Identifiable {
    @Published var text: String?
    @Published var bgColor: Color?
    @Published var fgCOlor: Color?
    @Published var scrolling: Bool?
    @Published var scrollSpeed: UInt8?
    @Published var pauseTime: UInt8?
    @Published var brightness: UInt8?
}
