//
//  MoviesTableViewCell.swift
//  Movies
//
//  Created by Erdinç Ayvaz on 17.08.2022.
//

import UIKit

class MoviesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var lblMovieTitle: UILabel!
    @IBOutlet weak var lblMovieDescription: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
