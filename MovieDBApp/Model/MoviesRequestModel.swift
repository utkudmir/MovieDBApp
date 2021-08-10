//
//  MoviesRequestModel.swift
//  MovieDBApp
//
//  Created by Utku Demir on 10.08.2021.
//

import Foundation

struct MoviesRequestModel {
    let apiKey: String = APIConstant.apiKey
    let language: String = "en-US"
    var page: Int?
    var query: String?
    
    init() {}

    init(page: Int?) {
        self.page = page
    }
    
    init(query: String?, page: Int?) {
        self.query = query
        self.page = page
    }

    func defaultParameters() -> [String: Any]? {
        return [
            "api_key": apiKey,
            "language": language,
            "page": page as Any,
        ]
    }
    
    func movieByIdParameters() -> [String: Any]? {
        return [
            "api_key": apiKey,
            "language": language,
        ]
    }
    
    func searchMoviesParameters() -> [String: Any]? {
        return [
            "api_key": apiKey,
            "page": page as Any,
            "language": language,
            "query" : query ?? "",
        ]
    }
    
}
