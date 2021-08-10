//
//  MoviesProvider.swift
//  MovieDBApp
//
//  Created by Utku Demir on 10.08.2021.
//

import Foundation

class MoviesProvider {
    var networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func getNowPlayingMovies(page: Int, completion: @escaping (FetchResutlt<MoviesResponseModel, String>) -> Void) {
        let model = MoviesRequestModel(page: page)
        let endpoint = Endpoint.nowPlayingMovies(model: model)
        networkService.request(endpoint: endpoint, completion: completion)
    }

    func getUpcomingMovies(page: Int, completion: @escaping (FetchResutlt<MoviesResponseModel, String>) -> Void) {
        let model = MoviesRequestModel(page: page)
        let endpoint = Endpoint.upcomingMovies(model: model)
        networkService.request(endpoint: endpoint, completion: completion)
    }

    func getMovieById(id: Int, completion: @escaping (FetchResutlt<MoviesDetailResponseModel, String>) -> Void) {
        let model = MoviesRequestModel()
        let endpoint = Endpoint.movieById(id: id,model: model)
        networkService.request(endpoint: endpoint, completion: completion)
    }

    func searchMovies(query: String, page: Int, completion: @escaping (FetchResutlt<MoviesResponseModel, String>) -> Void) {
        let model = MoviesRequestModel(query: query, page: page)
        let endpoint = Endpoint.searchMovies(model: model)
        networkService.request(endpoint: endpoint, completion: completion)
    }
    
    func getSimilarMovies(page: Int, id: Int, completion: @escaping (FetchResutlt<MoviesResponseModel, String>) -> Void) {
        let model = MoviesRequestModel(page: page)
        let endpoint = Endpoint.similarMovies(id: id, model: model)
        networkService.request(endpoint: endpoint, completion: completion)
    }

}
