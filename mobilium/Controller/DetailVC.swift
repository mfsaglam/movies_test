//
//  DetailVCViewController.swift
//  mobilium
//
//  Created by Fatih Sağlam on 10.03.2021.
//

import UIKit
import Kingfisher
import SafariServices

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
        }
    }
    
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDetail: UILabel!
    @IBOutlet weak var similarMoviesHeader: UILabel!
    @IBOutlet weak var similarMoviesSlider: UICollectionView!
    @IBOutlet weak var imdbRate: UILabel!
    @IBOutlet weak var imdbButton: UIButton!
    
    
//    init?(movie: MovieModel, coder: NSCoder) {
//        super.init(coder: coder)
//        self.movie = movie
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
    
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
    
    @IBAction func imdbButtonTapped(_ sender: Any) {
        movieManager.getImdbId(movieId: movie?.id ?? "") { (imdbId) in
            guard let url = URL(string: "https://www.imdb.com/title/\(imdbId)/") else { return }
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
            safariVC.delegate = self
        }
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
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 126, height: 200)
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
}

//MARK: - SFSafariViewControllerDelegate
extension DetailVC: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
