//
//  ShowsModel.swift
//  TVMazeChallenge
//
//  Created by Lucas Barcelos on 16/06/23.
//

import Foundation

struct ShowsModel: Codable {
    let name: String?
    let image: Poster?
    let premiered: String?
    let ended: String?
    let schedule: Schedule?
    let genres: [String]?
    let summary: String?
    //let episodes: [Episodes]?
}

struct Poster: Codable {
    let medium: String?
}

struct Schedule: Codable {
    let time: String?
    let days: [String]?
}

struct Episodes: Codable {
    let name: String?
    let number: String?
    let season: String?
    let summary: String?
    let image: Poster?
}
