A collection of internet radio stations, stored in a standard JSON format for easy parsing and use in applications.

## Data Format
The JSON file contains an array of radio station objects. Each object has the following properties:
- `name`: The name of the radio station.
- `audio_url`: The URL of the audio stream (often, but not always, ends in a file extension like .mp3, .aac, .pls, etc.).
- `station_url`: The URL of the radio station's website.
- `genres`: (Optional) An array of genres associated with the station.

### Example Entry
```json
{
    "name": "Example Radio",
    "audio_url": "http://stream.example.com:8000/live.pls",
    "station_url": "http://www.example.com",
    "genres": [
        "pop",
        "rock"
    ]
}
```

## Tools

This repo contains a few tools to help work with the radio station data:

- `import_radio_stations_to_navidrome.sh`: A shell script to import/seed the radio stations into Navidrome, a self-hosted music server that supports internet radio stations.
    - Usage: `sh import_radio_stations_to_navidrome.sh path/to/radio_stations.json http://navidrome-server:port username password`
      - Any existing stations with the same name will be skipped and throw a non-terminating error by the server. This is normal behavior built into Navidrome's API.
    - This script is tested and confirmed to work with Navidrome. It is unclear if this will work with other Subsonic-based systems, [although it should](https://www.subsonic.org/pages/api.jsp#createInternetRadioStation).

## Credit

This collection is sourced from a variety of locations:

- https://github.com/mdrxy/great-radio-sites
- https://github.com/xehl/campus-fm
- https://github.com/deroverda/recommended-radio-streams
- https://github.com/junguler/m3u-radio-music-playlists
- https://radio.1cloud.fm/
- https://you.radio/

Credit to the development team behind [Navidrome](https://github.com/navidrome/navidrome) for a great piece of software.

Credit to the development team behind [Subsonic](https://www.subsonic.org) for the base API that Navidrome and other music servers are built upon.

Credit to the development team behind [Symphonium](https://www.symfonium.app/), my Subsonic client of choice for Android, which integrates nicely with Navidrome and radio stations.
