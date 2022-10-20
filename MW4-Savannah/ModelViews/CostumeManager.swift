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
    @Published var connected = false
    @Published var costumeService = CostumeService()
    @Published var frontTextService = TextDisplayService()
    @Published var pedestalLightsService = LightDeviceService()
    @Published var bluetoothUnavailable = false
    @Published var bluetoothOff = false
    
    @Published var updateAvailable = false
    @Published var updatedFWURL = ""
    
    private var device: Peripheral?
    
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
        
        let connectToDeviceTask = Task {
            try await findBLEDevice()
        }
        
        let availableVersionTask = Task {
            let res = try await fetchManifest()
            let availableVersion = res.version
            updatedFWURL = "http://" + res.host + res.bin
            return availableVersion
        }
        
        Task {
            try await connectToDeviceTask.value
            let availableVersion = try await availableVersionTask.value
            print(availableVersion)
            print(costumeService.fwVersion!)
            if (availableVersion > costumeService.fwVersion!) {
                updateAvailable = true
            }
        }
    }
    
    private func clearDevice() async {
        await MainActor.run {
            self.device = nil
            self.connected = false
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
                connected = false
            case .poweredOff:
                bluetoothOff = true
                connected = false
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
        connected = true
        
        await costumeService.setDevice(peripheral!)
        await frontTextService.setDevice(peripheral!)
        await pedestalLightsService.setDevice(peripheral!)
    }
}

class CostumeManagerMock: CostumeManager {
    init(connected: Bool, bluetoothUnavailable: Bool, bluetoothOff: Bool, fwVersion: Int) {
        super.init()
        super.connected = connected
        super.bluetoothUnavailable = bluetoothUnavailable
        super.bluetoothOff = bluetoothOff
        
        super.costumeService.fwVersion = 0
    }
}
