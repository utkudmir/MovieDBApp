//
//  Endpoint.swift
//  MovieDBApp
//
//  Created by Utku Demir on 10.08.2021.
//

import Alamofire

enum Endpoint {
    case movieById(id: Int, model: MoviesRequestModel)
    case similarMovies(id: Int,model: MoviesRequestModel)
    case nowPlayingMovies(model: MoviesRequestModel)
    case searchMovies(model: MoviesRequestModel)
    case upcomingMovies(model: MoviesRequestModel)
}

extension Endpoint: IEndpoint {
    var url: String {
        return APIConstant.baseUrl + path
    }

    private var path: String {
        switch self {
        case .movieById(let id, _):
            return "/movie/\(id)"
        case .similarMovies(let id, _):
            return "/movie/\(id)/similar"
        case .nowPlayingMovies:
            return "/movie/now_playing"
        case .searchMovies:
            return "/search/movie"
        case .upcomingMovies:
            return "/movie/upcoming"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .movieById,
             .similarMovies,
             .nowPlayingMovies,
             .searchMovies,
             .upcomingMovies:
            return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case .movieById(_, let model):
            return model.movieByIdParameters()
        case .similarMovies(_, let model):
            return model.defaultParameters()
        case .nowPlayingMovies(let model):
            return model.defaultParameters()
        case .searchMovies(let model):
            return model.searchMoviesParameters()
        case .upcomingMovies(let model):
            return model.defaultParameters()
        }
    }

    var headers: HTTPHeaders? {
        return [
            "Content-Type": "application/json"
        ]
    }

    var encoding: ParameterEncoding {
        switch self {
        case .movieById,
             .similarMovies,
             .nowPlayingMovies,
             .searchMovies,
             .upcomingMovies:
            return URLEncoding.queryString
        }
    }
}

