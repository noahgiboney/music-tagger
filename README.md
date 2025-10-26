# MusicTagger

A command-line tool for automating the conversion of MP3 files to M4A, tagging them with metadata, and adding them to Apple Music/iTunes.

## Requirements
- **Swift**: Version 6.0 or later
- **Supported Platforms**:
  - macOS 15.0 or later
  - iOS 18.0 or later
- **Dependencies**:
  - [Swift Argument Parser](https://github.com/apple/swift-argument-parser) (version 1.3.0 or later)

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/noahgiboney/music-tagger
   ```
2. Navigate to the project directory:
   ```bash
   cd music-tagger
   ```
3. Build the project:
   ```bash
   swift build
   ```

## Usage
Run the tool with the required path to your MP3 files and optional metadata flags:

```bash
swift run music-tagger /path/to/music/files --artist "Artist Name" --album "Album Name" --genre "Genre" --cover /path/to/cover.jpg
```

### Options
Required values can be set using a JSON config file or using the options. Using options will overide the config file if supplied.
- `--config`: Path to a JSON config file with the three required values
- `--artist`: Specify the artist name (Required)
- `--album`: Specify the album name (Required)
- `--genre`: Specify the music genre (Required)
- `--cover`: Path to the cover art image
- `--explicit`: Mark songs as explicit 

## Notes
- Only MP3 files are processed; other file types are skipped.
- The current version assumes a hardcoded path your apple music directory.

## License
MIT License

