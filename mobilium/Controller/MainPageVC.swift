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
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var inTheatersView: UICollectionView!
    @IBOutlet weak var upcomingList: UITableView!
    @IBOutlet weak var sliderControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieManager.fetchUsing(urlType: MovieManager.nowPlayingUrl)
        movieManager.fetchUsing(urlType: MovieManager.upcomingUrl)
        upcomingList.dataSource = self
        //inTheatersView.delegate = self
        //inTheatersView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        searchBar.delegate = self
    }
}

//Mark: - UISearchBarDelegate
extension MainPageVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let queryText = searchBar.text ?? ""
        if queryText.count > 1 {
            movieManager.searchMovie(movieName: queryText)
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

//Mark: - UITableViewDelegate
extension MainPageVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movieManager.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "upcomingCell", for: indexPath)
        cell.textLabel?.text = "Movie"
        return cell
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

