//
//  MovieDetailViewModel.swift
//  MovieDBApp
//
//  Created by Utku Demir on 10.08.2021.
//

import UIKit

protocol MovieDetailPageViewModelDelegate {
    func didSuccessGetMovieById()
    func didFailGetMovieById(message: String)
}

class MovieDetailPageViewModel {
    let moviesProvider: MoviesProvider
    var delegate: MovieDetailPageViewModelDelegate?
    var movie: MoviesDetailResponseModel!
    var id: Int = 0

    init(moviesProvider: MoviesProvider) {
        self.moviesProvider = moviesProvider
    }

    func getMovieById() {
        moviesProvider.getMovieById(id: id, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let succesResponse):
                self.movie = succesResponse
                self.delegate?.didSuccessGetMovieById()
            case .failure(let errorMsg):
                self.delegate?.didFailGetMovieById(message: errorMsg)
            }
        })
    }
}
