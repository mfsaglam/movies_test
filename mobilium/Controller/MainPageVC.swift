//
//  ViewController.swift
//  mobilium
//
//  Created by Fatih Sağlam on 10.03.2021.
//

import UIKit
import Kingfisher

class MainPageVC: UIViewController {
    
    let movieManager = MovieManager()
    var searchedMovies: [MovieModel] = []
    var upcomingMovies: [MovieModel] = []
    var nowPlayingMovies: [MovieModel] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var inTheatersView: UICollectionView!
    @IBOutlet weak var upcomingList: UITableView!
    @IBOutlet weak var sliderControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        upcomingList.dataSource = self
        upcomingList.register(UINib(nibName: "UpcomingCell", bundle: nil), forCellReuseIdentifier: "upcomingCell")
        loadMovies()
        //inTheatersView.delegate = self
        //inTheatersView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        searchBar.delegate = self
    }
    
    func loadMovies() {
        upcomingMovies = []
        nowPlayingMovies = []
        movieManager.fetchUsing(urlType: MovieManager.nowPlayingUrl, targetArray: nowPlayingMovies)
        movieManager.fetchUsing(urlType: MovieManager.upcomingUrl, targetArray: upcomingMovies)
        DispatchQueue.main.async {
            self.upcomingList.reloadData()
        }
    }
}

//Mark: - UISearchBarDelegate
extension MainPageVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let queryText = searchBar.text ?? ""
        if queryText.count > 1 {
            movieManager.searchMovie(movieName: queryText, targetArray: searchedMovies)
            // enable the tableview and fill the rows with results
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.endEditing(true)
    }
}

//Mark: - UITableViewDataSource
extension MainPageVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //movieManager.movies.count
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "upcomingCell", for: indexPath) as! UpcomingCell
        //cell.movieTitle.text = upcomingMovies[0].movieTitle
        //cell.movieCover.kf.setImage(with: URL(string: upcomingMovies[0].posterLink))
        //cell.movieDescription.text = upcomingMovies[0].movieOverview
        cell.movieTitle.text = "Lol Movie(2007)"
        cell.movieCover.kf.setImage(with: URL(string: "https://www.themoviedb.org/t/p/w185/lykPQ7lgrLJPwLlSyetVXsl2wDf.jpg"))
        cell.movieDescription.text = "upcomingMovies[0].movieOverview"
        return cell
    }
    
    //Mark: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //create segue to DetailVC
    }
}

//Mark: - UICollectionViewDelegate
//extension MainPageVC: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//    }
//}

