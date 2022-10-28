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
    func getView(_ costume: CostumeModelView) -> some View {
        switch self {
        case .ChairLights: ChairLightsView(costume: costume)
        case .PedestalLights: PedestalLightsView(costume: costume)
        case .Text: TextEffectsView(costume: costume)
        case .Audio: AudioView(costume: costume)
        }
    }
}


struct MainView: View {
    @ObservedObject var costume: CostumeModelView
    let connectionManager: ConnectionManager?
    
    @State private var isOTASheetShowing = false
    @State private var demoMode = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    if (costume.connected) {
                        ForEach(NavigationTarget.allCases, id: \.rawValue) { item in
                            EffectsListItemView(
                                text: item.title,
                                effectDescriptionText: item.effectDescription,
                                editDestination: AnyView(item.getView(costume)
                                    .navigationTitle(item.title)
                                    .navigationBarTitleDisplayMode(.inline)
                                )
                            )
                        }
                        Spacer()
                        CostumePreviewView(costume: costume)
                        Spacer()
                        PreviewButtonView(triggerBool: $costume.isButtonPressed)
                            .padding(.bottom)
                    } else {
                        CostumeNotPresentView(costume: costume, demoMode: $demoMode)
                            .onChange(of: demoMode, perform: { newValue in
                                if demoMode {
                                    costume.connected = true
                                    costume.ready = true
                                    costume.updateAvailable = true
                                    
                                    costume.textScreen.string = "TEAM SAVANNAH"
                                    costume.textScreenAlt.string = "I WANT YOU"
                                }
                            })
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
                                
                                guard let connectionMgr = connectionManager else {
                                    return
                                }
                                
                                // TODO: we probably need to prevent users from starting the update process multiple times?
                                Task {
                                    let fw = try await fetchFirmwareFile(updatedFWURL)
                                    UIApplication.shared.isIdleTimerDisabled = true
                                    await connectionMgr.costumeService.sendFWUpdate(fw)
                                    UIApplication.shared.isIdleTimerDisabled = false
                                    isOTASheetShowing = false
                                }
                            }
                            .frame(width: 50.0)
                            .sheet(isPresented: $isOTASheetShowing) {
                                OTAProgressView(costumeService: connectionManager != nil ? connectionManager!.costumeService : nil)
                            }
                        }
                    }
                }
                if (demoMode) {
                    DemoModeBackground()
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(costume: CostumeModelView(), connectionManager: nil)
    }
}
