//
//  Helpers.swift
//  swift-tagger
//
//  Created by Noah Giboney on 8/9/25.
//

import Foundation
import AVFoundation

/// Adds a song to a users apple music library
/// - Parameter songFile: The URL of the song to apple music library
func addSongToAppleMusic(songFile: URL) throws {
    let fileManager = FileManager.default
    
    /* Assume this path is where music is stored */
    let musicPath = NSString("~/Music/Media.localized/Automatically Add to Music.localized").expandingTildeInPath
    let musicURL = URL(filePath: musicPath)
    
    /* TODO: Dynamic support for music directories */
    guard fileManager.fileExists(atPath: musicURL.path) else {
        print("Music directory not found")
        return
    }
    
    let songDestination = musicURL.appendingPathComponent(songFile.lastPathComponent)
    
    guard fileManager.fileExists(atPath: songFile.path) else {
        print("Source song not found")
        return
    }
    
    /* Copy the song to the music directory */
    try fileManager.copyItem(at: songFile, to: songDestination)
    print("\(songFile.lastPathComponent) uploaded to apple music")
}

/// Converts and tags an mp3 file to an m4a file with the given metadata tags
/// - Parameters:
///   - fileURL: The destination of the mp3 file
///   - audioMetadata: The metadata to apply on the file
func convertAndTag(fileURL: URL, audioMetadata: AudioMetadata) async throws {
    let asset = AVURLAsset(url: fileURL)
    let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)
    
    /* Create a m4a file to write to */
    let updatedFileName = audioMetadata.fileName.replacingOccurrences(of: ".mp3", with: ".m4a")
    let audioFile = getTemporaryDirectory().appendingPathComponent(updatedFileName)
    
    /* Setup file metadata */
    let title = AVMutableMetadataItem()
    title.identifier = .commonIdentifierTitle
    title.value = NSString(string: audioMetadata.title)
    title.keySpace = .common
    
    let artist = AVMutableMetadataItem()
    artist.identifier = .iTunesMetadataArtist
    artist.value = NSString(string: audioMetadata.artist)
    artist.keySpace = .iTunes
    
    let albumArtist = AVMutableMetadataItem()
    albumArtist.identifier = .iTunesMetadataAlbumArtist
    albumArtist.value = NSString(string: audioMetadata.artist)
    albumArtist.keySpace = .iTunes
    
    let album = AVMutableMetadataItem()
    album.identifier = .iTunesMetadataAlbum
    album.value = NSString(string: audioMetadata.album)
    album.keySpace = .iTunes
    
    let genre = AVMutableMetadataItem()
    genre.identifier = .iTunesMetadataUserGenre
    genre.value = NSString(string: audioMetadata.genre)
    genre.keySpace = .iTunes
    
    let contentRatingRaw = AVMutableMetadataItem()
    contentRatingRaw.keySpace = .iTunes
    contentRatingRaw.key = "rtng" as NSString
    contentRatingRaw.value = Data([audioMetadata.advisoryValue == 1 ? 0x01 : audioMetadata.advisoryValue == 2 ? 0x02 : 0x00]) as NSData
    
    /* Create the image data */
    let coverArt = AVMutableMetadataItem()
    
    if let coverArtPath = audioMetadata.coverArtPath {
        /* Return if cover art is not found */
        guard FileManager.default.fileExists(atPath: coverArtPath) else {
            print("Cover art not foun ")
            return
        }
        
        let imageURL = URL(filePath: coverArtPath)
        let imageData = NSData(contentsOf: imageURL)
        
        coverArt.identifier = .iTunesMetadataCoverArt
        coverArt.value = imageData
        genre.keySpace = .iTunes
    }
    
    exporter?.metadata = [title, artist, albumArtist, genre, contentRatingRaw, album, coverArt]
    
    /* Export the file */
    try await exporter?.export(to: audioFile, as: AVFileType.m4a)
}

/// Gets the URL for this procceses temporary directory.
/// - Returns: The URL of the temporary directory
func getTemporaryDirectory() -> URL {
    let fileManager = FileManager.default
    let currentDirectoryURL = URL(filePath: fileManager.currentDirectoryPath)
    return currentDirectoryURL.appending(path: "temp")
    
}

/// Setups up the temporary directory for this proccess
func createTemporaryDirectory() throws {
    let fileManager = FileManager.default
    let temporaryDirectory = getTemporaryDirectory()
    try fileManager.createDirectory(at: temporaryDirectory, withIntermediateDirectories: true, attributes: nil)
}

/// Cleans up the temporary directory
func deleteTemporaryDirectory() throws {
    let fileManager = FileManager.default
    let temporaryDirectory = getTemporaryDirectory()
    
    /* Check temp exists before removing */
    if fileManager.fileExists(atPath: temporaryDirectory.path())  {
        try fileManager.removeItem(at: temporaryDirectory)
    }
}
