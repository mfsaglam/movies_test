//
//  CollectionViewCell.swift
//  mobillium
//
//  Created by Fatih Sağlam on 12.03.2021.
//

import UIKit

class NowPlayingCell: UICollectionViewCell {

    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cover.contentMode = .scaleAspectFill
    }
}
