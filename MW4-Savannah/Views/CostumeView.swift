//
//  CostumeView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/6/22.
//

import SwiftUI

enum NavigationTargets: Int, CaseIterable {
    case ChairLights
    case PedestalLights
    case Text
    case Audio
    
    var title: String {
        switch self {
        case .ChairLights: return "Chair lights"
        case .PedestalLights: return "Pedestal lights"
        case .Text: return "Text effects"
        case .Audio: return "Audio"
        }
    }
    
    var effectDescription: String {
        switch self {
        case .ChairLights: return "Red"
        case .PedestalLights: return "White, Pulsing"
        case .Text: return "ON"
        case .Audio: return "OFF"
        }
    }
    
    @MainActor @ViewBuilder
    func getView(_ costumeManager: CostumeManager) -> some View {
        switch self {
        case .ChairLights: ChairLightsView()
        case .PedestalLights: PedestalLightsView(lightDeviceService: costumeManager.pedestalLightsService)
        case .Text: TextEffectsView(textDisplayService: costumeManager.frontTextService)
        case .Audio: AudioView()
        }
    }
}

struct CostumeView: View {
    @ObservedObject var costumeManager: CostumeManager

    @State private var isOTASheetShowing = false
    
    var body: some View {
        NavigationView {
            VStack {
                if (costumeManager.connected) {
                    ForEach(NavigationTargets.allCases, id: \.rawValue) { item in
                        EffectsListItemView(
                            text: item.title,
                            effectDescriptionText: item.effectDescription,
                            editDestination: AnyView(item.getView(costumeManager)
                                .navigationTitle(item.title)
                                .navigationBarTitleDisplayMode(.inline)
                                .toolbar{
                                    Button("Reset") {}
                                }
                            )
                        )
                    }
                    Spacer()
                    CostumeGraphicView(
                        chairLightColor: .red,
                        pedLightColor: .white,
                        isChairRainbow: true,
                        isPedRainbow: false,
                        txtDisplay: "I WANT YOU",
                        txtColor: .red)
                    Spacer()
                    PreviewButtonView(action: {} )
                        .padding(.bottom)
                } else {
                    Text(costumeManager.bluetoothOff ? "Please turn Bluetooth on in Settings." : (costumeManager.bluetoothUnavailable ? "Please allow \(Bundle.main.displayName) access to      Bluetooth" : "Please turn on costume") )
                }
            }
            .navigationBarTitle("TEAM SAVANNAH")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitleFontStyle(.title1)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if (costumeManager.updateAvailable) {
                        Button("update") {
                            isOTASheetShowing = true
                            // TODO: we probably need to prevent users from starting the update process multiple times?
                            Task {
                                let fw = try await fetchFirmwareFile(costumeManager.updatedFWURL)
                                UIApplication.shared.isIdleTimerDisabled = true
                                await costumeManager.costumeService.sendFWUpdate(fw)
                                UIApplication.shared.isIdleTimerDisabled = false
                                isOTASheetShowing = false
                            }
                        }
                        .frame(width: 50.0)
                        .sheet(isPresented: $isOTASheetShowing) {
                            OTAProgressView(costumeService: costumeManager.costumeService)
                        }
                    }
                }
            }
        }
    }
}

struct CostumeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CostumeView(costumeManager: CostumeManagerMock(connected: true, bluetoothUnavailable: false, bluetoothOff: false, fwVersion: 3))
            CostumeView(costumeManager: CostumeManagerMock(connected: true, bluetoothUnavailable: false, bluetoothOff: false, fwVersion: 1))
            CostumeView(costumeManager: CostumeManagerMock(connected: false, bluetoothUnavailable: false, bluetoothOff: false, fwVersion: 0))
        }
    }
}
