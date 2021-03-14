//
//  UpcomingCell.swift
//  mobillium
//
//  Created by Fatih Sağlam on 12.03.2021.
//

import UIKit

class UpcomingCell: UITableViewCell {
    
    
    @IBOutlet weak var movieCover: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        movieCover.layer.cornerRadius = movieCover.frame.size.height / 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
