//
//  ContentView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 8/30/22.
//

import SwiftUI
import CoreBluetooth
import AsyncBluetooth
import Combine

struct ContentView: View {
    @ObservedObject var _costumeController: CostumeController = costumeController
    @ObservedObject var _bleState = bleState
    
    @State var _availableVersion: Int?
    @State var _fwURL = ""
    
    @State var _device: Peripheral?
    
    @State var _disconnectionSubscription: AnyCancellable?
    
    init() {
        UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 10))
    }
        
    var body: some View {
        NavigationView {
            if (_device != nil) {
                VStack {
                    Button("Check for update") {
                        Task {
                            let res = try await fetchManifest()
                            _availableVersion = res.version
                            _fwURL = "http://" + res.host + res.bin
                        }
                    }
                    if let version = _availableVersion { Text("Available version: " + String(version)) }
                    if let _ = _availableVersion { Button("Update firmware") {
                        Task {
                            let fw = try await fetchFirmwareFile(_fwURL)
                            costumeController.sendFWUpdate(fw)
                        }
                    } }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar { ToolbarItem(placement: .principal) { StatusBarView(connected: true, fwVersion: Int(_costumeController.fwVersion ?? 0)) } }
                
            } else {
                Text(_bleState.bluetoothOff ? "Please turn Bluetooth on in Settings." : (_bleState.bluetoothUnavailable ? "Please allow \(Bundle.main.displayName) access to Bluetooth" : "Please turn on costume") )
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar { ToolbarItem(placement: .principal) { StatusBarView(connected: false) } }
            }
            

                
//
        }.task {
            do {
                _disconnectionSubscription = centralManager.eventPublisher.sink(
                    receiveValue: { value in
                        switch (value) {
                        case let .didUpdateState(state):
                            if (state == .poweredOn) {
                                Task {
                                    _device = try await getBLEDevice()
                                }
                            }
                        case .didDisconnectPeripheral:
                            _device = nil
                            Task {
                                _device = try await getBLEDevice()
                            }
                        }
                    }
                )
                
                let res = try await getBLEDevice() // don't assign to our state yet since that would redraw this view and interrupt the rest of this?
                guard let device = res else {
                    return
                }
                // TODO: the above is probably a sign that our control flow is all sorts of messed up and we need to do this work elsewhere, tbh.
                let fwVersion = await getFWVersion(device)
                _costumeController.fwVersion = UInt8(fwVersion!)
                _device = device
            } catch {
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}
