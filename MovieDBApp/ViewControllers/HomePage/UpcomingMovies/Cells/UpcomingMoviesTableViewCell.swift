//
//  UpcomingMoviesTableViewCell.swift
//  MovieDBApp
//
//  Created by Utku Demir on 10.08.2021.
//

import UIKit

class UpcomingMoviesTableViewCell: UITableViewCell {
    @IBOutlet weak var movieCoverImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var movieReleaseDateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        movieCoverImageView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupView(movie: MoviesModel?) {
        movieTitleLabel.text = movie?.title
        movieDescriptionLabel.text = movie?.body
        movieReleaseDateLabel.text = movie?.date

        movieCoverImageView.kf.indicatorType = .activity
        let imgUrl = URL(string: movie?.imgUrlString ?? "")
        movieCoverImageView.kf.setImage(with: imgUrl)
    }
    
}
