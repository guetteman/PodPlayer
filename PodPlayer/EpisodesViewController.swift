//
//  EpisodesViewController.swift
//  PodPlayer
//
//  Created by Luis Guette on 2/23/20.
//  Copyright © 2020 Luis Guette. All rights reserved.
//

import Cocoa
import AVFoundation

class EpisodesViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var pausePlayButton: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var deleteButton: NSButton!
    
    var podcast: Podcast? = nil
    var podcastsVC: PodcastsViewController? = nil
    var episodes: [Episode] = []
    var player: AVPlayer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        updateView()
    }
    
    func updateView() {
        titleLabel.stringValue = podcast?.title ?? "No podcast selected"
        
        if podcast?.imageURL != nil {
            let image = NSImage(byReferencing: URL(string: podcast!.imageURL!)!)
            
            imageView.image = image
        } else {
            imageView.image = nil
        }
        
        if podcast != nil {
            tableView.isHidden = false
            deleteButton.isHidden = false
        } else {
            tableView.isHidden = true
            deleteButton.isHidden = true
        }
        
        pausePlayButton.isHidden = true
        
        getEpisodes()
    }
    
    func getEpisodes() {
        if podcast?.rssURL != nil {
            let url = URL(string: podcast!.rssURL!)!
            
            URLSession.shared.dataTask(with: url) { (data:Data?, response:URLResponse?, error:Error?) in
                if error != nil {
                    print(error ?? "null error")
                } else {
                    if data != nil {
                        let parser = Parser()
                        let xml = parser.parse(data: data!)
                        
                        DispatchQueue.main.async {
                            self.episodes = parser.getEpisodes(for: xml)
                            self.tableView.reloadData()
                        }
                    }
                }
            }.resume()
        }
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
        if (pausePlayButton.title == "Pause") {
            player?.pause();
            pausePlayButton.title = "Play"
        } else {
            player?.play();
            pausePlayButton.title = "Pause"
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let episodeCellId = NSUserInterfaceItemIdentifier(rawValue: "episodeCell")
        
        let cell = tableView.makeView(withIdentifier: episodeCellId, owner: self) as? EpisodeCell
        
        let episode = episodes[row]
        
        cell?.titleLabel.stringValue = episode.title
        cell?.descriptionWebView.loadHTMLString(episode.htmlDescription, baseURL: nil)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        cell?.dateLabel.stringValue = dateFormatter.string(from: episode.pubDate)
        
        return cell
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 100
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if tableView.selectedRow >= 0 {
            let episode = episodes[tableView.selectedRow]
            
            if let url = URL(string: episode.audioURL) {
                player?.pause()
                player = nil
                
                player = AVPlayer.init(url: url)
                player?.play()
                pausePlayButton.isHidden = false
                pausePlayButton.title = "Pause"
            }
        }
    }
}
