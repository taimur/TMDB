//
//  TMDBMoviesPresenter.swift
//  TMDB
//
//  Created by Taimur Ajmal on 10/2/18.
//  Copyright © 2018 Taimur Ajmal. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class TMDBMoviesPresenter: NSObject {

  typealias T = TMDBMoviesViewProtocol
  weak var view: T?

  override init() {

  }

}

extension TMDBMoviesPresenter: TMDBMoviesPresenterProtocol {

  public func onPopUpInvoked(withView txtfView: UITextField, withKeywords suggested: [NSManagedObject], andCurrentPageNo pageNo: String) -> SuggestedValuesTVC {

    var controller: SuggestedValuesTVC! // Tableview For PopUp
    var items = [String]()
    for keywords in suggested {
      if let value = keywords.value(forKeyPath: DB_ATTRIBUTES) as? String  {
        items.insert(value, at: 0)
      }
    }
    items = items.removeDuplicates()

    controller = SuggestedValuesTVC(items) { (keyword) in
      self.view?.updateSearch(keyword: keyword)
      self.getMovies(withKeywords: keyword, forPageNumber: pageNo)
      self.hideKeyboard()
      self.dismissPopOver()
    }
    controller.preferredContentSize = CGSize(width: 300.0, height: 300.0)

    let presentationController = PopOverPresenter.configurePresentation(forController: controller)
    presentationController.sourceView = txtfView
    presentationController.sourceRect = txtfView.bounds
    presentationController.permittedArrowDirections = [.down, .up]
    return controller
  }


  public func getMovies(withKeywords keywords: String, forPageNumber number: String) {
    view?.showLoading()
    TMDBCatalogueManager.sharedInstance.getMovies(withKeywords: keywords, forPageNumber: number, successBlock:{(results,totalPages) ->
      Void in

      if let res = results, let pages = totalPages {
        self.view?.hideLoading()
        self.view?.updateViewOnDataReceive(results: res, totalPages: pages)
      }

    }, failedBlock: {
        self.view?.hideLoading()
        self.view?.updateViewOnFailToLoad()
        self.view?.showAlert(withTitle: ERROR_TITLE, andMessage: GENERAL_ERROR_DESC)
      })
  }
  public func getMovieDetails(withid movieID: String) {

    view?.showLoading()
    TMDBCatalogueManager.sharedInstance.getMovieDetails(withMovieId: String(movieID), successBlock: {(movieDetailsObject) ->
      Void in
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let movieDetailVC = storyboard.instantiateViewController(withIdentifier: "movieDetails") as! TMDBMovieDetailsViewController
        movieDetailVC.movieDetailsObject = movieDetailsObject

        self.view?.hideLoading()
        self.view?.showMovieDetails(movieDetailVC: movieDetailVC)
      }
      ,failedBlock:{
        self.view?.hideLoading()
        self.view?.showAlert(withTitle: ERROR_TITLE, andMessage: GENERAL_ERROR_DESC)
      })
  }

  public func saveData(keyword: String) -> [NSManagedObject] {

    let suggestedKeywords: [NSManagedObject] = []
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return suggestedKeywords
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: DB_ENTITY,
                                            in: managedContext)!

    let keywords = NSManagedObject(entity: entity,
                                   insertInto: managedContext)

    keywords.setValue(keyword, forKeyPath: DB_ATTRIBUTES)

    do {
      try managedContext.save()
      return self.fetchData()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
    return suggestedKeywords
  }

  public func fetchData() -> [NSManagedObject] {

    var suggestedKeywords: [NSManagedObject] = []
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return suggestedKeywords
    }
    let managedContext = appDelegate.persistentContainer.viewContext

    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: DB_ENTITY)

    do {
      suggestedKeywords = try managedContext.fetch(fetchRequest)
      return suggestedKeywords
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return suggestedKeywords
  }

  public func onScreenloaded() {
    view?.setupView()
  }
  public func showLoading() {
    view?.showLoading()
  }
  public func hideLoading() {
    view?.hideLoading()
  }

  public func hideKeyboard() {
    view?.hideKeyboard()
  }

  public func showPopUp() {
    view?.showPopUp()
  }

  public func setView(view: Any) {

  }

  public func noDataFoundForKeyword(keyword: String) {
    view?.showAlert(withTitle: ERROR_TITLE, andMessage: NO_MOVIE_FOUND + keyword)

  }
  public func dismissPopOver() {
    view?.dismissPopOver()
  }

  public func posterCellSize(_ numberOfCellsInRow: Int) -> CGSize {

    /* Images on the server have this 3 sizes -
     300 x 445
     500 x 741
     600 x 889

     Ratiio / 69:89

     Link - http://andrew.hedges.name/experiments/aspect_ratio/
     */

    let originalWidth: CGFloat = 300
    let originalHeight: CGFloat = 450

    //let posterSize = self.posterCellSize(numberOfCellsInRow, width: originalWidth, height: originalHeight)

    let numberOfCells = CGFloat(numberOfCellsInRow)

    var newWidth: CGFloat = (UIScreen.main.bounds.size.width - (self.spaceBetweenCells() * (numberOfCells + 1))) / numberOfCells
    newWidth -= self.spaceBetweenCells()
    let newHeight: CGFloat = (originalHeight / originalWidth) * newWidth

    return CGSize(width: newWidth, height: newHeight + kMovielabelHeight)
  }

  func spaceBetweenCells() -> CGFloat {
    return 10.0
  }
}
