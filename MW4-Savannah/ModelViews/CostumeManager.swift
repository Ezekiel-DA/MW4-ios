////
////  CostumeControllerModelView.swift
////  MW4-Savannah
////
////  Created by Nicolas LEFEBVRE on 9/1/22.
////
//
//import Foundation
//import SwiftUI
//import Combine
//import CoreBluetooth
//import AsyncBluetooth
//
//let centralManager = CentralManager()
//
//@MainActor class CostumeManager: ObservableObject {
//    @Published var connected = false
//    @Published var found = false
//    @Published var costumeService = CostumeService()
//    @Published var frontTextService = TextDisplayService()
//    @Published var chairLightsService = LightDeviceService()
//    @Published var pedestalLightsService = LightDeviceService()
//    @Published var bluetoothUnavailable = false
//    @Published var bluetoothOff = false
//
//    @Published var updateAvailable = false
//    @Published var updatedFWURL = ""
//
//    private var device: Peripheral?
//
//    private var disconnectionSubscription: AnyCancellable?
//
//    init() {
//        disconnectionSubscription = centralManager.eventPublisher.sink(
//            receiveValue: { value in
//                switch (value) {
//                case let .didUpdateState(state):
//                    if (state == .poweredOn) {
//                        Task {
//                            if (self.bluetoothOff) { // don't start a scan from here if bluetooth wasn't off and just toggled on
//                                self.bluetoothOff = false
//                                try await self.findBLEDevice()
//                            }
//                        }
//                    }
//                case .didDisconnectPeripheral:
//                    Task {
//                        await self.clearDevice()
//                        try await self.findBLEDevice()
//                    }
//                case .willRestoreState(state: _):
//                    break // TODO : should we attempt to use this to do OTA updates in the background?
//                case .didConnectPeripheral(peripheral: _):
//                    break
//                }
//            }
//        )
//
//        let connectToDeviceTask = Task {
//            try await findBLEDevice()
//        }
//
//        let availableVersionTask = Task {
//            let res = try await fetchManifest()
//            let availableVersion = res.version
//            updatedFWURL = "http://" + res.host + res.bin
//            return availableVersion
//        }
//
//        Task {
//            try await connectToDeviceTask.value
//            let availableVersion = try await availableVersionTask.value
//            print("version: ", costumeService.fwVersion!, " - available: v.", availableVersion)
//            if (availableVersion > costumeService.fwVersion!) {
//                updateAvailable = true
//            }
//        }
//    }
//
//    private func clearDevice() async {
//        await MainActor.run {
//            self.device = nil
//            self.connected = false
//            self.found = false
//        }
//    }
//
//    private func findBLEDevice() async throws {
//        do {
//            try await centralManager.waitUntilReady()
//        }
//        catch {
//            switch centralManager.bluetoothState {
//            case .unauthorized:
//                print("unauthorized")
//                bluetoothUnavailable = true
//                connected = false
//                found = false
//            case .poweredOff:
//                bluetoothOff = true
//                connected = false
//                found = false
//            default:
//                break
//            }
//
//            return
//        }
//
//        var peripheral: Peripheral?
//
//        let scannedPeripherals = try await centralManager.scanForPeripherals(withServices: [CBUUID(string: MWNEXT_BLE_COSTUME_CONTROL_SERVICE_UUID)])
//        for await scannedPeripheral in scannedPeripherals {
//            peripheral = scannedPeripheral.peripheral
//            break
//        }
//        await centralManager.stopScan()
//        try await centralManager.connect(peripheral!, options: [CBCentralManagerOptionShowPowerAlertKey: true])
//        device = peripheral
//
//        found = true
//
//        // force a find of the light device service; there can be multiple instances, a thing AsyncBluetooth's convenience methods don't seem to account for very well
//        try await device!.discoverServices([CBUUID(string: MW4_BLE_LIGHT_DEVICE_SERVICE_UUID)])
//
//        for service in device!.discoveredServices ?? [] {
//            if service.uuid != CBUUID(string: MW4_BLE_LIGHT_DEVICE_SERVICE_UUID) {
//                break
//            }
//
//            try await device!.discoverCharacteristics([CBUUID(string: MW4_BLE_ID_CHARACTERISTIC_UUID)], for: service)
//
//            let idCharacteristic = service.discoveredCharacteristics?.first(where: { $0.uuid == CBUUID(string: MW4_BLE_ID_CHARACTERISTIC_UUID) })
//            try await device!.readValue(for: idCharacteristic!)
//            let id = idCharacteristic!.value!.first!
//
//            switch id {
//            case 1:
//                await chairLightsService.setDevice(peripheral!, service: service)
//                break
//            case 2:
//                await pedestalLightsService.setDevice(peripheral!, service: service)
//                break
//            default:
//                assert(false) // this should never hit on this costume
//                break
//            }
//        }
//
//        await costumeService.setDevice(peripheral!)
//        await frontTextService.setDevice(peripheral!)
//
//        connected = true
//    }
//}
