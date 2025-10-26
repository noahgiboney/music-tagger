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
    case configDecoding
    case configNotFound(String)
    
    var errorDescription: String? {
        switch self {
        case .coverArtNotFound(let coverArt):
            "Cover art not found: \(coverArt)."
        case .songFilesNotFound(let filePath):
            "Path to song files not found: \(filePath)"
        case .configDecoding:
            "There was a problem decoding the config file"
        case .configNotFound(let configPath):
            "Path to config not found: \(configPath)"
        }
    }
}
