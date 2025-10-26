//
//  Config.swift
//  music-tagger
//
//  Created by Noah Giboney on 10/25/25.
//

import Foundation

/// Structure a config file must follow
struct Config: Decodable {
    let artist: String
    let album: String
    let pathToCoverArt: String?
    let genre: String
}
