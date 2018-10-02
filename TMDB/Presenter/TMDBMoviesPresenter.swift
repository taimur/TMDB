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

public protocol TMDBMoviesDelegate: class {

}
public class TMDBMoviesPresenter: NSObject {


  typealias T = TMDBMoviesViewProtocol
  weak var view: T?
  weak var delegate: TMDBMoviesDelegate?
  let context: TMDBMoviesContext


  init(context: TMDBMoviesContext,
       delegate: TMDBMoviesDelegate? = nil) {
    self.context = context
    self.delegate = delegate
  }

}

extension TMDBMoviesPresenter: TMDBMoviesPresenterProtocol {

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
      return suggestedKeywords
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
    fetchRequest.fetchLimit = 10

    do {
      suggestedKeywords = try managedContext.fetch(fetchRequest)
      return suggestedKeywords
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return suggestedKeywords
  }

  public func pushViewController(viewController: UIViewController) {

  }

  public func onScreenloaded() {

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

  public func setView(view: Any) {

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
