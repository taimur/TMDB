//
//  TMDBMoviesViewController.swift
//  TMDB
//
//  Created by Taimur Ajmal on 9/29/18.
//  Copyright © 2018 Taimur Ajmal. All rights reserved.
//

import UIKit
import MBProgressHUD
import CoreData

class TMDBMoviesViewController: UIViewController {

  typealias T = TMDBMoviesPresenterProtocol
  var presenter: T?

  //Collection View Items
  let minimumRowItemObjectsInRow = 3
  let reuseIdentifier = "cellIdentifier"
  let headerIdentifier = "headerIdentifier"
  @IBOutlet weak var moviesCollectionView:UICollectionView!
  private let layout = UICollectionViewFlowLayout()

  //IBOutlets
  @IBOutlet weak var txtfSearch:UITextField!
  @IBOutlet weak var lblfInfo:UILabel!

  fileprivate var arrResults:[AnyObject] = [AnyObject]()
  fileprivate var moviesTotalPages = ""
  var currPageNumber = "1"

  var fetchInProgress:Bool = false // Avoid multiple calls
  var loadingMoreAssets:Bool = false // Pagination
  var suggestedKeywords: [NSManagedObject] = [] // To Save Values

  var controller: SuggestedValuesTVC! // Tableview For PopUp

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter?.onScreenloaded()

    if let keywords = presenter?.fetchData() {
      suggestedKeywords = keywords
    }

    // Do any additional setup after loading the view, typically from a nib.
  }

  override func viewWillAppear(_ animated: Bool) {

  }
  // MARK: USER_DEFINED_FUNCTIONS
  func didTapView() {
    self.view.endEditing(true)
  }

  func setupView() {

    self.hideKeyboardOnTap()
    lblfInfo.isHidden = false
    layout.scrollDirection = UICollectionViewScrollDirection.vertical
    layout.minimumInteritemSpacing = spaceBetweenCells()
    layout.minimumLineSpacing = spaceBetweenCells()
    layout.sectionInset =
      UIEdgeInsetsMake(spaceBetweenCells(),
                       spaceBetweenCells(),
                       spaceBetweenCells(),
                       spaceBetweenCells())

    moviesCollectionView.collectionViewLayout = layout
    moviesCollectionView.backgroundColor = UIColor.clear

    // Register cell classes
    moviesCollectionView!.register(TMDBCataloguePosterCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    moviesCollectionView!.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)
  }

  internal func getMovies(withKeywords keywords:String, forPageNumber number:String)
  {
    self.hideKeyboard()
    if self.fetchInProgress == true {
      return
    }

    self.fetchInProgress = true
    presenter?.getMovies(withKeywords: keywords, forPageNumber: currPageNumber)

  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func spaceBetweenCells() -> CGFloat {
    return 10.0
  }
}
extension TMDBMoviesViewController: TMDBMoviesViewProtocol {

  func hideKeyboard() {
    self.view.endEditing(true)
  }

  func showLoading() {
    MBProgressHUD.showAdded(to: self.view, animated: true)
  }

  func hideLoading() {
    MBProgressHUD.hide(for: self.view, animated: true)
  }

  func updateViewOnDataReceive(results: NSArray, totalPages: String) {

    self.lblfInfo.isHidden = true
    self.moviesTotalPages = totalPages

    if self.loadingMoreAssets == false {
      if self.arrResults.count > 0 { 
        self.moviesCollectionView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
      }
      if results.count == 0 {
        self.lblfInfo.isHidden = false
        if let text = self.txtfSearch.text {
          presenter?.noDataFoundForKeyword(keyword:text)
        }
      }
      self.arrResults.removeAll(keepingCapacity: false)
    }
    // Save only for the fist time - not in case of loading more assets in pagination
    // Save successful queries only

    if let text = self.txtfSearch.text {
      if results.count > 0 && loadingMoreAssets == false {
        if let keywords = self.presenter?.saveData(keyword: text) {
          if keywords.count > 0 {
            self.suggestedKeywords = keywords
          }
        }
      }
    }
    self.arrResults += results as [AnyObject]
    self.moviesCollectionView.reloadData()
    self.fetchInProgress = false
  }

  func updateViewOnFailToLoad() {
    self.fetchInProgress = false
  }

  func showMovieDetails(movieDetailVC: TMDBMovieDetailsViewController) {
    self.present(movieDetailVC, animated: true, completion:nil)
  }

