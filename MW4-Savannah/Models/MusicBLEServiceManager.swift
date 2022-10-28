//
//  MusicBLEServiceManager.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 10/27/22.
//

import Foundation
import SwiftUI
import Combine
import CoreBluetooth
import AsyncBluetooth

let MW4_BLE_MUSIC_CONTROL_SERVICE_UUID                           = "884411c5-0445-4a87-bd8e-e08311026227"

let MW4_BLE_MUSIC_CONTROL_VOLUME_CHARACTERISTIC                  = "2a561d00-1072-42a4-acac-e06a7509b4ca"


@MainActor class MusicBLEServiceManager {
    @ObservedObject var modelView: CostumeModelView
    
    internal var device: Peripheral?
    
    private var valueUpdateSubscription: AnyCancellable?
    private var appSideUpdates: Set<AnyCancellable> = []
        
    init(modelView: CostumeModelView) {
        self.modelView = modelView
        
        self.modelView.$musicControl.throttle(for: .milliseconds(500), scheduler: DispatchQueue.main, latest: true).sink { val in
            Task {
                try await self.writeMusicSettings(musicSettings: val)
            }
        }.store(in: &appSideUpdates)
    }
    
    private func writeMusicSettings(musicSettings val: MusicModelView) async throws {
        guard let device = self.device else {
            print("NO DEVICE CONNECTED!")
            return
        }
        
        try await device.writeValue(UInt8(val.volume), forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_MUSIC_CONTROL_VOLUME_CHARACTERISTIC)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_MUSIC_CONTROL_SERVICE_UUID)!)
    }
        
    func setDevice(_ peripheral: Peripheral) async {
        device = peripheral
                
        do {
            let volume: Int? = try await device!.readValue(forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_MUSIC_CONTROL_VOLUME_CHARACTERISTIC)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_MUSIC_CONTROL_SERVICE_UUID)!)
            
            modelView.musicControl.volume = Double(volume!)
            
            try await device!.setNotifyValue(true, forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_MUSIC_CONTROL_VOLUME_CHARACTERISTIC)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_MUSIC_CONTROL_SERVICE_UUID)!)
                                             
            valueUpdateSubscription = device!.characteristicValueUpdatedPublisher.sink(
                receiveValue: { value in
                    Task {
                        switch value.uuid {
                        case CBUUID(string: MW4_BLE_MUSIC_CONTROL_VOLUME_CHARACTERISTIC):
                            self.modelView.musicControl.volume = Double(value.value![0])
                            break
                        default:
                            break
                        }
                    }
                }
            )
        } catch {
            assert(false)
            return
        }
    }
}
