//
//  ConnectionManager.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 10/26/22.
//

import Foundation
import SwiftUI
import Combine
import CoreBluetooth
import AsyncBluetooth

// Does this need to be @MainActor?
class ConnectionManager {
    @ObservedObject var modelView: CostumeModelView
    
    var costumeService: CostumeBLEServiceManager
    
    private var device: Peripheral?
    
    private var disconnectionSubscription: AnyCancellable?  

    private var chairLightsDevice: LightDeviceBLEServiceManager
    private var pedestalLightsDevice: LightDeviceBLEServiceManager
    
    private var textDisplayService: TextDisplayBLEServiceManager
    
    private var musicService: MusicBLEServiceManager
    
    private var centralManager = CentralManager()
        
    init(modelView: CostumeModelView) {
        self.modelView  = modelView
        self.costumeService = CostumeBLEServiceManager(modelView: modelView)
        self.textDisplayService = TextDisplayBLEServiceManager(modelView: modelView)
        self.chairLightsDevice = LightDeviceBLEServiceManager(modelView: modelView, which: .Chair)
        self.pedestalLightsDevice = LightDeviceBLEServiceManager(modelView: modelView, which: .Pedestal)
        self.musicService = MusicBLEServiceManager(modelView: modelView)
        
        disconnectionSubscription = centralManager.eventPublisher.sink(
            receiveValue: { value in
                switch (value) {
                case let .didUpdateState(state):
                    if (state == .poweredOn) {
                        Task {
                            if (self.modelView.bluetoothOff) { // don't start a scan from here if bluetooth wasn't off and just toggled on
                                self.modelView.bluetoothOff = false
                                try await self.findBLEDevice()
                            }
                        }
                    }
                case .didDisconnectPeripheral:
                    Task {
                        await self.clearDevice()
                        try await self.findBLEDevice()
                    }
                case .willRestoreState(state: _):
                    break // TODO : should we attempt to use this to do OTA updates in the background?
                case .didConnectPeripheral(peripheral: _):
                    break
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
            let fwVersion = modelView.fwVersion
            
            try await connectToDeviceTask.value
            let availableVersion = try await availableVersionTask.value
            print("version: ", fwVersion, " - available: v.", availableVersion)
            if (availableVersion > fwVersion) {
                modelView.updateAvailable = true
            }
        }
    }
    
    private func clearDevice() async {
        await MainActor.run {
            self.device = nil
            self.modelView.connected = false
            self.modelView.ready = false
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
                self.modelView.bluetoothUnavailable = true
                self.modelView.connected = false
                self.modelView.ready = false
            case .poweredOff:
                self.modelView.bluetoothOff = true
                self.modelView.connected = false
                self.modelView.ready = false
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
        
        self.modelView.ready = true
        
        // force a find of the light device service; there can be multiple instances, a thing AsyncBluetooth's convenience methods don't seem to account for very well
        try await device!.discoverServices([CBUUID(string: MW4_BLE_LIGHT_DEVICE_SERVICE_UUID)])
                
        for service in device!.discoveredServices ?? [] {
            if service.uuid != CBUUID(string: MW4_BLE_LIGHT_DEVICE_SERVICE_UUID) {
                break
            }
            
            try await device!.discoverCharacteristics([CBUUID(string: MW4_BLE_ID_CHARACTERISTIC_UUID)], for: service)
            
            let idCharacteristic = service.discoveredCharacteristics?.first(where: { $0.uuid == CBUUID(string: MW4_BLE_ID_CHARACTERISTIC_UUID) })
            try await device!.readValue(for: idCharacteristic!)
            let id = idCharacteristic!.value!.first!
            
            switch id {
            case 1:
                await chairLightsDevice.setDevice(peripheral!, service: service)
                break
            case 2:
                await pedestalLightsDevice.setDevice(peripheral!, service: service)
                break
            default:
                assert(false) // this should never hit on this costume
                break
            }
        }
                
        await costumeService.setDevice(peripheral!)
        await textDisplayService.setDevice(peripheral!)
        
        if modelView.fwVersion >= 3 {
            await musicService.setDevice(peripheral!)
        }
        
        self.modelView.connected = true
    }
}
