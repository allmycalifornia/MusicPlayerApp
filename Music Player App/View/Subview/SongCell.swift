//
//  SongCell.swift
//  Music Player App
//
//  Created by Борис Кравченко on 23.12.2024.
//

import SwiftUI

struct SongCell: View {
    
    let song: SongModel
    let durationFormateed: (TimeInterval) -> String
    
    var body: some View {
        HStack {
            SongImageView(imageData: song.coverImage, size: 60)
            
            VStack(alignment: .leading) {
                Text(song.name)
                    .songNameFont()
                Text(song.artist ?? "Unknown Artist")
                    .artistFont()
            }
            
            Spacer()
            
            if let duration = song.duration {
                Text(durationFormateed(duration))
                    .artistFont()
            }
            
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}

#Preview {
    PlayerView()
}
