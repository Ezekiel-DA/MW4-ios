//
//  OTAProgressView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/2/22.
//

import SwiftUI

struct OTAProgressView: View {
    @ObservedObject var costumeService: CostumeBLEServiceManager
    
    init(costumeService: CostumeBLEServiceManager?) {
        self.costumeService = costumeService ?? CostumeBLEServiceManager(modelView: CostumeModelView())
    }
    
    var body: some View {
//        if costumeService.otaProgress != 0.0 {
            VStack {
                Text("Update in progress").font(.largeTitle)
                Spacer()
                Text("Progress: \(costumeService.otaProgress, specifier: "%.1f") %")
                    .padding(.bottom)
                
                Spacer()
                
                VStack {
                    Text("Do not turn off costume. Leave app running.").fontWeight(.bold)
                    Text("Costume will restart once complete.")
                }.foregroundColor(.red)
                
                Spacer()
            }
//        }
    }
}

struct OTAProgressView_Previews: PreviewProvider {
    static var previews: some View {
        OTAProgressView(costumeService: CostumeBLEServiceManager(modelView: CostumeModelView()))
    }
}
