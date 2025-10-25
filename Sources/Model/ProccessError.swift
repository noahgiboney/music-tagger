//
//  ProccessError.swift
//  music-tagger
//
//  Created by Noah Giboney on 10/25/25.
//

import Foundation

enum ProccessError: LocalizedError {
    case coverArtNotFound(String)
    case songFilesNotFound(String)
    
    var errorDescription: String? {
        switch self {
        case .coverArtNotFound(let coverArt):
            "\(coverArt) not found."
        case .songFilesNotFound(let filePath):
            "Path to song files not found: \(filePath)"
        }
    }
}
