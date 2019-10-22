//
//  MusicTrack.swift
//  MusicBrowser
//


import ObjectMapper

struct MusicTrack: Mappable{
    var trackTitle: String = ""
    var album: String = ""
    var artistName: String = ""
    var coverImageURLString: String = ""
    
    private var tracks : [String] = []{
        didSet{
            trackTitle = tracks[0]
        }
    }
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        tracks <- map["tracks"]
        album <- map["album"]
        artistName <- map["artist"]
        coverImageURLString <- map["cover"]
    }
}
