//
//  SimilarMoviesCell.swift
//  mobilium
//
//  Created by Fatih Sağlam on 13.03.2021.
//

import UIKit

class SimilarMoviesCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        image.layer.cornerRadius = image.frame.size.height / 8
    }

}
