//
//  SimilarMoviesViewModel.swift
//  MovieDBApp
//
//  Created by Utku Demir on 10.08.2021.
//

import Foundation

protocol SimilarMoviesViewModelDelegate {
    func didSuccessGetSimilarMovies()
    func didFailGetSimilarMovies(message: String)
}

class SimilarMoviesViewModel {
    let moviesProvider: MoviesProvider
    var delegate: SimilarMoviesViewModelDelegate?
    var movies: [MoviesModel] = []
    var id: Int = 0
    var page: Int = 1
    var totalPages: Int = 0
    var totalResults: Int = 0
    var isLoadingMore: Bool = false

    init(moviesProvider: MoviesProvider) {
        self.moviesProvider = moviesProvider
    }

    func getSimilarMovies() {
        moviesProvider.getSimilarMovies(page: page, id: id, completion: { [weak self] result in
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

                    self.delegate?.didSuccessGetSimilarMovies()
                } else {
                    print("No Movies Found")
                }

                self.isLoadingMore = false
            case .failure(let errorMsg):
                if self.isLoadingMore == true {
                    self.isLoadingMore = false
                    self.page -= 1
                }
                self.delegate?.didFailGetSimilarMovies(message: errorMsg)
            }
        })
    }
}
