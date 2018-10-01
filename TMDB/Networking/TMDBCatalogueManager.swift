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

  fileprivate static var __once: () = {
    Static.instance = TMDBCatalogueManager()

  }()

  class var sharedInstance: TMDBCatalogueManager {


    _ = TMDBCatalogueManager.__once

    return Static.instance!
  }

  // MARK: Helper_functions
  func baseURL() -> String {
    return "https://api.themoviedb.org/3"
  }

  func appendAPIKey() -> String {
    return "?api_key=\(tmdb_authkey)"
  }

  func appendParameters(parameters:String) ->String {
    return parameters == "" ? "":self.andSign + parameters
  }

  func generateURL(_ endPoint:String,parameters:String) -> String {
    return self.baseURL() + endPoint + self.appendAPIKey() + self.appendParameters(parameters: parameters)
  }


  // MARK: APIs
  func getMovies(withKeywords text:String, forPageNumber number:String, successBlock: @escaping (_ results: NSArray?, _ totalPage:String?) -> Void, failedBlock: @escaping () -> Void)
  {
    //http://api.themoviedb.org/3/search/movie?api_key=2696829a81b1b5827d515ff121700838&query=batman&page=1
    let query = "query=\(text)"
    let page = "page=\(number)"
    let parameters = query + "&" + page
    
    let endpoint = kEndPointMovies
    let urlString = self.generateURL(endpoint, parameters: parameters)

    Alamofire.request(urlString, method: .get, parameters: ["":""], encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in

      switch(response.result) {
      case .success(_):
        let results = NSMutableArray()
        if((response.result.value) != nil) {
          let swiftyJsonVar = JSON(response.result.value!)

          var totalPages = ""

          if let tempTotalPage = swiftyJsonVar["total_pages"].int {
            totalPages = String(tempTotalPage)
          }

          if let resData = swiftyJsonVar["results"].arrayObject {

            for item in resData {
              let object = Mapper<TMDBMovieObject>().map(JSONObject: item)
              results.add(object!)

            }
            successBlock(results as NSArray, totalPages)
          }

        }

        break

      case .failure(_):
        if let error = response.result.error {
          print(error)
        }
        break

      }
    }
  }
}
