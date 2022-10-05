//
//  AudioChooser.swift
//  MW4-Savannah
//
//  Created by LI Yun on 10/3/22.
//

import SwiftUI

enum AudioModes: Int, CaseIterable {
    case RecordedVoice
    case Song


    var title: String {
        switch self {
        case .RecordedVoice: return "Recorded Voice"
        case .Song: return "Song"

         
        }
    }
}

struct AudioChooserView: View {
    @State private var isOn: Bool = true
    @State private var picked: Int = 0
    var body: some View {
        VStack(alignment: .leading) {
            Toggle(isOn: $isOn) { Text("Button Trigger").fontWeight(.heavy) }
            Text("Play desired audio")
        
            
            if(isOn){
                Text("Sound Type")
                Picker(selection: $picked, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                    ForEach(AudioModes.allCases, id: \.rawValue) { item in
                            Text(item.title).tag(item.rawValue)
                    }
                }.pickerStyle(SegmentedPickerStyle())
             
                    //If users choose Recorded Voice
                    if(picked==0){
                        VStack(alignment: .center){
                            Text("Tip: Your voice will be recorded via the Pedestal. Lean closer for best result. Maximum length will be 10 seconds. ")
                                .multilineTextAlignment(.center)
                                .padding(.trailing)

                            Button {
                            } label: {
                                Image(systemName: "recordingtape")
                                    .imageScale(.large)
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(Color.blue)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(color: .gray, radius: 2, x: 0, y: 1)

                            }
                            .padding(.bottom)
                            Text("Hold to record")
                                .fontWeight(.bold)
                                .padding(.bottom)
                        }.padding(.top)
                  
                        
                    }
                    //If users choose Song
                    else{
                       SongListView()
                        
                    }
            }
 
            
   
        }
 
    }
}

struct AudioChooserView_Previews: PreviewProvider {
    static var previews: some View {
        AudioChooserView()
    }
}
