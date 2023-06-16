//
//  NetworkManager.swift
//  TVMazeChallenge
//
//  Created by Lucas Barcelos on 16/06/23.
//

import Foundation

protocol ShowServiceAPIProtocol {
    func success(shows: [ShowsModel])
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
                    self.delegate?.success(shows: json)
                } catch {
                    print("Error - Show API")
                    self.delegate?.error(error: error)
                }
            }
        }
        request.resume()
    }
}
