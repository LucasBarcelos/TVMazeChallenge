//
//  EpisodeDetailsVC.swift
//  TVMazeChallenge
//
//  Created by Lucas Barcelos on 17/06/23.
//

import UIKit

class EpisodeDetailsVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var backgroundPoster: DownloadImageView!
    @IBOutlet weak var episodePoster: DownloadImageView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var summaryTextView: UITextView!
    
    // MARK: - Properties
    var selectedEpisode: Episodes?
    var backgroundShowPoster: String = ""
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupDetailsView()
        setupSummaryHTML()
    }
    
    // MARK: - Methods
    func setupDetailsView() {
        
        self.episodePoster.layer.cornerRadius = 12
        
        guard let name = selectedEpisode?.name,
              let poster = selectedEpisode?.image?.original,
              let number = selectedEpisode?.number,
              let season = selectedEpisode?.season else { return }
        
        self.episodePoster.setUrl(poster)
        self.backgroundPoster.setUrl(backgroundShowPoster)
        self.navigationItem.title = name
        self.numberLabel.text = "\(number)"
        self.seasonLabel.text = "\(season)"
    }
    
    func setupSummaryHTML() {
        guard let summary = selectedEpisode?.summary else { return }
        
        let data = Data(summary.utf8)
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            self.summaryTextView.attributedText = attributedString
            self.summaryTextView.font = UIFont.systemFont(ofSize: 16)
            self.summaryTextView.textColor = UIColor.label
        }
    }
}
