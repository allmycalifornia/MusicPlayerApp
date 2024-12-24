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
            if let data = song.coverImage, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                ZStack {
                    Color.gray
                        .frame(width: 60, height: 60)
                    Image(systemName: "music.note")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                        .foregroundStyle(.white)
                }
                .cornerRadius(10)
            }
            
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
