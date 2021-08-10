//
//  HomePageViewController.swift
//  MovieDBApp
//
//  Created by Utku Demir on 10.08.2021.
//

import UIKit

class HomePageViewController: UIViewController {
    @IBOutlet var upcomingMoviesTableView: UITableView!
    @IBOutlet weak var nowPlayingMoviesSliderView: UICollectionView!
    @IBOutlet weak var nowPlayingMoviesSliderPageControl: UIPageControl!

    var upcomingMoviesViewModel: UpcomingMoviesViewModel!
    var nowPlayingMoviesViewModel: NowPlayingMoviesViewModel!
    var searchMoviesViewModel: SearchMoviesViewModel!
    var movieDetailPageViewModel: MovieDetailPageViewModel!
    
    weak var nowPlayingActivityIndicatorView: UIActivityIndicatorView!
    weak var upcomingActivityIndicatorView: UIActivityIndicatorView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponent()
        setupViewModels()
        getNowPlayingMovies()
        getUpcomingMovies()
    }

    private func setupComponent() {
        setupSearchMovieView()
        setupNowPlayingMoviesView()
        setupUpcomingMoviesTableView()
    }
    
    private func setupViewModels() {
        let networkService = NetworkService.share
        let moviesProvider = MoviesProvider(networkService: networkService)
        upcomingMoviesViewModel = UpcomingMoviesViewModel(moviesProvider: moviesProvider)
        nowPlayingMoviesViewModel = NowPlayingMoviesViewModel(moviesProvider: moviesProvider)
        movieDetailPageViewModel = MovieDetailPageViewModel(moviesProvider: moviesProvider)
        searchMoviesViewModel = SearchMoviesViewModel(moviesProvider: moviesProvider)
        upcomingMoviesViewModel.delegate = self
        nowPlayingMoviesViewModel.delegate = self
        movieDetailPageViewModel.delegate = self
        searchMoviesViewModel.delegate = self
    }
    
    private func getNowPlayingMovies() {
        nowPlayingActivityIndicatorView.startAnimating()
        nowPlayingMoviesViewModel.getNowPlaying()
    }
    
    private func getUpcomingMovies() {
        upcomingActivityIndicatorView.startAnimating()
        upcomingMoviesViewModel.getUpcomingMovies()
    }
    
    func setupSearchMovieView() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func setupNowPlayingMoviesView() {
        let nowPlayingActivityIndicatorView = UIActivityIndicatorView(style: .large)
        nowPlayingMoviesSliderView.backgroundView = nowPlayingActivityIndicatorView
        self.nowPlayingActivityIndicatorView = nowPlayingActivityIndicatorView
        nowPlayingMoviesSliderView.register(UINib(nibName: "NowPlayingMoviesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "nowPlayingMoviesSliderCell")
    }

    private func setupUpcomingMoviesTableView() {
        let upcomingActivityIndicatorView = UIActivityIndicatorView(style: .medium)
        upcomingMoviesTableView.backgroundView = upcomingActivityIndicatorView
        self.upcomingActivityIndicatorView = upcomingActivityIndicatorView
        upcomingMoviesTableView.rowHeight = 125
        upcomingMoviesTableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        upcomingMoviesTableView.separatorInset = .zero
        upcomingMoviesTableView.register(UINib(nibName: "UpcomingMoviesTableViewCell", bundle: nil), forCellReuseIdentifier: "UpcomingMoviesTableViewCell")
    }
    
    @objc func startRefresh() {
        upcomingMoviesViewModel.page = 1
        nowPlayingMoviesViewModel.page = 1
        upcomingMoviesViewModel.getUpcomingMovies()
        nowPlayingMoviesViewModel.getNowPlaying()
    }

}

extension HomePageViewController: NowPlayingMoviesViewModelDelegate, UpcomingMoviesViewModelDelegate , SearchMoviesViewModellDelegate, MovieDetailPageViewModelDelegate{
    func didSuccessSearchMovie() {
    }
    
    func didFailSearchMovie(message: String) {
        print("Failed Search Movie: \(message)")
    }
    
    
    func didSuccessGetMovieById() {
        let movieDetailPageVC = MovieDetailPageViewController()
        movieDetailPageVC.movie = movieDetailPageViewModel.movie
        self.navigationController?.pushViewController(movieDetailPageVC, animated: true)
    }
    
    func didFailGetMovieById(message: String) {
        print("Failed Get Selected Movie: \(message)")
    }
    
    
    func didSuccesGetUpcomingMovies() {
        upcomingActivityIndicatorView?.stopAnimating()
        upcomingMoviesTableView.reloadData()
    }
    
    func didFailGetUpcomingMovies(message: String) {
        print("Failed Get Upcoming Movies: \(message)")
    }
    
    func didSuccessGetNowPlayingMovies() {
        nowPlayingMoviesSliderPageControl.numberOfPages = nowPlayingMoviesViewModel.movies.count
        nowPlayingMoviesSliderPageControl.currentPage = 0
        nowPlayingActivityIndicatorView?.stopAnimating()
        nowPlayingMoviesSliderView.reloadData()
    }

    func didFailGetNowPlayingMovies(message: String) {
        print("Failed Get Now Playing Movies: \(message)")
    }
}

extension HomePageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingMoviesViewModel.movies.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = upcomingMoviesTableView.dequeueReusableCell(withIdentifier: "UpcomingMoviesTableViewCell") as! UpcomingMoviesTableViewCell
        let movie = upcomingMoviesViewModel.movies[indexPath.row]
        cell.setupView(movie: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == upcomingMoviesViewModel.movies.count - 1, !upcomingMoviesViewModel.movies.isEmpty {
            if upcomingMoviesViewModel.movies.count < upcomingMoviesViewModel.totalResults, upcomingMoviesViewModel.page < upcomingMoviesViewModel.totalPages {
                
                upcomingMoviesViewModel.isLoadingMore = true
                upcomingMoviesViewModel.page += 1
                upcomingMoviesViewModel.getUpcomingMovies()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        movieDetailPageViewModel.id = upcomingMoviesViewModel.movies[indexPath.row].id ?? 0
        movieDetailPageViewModel.getMovieById()
    }
}

extension HomePageViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension HomePageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nowPlayingMoviesViewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nowPlayingMoviesSliderCell", for: indexPath) as! NowPlayingMoviesCollectionViewCell
        let movie = nowPlayingMoviesViewModel.movies[indexPath.row]
        cell.setupView(movie: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        movieDetailPageViewModel.id = nowPlayingMoviesViewModel.movies[indexPath.row].id ?? 0
        movieDetailPageViewModel.getMovieById()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = round(index)
        self.nowPlayingMoviesSliderPageControl.currentPage = Int(roundedIndex)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        nowPlayingMoviesSliderPageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

        nowPlayingMoviesSliderPageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}

extension HomePageViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let size = nowPlayingMoviesSliderView.frame.size
            return CGSize(width: size.width, height: size.height)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0.0
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0.0
        }
}

