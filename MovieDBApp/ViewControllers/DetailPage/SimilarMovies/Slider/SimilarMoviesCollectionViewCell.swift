//
//  SimilarMoviesCollectionViewCell.swift
//  MovieDBApp
//
//  Created by Utku Demir on 10.08.2021.
//

import UIKit

class SimilarMoviesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieReleaseDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        movieImageView.layer.cornerRadius = 10
    }
    
    func setupView(movie: MoviesModel?) {
        movieTitleLabel.text = movie?.title
        movieReleaseDateLabel.text = movie?.date
        
        movieImageView.kf.indicatorType = .activity
        let imgUrl = URL(string: movie?.imgUrlString ?? "")
        movieImageView.kf.setImage(with: imgUrl)
    }

}
