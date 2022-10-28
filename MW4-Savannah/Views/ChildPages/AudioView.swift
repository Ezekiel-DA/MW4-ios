//
//  AudioView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/6/22.
//

import SwiftUI

struct AudioView: View {
    @ObservedObject var costume: CostumeModelView
    
    var body: some View {
        VStack {
            CostumePreviewView(costume: costume)
            Form {
                Section {
                    //AudioChooserView()
                    
                    if costume.fwVersion >= 3 {
                        HStack {
                            Text("Volume")
                            Slider(value: $costume.musicControl.volume, in: 0...21, step: 1)
                        }
                    } else {
                        Text("Volume control requires costume firmware version 3.\nPlease upgrade.")
                    }
                    
                }
            }
        }
   
    }
}

struct AudioView_Previews: PreviewProvider {
    static var previews: some View {
        AudioView(costume: CostumeModelView())
    }
}
