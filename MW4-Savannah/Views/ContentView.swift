//
//  ContentView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 8/30/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var costumeManager: CostumeManager
        
    @State var _availableVersion: Int?
    @State var _fwURL = ""

    var body: some View {
        NavigationView {
            if (costumeManager.device != nil) {
                VStack {
                    TextDisplayView(textDisplayService: costumeManager.frontTextService)
                    Button("Check for update") {
                        Task {
                            let res = try await fetchManifest()
                            _availableVersion = res.version
                            _fwURL = "http://" + res.host + res.bin
                        }
                    }
                    if let version = _availableVersion { Text("Available version: " + String(version)) }
                    if let _ = _availableVersion {
                        VStack {
                            Button("Update firmware") {
                                Task {
                                    let fw = try await fetchFirmwareFile(_fwURL)
                                    await costumeManager.costumeService.sendFWUpdate(fw)
                                }
                            }
                            OTAProgressView(costumeService: costumeManager.costumeService)
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar { ToolbarItem(placement: .principal) { StatusBarView(connected: true, costumeService: costumeManager.costumeService) } }

            } else {
                Text(costumeManager.bluetoothOff ? "Please turn Bluetooth on in Settings." : (costumeManager.bluetoothUnavailable ? "Please allow \(Bundle.main.displayName) access to Bluetooth" : "Please turn on costume") )
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar { ToolbarItem(placement: .principal) { StatusBarView(connected: false, costumeService: costumeManager.costumeService) } }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(costumeManager: CostumeManager())
        
    }
}
