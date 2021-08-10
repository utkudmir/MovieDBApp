//
//  MovieDetailPageViewController.swift
//  MovieDBApp
//
//  Created by Utku Demir on 10.08.2021.
//

import UIKit

class MovieDetailPageViewController: UIViewController {
    @IBOutlet weak var movieCoverImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDescriptionTextView: UITextView!
    @IBOutlet weak var imdbIconImageView: UIImageView!
    @IBOutlet weak var movieReleaseDateLabel: UILabel!
    @IBOutlet weak var movieRateLabel: UILabel!
    
    @IBOutlet weak var similarMoviesSliderView: UICollectionView!
    
    var movieImdbId : String?
    var movie: MoviesDetailResponseModel!
    var similarMoviesViewModel: SimilarMoviesViewModel!
    var movieDetailPageViewModel: MovieDetailPageViewModel!
    
    weak var similarActivityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponent()
        setupViewModels()
        getSimilarMovies()
        
    }
    private func setupComponent() {
        setupView(movie: self.movie)
        setupSimilarMoviesView()
    }
    
    private func setupViewModels() {
        let networkService = NetworkService.share
        let moviesProvider = MoviesProvider(networkService: networkService)
        similarMoviesViewModel = SimilarMoviesViewModel(moviesProvider: moviesProvider)
        similarMoviesViewModel.id = self.movie.id ?? 0
        movieDetailPageViewModel = MovieDetailPageViewModel(moviesProvider: moviesProvider)
        similarMoviesViewModel.delegate = self
        movieDetailPageViewModel.delegate = self
    }
    
    func setupView(movie: MoviesDetailResponseModel?) {
        movieTitleLabel.text = movie?.title
        movieDescriptionTextView.text = movie?.overview
        movieReleaseDateLabel.text = movie?.releaseDate
        movieRateLabel.text = String(movie?.voteAverage ?? 0.0)
        movieImdbId = movie?.imdbId
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imdbIconTapped))
        imdbIconImageView.isUserInteractionEnabled = true
        imdbIconImageView.addGestureRecognizer(tapGestureRecognizer)
        
        
        movieCoverImageView?.kf.indicatorType = .activity
        let posterPath = movie?.backdropPath ?? "n/a"
        let imgUrl = URL(string: APIConstant.imgBaseUrl + "w780" + posterPath)
        movieCoverImageView?.kf.setImage(with: imgUrl)
        
        
    }
    
    func setupSimilarMoviesView(){
        let similarActivityIndicatorView = UIActivityIndicatorView(style: .medium)
        similarMoviesSliderView.backgroundView = similarActivityIndicatorView
        self.similarActivityIndicatorView = similarActivityIndicatorView
        similarMoviesSliderView.register(UINib(nibName: "SimilarMoviesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "similarMoviesSliderCell")
        
    }
    
    private func getSimilarMovies() {
        similarActivityIndicatorView.startAnimating()
        similarMoviesViewModel.getSimilarMovies()
    }
    
    @objc func imdbIconTapped() {
        let path = "https://www.imdb.com/title/" + (self.movieImdbId ?? "")
        guard let url = URL(string: path) else { return }
        UIApplication.shared.open(url)
    }

}

extension MovieDetailPageViewController: SimilarMoviesViewModelDelegate, MovieDetailPageViewModelDelegate {
    
    func didSuccessGetSimilarMovies() {
        similarActivityIndicatorView?.stopAnimating()
        similarMoviesSliderView.reloadData()
    }

    func didFailGetSimilarMovies(message: String) {
        print("Failed Get Now Playing Movies: \(message)")
    }
    
    func didSuccessGetMovieById() {
        let movieDetailPageVC = MovieDetailPageViewController()
        movieDetailPageVC.movie = movieDetailPageViewModel.movie
        self.navigationController?.pushViewController(movieDetailPageVC, animated: true)
    }
    
    func didFailGetMovieById(message: String) {
        print("Failed Get Selected Movie: \(message)")
    }
}

extension MovieDetailPageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarMoviesViewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "similarMoviesSliderCell", for: indexPath) as! SimilarMoviesCollectionViewCell
        let movie = similarMoviesViewModel.movies[indexPath.row]
        cell.setupView(movie: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        movieDetailPageViewModel.id = similarMoviesViewModel.movies[indexPath.row].id ?? 0
        movieDetailPageViewModel.getMovieById()
    }
}

extension MovieDetailPageViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 150, height: 200)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0.0
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0.0
        }
}
