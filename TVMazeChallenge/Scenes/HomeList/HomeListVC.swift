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
    private var shows: [ShowsModel] = []
    private var filteredShows: [ShowsModel] = []
    private var sortedShows : [ShowsModel] = []
    let loadingView = LoadingView()
    
    private let homeListViewModel: HomeListViewModel = HomeListViewModel(serviceAPI: ShowServiceAPI())
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeListViewModel.delegate(delegate: self)
        self.homeListViewModel.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        configureSearch()
        setupSortShows()
    }
    
    // MARK: - Methods
    private func configureSearch() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.barTintColor = .white
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func setupSortShows() {
        let showAtoZ = UIAction(title: "A - Z") { [weak self] _ in
            self?.shows.sort { $0.name < $1.name }
            self?.collectionView.reloadData()
        }
        
        let showZtoA = UIAction(title: "Z - A") { [weak self] _ in
            self?.shows.sort { $0.name > $1.name }
            self?.collectionView.reloadData()
        }
        
        let showDefault = UIAction(title: "Default") { [weak self] _ in
            self?.shows.sort { $0.id < $1.id }
            self?.collectionView.reloadData()
        }
        
        let menuItem = UIMenu(children: [showAtoZ, showZtoA, showDefault])
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sort", menu: menuItem)
    }
    
    // Mark: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "DetailsVC") {
            let vc = segue.destination as! DetailsVC
            guard let indexPaths = collectionView.indexPathsForSelectedItems else { return }
            
            indexPaths.forEach { indexPath in
                let show = isFiltering ? filteredShows[indexPath.item] : shows[indexPath.item]
                vc.selectedShow = show
            }
            
            guard let result = sender as? [Episodes] else { return }
            vc.showEpisodes = result
        }
    }
}

// MARK: - Extension - Collection View Delegate / DataSource
extension HomeListVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        isFiltering ? filteredShows.count : shows.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "showCell", for: indexPath) as! HomeListCell
        
        let show = isFiltering ? filteredShows[indexPath.item] : shows[indexPath.item]
        
        cell.setupCell(data: show)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let show = isFiltering ? filteredShows[indexPath.item] : shows[indexPath.item]
        
        self.homeListViewModel.delegate?.startLoading()
        self.homeListViewModel.serviceAPI?.fetchEpisodes(idShow: "\(show.id)")
        
        print("Show selected: \(show.name)")
    }
}

// MARK: - Extension - Collection View Layout
extension HomeListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.view.frame.size.width - 60) / 2
        let height = width * 1.4
        return CGSize(width: width, height: height)
    }
}

// MARK: - Extension - View Model Protocol
extension HomeListVC: HomeListViewModelProtocol {
    
    func startLoading() {
        DispatchQueue.main.async {
            self.view.addSubview(self.loadingView)
            self.view.isUserInteractionEnabled = false
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.loadingView.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }

    func successGoToResult(result: [ShowsModel]?) {
        DispatchQueue.main.async {
            guard let shows = result else { return }
            self.shows = shows
            self.collectionView.reloadData()
        }
    }
    
    func successEpisodes(result: [Episodes]?) {
        DispatchQueue.global().async {
            guard let result = result else { return }
                
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "DetailsVC", sender: result)
            }
        }
    }
    
    func erroFetch(message: String) {
        print("error")
    }
}

// MARK: - Extension - Search Results Updating
extension HomeListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredShows = shows.filter { character in
            character.name.lowercased().contains(searchText.lowercased())
        }
        collectionView.reloadData()
    }
}
