//
//  OTAProgressView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/2/22.
//

import SwiftUI

struct OTAProgressView: View {
    @ObservedObject var costumeService: CostumeService
    
    var body: some View {
        if costumeService.otaProgress != 0.0 {
            VStack {
                Text("Progress: \(costumeService.otaProgress, specifier: "%.1f") %")
                    .padding(.bottom)
                
                Text("Transfer speed : \(costumeService.otaKBps, specifier: "%.1f") kB/s")
                Text("Elapsed time   : \(costumeService.otaElapsed, specifier: "%.1f") s")
            }
        }
    }
}

struct OTAProgressView_Previews: PreviewProvider {
    static var previews: some View {
        OTAProgressView(costumeService: CostumeService())
    }
}
