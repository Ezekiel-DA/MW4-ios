//
//  NavBarModifiers.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/7/22.
//

import SwiftUI
import UIKit

// TODO: this probably shouldn't be applying globally...
struct NavigationBarTitleFontStyle: ViewModifier {
    init(_ style: UIFont.TextStyle) {
        let font = UIFont.preferredFont(forTextStyle: style)        
        UINavigationBar.appearance().titleTextAttributes = [.font: font]
    }
    
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    func navigationBarTitleFontStyle(_ style: UIFont.TextStyle) -> some View {
        self.modifier(NavigationBarTitleFontStyle(style))
    }
}
