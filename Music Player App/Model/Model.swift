//
//  Model.swift
//  Music Player App
//
//  Created by Борис Кравченко on 23.12.2024.
//

import SwiftUI

struct SongModel: Identifiable {
    let id = UUID()
    let data: Data
    let name: String
    let artist: String?
    let coverImage: Data?
    let duration: TimeInterval?
}
