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
    var searchResults: [MovieModel] = []
    var upcomingMovies: [MovieModel] = []
    var nowPlayingMovies: [MovieModel] = []
    var detailViewMovie: MovieModel?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var inTheatersView: UICollectionView!
    @IBOutlet weak var upcomingList: UITableView!
    @IBOutlet weak var sliderControl: UIPageControl!
    @IBOutlet weak var searchResultsList: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        upcomingList.delegate = self
        upcomingList.dataSource = self
        inTheatersView.dataSource = self
        inTheatersView.delegate = self
        searchResultsList.delegate = self
        searchResultsList.dataSource = self
        inTheatersView.isPagingEnabled = true
        searchResultsList.isHidden = true
        
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = .horizontal
        inTheatersView.collectionViewLayout = flowLayout
        
        upcomingList.register(UINib(nibName: "UpcomingCell", bundle: nil), forCellReuseIdentifier: "upcomingCell")
        inTheatersView.register(UINib(nibName: "NowPlayingCell", bundle: nil), forCellWithReuseIdentifier: "nowPlayingCell")
        loadMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func refleshSliderControl() {
        self.sliderControl.numberOfPages = self.nowPlayingMovies.count
    }
    
    private func loadMovies() {
        movieManager.fetchUsing(urlType: MovieManager.nowPlayingUrl) { [weak self] results in
            guard let self = self else { return }
            self.nowPlayingMovies = results
            DispatchQueue.main.async {
                self.inTheatersView.reloadData()
                self.refleshSliderControl()
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

//MARK: - UISearchBarDelegate
extension MainPageVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let queryText = searchBar.text ?? ""
        if queryText.count > 1 {
            movieManager.searchMovie(movieName: queryText) { results in
                self.searchResults = results
                self.searchResultsList.isHidden = false
                self.searchResultsList.reloadData()
            }
            //TODO: - enable the tableview and fill the rows with results
        } else if queryText.count == 0 {
            self.searchResultsList.isHidden = true
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

//MARK: - UITableViewDataSource, UITableViewDelegate
extension MainPageVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == upcomingList {
            return upcomingMovies.count
        } else if tableView == searchResultsList {
            return searchResults.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == upcomingList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "upcomingCell", for: indexPath) as! UpcomingCell
            let movie = upcomingMovies[indexPath.row]
            cell.movieTitle.text = movie.movieTitle
            cell.movieCover.kf.setImage(with: URL(string: movie.posterLink))
            cell.movieDescription.text = movie.movieOverview
            return cell
        } else if tableView == searchResultsList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultsCell", for: indexPath)
            let movie = searchResults[indexPath.row]
            cell.textLabel?.text = movie.movieTitle
            return cell
        }
        return UITableViewCell()
    }
    
//MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == upcomingList {
            detailViewMovie = upcomingMovies[indexPath.row]
            self.performSegue(withIdentifier: "showDetailView", sender: self)
        } else if tableView == searchResultsList {
            detailViewMovie = searchResults[indexPath.row]
            self.performSegue(withIdentifier: "showDetailView", sender: self)
        }
        
//        let movie = upcomingMovies[indexPath.row]
//        let vc = UIStoryboard.init(name: "Main", bundle: .main).instantiateViewController(identifier: "DetailVC") { (coder) -> UIViewController? in
//            let detailVC = DetailVC.init(movie: movie, coder: coder)
//            return detailVC
//        }
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailView" {
            let destinationVC = segue.destination as! DetailVC
            let _ = destinationVC.view
            destinationVC.movie = detailViewMovie
        }
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MainPageVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    //UITableViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nowPlayingMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return inTheatersView.frame.size
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.sliderControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        detailViewMovie = nowPlayingMovies[indexPath.row]
        self.performSegue(withIdentifier: "showDetailView", sender: self)
    }
    
    //TODO: - Make Bulletpoints inactive for touching
    
//MARK: - UICollectionViewDataSource Methods
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nowPlayingCell", for: indexPath) as! NowPlayingCell
        let movie = nowPlayingMovies[indexPath.row]
        cell.cover.kf.setImage(with: URL(string: movie.posterLink))
        cell.title.text = movie.movieTitle
        return cell
    }
}
