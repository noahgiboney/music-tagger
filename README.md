# SwiftTagger

A command-line tool for automating converting MP3 files to M4A and tagging them with metadata before adding them to Apple Music/iTunes.

## Requirements
- macOS with Swift installed

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/swift-tagger.git
   ```
2. Navigate to the project directory:
   ```bash
   cd swift-tagger
   ```
3. Build the project:
   ```bash
   swift build
   ```

## Usage
Run the tool with the required path to your MP3 files and optional metadata flags:

```bash
swift run swift-tagger /path/to/music/files --artist "Artist Name" --album "Album Name" --genre "Genre" --cover /path/to/cover.jpg
```

### Options
- `--artist`: Specify the artist name
- `--album`: Specify the album name
- `--genre`: Specify the music genre
- `--cover`: Path to the cover art image (optional)
- `--explicit`: Mark songs as explicit (optional)

## Notes
- Only MP3 files are processed; other file types are skipped.
- The current version assumes a hardcoded path your apple music directory.

## License
MIT License

