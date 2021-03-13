//
//  DetailVCViewController.swift
//  mobilium
//
//  Created by Fatih Sağlam on 10.03.2021.
//

import UIKit
import Kingfisher

class DetailVC: UIViewController {
    
    var movieManager = MovieManager()
    var similarMovies: [MovieModel] = []
    
    
    var movie: MovieModel? {
        didSet {
            movieTitle?.text = movie?.movieTitle
            movieDetail?.text = movie?.movieOverview
            detailImage?.kf.setImage(with: URL(string: movie?.posterLink ?? ""))
            imdbRate.text = movie?.imdbVote
            //set imdb image with link
        }
    }
    
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDetail: UILabel!
    @IBOutlet weak var similarMoviesHeader: UILabel!
    @IBOutlet weak var similarMoviesSlider: UICollectionView!
    @IBOutlet weak var imdbRate: UILabel!
    @IBOutlet weak var imdbLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
}
