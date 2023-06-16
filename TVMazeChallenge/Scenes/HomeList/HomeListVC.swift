//
//  HomeListVC.swift
//  TVMazeChallenge
//
//  Created by Lucas Barcelos on 16/06/23.
//

import UIKit

class HomeListVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    var shows: [ShowsModel] = []
    private let homeListViewModel: HomeListViewModel = HomeListViewModel(serviceAPI: ShowServiceAPI())
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeListViewModel.delegate(delegate: self)
        self.homeListViewModel.serviceAPI?.fetchShow()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
}

extension HomeListVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "showCell", for: indexPath) as! HomeListCell
        cell.setupCell(data: shows[indexPath.row])
        return cell
    }
    
}

extension HomeListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.view.frame.size.width - 40) / 2
        let height = width * 1.4
        return CGSize(width: width, height: height)
    }
}

extension HomeListVC: HomeListViewModelProtocol {
    func successGoToResult(result: [ShowsModel]?) {
        DispatchQueue.main.async {
            guard let shows = result else { return }
            self.shows = shows
            self.collectionView.reloadData()
        }
    }
    
    func erroFetch(message: String) {
        DispatchQueue.main.async {
            print("error")
        }
    }
}
