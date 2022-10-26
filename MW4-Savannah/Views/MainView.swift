//
//  MainView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 10/25/22.
//

import SwiftUI

enum NavigationTarget: Int, CaseIterable {
    case ChairLights
    case PedestalLights
//    case Text
//    case Audio
    
    var title: String {
        switch self {
        case .ChairLights: return "Chair lights"
        case .PedestalLights: return "Pedestal lights"
//        case .Text: return "Text effects"
//        case .Audio: return "Audio"
        }
    }
    
    var effectDescription: String {
        switch self {
        case .ChairLights: return "Red"
        case .PedestalLights: return "White, Pulsing"
//        case .Text: return "ON"
//        case .Audio: return "OFF"
        }
    }
    
    @MainActor @ViewBuilder
    func getView(_ costume: CostumeModelView) -> some View {
        switch self {
        case .ChairLights: ChairLightsView(costume: costume)
        case .PedestalLights: PedestalLightsView(costume: costume)
//        case .Text: TextEffectsView(CostumeModelView: costume)
//        case .Audio: AudioView()
        }
    }
}


struct MainView: View {
    @ObservedObject var costume = CostumeModelView()
    
    @State private var isOTASheetShowing = false
    
    var body: some View {
        NavigationView {
            VStack {
                if (costume.connected) {
                    ForEach(NavigationTarget.allCases, id: \.rawValue) { item in
                        EffectsListItemView(
                            text: item.title,
                            effectDescriptionText: item.effectDescription,
                            editDestination: AnyView(item.getView(costume)
                                .navigationTitle(item.title)
                                .navigationBarTitleDisplayMode(.inline)
                                .toolbar{
                                    Button("Reset") {}
                                }
                            )
                        )
                    }
                    Spacer()
                    CostumePreviewView(costume: costume)
                    Spacer()
                    PreviewButtonView(triggerBool: $costume.isButtonPressed)
                        .padding(.bottom)
                } else {
                    Text(costume.bluetoothOff ?
                         "Please turn Bluetooth on in Settings."
                         : costume.bluetoothUnavailable ?
                            "Please allow \(Bundle.main.displayName) access to Bluetooth"
                            : costume.ready ? "Costume found, connecting..." : "Please turn on costume"
                   )
                }
            }
            .navigationBarTitle("TEAM SAVANNAH")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitleFontStyle(.title1)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if (costume.updateAvailable) {
                        Button("update") {
                            isOTASheetShowing = true
                            // TODO: we probably need to prevent users from starting the update process multiple times?
//                            Task {
//                                let fw = try await fetchFirmwareFile(costumeManager.updatedFWURL)
//                                UIApplication.shared.isIdleTimerDisabled = true
//                                await costumeManager.costumeService.sendFWUpdate(fw)
//                                UIApplication.shared.isIdleTimerDisabled = false
//                                isOTASheetShowing = false
//                            }
                        }
                        .frame(width: 50.0)
                        .sheet(isPresented: $isOTASheetShowing) {
                            //OTAProgressView(costumeService: costumeManager.costumeService)
                        }
                    }
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
