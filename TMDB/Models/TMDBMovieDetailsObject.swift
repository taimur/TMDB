//
//  TMDBMovieDetailsObject.swift
//  TMDB
//
//  Created by Taimur Ajmal on 10/1/18.
//  Copyright © 2018 Taimur Ajmal. All rights reserved.
//

import UIKit
import ObjectMapper

class TMDBMovieDetailsObject:Mappable {
  
  var adult: Bool
  var backdrop_path:String?
  var belongs_to_collection:Bool?
  var budget:Int?
  var genres:Array<AnyObject>
  var homepage:String?

  var id:Int?
  var imdb_id:Int?
  var original_language:String?
  var original_title:String?
  var overview:String?
  var popularity:Float?
  var poster_path:String?

  var production_companies:Array<AnyObject>!
  var production_countries:Array<AnyObject>!

  var release_date:String?

  var revenue: Int?
  var runtime:Int?
  var spoken_languages:Array<AnyObject>!

  var status:String?
  var tagline:String?

  var title:String?
  var video:Bool?
  var vote_average: Float?
  var vote_count:Int?

  required convenience init?(map: Map) {
    self.init()
  }

  init()
  {
    adult = false
    backdrop_path = ""
    belongs_to_collection = false
    budget = -1
    genres = [AnyObject]()
    homepage = ""

    id = -1
    imdb_id = -1
    original_language = ""
    original_title = ""
    overview = ""
    popularity = 0.0
    poster_path = ""

    production_companies = Array()
    production_countries = Array()

    release_date = ""

    revenue = -1
    runtime = -1
    spoken_languages = Array()

    status = ""
    tagline = ""

    title = ""
    video = false
    vote_average = 0.0
    vote_count = -1

  }
  func mapping(map: Map) {

    poster_path             <- map["poster_path"]
    adult                   <- map["adult"]
    backdrop_path           <- map["backdrop_path"]
    belongs_to_collection   <- map["belongs_to_collection"]
    budget                  <- map["budget"]
    genres                  <- map["genres"]
    homepage                <- map["homepage"]

    id                      <- map["id"]
    imdb_id                 <- map["imdb_id"]
    original_language       <- map["original_language"]
    original_title          <- map["original_title"]
    overview                <- map["overview"]
    popularity              <- map["popularity"]
    poster_path             <- map["poster_path"]

    production_companies    <- map["production_companies"]
    production_countries    <- map["production_countries"]

    release_date            <- map["release_date"]

    revenue                 <- map["revenue"]
    runtime                 <- map["runtime"]
    spoken_languages        <- map["spoken_languages"]

    status                  <- map["status"]
    tagline                 <- map["tagline"]

    title                   <- map["title"]
    video                   <- map["video"]
    vote_average            <- map["vote_average"]
    vote_count              <- map["vote_count"]
  }
}

