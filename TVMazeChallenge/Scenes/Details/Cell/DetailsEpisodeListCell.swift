//
//  DetailsEpisodeListCell.swift
//  TVMazeChallenge
//
//  Created by Lucas Barcelos on 17/06/23.
//

import UIKit

class DetailsEpisodeListCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var episodeTitleLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    // MARK: - Properties
    static let identifier: String = "DetailsEpisodeListCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        mainView.clipsToBounds = true
        mainView.layer.cornerRadius = 10
        mainView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        mainView.layer.shadowRadius = 2
        mainView.layer.shadowOffset = CGSize(width: 2, height: 3)
        mainView.layer.shadowOpacity = 0.30
        mainView.layer.masksToBounds = false
    }
    
    public func setupCell(data: Episodes?) {
        guard let name = data?.name,
              let season = data?.season,
              let episodeNumber = data?.number else { return }
        self.episodeTitleLabel.text = "S\(season)xE\(episodeNumber) - \(name)"
    }

}
