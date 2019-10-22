//
//  NetworkManager.swift
//  MusicBrowser
//

import Foundation

import Alamofire
import AlamofireObjectMapper

class NetworkManager{
    var urlAPI : String = "https://1979673067.rsc.cdn77.org/music.json"
    weak var delegate: MusicTracksUpdatedProtocol?
    
    func retrieveMusicTracks() {
        guard let URL = URL(string: urlAPI) else {
            return
        }
        
        Alamofire.request(URL).responseArray { (response: DataResponse<[MusicTrack]>) in
            if let result = response.result.value {
                //sort the array by album alphabetically before sending
                let sortedMusicTracks : [MusicTrack] = result.sorted {
                    $0.album < $1.album
                }
                
                self.delegate?.responseuUpdated(musicTracks: sortedMusicTracks)
            } else if let error = response.result.error {
                print(error)
            }
        }
    }
    
    func imageFromURL(urlString: String, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        guard let imageURL = URL(string: urlString) else {
            return
        }
        Alamofire.request(imageURL).responseData { response in
            guard let data = response.data else {
                completionHandler(nil, response.error)
                return
            }
            let image = UIImage(data: data)
            completionHandler(image, nil)
        }
    }
    
}
