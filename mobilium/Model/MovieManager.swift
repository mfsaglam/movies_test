//
//  Movie.swift
//  mobilium
//
//  Created by Fatih Sağlam on 10.03.2021.
//

import UIKit
import Alamofire

class MovieManager {
    
    var movies: [MovieModel] = []
    
    static let apiKey = "57b1a612ee027e0ecf15aadabf38d177"
    let imageBaseUrl = "https://image.tmdb.org/t/p/w185/"
    
    static let nowPlayingUrl = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)&language=en-US"
    
    static let upcomingUrl = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)&language=en-US"
    
    let searchUrl = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=en-US&include_adult=false"
    
    func searchMovie(movieName: String) {
        let urlString = "\(searchUrl)&query=\(movieName)".replacingOccurrences(of: " ", with: "%20")
        AF.request(urlString).response { responseData in
            if let safeData = responseData.data {
                //print(String(data: safeData, encoding: .utf8) ?? "nil")
                self.parseJSON(movieData: safeData)
            } else {
                print(responseData.error?.errorDescription ?? "error nil")
            }
        }
    }
    
    func fetchUsing(urlType: String) {
        AF.request(urlType).response { responseData in
            if let safeData = responseData.data {
                self.parseJSON(movieData: safeData)
            } else {
                print(responseData.error?.errorDescription ?? "error nil")
            }
        }
    }
    
    func parseJSON(movieData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(MovieData.self, from: movieData)
            for data in decodedData.results {
                if data.poster_path != nil {
                    let movie: MovieModel = MovieModel(posterLink: imageBaseUrl + data.poster_path!, movieTitle: data.title!, movieOverview: data.overview!, imdbVote: "\(data.vote_average!)")
                    movies.append(movie)
                }
            }
            print("movies loaded")
        } catch {
            print(error)
        }
    }
}
