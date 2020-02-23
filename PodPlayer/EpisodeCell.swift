//
//  EpisodeCell.swift
//  PodPlayer
//
//  Created by Luis Guette on 2/23/20.
//  Copyright © 2020 Luis Guette. All rights reserved.
//

import Cocoa
import WebKit

class EpisodeCell: NSTableCellView {

    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var dateLabel: NSTextField!
    @IBOutlet weak var descriptionWebView: WKWebView!
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
