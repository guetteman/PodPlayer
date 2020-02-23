//
//  Episode.swift
//  PodPlayer
//
//  Created by Luis Guette on 2/23/20.
//  Copyright © 2020 Luis Guette. All rights reserved.
//

import Cocoa

class Episode {
    var title = ""
    var pubDate = Date()
    var htmlDescription = ""
    var audioURL = ""
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        
        return formatter
    } ()
}
