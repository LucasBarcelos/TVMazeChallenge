//
//  HomeListCell.swift
//  TVMazeChallenge
//
//  Created by Lucas Barcelos on 16/06/23.
//

import UIKit

class HomeListCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet weak var showTitleLabel: UILabel!
    @IBOutlet weak var posterImageView: DownloadImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
      
        layer.cornerRadius = 12
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    public func setupCell(data: ShowsModel?) {
        guard let name = data?.name,
              let image = data?.image?.medium else { return }
        self.showTitleLabel.text = name
        self.posterImageView.setUrl(image)
    }
}
