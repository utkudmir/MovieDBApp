//
//  NowPlayingMoviesCollectionViewCell.swift
//  MovieDBApp
//
//  Created by Utku Demir on 10.08.2021.
//

import UIKit

class NowPlayingMoviesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var movieCoverImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func setupView(movie: MoviesModel?) {
        movieTitleLabel.text = movie?.title

        movieCoverImageView.kf.indicatorType = .activity
        let imgUrl = URL(string: movie?.posterUrlString ?? "")
        movieCoverImageView.kf.setImage(with: imgUrl)
    }
    

}
