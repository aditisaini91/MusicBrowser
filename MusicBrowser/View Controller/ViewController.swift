//
//  ViewController.swift
//  MusicBrowser
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, MusicTracksUpdatedProtocol {
    @IBOutlet weak var tableView: UITableView!
    var resultSearchController = UISearchController()
    lazy var networkManager : NetworkManager = {
        let manager = NetworkManager()
        manager.delegate = self
        manager.retrieveMusicTracks()
        return manager
    }()
    var musicTracks : [MusicTrack] = [] //data to render in tableview
    var filteredMusicTracks : [MusicTrack] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register the custom table view cell
        let nib = UINib.init(nibName: "MusicItemCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MusicItemCell")
        
        //search controller setup
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.searchBar.sizeToFit()
            tableView.tableHeaderView = controller.searchBar
            return controller
        })()
        
        //netowrk calls
        _ = networkManager
        
    }
    
    //MARK: Tableview delegates datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (resultSearchController.isActive) {
            return filteredMusicTracks.count
        } else {
            return musicTracks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicItemCell", for: indexPath) as! MusicItemCell
        
        var musicTrack : MusicTrack?
        if (resultSearchController.isActive) {
            musicTrack = filteredMusicTracks[indexPath.row]
        } else {
            musicTrack = musicTracks[indexPath.row]
        }
        cell.artistLabel.text = musicTrack?.artistName
        cell.albumLabel.text = musicTrack?.album
        cell.titleTrackLabel.text = musicTrack?.trackTitle
        
        //setup image lazy loading
        if let url = musicTrack?.coverImageURLString {
            networkManager.imageFromURL(urlString: url) { (image, error) in
                guard error == nil else {
                    print(error!)
                    return
                }
                if let cellToUpdate = self.tableView?.cellForRow(at: indexPath) as? MusicItemCell {
                    cellToUpdate.coverImage.image = image
                    cellToUpdate.setNeedsLayout()
                }
            }
        }
        
        return cell
    }
    
    
    //MARK: UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        filteredMusicTracks.removeAll(keepingCapacity: false)
        guard let searchText = searchController.searchBar.text else {
            return
        }
        
        let array = musicTracks.filter {
            $0.album.range(of: searchText) != nil
                || $0.artistName.range(of: searchText) != nil
                || $0.trackTitle.range(of: searchText) != nil
        }
        filteredMusicTracks = array
        
        tableView.reloadData()
    }
    
    //MARK: MusicTracksUpdatedProtocol
    func responseuUpdated(musicTracks: [MusicTrack]) {
        self.musicTracks = musicTracks
        tableView.reloadData()
    }
    
}

