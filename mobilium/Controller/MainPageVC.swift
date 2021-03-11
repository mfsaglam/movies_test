//
//  ViewController.swift
//  mobilium
//
//  Created by Fatih Sağlam on 10.03.2021.
//

import UIKit

class MainPageVC: UIViewController {
    
    let movieManager = MovieManager()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var inTheatersView: UICollectionView!
    
    @IBOutlet weak var upcomingList: UITableView!
    
    @IBOutlet weak var sliderControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        searchBar.delegate = self
    }
}
//Mark: - SearchBarDelegate
extension MainPageVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let queryText = searchBar.text ?? ""
        if queryText.count > 1 {
            movieManager.searchMovie(movieName: queryText)
            // enable the tableview and fill the rows with results
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
    }
}

//Mark: - CollectionViewDelegate

