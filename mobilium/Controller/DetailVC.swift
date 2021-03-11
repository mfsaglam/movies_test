//
//  DetailVCViewController.swift
//  mobilium
//
//  Created by Fatih Sağlam on 10.03.2021.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var detailImage: UIImageView!
    
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var movieDetail: UILabel!
    
    @IBOutlet weak var similarMoviesHeader: UILabel!
    
    
    @IBOutlet weak var similarMoviesSlider: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
