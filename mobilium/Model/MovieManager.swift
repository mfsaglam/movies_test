//
//  Movie.swift
//  mobillium
//
//  Created by Fatih Sağlam on 10.03.2021.
//

import UIKit
import Alamofire

class MovieManager {

    static let apiKey = "57b1a612ee027e0ecf15aadabf38d177"
    let imageBaseUrl = "https://image.tmdb.org/t/p/w300/"
    static let nowPlayingUrl = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)&language=en-US"
    static let upcomingUrl = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)&language=en-US"
    let searchUrl = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=en-US&include_adult=false"
        
    func searchMovie(movieName: String, completion: @escaping ([MovieModel], Error?) -> Void) {
        let urlString = "\(searchUrl)&query=\(movieName)".replacingOccurrences(of: " ", with: "%20")
        AF.request(urlString).response { responseData in
            if let safeData = responseData.data {
                self.parseJSON(movieData: safeData, completion: completion)
            } else {
                print(responseData.error?.errorDescription ?? "error nil")
            }
        }
    }
    
    func fetchUsing(urlType: String, completion: @escaping ([MovieModel], Error?) -> Void) {
        AF.request(urlType).response { responseData in
            if let safeData = responseData.data {
                self.parseJSON(movieData: safeData, completion: completion)
            } else {
                print(responseData.error?.errorDescription ?? "error nil")
            }
        }
    }
    
    func getImdbId(movieId: String, completion: @escaping (String, Error?) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/external_ids?api_key=\(MovieManager.apiKey)"
        AF.request(urlString).response { responseData in
            if let safeData = responseData.data {
                self.parseSingleObjectJSON(movieData: safeData) { (result, error) in
                    if error != nil {
                        completion("", error)
                    } else {
                        completion(result?.imdb_id ?? "", nil)
                    }
                }
            } else {
                completion("", responseData.error)
            }
        }
        //TODO: - Return IMDB id here
    }
    
    func getSimilarMovies(movieId: String, completion: @escaping ([MovieModel], Error?) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/similar?api_key=\(MovieManager.apiKey)&language=en-US"
        AF.request(urlString).response { responseData in
            if let safeData = responseData.data {
                self.parseJSON(movieData: safeData, completion: completion)
            } else {
                completion([], responseData.error)
            }
        }
    }
    
    func parseJSON(movieData: Data, completion: @escaping ([MovieModel], Error?) -> Void ) {
        let decoder = JSONDecoder()
        do {
            var resultsArray: [MovieModel] = []
            let decodedData = try decoder.decode(MovieData.self, from: movieData)
            for data in decodedData.results {
                if data.poster_path != nil {
                    let movie: MovieModel = MovieModel(posterLink: imageBaseUrl + data.poster_path!, movieTitle: data.title!, movieOverview: data.overview!, imdbVote: "\(data.vote_average!)", id: "\(data.id!)")
                    resultsArray.append(movie)
                }
            }
            completion(resultsArray, nil)
        } catch {
            completion([], error)
        }
    }
    
    func parseSingleObjectJSON(movieData: Data, completion: @escaping (MovieModelJson?, Error?) -> Void ) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(MovieModelJson.self, from: movieData)
            completion(decodedData, nil)
        } catch {
            completion(nil, error)
        }
    }
}
