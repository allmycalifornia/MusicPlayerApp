//
//  SongImageView.swift
//  Music Player App
//
//  Created by Борис Кравченко on 25.12.2024.
//

import SwiftUI

struct SongImageView: View {
    
    let imageData: Data?
    let size: CGFloat
    
    var body: some View {
        if let data = imageData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        } else {
            ZStack {
                Color.gray
                    .frame(width: size, height: size)
                Image(systemName: "music.note")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 30)
                    .foregroundStyle(.white)
            }
            .cornerRadius(10)
        }
    }
}

#Preview {
    SongImageView(imageData: Data(), size: 200)
}
