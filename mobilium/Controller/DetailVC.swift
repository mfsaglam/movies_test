//
//  DetailVCViewController.swift
//  mobilium
//
//  Created by Fatih Sağlam on 10.03.2021.
//

import UIKit
import Kingfisher

class DetailVC: UIViewController {
    
    let movieManager = MovieManager()
    var similarMovies: [MovieModel] = []
    
    var movie: MovieModel? {
        didSet {
            movieTitle?.text = movie?.movieTitle
            movieDetail?.text = movie?.movieOverview
            detailImage?.kf.setImage(with: URL(string: movie?.posterLink ?? ""))
            imdbRate?.text = movie?.imdbVote
            loadSimilarMovies()
            //TODO: - set imdb image with link
        }
    }
    
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDetail: UILabel!
    @IBOutlet weak var similarMoviesHeader: UILabel!
    @IBOutlet weak var similarMoviesSlider: UICollectionView!
    @IBOutlet weak var imdbRate: UILabel!
    @IBOutlet weak var imdbLogo: UIImageView!
    
//    init?(movie: MovieModel, coder: NSCoder) {
//        super.init(coder: coder)
//        self.movie = movie
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
    
    //TODO: - create a transparent button on the imdb logo and when the user clicks it, call the getMovieİd function(it will give me a string in completion) to trigger safariView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        similarMoviesSlider.delegate = self
        similarMoviesSlider.dataSource = self
        similarMoviesSlider.isPagingEnabled = true
        
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = .horizontal
        similarMoviesSlider.collectionViewLayout = flowLayout
        
        similarMoviesSlider.register(UINib(nibName: "SimilarMoviesCell", bundle: nil), forCellWithReuseIdentifier: "similarMoviesCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func loadSimilarMovies() {
        if movie != nil {
            movieManager.getSimilarMovies(movieId: movie!.id) { [weak self] results in
                guard let self = self else { return }
                self.similarMovies = results
                self.similarMoviesSlider.reloadData()
            }
        }
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension DetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = similarMovies[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "similarMoviesCell", for: indexPath) as! SimilarMoviesCell
        cell.image.kf.setImage(with: URL(string: movie.posterLink))
        cell.title.text = movie.movieTitle
        return cell
        //TODO - : set Cells sizes 126 200 (sizeforItemAt)
        //TODO - : İnseteri zero döndür...
    }
}
