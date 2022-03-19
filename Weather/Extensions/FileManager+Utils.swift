//
//  FileManager+Utils.swift
//  Weather
//
//  Created by jyohub on 2022/03/12.
//

import UIKit

extension FileManager {
    
    func saveBackgroundImageToDocumentDirectory(
        image: UIImage,
        fileName: String = .backgroundImage
    ) {
        if let data = image.jpegData(compressionQuality: 0.5) {
            guard let path = backgroundImageFilePath(fileName: fileName) else { return }
            try? data.write(to: path)
            NotificationCenter.default.post(name: .imageSaved, object: nil)
        }
    }
    
    func loadBackgroundImage(fileName: String = .backgroundImage) -> UIImage? {
        guard let imageUrl = backgroundImageFilePath(fileName: fileName) else { return nil }
        let image = UIImage(contentsOfFile: imageUrl.path)
        return image
    }
    
    private func backgroundImageFilePath(fileName: String) -> URL? {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard !documentDirectory.isEmpty else { return nil }
        return documentDirectory[0].appendingPathComponent(fileName)
    }
}
