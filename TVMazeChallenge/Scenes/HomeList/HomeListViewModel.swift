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
    
    func startLoading()
    func stopLoading()
}

class HomeListViewModel: ShowServiceAPIProtocol {

    weak var delegate:HomeListViewModelProtocol?
    let serviceAPI:ShowServiceAPI?
    
    init(serviceAPI: ShowServiceAPI) {
        self.serviceAPI = serviceAPI
        self.serviceAPI?.delegate = self
    }
    
    // MARK: - View Life Cycle
    func viewDidLoad() {
        self.delegate?.startLoading()
        self.serviceAPI?.fetchShow()
    }
    
    func delegate(delegate:HomeListViewModelProtocol?){
        self.delegate = delegate
    }
    
    func successFetchShows(shows: [ShowsModel]) {
        self.delegate?.stopLoading()
        self.delegate?.successGoToResult(result: shows)
    }
    
    func successFetchEpisodes(eps: [Episodes]) {
        self.delegate?.stopLoading()
        self.delegate?.successEpisodes(result: eps)
    }
    
    func error(error: Error) {
        print("Error - API")
        self.delegate?.stopLoading()
        self.delegate?.erroFetch(message: String(error.localizedDescription))
    }
}

