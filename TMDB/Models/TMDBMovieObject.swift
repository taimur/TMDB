//
//  TMDBMovieObject.swift
//  TMDB
//
//  Created by Taimur Ajmal on 9/30/18.
//  Copyright © 2018 Taimur Ajmal. All rights reserved.
//

import UIKit
import ObjectMapper

class TMDBMovieObject:Mappable {

  var poster_path:String?
  var adult: Bool
  var overview:String?
  var release_date:String?
  var genre_ids:Array<Int>
  var id: Int?
  var original_title:String?
  var original_language:String?
  var title:String?
  var backdrop_path:String?
  var popularity:Int
  var vote_count:Int
  var video: Bool
  var vote_average:Int

  required convenience init?(map: Map) {
    self.init()
  }

  init()
  {
    poster_path = ""
    adult = false
    overview = ""
    release_date = ""
    genre_ids = []
    id = -1
    original_title = ""
    original_language = ""
    title = ""
    backdrop_path = ""
    popularity = -1
    vote_count = -1
    video = false
    vote_average = -1

  }

  func mapping(map: Map) {

    poster_path         <- map["poster_path"]
    adult               <- map["adult"]
    overview            <- map["overview"]
    release_date        <- map["release_date"]
    genre_ids           <- map["genre_ids"]
    id                  <- map["id"]
    original_title      <- map["original_title"]
    original_language   <- map["original_language"]
    title               <- map["title"]
    backdrop_path       <- map["backdrop_path"]
    popularity          <- map["popularity"]
    vote_count          <- map["vote_count"]
    video               <- map["video"]
    vote_average        <- map["vote_average"]
  }

}
