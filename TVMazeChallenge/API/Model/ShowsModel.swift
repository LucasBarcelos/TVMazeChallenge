//
//  ShowsModel.swift
//  TVMazeChallenge
//
//  Created by Lucas Barcelos on 16/06/23.
//

import Foundation

struct ShowsModel: Codable {
    let id: Int
    let name: String
    let image: Poster?
    let premiered: String?
    let ended: String?
    let schedule: Schedule?
    let genres: [String]?
    let summary: String?
}

struct Poster: Codable {
    let medium: String?
    let original: String?
}

struct Schedule: Codable {
    let time: String?
    let days: [String]?
}

struct Episodes: Codable {
    let name: String?
    let number: Int?
    let season: Int?
    let summary: String?
    let image: Poster?
}
