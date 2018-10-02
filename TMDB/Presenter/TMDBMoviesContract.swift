//
//  TMDBMoviesContract.swift
//  TMDB
//
//  Created by Taimur Ajmal on 10/2/18.
//  Copyright © 2018 Taimur Ajmal. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol TMDBMoviesViewProtocol: class {
  func dismissPopOver()
  func updateViewOnDataReceive(results: NSArray, totalPages: String)
  func updateViewOnFailToLoad()
  func showLoading()
  func hideLoading()
  func hideKeyboard()
}

public protocol TMDBMoviesPresenterProtocol: class {

  func pushViewController(viewController: UIViewController)
  func onScreenloaded()
  func setView(view: Any)
  
  func getMovies(withKeywords keywords: String, forPageNumber number: String)
  func getMovieDetails(withid movieID:String)
  func saveData(keyword:String) -> [NSManagedObject]
  func fetchData() -> [NSManagedObject]
  func posterCellSize(_ numberOfCellsInRow: Int) -> CGSize
}
