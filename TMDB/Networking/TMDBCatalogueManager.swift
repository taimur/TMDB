//
//  TMDBCatalogueManager.swift
//  TMDB
//
//  Created by Taimur Ajmal on 9/30/18.
//  Copyright © 2018 Taimur Ajmal. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper

class TMDBCatalogueManager: NSObject {

  var backSlash = "/"
  var andSign = "&"
  var questionMark = "&"

  struct Static {
    static var instance: TMDBCatalogueManager?
    static var token: Int = 0
  }

  fileprivate static var once: () = {
    Static.instance = TMDBCatalogueManager()

  }()

  class var sharedInstance: TMDBCatalogueManager {

    _ = TMDBCatalogueManager.once

    return Static.instance!
  }

  // MARK: Helper_functions
  func baseURL() -> String {
    return "https://api.themoviedb.org/3"
  }

  func appendAPIKey() -> String {
    return "?api_key=\(authKey)"
  }

  func appendParameters(parameters: String) -> String {
    return parameters == "" ? "":self.andSign + parameters
  }

  func generateURL(_ endPoint: String, parameters: String) -> String {
    return self.baseURL() + endPoint + self.appendAPIKey() + self.appendParameters(parameters: parameters)
  }

  // MARK: APIs

  // Get Movies with Search Query
  func getMovies(withKeywords text: String, forPageNumber number: String, successBlock: @escaping (_ results: NSArray?, _ totalPage: String?) -> Void, failedBlock: @escaping () -> Void) {
    //http://api.themoviedb.org/3/search/movie?api_key=2696829a81b1b5827d515ff121700838&query=batman&page=1
    let query = "query=\(text)"
    let page = "page=\(number)"
    let parameters = query + "&" + page

    let endpoint = kSearch + kEndPointMovies
    var urlString = self.generateURL(endpoint, parameters: parameters)

    if let str = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
      urlString = str
    }

    Alamofire.request(urlString, method: .get, parameters: ["": ""], encoding: URLEncoding.default, headers: nil).responseJSON { (response: DataResponse<Any>) in

      switch response.result {
      case .success:
        let results = NSMutableArray()
        if response.result.value != nil {
          let swiftyjson = JSON(response.result.value!)

          var totalPages = ""

          if let tempTotalPage = swiftyjson["total_pages"].int {
            totalPages = String(tempTotalPage)
          }

          if let resData = swiftyjson["results"].arrayObject {

            for item in resData {
              if let object = Mapper<Movie>().map(JSONObject: item) {
                results.add(object)
              }

            }
            successBlock(results as NSArray, totalPages)
          }
        }
      case .failure:
        if let error = response.result.error {
          print(error)
        }
      }
    }
  }

  // Fetch Movie Details
  func getMovieDetails(withMovieId id: String, successBlock: @escaping (_ movieObject: MovieDetails?) -> Void, failedBlock: @escaping () -> Void) {
    let parameters = ""
    let endpoint = kEndPointMovies + self.backSlash + id
    let urlString = self.generateURL(endpoint, parameters: parameters)

    Alamofire.request(urlString, method: .get, parameters: ["": ""], encoding: URLEncoding.default, headers: nil).responseJSON { (response: DataResponse<Any>) in

      switch response.result {
      case .success:
        if response.result.value != nil {
          let swiftyjson = JSON(response.result.value!)
          if let item = swiftyjson.dictionaryObject {
            if let object = Mapper<MovieDetails>().map(JSONObject: item) {
              successBlock(object)
            }
          }
        }
      case .failure:
        if let error = response.result.error {
          print(error)
        }
      }
    }
  }

}
