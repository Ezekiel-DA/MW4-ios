//
//  MW4_SavannahApp.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 8/30/22.
//

import SwiftUI

//var bleMgr = BLEManager()

@main
struct MW4_SavannahApp: App {
    
    @StateObject var costumeMgr = CostumeManager()
    
    var body: some Scene {
        WindowGroup {
            //ContentView(costumeManager: costumeMgr)
            CostumeView()
        }
    }
}

extension Bundle {
    var displayName: String {
        if let name = object(forInfoDictionaryKey: "CFBundleDisplayName") {
            return name as! String
        } else {
            return "?MISSING APP NAME?"
        }
    }
}

extension UINavigationController {
    // Remove back button text
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
