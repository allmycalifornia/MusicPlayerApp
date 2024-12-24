//
//  Model.swift
//  Music Player App
//
//  Created by Борис Кравченко on 23.12.2024.
//

import SwiftUI

struct SongModel: Identifiable {
    var id = UUID()
    var data: Data
    var name: String
    var artist: String?
    var coverImage: Data?
    var duration: TimeInterval?
}
