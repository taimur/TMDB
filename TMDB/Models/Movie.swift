//
//  Movie.swift
//  TMDB
//
//  Created by Taimur Ajmal on 9/30/18.
//  Copyright © 2018 Taimur Ajmal. All rights reserved.
//

import UIKit
import ObjectMapper

class Movie: Mappable,Codable {

  var posterPath: String
  var adult: Bool
  var overview: String
  var releaseDate: String
  var genres: [Int]
  var id: Int
  var originalTitle: String
  var originalLanguage: String
  var title: String
  var backdropPath: String
  var popularity: Int
  var voteCount: Int
  var video: Bool
  var voteAverage: Int

  required convenience init?(map: Map) {
    self.init()
  }

  init() {
    posterPath = ""
    adult = false
    overview = ""
    releaseDate = ""
    genres = []
    id = -1
    originalTitle = ""
    originalLanguage = ""
    title = ""
    backdropPath = ""
    popularity = -1
    voteCount = -1
    video = false
    voteAverage = -1

  }

  func mapping(map: Map) {

    posterPath         <- map["poster_path"]
    adult               <- map["adult"]
    overview            <- map["overview"]
    releaseDate        <- map["release_date"]
    genres           <- map["genre_ids"]
    id                  <- map["id"]
    originalTitle      <- map["original_title"]
    originalLanguage   <- map["original_language"]
    title               <- map["title"]
    backdropPath       <- map["backdrop_path"]
    popularity          <- map["popularity"]
    voteCount          <- map["vote_count"]
    video               <- map["video"]
    voteAverage        <- map["vote_average"]
  }

}
