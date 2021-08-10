//
//  SearchMoviesViewModel.swift
//  MovieDBApp
//
//  Created by Utku Demir on 10.08.2021.
//

import Foundation

protocol SearchMoviesViewModellDelegate {
    func didSuccessSearchMovie()
    func didFailSearchMovie(message: String)
}

class SearchMoviesViewModel {
    let moviesProvider: MoviesProvider
    var delegate: UpcomingMoviesViewModelDelegate?
    var movies: [MoviesModel] = []
    var page: Int = 1
    var query: String = ""
    var totalPages: Int = 0
    var totalResults: Int = 0
    var isLoadingMore: Bool = false

    init(moviesProvider: MoviesProvider) {
        self.moviesProvider = moviesProvider
    }

    func getUpcomingMovies() {
        moviesProvider.searchMovies(query: query, page: page, completion: { [weak self] result in
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

                    self.delegate?.didSuccesGetUpcomingMovies()
                } else {
                    print("No Movies Found")
                }
                self.isLoadingMore = false
            case .failure(let errorMsg):
                if self.isLoadingMore == true {
                    self.isLoadingMore = false
                    self.page -= 1
                }
                self.delegate?.didFailGetUpcomingMovies(message: errorMsg)
            }
        })
    }
}
