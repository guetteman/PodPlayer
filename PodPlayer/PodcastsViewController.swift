//
//  PodcastsViewController.swift
//  PodPlayer
//
//  Created by Luis Guette on 2/18/20.
//  Copyright © 2020 Luis Guette. All rights reserved.
//

import Cocoa

class PodcastsViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet weak var podcastURLTextField: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    
    var podcasts: [Podcast] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        getPodcasts()
        podcastURLTextField.stringValue = "https://rss.simplecast.com/podcasts/279/rss"
    }
    
    func getPodcasts() {
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let fetchy = Podcast.fetchRequest() as NSFetchRequest<Podcast>
            
            fetchy.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            do {
                podcasts = try context.fetch(fetchy)
                
                tableView.reloadData()
            } catch {}
        }
    }
    
    @IBAction func addPodcastClicked(_ sender: Any) {
        
        if let url = URL(string: podcastURLTextField.stringValue) {
            
            URLSession.shared.dataTask(with: url) { (data:Data?, response:URLResponse?, error:Error?) in
                if error != nil {
                    print(error ?? "null error")
                } else {
                    if data != nil {
                        let parser = Parser()
                        let xml = parser.parse(data: data!)
                        DispatchQueue.main.async {
                            if !self.podcastExists(rssURL: self.podcastURLTextField.stringValue) {
                                if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                                    let podcast = Podcast(context: context)
                                    
                                    podcast.rssURL = self.podcastURLTextField.stringValue
                                    podcast.title = parser.getTitle(for: xml)
                                    podcast.imageURL = parser.getImageURL(for: xml)
                                    
                                }
                                (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
                                self.podcastURLTextField.stringValue = ""
                                self.getPodcasts()
                            }
                        }
                    }
                }
            }.resume()
        }
    }
    
    func podcastExists(rssURL:String) -> Bool {
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let fetchy = Podcast.fetchRequest() as NSFetchRequest<Podcast>
            
            fetchy.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            fetchy.predicate = NSPredicate(format: "rssURL == %@", rssURL)
            
            do {
                let matchingPodcasts = try context.fetch(fetchy)
                
                if matchingPodcasts.count >= 1 {
                    return true
                } else {
                    return false
                }
            } catch {}
        }
        
        return false
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return podcasts.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let podcastCellId = NSUserInterfaceItemIdentifier(rawValue: "podcastCell")
        let cell = tableView.makeView(withIdentifier: podcastCellId, owner: self) as? NSTableCellView
        let podcast = podcasts[row]
        
        cell?.textField?.stringValue = podcast.title ?? "unknown title"
        
        return cell
    }
}
