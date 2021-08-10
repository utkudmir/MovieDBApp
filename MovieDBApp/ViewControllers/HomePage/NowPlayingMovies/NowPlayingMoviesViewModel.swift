//
//  NowPlayingMoviesViewModel.swift
//  MovieDBApp
//
//  Created by Utku Demir on 10.08.2021.
//

import Foundation

protocol NowPlayingMoviesViewModelDelegate {
    func didSuccessGetNowPlayingMovies()
    func didFailGetNowPlayingMovies(message: String)
}

class NowPlayingMoviesViewModel {
    let moviesProvider: MoviesProvider
    var delegate: NowPlayingMoviesViewModelDelegate?
    var movies: [MoviesModel] = []
    var page: Int = 1
    var totalPages: Int = 0
    var totalResults: Int = 0
    var isLoadingMore: Bool = false

    init(moviesProvider: MoviesProvider) {
        self.moviesProvider = moviesProvider
    }

    func getNowPlaying() {
        moviesProvider.getNowPlayingMovies(page: page, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let succesResponse):
                if let results = succesResponse.results {
                    self.page = succesResponse.page ?? 0
                    self.totalPages = succesResponse.totalPages ?? 0
                    self.totalResults = succesResponse.totalResults ?? 0
                    
                    if self.isLoadingMore == false {
                        self.movies.removeAll()
                    }
                    
                    for movieResponse in results {
                        let newMovie = MoviesModel(data: movieResponse)
                        self.movies.append(newMovie)
                    }

                    self.delegate?.didSuccessGetNowPlayingMovies()
                } else {
                    print("No Movies Found")
                }

                self.isLoadingMore = false
            case .failure(let errorMsg):
                if self.isLoadingMore == true {
                    self.isLoadingMore = false
                    self.page -= 1
                }
                self.delegate?.didFailGetNowPlayingMovies(message: errorMsg)
            }
        })
    }
}
