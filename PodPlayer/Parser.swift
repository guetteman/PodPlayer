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
}
