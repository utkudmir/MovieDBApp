//
//  MoviesModel.swift
//  MovieDBApp
//
//  Created by Utku Demir on 10.08.2021.
//

import Foundation

struct MoviesModel {
    var id: Int?
    var title: String?
    var body: String?
    var date: String?
    var imgUrlString: String?
    var posterUrlString: String?
    var imdbId: String?
    var imdbRate: Double?
    
    init(data: MoviesDetailResponseModel) {
        self.id = data.id ?? -1
        self.title = data.title ?? "n/a"
        self.body = data.overview ?? "n/a"
        self.date = data.releaseDate ?? "n/a"
        
        let posterPath = data.posterPath ?? "n/a"
        self.imgUrlString = APIConstant.imgBaseUrl + "w500" + posterPath
        
        let backdropPath = data.backdropPath ?? "n/a"
        self.posterUrlString = APIConstant.imgBaseUrl + "w780" + backdropPath
        
        self.imdbId = data.imdbId ?? "n/a"
        self.imdbRate = data.voteAverage ?? 0.0
    }
}
