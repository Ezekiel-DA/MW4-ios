//
//  SongListView.swift
//  MW4-Savannah
//
//  Created by LI Yun on 10/3/22.
//

import SwiftUI

struct SongListView: View {
    struct Song: Identifiable, Hashable {
        let name: String
        let id = UUID()
    }

    private var songs = [
        Song(name: "This is Halloween"),
        Song(name: "Placeholder"),
        Song(name: "Songname")
    ]

    @State private var singleSelection: UUID?

    var body: some View {
    
            Form{
                    Picker (selection: $singleSelection,label: Text("Choose a song")){
                        ForEach(songs, id:\.self){ song in
                            Text(song.name)
                        }
                    }.pickerStyle(.inline)
                
            }
        
    
   
        }
    }


struct SongListView_Previews: PreviewProvider {
    static var previews: some View {
        SongListView()
    }
}
