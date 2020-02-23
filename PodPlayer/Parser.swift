//
//  Parser.swift
//  PodPlayer
//
//  Created by Luis Guette on 2/18/20.
//  Copyright © 2020 Luis Guette. All rights reserved.
//

import Foundation

class Parser {
    
    func parse(data:Data) -> XMLIndexer {
        return SWXMLHash.parse(data)
    }
    
    func getTitle(for xml:XMLIndexer) -> String {
        return xml["rss"]["channel"]["title"].element?.text ?? ""
    }
    
    func getImageURL(for xml:XMLIndexer) -> String {
        return xml["rss"]["channel"]["itunes:image"].element?.attribute(by: "href")?.text ?? ""
    }
    
    func getEpisodes(for xml:XMLIndexer) -> [Episode] {
        var episodes: [Episode] = []
        
        for item in xml["rss"]["channel"]["item"].all {
            let episode = Episode()

            episode.title = item["title"].element?.text ?? ""
            episode.htmlDescription = item["description"].element?.text ?? ""
            episode.audioURL = item["enclosure"].element?.attribute(by: "url")?.text ?? ""
            
            if let pubDate = item["pubDate"].element?.text {
                if let date = Episode.formatter.date(from: pubDate) {
                    episode.pubDate = date
                }
            }
            
            episodes.append(episode)
        }
        
        return episodes
    }
}
