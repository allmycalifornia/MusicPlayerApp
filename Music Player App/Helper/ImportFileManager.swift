//
//  ImportFileManager.swift
//  Music Player App
//
//  Created by Борис Кравченко on 24.12.2024.
//

import Foundation
import SwiftUI
import AVFoundation

struct ImportFileManager: UIViewControllerRepresentable {
    
    @Binding var songs: [SongModel]
    
    // Координатор управляет задачами между SwiftUI и UIKit
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    // Метод создаёт и настраивает пикер для выбора аудиофайлов
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        // Разрешение открыть файлы с типом аудио (MP3, WAV)
        let picker = UIDocumentPickerViewController(documentTypes: ["public.audio"], in: .open)
        // Разрешение выбрать только 1 файл
        picker.allowsMultipleSelection = false
        // Пока расширения файлов
        picker.shouldShowFileExtensions = true
        // Установка координатора в качестве делегата
        picker.delegate = context.coordinator
        return picker
    }
    
    // Метод обновления контроллера с новыми данными
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    // Координатор служит связующим звеном между UIDocumentPicker и ImportFileManager
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        
        var parent: ImportFileManager
        
        init(parent: ImportFileManager) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            
            
            guard let url = urls.first, url.startAccessingSecurityScopedResource() else { return }
            
            defer { url.stopAccessingSecurityScopedResource() }
            
            do {
                let document = try Data(contentsOf: url)
                let asset = AVAsset(url: url)
                var song = SongModel(data: document, name: url.lastPathComponent)
                let metadata = asset.metadata
                for item in metadata {
                    guard let key = item.commonKey?.rawValue, let value = item.value else { continue }
                    switch key {
                    case AVMetadataKey.commonKeyArtist.rawValue:
                        song.artist = value as? String
                    case AVMetadataKey.commonKeyArtwork.rawValue:
                        song.coverImage = value as? Data
                    case AVMetadataKey.commonKeyTitle.rawValue:
                        song.name = value as? String ?? song.name
                    default:
                        break
                    }
                }
                
                // Получение продолжительности песни
                song.duration = CMTimeGetSeconds(asset.duration)
                
                // Добавление песни в массив songs, если там такой ещё нет
                if !self.parent.songs.contains(where: { $0.name == song.name }) {
                    DispatchQueue.main.async {
                        self.parent.songs.append(song)
                    }
                } else {
                    print("Song with this name already exists")
                }
                
            } catch {
                print("Error processing the file: \(error)")
            }
        }
    }
}
