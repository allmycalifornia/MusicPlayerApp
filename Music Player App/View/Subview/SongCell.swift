//
//  SongCell.swift
//  Music Player App
//
//  Created by Борис Кравченко on 23.12.2024.
//

import SwiftUI

struct SongCell: View {
    
    let song: SongModel
    
    var body: some View {
        HStack {
            Color.white
                .frame(width: 60, height: 60)
                .cornerRadius(10)
                .padding(5)
            
            VStack(alignment: .leading) {
                Text(song.name)
                    .songNameFont()
                Text(song.artist ?? "Unknown Artist")
                    .artistFont()
            }
            
            Spacer()
            
            Text("03:48")
                .artistFont()
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}

#Preview {
    SongCell(song: SongModel(data: Data(), name: "Boulevard of broken dreams", artist: "Green Day", coverImage: Data(), duration: 0))
}
