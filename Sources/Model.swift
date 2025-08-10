//
//  Model.swift
//  swift-tagger
//
//  Created by Noah Giboney on 8/10/25.
//

import Foundation

/// Represents metadata fields for an audio file.
struct AudtioMetadata {
    var fileName: String
    var album: String = ""
    var artist: String
    var genre: String
    var coverArtPath: String?
    var isExplict: Bool
    
    var title: String {
        fileName.replacingOccurrences(of: ".mp3", with: "")
    }
    
    var advisoryValue: NSNumber {
        isExplict ? 1 : 0
    }
}
