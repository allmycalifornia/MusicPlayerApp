//
//  ViewModel.swift
//  Music Player App
//
//  Created by Борис Кравченко on 23.12.2024.
//

import SwiftUI
import AVFAudio
import RealmSwift

class ViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    @ObservedResults(SongModel.self) var songs
    @Published var audioPlayer: AVAudioPlayer?
    @Published var isPlaying: Bool = false
    @Published var currentIndex: Int?
    @Published var currentTime: TimeInterval = 0.0
    @Published var totalTime: TimeInterval = 0.0
    
    // Флаги для перемешивания и повторения
    @Published var isShuffle: Bool = false
    @Published var isRepeat: Bool = false
    
    var currentSong: SongModel? {
        guard let currentIndex = currentIndex, songs.indices.contains(currentIndex) else { return nil }
        return songs[currentIndex]
    }
    
    func durationFormatted(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: duration) ?? ""
    }
    
    func playAudio(song: SongModel) {
        do {
            self.audioPlayer = try AVAudioPlayer(data: song.data)
            self.audioPlayer?.delegate = self
            self.audioPlayer?.play()
            isPlaying = true
            totalTime = audioPlayer?.duration ?? 0.0
            if let index = songs.firstIndex(where: { $0.id == song.id }) {
                currentIndex = index
            }
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
    
    func playPause() {
        if isPlaying {
            self.audioPlayer?.pause()
        } else {
            self.audioPlayer?.play()
        }
        isPlaying.toggle()
    }
    
    func forward() {
        guard let currentIndex = currentIndex else { return }
        let nextIndex: Int
        
        if isShuffle {
            // В случае перемешивания выбираем случайную песню
            nextIndex = Int.random(in: 0..<songs.count)
        } else {
            // Если не перемешиваем, идем по порядку
            nextIndex = currentIndex + 1 < songs.count ? currentIndex + 1 : 0
        }
        
        playAudio(song: songs[nextIndex])
    }
    
    func backward() {
        guard let currentIndex = currentIndex else { return }
        let previousIndex: Int
        
        if isShuffle {
            // В случае перемешивания выбираем случайную песню
            previousIndex = Int.random(in: 0..<songs.count)
        } else {
            // Если не перемешиваем, идем по порядку
            previousIndex = currentIndex > 0 ? currentIndex - 1 : songs.count - 1
        }
        
        playAudio(song: songs[previousIndex])
    }
    
    func rewindAudio(time: TimeInterval = 15) {
        guard let player = audioPlayer else { return }
        let newTime = player.currentTime - time
        player.currentTime = max(newTime, 0) // Убедимся, что не перемотаем за начало трека
        updateProgress() // Обновляем прогресс воспроизведения
    }

    func fastForwardAudio(time: TimeInterval = 15) {
        guard let player = audioPlayer else { return }
        let newTime = player.currentTime + time
        player.currentTime = min(newTime, player.duration) // Убедимся, что не перемотаем за конец трека
        updateProgress() // Обновляем прогресс воспроизведения
    }
    
    func seekAudio(time: TimeInterval) {
        audioPlayer?.currentTime = time
    }
    
    func updateProgress() {
        guard let player = audioPlayer else { return }
        currentTime = player.currentTime
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            if isRepeat {
                // В случае повтора, играем текущую песню снова
                playAudio(song: songs[currentIndex ?? 0])
            } else {
                // В обычном режиме идем к следующей песне
                forward()
            }
        }
    }
    
    func stopAudio() {
        audioPlayer?.stop()
        self.audioPlayer = nil
        isPlaying = false
    }
    
    // Переключение на режим перемешивания
    func toggleShuffle() {
        isShuffle = true
        isRepeat = false // отключаем repeat при включении shuffle
    }
    
    // Переключение на режим повтора
    func toggleRepeat() {
        isRepeat = true
        isShuffle = false // отключаем shuffle при включении repeat
    }
    
    // Переключение между shuffle и repeat
    func toggleShuffleRepeat() {
        if isShuffle {
            toggleRepeat()  // Если shuffle активен, переключаем на repeat
        } else {
            toggleShuffle() // Если repeat активен, переключаем на shuffle
        }
    }
}
