//
//  ViewController.swift
//  mobillium
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
        searchBar.showsCancelButton = true
        self.sliderControl.isUserInteractionEnabled = false
        
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = .horizontal
        inTheatersView.collectionViewLayout = flowLayout
        
        upcomingList.register(UINib(nibName: K.upcomingCellNib, bundle: nil), forCellReuseIdentifier: K.upcomingCellId)
        inTheatersView.register(UINib(nibName: K.nowPlayingCellNib, bundle: nil), forCellWithReuseIdentifier: K.nowPlayingCellId)
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
        movieManager.fetchUsing(urlType: MovieManager.nowPlayingUrl) { [weak self] (results, error) in
            guard error == nil else {
                //show alert here
                return
            }
            self?.nowPlayingMovies = results
            DispatchQueue.main.async {
                self?.inTheatersView.reloadData()
                self?.refleshSliderControl()
            }
        }
        
        movieManager.fetchUsing(urlType: MovieManager.upcomingUrl) { [weak self] (results, error) in
            guard error == nil else {
                //show alert here
                return
            }
            self?.upcomingMovies = results
            DispatchQueue.main.async {
                self?.upcomingList.reloadData()
            }
        }
    }
}

//MARK: - UISearchBarDelegate
extension MainPageVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let queryText = searchBar.text ?? ""
        if queryText.count > 1 {
            movieManager.searchMovie(movieName: queryText) { [ weak self ] (results, error) in
                guard error == nil else {
                    //show alert here
                    return
                }
                self?.searchResults = results
                self?.searchResultsList.isHidden = false
                self?.sliderControl.isHidden = true
                self?.searchResultsList.reloadData()
            }
        } else if queryText.count == 0 {
            self.searchResultsList.isHidden = true
            self.sliderControl.isHidden = false
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.view.endEditing(true)
        self.searchResultsList.isHidden = true
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
            let cell = tableView.dequeueReusableCell(withIdentifier: K.upcomingCellId, for: indexPath) as! UpcomingCell
            let movie = upcomingMovies[indexPath.row]
            cell.movieTitle.text = movie.movieTitle
            cell.movieCover.kf.setImage(with: URL(string: movie.posterLink))
            cell.movieDescription.text = movie.movieOverview
            return cell
        } else if tableView == searchResultsList {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.searchResultsCellId, for: indexPath)
            let movie = searchResults[indexPath.row]
            cell.textLabel?.text = movie.movieTitle
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return K.upcomingHeader
    }
    
//MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == upcomingList {
            detailViewMovie = upcomingMovies[indexPath.row]
            self.performSegue(withIdentifier: K.detailViewSegue, sender: self)
        } else if tableView == searchResultsList {
            detailViewMovie = searchResults[indexPath.row]
            self.performSegue(withIdentifier: K.detailViewSegue, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.detailViewSegue {
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
        self.performSegue(withIdentifier: K.detailViewSegue, sender: self)
    }

//MARK: - UICollectionViewDataSource Methods
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.nowPlayingCellId, for: indexPath) as! NowPlayingCell
        let movie = nowPlayingMovies[indexPath.row]
        cell.cover.kf.setImage(with: URL(string: movie.posterLink))
        cell.title.text = movie.movieTitle
        return cell
    }
}
