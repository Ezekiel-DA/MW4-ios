////
////  FrontTextService.swift
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
//let MW4_BLE_TEXT_DISPLAY_SERVICE_UUID                            = "aafca82b-95ae-4f33-9cf3-7ee0ef15ddf4"
//
//let MW4_BLE_TEXT_DISPLAY_TEXT_CHARACTERISTIC_UUID                = "c5b56d2e-b6e9-49c7-b098-5af9a75f46cd"
//let MW4_BLE_TEXT_DISPLAY_OFFSET_CHARACTERISTIC_UUID              = "a0f348d3-5c80-420f-bb5f-1732824ac215"
//let MW4_BLE_TEXT_DISPLAY_SCROLLING_CHARACTERISTIC_UUID           = "966c3d0d-493c-4b59-ae1d-d3768ff9ada8"
//let MW4_BLE_TEXT_DISPLAY_SCROLL_SPEED_CHARACTERISTIC_UUID        = "1fc1cf59-0e88-4dda-81fc-818a14da216b"
//let MW4_BLE_TEXT_DISPLAY_PAUSE_TIME_CHARACTERISTIC_UUID          = "7a991117-a277-46ae-8d73-0a7e7e6ae7e8"
//let MW4_BLE_TEXT_DISPLAY_BRIGHTNESS_CHARACTERISTIC_UUID          = "48387eca-eedf-40ee-ab37-b4fb3a18cdf1"
//let MW4_BLE_TEXT_DISPLAY_FG_COLOR_CHARACTERISTIC_UUID            = "4119bf67-6295-4ec9-b596-5b32a3f2fda5"
//let MW4_BLE_TEXT_DISPLAY_BG_COLOR_CHARACTERISTIC_UUID            = "1b56faa0-376a-432a-a79a-e1a4f12dd493"
//
//let MW4_BLE_TEXT_DISPLAY_TEXT_ALT_CHARACTERISTIC_UUID            = "5830efb7-819e-42db-8d4e-e9e19f096a20"
//let MW4_BLE_TEXT_DISPLAY_OFFSET_ALT_CHARACTERISTIC_UUID          = "0ef6a5e1-9f5c-41ba-b1d6-39139cc8e721"
//let MW4_BLE_TEXT_DISPLAY_SCROLLING_ALT_CHARACTERISTIC_UUID       = "15b01f47-fe52-4851-8835-e97b09906443"
//let MW4_BLE_TEXT_DISPLAY_SCROLL_SPEED_ALT_CHARACTERISTIC_UUID    = "ee361bc6-09cc-47af-b5b8-7e035b92e339"
//let MW4_BLE_TEXT_DISPLAY_PAUSE_TIME_ALT_CHARACTERISTIC_UUID      = "920879e1-b132-4326-ad22-7daf4bd4f037"
//let MW4_BLE_TEXT_DISPLAY_BRIGHTNESS_ALT_CHARACTERISTIC_UUID      = "a682dc43-8039-402e-a5cb-4c1b41075bf4"
//let MW4_BLE_TEXT_DISPLAY_FG_COLOR_ALT_CHARACTERISTIC_UUID        = "de7cc85a-7df9-416b-be56-76c5ac8faa89"
//let MW4_BLE_TEXT_DISPLAY_BG_COLOR_ALT_CHARACTERISTIC_UUID        = "fe344d11-3bc2-4511-841b-05f69f80b17f"
//
//@MainActor class TextDisplayService: ObservableObject {
//    @Published var text: String?
//    @Published var bgColor: Color?
//    @Published var fgCOlor: Color?
//    @Published var scrolling: UInt8?
//    @Published var scrollSpeed: UInt8?
//    @Published var pauseTime: UInt8?
//    @Published var brightness: UInt8?
//    
//    internal var device: Peripheral?
//    
//    private var valueUpdateSubscription: AnyCancellable?
//    
//    private var appSideUpdates: Set<AnyCancellable> = []
//    
//    init() {
//        $text.sink { val in
//            Task {
//                guard let device = self.device else {
//                    print("NO DEVICE CONNECTED!!")
//                    return
//                }
//                try await device.writeValue(self.text ?? "", forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_TEXT_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SERVICE_UUID)!)
//            }
//        }.store(in: &appSideUpdates)
//        
//        $scrolling.sink { val in
//            Task {
//                guard let device = self.device else {
//                    print("NO DEVICE CONNECTED!")
//                    return
//                }
//                try await device.writeValue(Data([self.scrolling!]), forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SCROLLING_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SERVICE_UUID)!)
//            }
//        }.store(in: &appSideUpdates)
//    }
//    
//    func setDevice(_ peripheral: Peripheral) async {
//        device = peripheral
//                
//        do {
//            
//            text = try await device!.readValue(forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_TEXT_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SERVICE_UUID)!)
//            scrolling = try await device!.readValue(forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SCROLLING_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SERVICE_UUID)!)
//            
//            try await device!.setNotifyValue(true, forCharacteristicWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_TEXT_CHARACTERISTIC_UUID)!, ofServiceWithUUID: UUID(uuidString: MW4_BLE_TEXT_DISPLAY_SERVICE_UUID)!)
//            
//            valueUpdateSubscription = device!.characteristicValueUpdatedPublisher.sink(
//                receiveValue: { value in
//                    Task {
//                        switch value.uuid {
//                        case CBUUID(string: MW4_BLE_TEXT_DISPLAY_TEXT_CHARACTERISTIC_UUID):
//                            self.text = String(decoding: value.value!, as: UTF8.self)
//                            break
//                        case CBUUID(string: MW4_BLE_TEXT_DISPLAY_SCROLLING_CHARACTERISTIC_UUID):
//                            self.scrolling = value.value![0]
//                            break
//                        default:
//                            break
//                        }
//                    }
//                }
//            )
//        } catch {
//            assert(false)
//            return
//        }
//    }
//}
//
//class TextDisplayServiceMock: TextDisplayService {
//    init(text dummyText: String, scrolling isScrolling: UInt8) {
//        super.init()
//        text = dummyText
//        scrolling = isScrolling
//    }
//}
