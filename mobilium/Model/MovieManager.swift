//
//  Movie.swift
//  mobilium
//
//  Created by Fatih Sağlam on 10.03.2021.
//

import UIKit
import Alamofire
import Kingfisher

struct MovieManager {
    
    static let apiKey = "57b1a612ee027e0ecf15aadabf38d177"
    
    let nowPlayingUrl = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)&language=en-US"
    
    let upcomingUrl = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)&language=en-US"
    
    let searchUrl = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=en-US&include_adult=false"
    
    func searchMovie(movieName: String) {
        let urlString = "\(searchUrl)&query=\(movieName)"
        AF.request(urlString).response { responseData in
            if let safeData = responseData.data {
                print(String(data: safeData, encoding: .utf8))
                parseJSON(movieData: safeData)
            } else {
                print(responseData.error?.errorDescription)
            }
        }
    }
    
    func fetchUpcoming() {
        
    }
    
    func fetchNowPlaying() {
        
    }
    
    func parseJSON(movieData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(MovieData.self, from: movieData)
            print(decodedData.results.map{ $0.title })
        } catch {
            print(error)
        }
    }
    
}