  func showAlert(withTitle title:String, andMessage message:String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
    self.present(alert, animated: true, completion: nil)
  }

  func updateSearch(keyword: String) {
    self.txtfSearch.text = keyword
  }

  func showPopUp() {
    self.present(controller, animated: true)
  }

  func dismissPopOver() {
    if let _ = self.controller {
      self.controller.dismiss(animated: true, completion: nil)
    }
  }
}

// MARK: - UICollectionViewDataSource
extension TMDBMoviesViewController: UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return arrResults.count
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

    var view: UICollectionReusableView!
    let tempView = self.moviesCollectionView!.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier, for: indexPath)

    for subview in tempView.subviews {
      subview.removeFromSuperview()
    }

    let label = UILabel(frame: CGRect(x: self.spaceBetweenCells(),
                                      y: tempView.center.y + self.spaceBetweenCells(),
                                      width: tempView.frame.size.width - (self.spaceBetweenCells() * 2),
                                      height: tempView.frame.size.height))

    label.textColor = UIColor.darkGray
    label.font = UIFont(name: "Helvetica-Bold", size: 16.0)
    label.textAlignment = NSTextAlignment.left
    tempView.addSubview(label)
    view = tempView
    return view
  }
}

// MARK: - UICollectionViewDelegates
extension TMDBMoviesViewController: UICollectionViewDelegate {

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    var cell: UICollectionViewCell = UICollectionViewCell()
    let movieObject = self.arrResults[(indexPath as IndexPath).item]

    if movieObject is TMDBMovieObject {
      let posterCell: TMDBCataloguePosterCell = (collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) ) as! TMDBCataloguePosterCell

      posterCell.contentView.backgroundColor = UIColor.clear
      posterCell.backgroundColor = UIColor.clear
      posterCell.lblMovieTitle.text = (movieObject as! TMDBMovieObject).title
      posterCell.imageViewContentMode = UIViewContentMode.scaleAspectFit

      if let posterPath = (movieObject as! TMDBMovieObject).poster_path {
        posterCell.imageURLString = posterPath
      }

      cell = posterCell
    }
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let movieObject = self.arrResults[(indexPath as IndexPath).item]
    if let tempID = (movieObject as! TMDBMovieObject).id {
      presenter?.getMovieDetails(withid: String(tempID))
    }
  }
}

extension TMDBMoviesViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsetsMake(0, self.spaceBetweenCells(), self.spaceBetweenCells(), self.spaceBetweenCells())
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    if let size = self.presenter?.posterCellSize(self.minimumRowItemObjectsInRow) {
      return size
    }
    return CGSize(width: 0.0, height: 0.0) // default values
  }
}

// MARK: TextField_Delegates
extension TMDBMoviesViewController: UITextFieldDelegate {

  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if suggestedKeywords.count > 0 {
      if let ctrl = presenter?.onPopUpInvoked(withView: textField, withKeywords: suggestedKeywords, andCurrentPageNo: currPageNumber) {
         controller = ctrl
        self.showPopUp()
      }
    }
    return true
  }
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    return true
  }
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    self.dismissPopOver()
    return true
  }
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let text = textField.text {
      self.dismissPopOver()
      self.loadingMoreAssets = false
      self.getMovies(withKeywords: text, forPageNumber: currPageNumber)
    }
    return true
  }

  func textFieldDidReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return true
  }
}

//MARK: UIScrollView_Delegate
extension TMDBMoviesViewController: UIScrollViewDelegate {

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
  let bottom:CGFloat = self.moviesCollectionView.contentOffset.y + self.moviesCollectionView.frame.size.height

  if bottom >= scrollView.contentSize.height {
    if self.fetchInProgress == false {
      self.loadingMoreAssets = true
      var validPage = true
      var tempPageNo = Int(self.currPageNumber)! + 1
      if tempPageNo > 1000 {
        validPage = false
        tempPageNo = 1000 // TMDB APIs have limit for pages of 1 to 1000
      }
      if self.moviesTotalPages.isEmpty == false {
        if tempPageNo >= Int(self.moviesTotalPages)!
        {
          validPage = false
        }
      }
      self.currPageNumber = String(tempPageNo)
      if validPage == true {
         if let text = txtfSearch.text {
           self.getMovies(withKeywords: text, forPageNumber: currPageNumber)
         }
        }
      }
    }
  }
}
