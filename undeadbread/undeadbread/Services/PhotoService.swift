//
//  PhotoService.swift
//  undeadbread
//
//  Created by stephenciauri on 2/10/18.
//  Copyright © 2018 Stephen Ciauri. All rights reserved.
//

import Foundation
import UIKit

protocol PhotoServiceProtocol: class {
    func getPhoto(named filename: String) -> UIImage?
    func save(photo image: UIImage, named: String) -> URL?
}

class PhotoService: PhotoServiceProtocol {
    static let shared = PhotoService()
    
    private let fileManager = FileManager()
    private lazy var photosURL: URL? = {
        if let documentsURL = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            let photosURL = documentsURL.appendingPathComponent("Photos", isDirectory: true)
            if !fileManager.fileExists(atPath: photosURL.path) {
                do {
                    try fileManager.createDirectory(at: photosURL, withIntermediateDirectories: false, attributes: nil)
                    return photosURL
                } catch let error {
                    NSLog(error.localizedDescription)
                    return nil
                }
            } else {
                return photosURL
            }
        } else {
            return nil
        }
    }()
    
    func getPhoto(named filename: String) -> UIImage? {
        guard let photosURL = photosURL else {
            return nil
        }
        return UIImage(contentsOfFile: photosURL.appendingPathComponent(filename).path)
    }
    
    func save(photo image: UIImage, named filename: String) -> URL? {
        guard let photosURL = photosURL else {
            return nil
        }
        let destinationURL = photosURL.appendingPathComponent(filename)
        do {
            try UIImageJPEGRepresentation(image, 0.5)?.write(to: destinationURL, options: .atomic)
            return destinationURL
        } catch let error {
            NSLog(error.localizedDescription)
            return nil
        }
    }
}
