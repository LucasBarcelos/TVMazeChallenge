//
//  HomeListViewModel.swift
//  TVMazeChallenge
//
//  Created by Lucas Barcelos on 16/06/23.
//

import Foundation
import UIKit

protocol HomeListViewModelProtocol: AnyObject {
    func successGoToResult(result: [ShowsModel]?)
    func successEpisodes(result: [Episodes]?)
    func erroFetch(message: String)
}

class HomeListViewModel: ShowServiceAPIProtocol {

    weak var delegate:HomeListViewModelProtocol?
    let serviceAPI:ShowServiceAPI?
    
    init(serviceAPI: ShowServiceAPI) {
        self.serviceAPI = serviceAPI
        self.serviceAPI?.delegate = self
    }
    
    func delegate(delegate:HomeListViewModelProtocol?){
        self.delegate = delegate
    }
    
    func successFetchShows(shows: [ShowsModel]) {
        self.delegate?.successGoToResult(result: shows)
    }
    
    func successFetchEpisodes(eps: [Episodes]) {
        self.delegate?.successEpisodes(result: eps)
    }
    
    func error(error: Error) {
        print("Error - API")
        self.delegate?.erroFetch(message: String(error.localizedDescription))
    }
}

