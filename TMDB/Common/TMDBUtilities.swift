//
//  TMDBUtilities.swift
//  TMDB
//
//  Created by Taimur Ajmal on 9/30/18.
//  Copyright © 2018 Taimur Ajmal. All rights reserved.
//

import UIKit

class TMDBUtilities: NSObject {

  var baseURL: String = "https://image.tmdb.org/t/p/"

  func generateImageLink(withURLString url: String) -> String {
    var width = "w300" // for iPhone

    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
      width = "w500" //iPad
    }

    return self.baseURL + width + url
  }

  func getFormattedDate(strDate: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    if let date = dateFormatter.date(from: strDate) {
      dateFormatter.dateFormat = "dd - MMM - yy"
      let formatedDte = dateFormatter.string(from: date)
      return formatedDte
    }
    return ""
  }
}
