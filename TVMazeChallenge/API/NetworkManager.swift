//
//  NetworkManager.swift
//  TVMazeChallenge
//
//  Created by Lucas Barcelos on 16/06/23.
//

import Foundation

protocol ShowServiceAPIProtocol {
    func successFetchShows(shows: [ShowsModel])
    func successFetchEpisodes(eps: [Episodes])
    func error(error: Error)
}

class ShowServiceAPI{
    
    // Properties
    var delegate: ShowServiceAPIProtocol?
    
    // Methods
    public func fetchShow() {
        
        guard let url = URL(string: BaseURLServices.fetchShows) else { return }
        
        let request = URLSession.shared.dataTask(with: url){(data, response, error) in
            if let data = data {
                do {
                    let json = try JSONDecoder().decode([ShowsModel].self, from: data)
                    self.delegate?.successFetchShows(shows: json)
                } catch {
                    print("Error - Show API")
                    self.delegate?.error(error: error)
                }
            }
        }
        request.resume()
    }
    
    public func fetchEpisodes(idShow: String) {
        
        guard let url = URL(string: BaseURLServices.fetchEpisodes.replacingOccurrences(of: "PARAM", with: idShow)) else { return }
        
        let request = URLSession.shared.dataTask(with: url){(data, response, error) in
            if let data = data {
                do {
                    let json = try JSONDecoder().decode([Episodes].self, from: data)
                    self.delegate?.successFetchEpisodes(eps: json)
                } catch {
                    print("Error - Episodes API")
                    self.delegate?.error(error: error)
                }
            }
        }
        request.resume()
    }
}
