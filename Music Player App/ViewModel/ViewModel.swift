//
//  ViewModel.swift
//  Music Player App
//
//  Created by Борис Кравченко on 23.12.2024.
//

import SwiftUI

class ViewModel: ObservableObject {
    
    @Published var songs: [SongModel] = [
        SongModel(
            data: Data(),
            name: "Song #1",
            artist: "Blur",
            coverImage: Data(),
            duration: 0
        ),
        SongModel(
            data: Data(),
            name: "Unstoppable",
            artist: "SIA",
            coverImage: Data(),
            duration: 0
        ),
        SongModel(
            data: Data(),
            name: "American Idiot",
            artist: "Green Day",
            coverImage: Data(),
            duration: 0
        ),
    ]
}
