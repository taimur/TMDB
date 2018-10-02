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
  func showMovieDetails(movieDetailVC: TMDBMovieDetailsViewController)
  func showLoading()
  func hideLoading()
  func hideKeyboard()
  func setupView()
  func updateSearch(keyword: String)
  func showAlert(withTitle title:String, andMessage message:String)
  func showPopUp()
}

public protocol TMDBMoviesPresenterProtocol: class {

  func onScreenloaded()
  func onPopUpInvoked(withView txtfView: UITextField, withKeywords suggested:[NSManagedObject], andCurrentPageNo pageNo:String) -> SuggestedValuesTVC
  func getMovies(withKeywords keywords: String, forPageNumber number: String)
  func getMovieDetails(withid movieID:String)
  func noDataFoundForKeyword(keyword:String)
  func saveData(keyword:String) -> [NSManagedObject]
  func fetchData() -> [NSManagedObject]
  func posterCellSize(_ numberOfCellsInRow: Int) -> CGSize
}
