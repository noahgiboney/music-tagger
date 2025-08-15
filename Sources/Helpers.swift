//
//  Helpers.swift
//  swift-tagger
//
//  Created by Noah Giboney on 8/9/25.
//

import Foundation
import AVFoundation

/// Converts an mp3 to m4a, tags the file with metadata, and uploads the file to apple music.
/// - Parameters:
///   - fileURL: The song URL
///   - desination: The URL destination of the song
///   - song: The song to process
func uploadSong(fileURL: URL, desination: URL, song: Song) async throws {
    let asset = AVURLAsset(url: fileURL)
    let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)
    
    let audioMetadata = song.metadata
    
    /* Setup file metadata */
    let title = AVMutableMetadataItem()
    title.identifier = .commonIdentifierTitle
    title.value = NSString(string: song.title)
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
    try await exporter?.export(to: desination, as: AVFileType.m4a)
}

/// Creates a file location for the song to be uploaded to within the apple music library
/// - Parameter fileName: The filename
/// - Returns: URL of the file destination
func createSongLocation(fileName: String) -> URL {
    /* Assume this path is where music is stored */
    let musicPath = NSString("~/Music/Media.localized/Automatically Add to Music.localized").expandingTildeInPath
    let musicURL = URL(filePath: musicPath)
    
    let updatedFileName = fileName.replacingOccurrences(of: ".mp3", with: ".m4a")
    return musicURL.appendingPathComponent(updatedFileName)
}
