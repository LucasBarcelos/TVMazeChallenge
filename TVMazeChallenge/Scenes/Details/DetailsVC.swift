//
//  DetailsVC.swift
//  TVMazeChallenge
//
//  Created by Lucas Barcelos on 17/06/23.
//

import UIKit

class DetailsVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var poster: DownloadImageView!
    @IBOutlet weak var backgroundPoster: DownloadImageView!
    @IBOutlet weak var daysTimeLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var selectedShow: ShowsModel?
    var showEpisodes: [Episodes]?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDetailsView()
        setupSummaryHTML()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    // MARK: - Methods
    func setupDetailsView() {
        
        self.poster.layer.cornerRadius = 12
        
        guard let name = selectedShow?.name,
              let poster = selectedShow?.image?.medium,
              let background = selectedShow?.image?.original,
              let time = selectedShow?.schedule?.time,
              let days = selectedShow?.schedule?.days,
              let genre = selectedShow?.genres else { return }
        
        self.poster.setUrl(poster)
        self.backgroundPoster.setUrl(background)
        self.navigationItem.title = name
        self.daysTimeLabel.text = "\(time) - \(days.joined(separator: ", "))"
        self.genresLabel.text = "\(genre.joined(separator: ", "))"
    }
    
    func setupSummaryHTML() {
        guard let summary = selectedShow?.summary else { return }
        
        let data = Data(summary.utf8)
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            self.summaryTextView.attributedText = attributedString
            self.summaryTextView.font = UIFont.systemFont(ofSize: 16)
            self.summaryTextView.textColor = UIColor.label
        }
    }
}

extension DetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return showEpisodes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsEpisodeListCell", for: indexPath) as? DetailsEpisodeListCell
        cell?.setupCell(data: self.showEpisodes?[indexPath.section])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: 16))
        view.backgroundColor = .clear
        return view
    }
}
