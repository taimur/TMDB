//
//  MovieDetails.swift
//  TMDB
//
//  Created by Taimur Ajmal on 10/1/18.
//  Copyright © 2018 Taimur Ajmal. All rights reserved.
//

import UIKit
import ObjectMapper

class MovieDetails: Mappable {

  var adult: Bool
  var backdropPath: String?
  var belongsToCollection: Bool?
  var budget: Int?
  var genres: [AnyObject]!
  var homepage: String?

  var id: Int?
  var imdbID: String?
  var originalLanguage: String?
  var originalTitle: String?
  var overview: String?
  var popularity: Float?
  var posterPath: String?

  var productionCompanies: [AnyObject]!
  var productionCountries: [AnyObject]!

  var releaseDate: String?

  var revenue: Int?
  var runtime: Int?
  var spokenLanguages: [AnyObject]!

  var status: String?
  var tagline: String?

  var title: String?
  var video: Bool?
  var voteAverage: Float?
  var voteCount: Int?

  required convenience init?(map: Map) {
    self.init()
  }

  init() {
    adult = false
    backdropPath = ""
    belongsToCollection = false
    budget = -1
    genres = [AnyObject]()
    homepage = ""

    id = -1
    imdbID = ""
    originalLanguage = ""
    originalTitle = ""
    overview = ""
    popularity = 0.0
    posterPath = ""

    productionCompanies = Array()
    productionCountries = Array()

    releaseDate = ""

    revenue = -1
    runtime = -1
    spokenLanguages = Array()

    status = ""
    tagline = ""

    title = ""
    video = false
    voteAverage = 0.0
    voteCount = -1

  }
  func mapping(map: Map) {

    posterPath             <- map["poster_path"]
    adult                   <- map["adult"]
    backdropPath           <- map["backdrop_path"]
    belongsToCollection   <- map["belongs_to_collection"]
    budget                  <- map["budget"]
    genres                  <- map["genres"]
    homepage                <- map["homepage"]

    id                      <- map["id"]
    imdbID                 <- map["imdb_id"]
    originalLanguage       <- map["original_language"]
    originalTitle          <- map["original_title"]
    overview                <- map["overview"]
    popularity              <- map["popularity"]
    posterPath             <- map["poster_path"]

    productionCompanies    <- map["production_companies"]
    productionCountries    <- map["production_countries"]

    releaseDate            <- map["release_date"]

    revenue                 <- map["revenue"]
    runtime                 <- map["runtime"]
    spokenLanguages        <- map["spoken_languages"]

    status                  <- map["status"]
    tagline                 <- map["tagline"]

    title                   <- map["title"]
    video                   <- map["video"]
    voteAverage            <- map["vote_average"]
    voteCount              <- map["vote_count"]
  }
}
