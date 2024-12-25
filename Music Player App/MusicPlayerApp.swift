//
//  Music_Player_AppApp.swift
//  Music Player App
//
//  Created by Борис Кравченко on 23.12.2024.
//

//import SwiftUI
//
//@main
//struct MusicPlayerApp: App {
//    var body: some Scene {
//        WindowGroup {
//            PlayerView()
//        }
//    }
//}

import SwiftUI
import AVFoundation

@main
struct MusicPlayerApp: App {
    init() {
        configureAudioSession()
    }
    
    var body: some Scene {
        WindowGroup {
            PlayerView()
        }
    }
    
    private func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [])
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
}
