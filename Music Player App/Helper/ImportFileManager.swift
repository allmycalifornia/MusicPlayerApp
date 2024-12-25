//
//  ImportFileManager.swift
//  Music Player App
//
//  Created by Борис Кравченко on 24.12.2024.
//

//import Foundation
//import SwiftUI
//import AVFoundation

//struct ImportFileManager: UIViewControllerRepresentable {
//    
//    @Binding var songs: [SongModel]
//    
//    // Координатор управляет задачами между SwiftUI и UIKit
//    func makeCoordinator() -> Coordinator {
//        Coordinator(parent: self)
//    }
//    
//    // Метод создаёт и настраивает пикер для выбора аудиофайлов
//    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
//        // Разрешение открыть файлы с типом аудио (MP3, WAV)
//        let picker = UIDocumentPickerViewController(documentTypes: ["public.audio"], in: .open)
//        // Разрешение выбрать только 1 файл
//        picker.allowsMultipleSelection = false
//        // Пока расширения файлов
//        picker.shouldShowFileExtensions = true
//        // Установка координатора в качестве делегата
//        picker.delegate = context.coordinator
//        return picker
//    }
//    
//    // Метод обновления контроллера с новыми данными
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
//    
//    // Координатор служит связующим звеном между UIDocumentPicker и ImportFileManager
//    class Coordinator: NSObject, UIDocumentPickerDelegate {
//        
//        var parent: ImportFileManager
//        
//        init(parent: ImportFileManager) {
//            self.parent = parent
//        }
//        
//        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//            
//            
//            guard let url = urls.first, url.startAccessingSecurityScopedResource() else { return }
//            
//            defer { url.stopAccessingSecurityScopedResource() }
//            
//            do {
//                let document = try Data(contentsOf: url)
//                let asset = AVAsset(url: url)
//                var song = SongModel(data: document, name: url.lastPathComponent)
//                let metadata = asset.metadata
//                for item in metadata {
//                    guard let key = item.commonKey?.rawValue, let value = item.value else { continue }
//                    switch key {
//                    case AVMetadataKey.commonKeyArtist.rawValue:
//                        song.artist = value as? String
//                    case AVMetadataKey.commonKeyArtwork.rawValue:
//                        song.coverImage = value as? Data
//                    case AVMetadataKey.commonKeyTitle.rawValue:
//                        song.name = value as? String ?? song.name
//                    default:
//                        break
//                    }
//                }
//                
//                // Получение продолжительности песни
//                song.duration = CMTimeGetSeconds(asset.duration)
//                
//                // Добавление песни в массив songs, если там такой ещё нет
//                if !self.parent.songs.contains(where: { $0.name == song.name }) {
//                    DispatchQueue.main.async {
//                        self.parent.songs.append(song)
//                    }
//                } else {
//                    print("Song with this name already exists")
//                }
//                
//            } catch {
//                print("Error processing the file: \(error)")
//            }
//        }
//    }
//}

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
