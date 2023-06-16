//
//  DownloadImageView.swift
//  TVMazeChallenge
//
//  Created by Lucas Barcelos on 16/06/23.
//

import Foundation
import UIKit

class DownloadImageView: UIImageView {
    
    //MARK: - Variables
    var progress: UIActivityIndicatorView!
    
    //MARK: - Constants
    let downloadQueue = OperationQueue()
    
    let mainQueue = OperationQueue.main
    
    //MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createProgress()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createProgress()
    }
    
    //MARK: - Functions
    func createProgress() {
        progress = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        addSubview(progress)
    }
    
    override func layoutSubviews()  {
        progress.center = convert(self.center , from:self.superview)
    }
    
    func setUrl(_ url: String) {
        setUrl(url, cache: true)
    }
    
    func setUrl(_ url: String, cache: Bool) {
        self.image = nil
        downloadQueue.cancelAllOperations()
        progress.startAnimating()
        downloadQueue.addOperation( { self.downloadImg(url, cache: true) } )
    }
    
    private func downloadImg(_ url: String, cache: Bool) {
        var data: Data!
        if(!cache) {
            data = try? Data(contentsOf: URL(string: url)!)
        } else {
            var path = url.replacingOccurrences(of: "/", with: "_")
            path = path.replacingOccurrences(of: "\\", with: "_")
            path = path.replacingOccurrences(of: ":", with: "_")
            path = NSHomeDirectory() + "/Documents/" + path
            let exists = FileManager.default.fileExists(atPath: path)
            if(exists) {
                data = try? Data(contentsOf: URL(fileURLWithPath: path))
            } else {
                print(url)
                data = try? Data(contentsOf: URL(string: url)!)
                if(data != nil) {
                    try! data.write(to: URL(fileURLWithPath: path), options:.atomic)
                }
            }
        }
        if(data != nil) {
            mainQueue.addOperation( {self.showImg(data)} )
        }
    }
    
    func showImg(_ data: Data) {
        if(data.count > 0) {
            self.image = UIImage(data: data)
        }
        progress.stopAnimating()
    }
}


