//
//  MusicTagger.swift
//  music-tagger
//
//  Created by Noah Giboney on 8/9/25.
//

import ArgumentParser
import Foundation

@main
struct MusicTagger: AsyncParsableCommand {
    
    @Argument(help: "The path on your computer to the directory that holds the music files.")
    var pathToFiles: String
    
    @Option(help: "The name of the artist.")
    var artist = ""
    
    @Option(help: "The name of the album. Will default to the folder name of the input files.")
    var album = ""
    
    @Option(help: "The genre of the music.")
    var genre = ""
    
    @Option(help: "Path to the image of the cover art")
    var cover: String?
    
    @Flag(help: "If enabled will mark songs as explict")
    var explicit = false
    
    @Flag(help: "Print debug output")
    var debug = false
    
    mutating func run() async throws {
        let fileManager = FileManager.default
        
        /* Ensure we can locate the files to do work on */
        guard fileManager.fileExists(atPath: pathToFiles) else {
            throw ProccessError.songFilesNotFound(pathToFiles)
        }
        
        if debug { print("Debug: Found files at: \(pathToFiles)") }
        
        let files = try fileManager.contentsOfDirectory(atPath: pathToFiles)
        
        let metadata = AudioMetadata(
            album: album,
            artist: artist,
            genre: genre,
            coverArtPath: cover,
            isExplict: explicit,
            pathToFiles: pathToFiles,
            debug: debug
        )
        
        if debug { print("Debug: Created run metadata: \(metadata)") }
        
        /* Proccess files in parrallel */
        await withTaskGroup(of: Void.self) { group in
            for file in files {
                group.addTask {
                    await proccessSong(file, metadata: metadata)
                }
            }
            
            /* Wait for all songs to procces */
            await group.waitForAll()
        }
    }
}

/// Proccess a song
/// - Parameter song: The song to proccess
func proccessSong(_ songFileName: String, metadata: AudioMetadata) async {
    
    /* Create URL for the song */
    let fileURL = URL(filePath: "\(metadata.pathToFiles)/\(songFileName)")
    
    if !(fileURL.pathExtension.lowercased() == "mp3") {
        if metadata.debug { print("Debug: \(songFileName) is not an mp3, skipping")}
        return
    }
    
    if metadata.debug { print("Debug: Processing \(songFileName)") }
    
    let baseName = songFileName.components(separatedBy: ".").first ?? songFileName
    
    /* Create location in the apply music library */
    let filename = "\(baseName)_\(metadata.artist).mp3"
    let songLocation = createSongLocation(fileName: filename)
    
    if metadata.debug { print("Debug: Created song location at \(songLocation)") }
    
    /* Convert mp3 to m4a, tag the file, and upload to apple music library */
    do {
        try await uploadSong(fileURL: fileURL, desination: songLocation, metadata: metadata)
    } catch {
        print("Error: \(error.localizedDescription)")
        return
    }
    
    print("Proccessed: \(songFileName)")
}
