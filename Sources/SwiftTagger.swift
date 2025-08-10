//
//  SwiftTagger.swift
//  swift-tagger
//
//  Created by Noah Giboney on 8/9/25.
//

import ArgumentParser
import Foundation

@main
struct SwiftTag: AsyncParsableCommand {
    
    @Argument(help: "The path on your computer to the directory that holds the music files.")
    var pathToFiles: String
    
    @Option(help: "The name of the artist.")
    var artist = ""
    
    @Option(help: "The name of the album.")
    var album = ""
    
    @Option(help: "The genre of the music.")
    var genre = ""
    
    @Option(help: "Path to the image of the cover art")
    var cover: String?
    
    @Flag(help: "If enabled will mark songs as explict")
    var explicit = false

    mutating func run() async throws {
        let fileManager = FileManager.default
        
        /* Clean-up on any exit */
        defer { cleanUp() }
        
        /* Create the temporary directory for converted files to be stored */
        try createTemporaryDirectory()
        
        /* Ensure we can locate the files to do work on */
        guard fileManager.fileExists(atPath: pathToFiles) else {
            print("Unable to find path to files")
            return
        }
        
        /* Convert all mp3 file to m4a and tag them with appropriate metadata
         TODO: Use task group to convert songs in parallel
         */
        let files = try fileManager.contentsOfDirectory(atPath: pathToFiles)
        
        for file in files {
            
            let fileURL = URL(filePath: "\(pathToFiles)/\(file)")
            
            if !(fileURL.pathExtension.lowercased() == "mp3") {
                print("\(file) is not an mp3, skipping")
                continue
            }
            
            let metadata = AudioMetadata(
                fileName: file,
                album: album,
                artist: artist,
                genre: genre,
                coverArtPath: cover,
                isExplict: explicit
            )
            
            try await convertAndTag(fileURL: fileURL, audioMetadata: metadata)
        }
        
        /* Upload tagged files to apple music/iTunes
         TODO: Use task group to add songs in parallel
         */
        let taggedFiles = try fileManager.contentsOfDirectory(at: getTemporaryDirectory(), includingPropertiesForKeys: [])

        for file in taggedFiles {
            try addSongToAppleMusic(songFile: file)
        }
    }
}

/// Cleans up the proccess by removing the temporary directory
func cleanUp() {
    do {
        try deleteTemporaryDirectory()
    } catch {
        print(error)
    }
}
