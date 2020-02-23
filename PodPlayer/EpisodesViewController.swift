//
//  EpisodesViewController.swift
//  PodPlayer
//
//  Created by Luis Guette on 2/23/20.
//  Copyright © 2020 Luis Guette. All rights reserved.
//

import Cocoa

class EpisodesViewController: NSViewController {

    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var pausePlayButton: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    
    var podcast: Podcast? = nil
    var podcastsVC: PodcastsViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func updateView() {
        titleLabel.stringValue = podcast?.title ?? "No podcast selected"
        
        if podcast?.imageURL != nil {
            let image = NSImage(byReferencing: URL(string: podcast!.imageURL!)!)
            
            imageView.image = image
        } else {
            imageView.image = nil
        }
        
        pausePlayButton.isHidden = true
    }
    
    @IBAction func deleteClicked(_ sender: Any) {
        if podcast != nil {
            if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                context.delete(podcast!)
                
                (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
                
                podcastsVC?.getPodcasts()
                
                podcast = nil
                updateView()
            }
        }
    }
    @IBAction func pausePlayClicked(_ sender: Any) {
    }
}
