//
//  Model.swift
//  swift-tagger
//
//  Created by Noah Giboney on 8/10/25.
//

import Foundation


/// Represents metadata fields for a single audio file.
struct Song {
    var fileName: String
    var metadata: AudioMetadata
    
    var title: String {
        fileName.replacingOccurrences(of: ".mp3", with: "")
    }
}

/// Represents metadata fields for a group of audio file.
struct AudioMetadata {
    var album: String = ""
    var artist: String
    var genre: String
    var coverArtPath: String?
    var isExplict: Bool
    var pathToFiles: String

    var advisoryValue: NSNumber {
        isExplict ? 1 : 0
    }
}

enum ProccessError: LocalizedError {
    case coverArtNotFound(String)
    
    var errorDescription: String? {
        switch self {
        case .coverArtNotFound(let coverArt):
            "\(coverArt) not found"
        }
    }
}
