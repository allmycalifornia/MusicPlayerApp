//
//  AudioOutputPicker.swift
//  Music Player App
//
//  Created by Борис Кравченко on 26.12.2024.
//

import SwiftUI
import AVKit

struct AudioOutputPicker: UIViewRepresentable {
    func makeUIView(context: Context) -> AVRoutePickerView {
        let routePickerView = AVRoutePickerView()
        routePickerView.activeTintColor = .white // Цвет активной кнопки
        routePickerView.tintColor = .white      // Цвет кнопки в неактивном состоянии
        routePickerView.prioritizesVideoDevices = false // Только аудио-устройства
        return routePickerView
    }

    func updateUIView(_ uiView: AVRoutePickerView, context: Context) {
        // Никакие обновления не требуются
    }
}
