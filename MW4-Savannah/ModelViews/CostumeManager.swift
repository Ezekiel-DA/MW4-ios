//
//  CostumeControllerModelView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/1/22.
//

import Foundation
import SwiftUI
import Combine
import CoreBluetooth
import AsyncBluetooth

let centralManager = CentralManager()

@MainActor class CostumeManager: ObservableObject {
    @Published var costumeService = CostumeService()
    @Published var frontTextService = TextDisplayService()
    @Published var bluetoothUnavailable = false
    @Published var bluetoothOff = false
    @Published var device: Peripheral?
    
    private var disconnectionSubscription: AnyCancellable?
    
    init() {
        disconnectionSubscription = centralManager.eventPublisher.sink(
            receiveValue: { value in
                switch (value) {
                case let .didUpdateState(state):
                    if (state == .poweredOn) {
                        Task {
                            if (self.bluetoothOff) { // don't start a scan from here if bluetooth wasn't off and just toggled on
                                self.bluetoothOff = false
                                try await self.findBLEDevice()
                            }
                        }
                    }
                case .didDisconnectPeripheral:
                    Task {
                        await self.clearDevice()
                        try await self.findBLEDevice()
                    }
                }
            }
        )
        
        Task {
            try await findBLEDevice()
        }
    }
    
    private func clearDevice() async {
        await MainActor.run {
            self.device = nil
        }
    }
    
    private func findBLEDevice() async throws {
        do {
            try await centralManager.waitUntilReady()
        }
        catch {
            switch centralManager.bluetoothState {
            case .unauthorized:
                print("unauthorized")
                bluetoothUnavailable = true
            case .poweredOff:
                bluetoothOff = true
            default:
                break
            }
            
            return
        }
        
        var peripheral: Peripheral?
        
        let scannedPeripherals = try await centralManager.scanForPeripherals(withServices: [CBUUID(string: MWNEXT_BLE_COSTUME_CONTROL_SERVICE_UUID)])
        for await scannedPeripheral in scannedPeripherals {
            peripheral = scannedPeripheral.peripheral
            break
        }
        await centralManager.stopScan()
        try await centralManager.connect(peripheral!, options: [CBCentralManagerOptionShowPowerAlertKey: true])
        device = peripheral
        
        await costumeService.setDevice(peripheral!)
        await frontTextService.setDevice(peripheral!)
    }
}
