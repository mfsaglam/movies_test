//
//  Movie.swift
//  mobilium
//
//  Created by Fatih Sağlam on 11.03.2021.
//

import Foundation

struct MovieData: Codable {
    var results: [Movie]
}

struct Movie: Codable {
    var poster_path: String?
    var overview: String?
    var title: String?
    var vote_average: Double?
    var id: Int?
}
