//
//  AudioMetadata.swift
//  music-tagger
//
//  Created by Noah Giboney on 10/25/25.
//

import Foundation

/// Represents metadata fields for a group of audio file.
struct AudioMetadata {
    var album: String = ""
    var artist: String
    var genre: String
    var pathToCovertArt: String?
    var isExplict: Bool
    var pathToFiles: String
    var debug: Bool

    var advisoryValue: NSNumber {
        isExplict ? 1 : 0
    }
}
