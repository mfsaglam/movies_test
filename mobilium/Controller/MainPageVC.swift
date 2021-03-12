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
        searchBar.delegate = self
        upcomingList.dataSource = self
        inTheatersView.dataSource = self
        inTheatersView.delegate = self
        (inTheatersView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset = .zero
        (inTheatersView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing = .zero
        (inTheatersView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = inTheatersView.frame.size
        (inTheatersView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing = .zero

        inTheatersView.automaticallyAdjustsScrollIndicatorInsets = false
        upcomingList.register(UINib(nibName: "UpcomingCell", bundle: nil), forCellReuseIdentifier: "upcomingCell")
        inTheatersView.register(UINib(nibName: "NowPlayingCell", bundle: nil), forCellWithReuseIdentifier: "nowPlayingCell")
        loadMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        inTheatersView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func loadMovies() {
        movieManager.fetchUsing(urlType: MovieManager.nowPlayingUrl) { [weak self] results in
            guard let self = self else { return }
            self.nowPlayingMovies = results
            DispatchQueue.main.async {
                self.inTheatersView.reloadData()
            }
        }
        movieManager.fetchUsing(urlType: MovieManager.upcomingUrl) { [weak self] results in
            guard let self = self else { return }
            self.upcomingMovies = results
            DispatchQueue.main.async {
                self.upcomingList.reloadData()
            }
        }
    }
}

//Mark: - UISearchBarDelegate
extension MainPageVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let queryText = searchBar.text ?? ""
        if queryText.count > 1 {
            movieManager.searchMovie(movieName: queryText) { results in
                print(results)
            }
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
        return upcomingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "upcomingCell", for: indexPath) as! UpcomingCell
        let movie = upcomingMovies[indexPath.row]
        cell.movieTitle.text = movie.movieTitle
        cell.movieCover.kf.setImage(with: URL(string: movie.posterLink))
        cell.movieDescription.text = movie.movieOverview
        return cell
    }
    
    //Mark: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //create segue to DetailVC
    }
}

//Mark: - UICollectionViewDelegate
extension MainPageVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nowPlayingMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(collectionView.frame.size)
        return CGSize(width: 414, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nowPlayingCell", for: indexPath) as! NowPlayingCell
        let movie = nowPlayingMovies[indexPath.row]
        cell.cover.kf.setImage(with: URL(string: movie.posterLink))
        cell.title.text = movie.movieTitle
        return cell
    }
}

