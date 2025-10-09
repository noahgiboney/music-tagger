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
        
        /* Ensure we can locate the files to do work on */
        guard fileManager.fileExists(atPath: pathToFiles) else {
            print("Unable to find path to files")
            return
        }
        
        let files = try fileManager.contentsOfDirectory(atPath: pathToFiles)
        
        let metadata = AudioMetadata(
            album: album,
            artist: artist,
            genre: genre,
            coverArtPath: cover,
            isExplict: explicit,
            pathToFiles: pathToFiles
        )
        
        /* Proccess files in parrallel */
        await withTaskGroup(of: Void.self) { group in
            for file in files {
                group.addTask {
                    let song = Song(fileName: file, metadata: metadata)
                    await proccessSong(song)
                }
            }
            
            /* Wait for all songs to procces */
            await group.waitForAll()
        }
    }
}

/// Proccess a song
/// - Parameter song: The song to proccess
func proccessSong(_ song: Song) async {
    
    /* Create URL for the song */
    let fileURL = URL(filePath: "\(song.metadata.pathToFiles)/\(song.fileName)")
    
    if !(fileURL.pathExtension.lowercased() == "mp3") {
        print("\(song.fileName) is not an mp3, skipping")
        return
    }
    
    let baseName = song.fileName.components(separatedBy: ".").first ?? song.fileName
    
    /* Create location in the apply music library */
    let filename = "\(baseName)_\(song.metadata.artist).mp3"
    let songLocation = createSongLocation(fileName: filename)
    
    /* Convert mp3 to m4a, tag the file, and upload to apple music library */
    do {
        try await uploadSong(fileURL: fileURL, desination: songLocation, song: song)
    } catch {
        print("ERROR: \(error.localizedDescription)")
        return
    }
    
    print("Proccessed \(song.fileName)")
}
