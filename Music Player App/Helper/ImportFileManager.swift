//
//  ImportFileManager.swift
//  Music Player App
//
//  Created by Борис Кравченко on 24.12.2024.
//

import Foundation
import SwiftUI
import AVFoundation
import RealmSwift

struct ImportFileManager: UIViewControllerRepresentable {
    
    // Координатор управляет задачами между SwiftUI и UIKit
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    // Метод создаёт и настраивает пикер для выбора аудиофайлов
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio])
        picker.allowsMultipleSelection = true // Разрешаем выбор нескольких файлов
        picker.delegate = context.coordinator
        return picker
    }
    
    // Метод обновления контроллера с новыми данными
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    // Координатор служит связующим звеном между UIDocumentPicker и ImportFileManager
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        
        // MARK: - Property
        var parent: ImportFileManager
        @ObservedResults(SongModel.self) var songs
        
        // MARK: - Initializer
        init(parent: ImportFileManager) {
            self.parent = parent
        }
        
        // MARK: - Methods
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            Task {
                for url in urls {
                    guard url.startAccessingSecurityScopedResource() else { continue }
                    defer { url.stopAccessingSecurityScopedResource() }
                    
                    let asset = AVAsset(url: url)
                    do {
                        // Загружаем метаданные и продолжительность асинхронно
                        let metadata = try await asset.load(.metadata)
                        let duration = try await asset.load(.duration)
                        
                        let song = SongModel(name: url.lastPathComponent, data: try Data(contentsOf: url))
                        
                        for item in metadata {
                            if let key = item.commonKey?.rawValue {
                                switch key {
                                case AVMetadataKey.commonKeyArtist.rawValue:
                                    song.artist = (try? await item.load(.value) as? String) ?? "Unknown Artist"
                                case AVMetadataKey.commonKeyArtwork.rawValue:
                                    song.coverImage = (try? await item.load(.value) as? Data)
                                case AVMetadataKey.commonKeyTitle.rawValue:
                                    song.name = (try? await item.load(.value) as? String) ?? song.name
                                default:
                                    break
                                }
                            }
                        }
                        
                        // Получаем продолжительность песни
                        song.duration = CMTimeGetSeconds(duration)
                        
                        let isDuplicate = songs.contains { $0.name == song.name && $0.artist == song.artist }
                        // Добавляем песню в массив, если она ещё не существует
                        if !isDuplicate {
                            $songs.append(song)
                        } else {
                            print("Song with this name already exists")
                        }
                    } catch {
                        print("Error processing the file: \(error)")
                    }
                }
            }
        }
    }
}
