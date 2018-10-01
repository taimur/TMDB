//
//  TMDBMoviesViewController.swift
//  TMDB
//
//  Created by Taimur Ajmal on 9/29/18.
//  Copyright © 2018 Taimur Ajmal. All rights reserved.
//

import UIKit
import MBProgressHUD

class TMDBMoviesViewController: UIViewController {

  //Collection View Items
  let minimumRowItemObjectsInRow = 3
  let reuseIdentifier = "cellIdentifier"
  let headerIdentifier = "headerIdentifier"
  @IBOutlet weak var moviesCollectionView:UICollectionView!
  private let layout = UICollectionViewFlowLayout()

  //IBOutlets
  @IBOutlet weak var txtfSearch:UITextField!

  fileprivate var arrResults:[AnyObject] = [AnyObject]()
  fileprivate var moviesTotalPages = ""
  var currPageNumber = "1"
  var fetchInProgress:Bool = false // Avoid multiple calls
  var loadingMoreAssets:Bool = false // Pagination

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupView()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func viewDidAppear(_ animated: Bool) {
    //self.txtfSearch.text = "Batman"
    //self.getMovies(withKeywords: "Batman", forPageNumber: "1")
  }
  // MARK: USER_DEFINED_FUNCTIONS

  func setupView() {

    self.layout.scrollDirection = UICollectionViewScrollDirection.vertical
    self.layout.minimumInteritemSpacing = self.spaceBetweenCells()
    self.layout.minimumLineSpacing = self.spaceBetweenCells()
    self.layout.sectionInset =
      UIEdgeInsetsMake(self.spaceBetweenCells(),
                       self.spaceBetweenCells(),
                       self.spaceBetweenCells(),
                       self.spaceBetweenCells())

    self.moviesCollectionView.collectionViewLayout = layout
    self.moviesCollectionView.backgroundColor = UIColor.clear

    // Register cell classes

    self.moviesCollectionView!.register(TMDBCataloguePosterCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    self.moviesCollectionView!.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)
  }

  internal func getMovies(withKeywords keywords:String, forPageNumber number:String)
  {
    self.view.endEditing(true)

    if self.fetchInProgress == true {
      return
    }

    self.fetchInProgress = true
    MBProgressHUD.showAdded(to: self.view, animated: true)
    
    TMDBCatalogueManager.sharedInstance.getMovies(withKeywords: keywords, forPageNumber: number, successBlock:{(results,totalPages) ->
      Void in

      if let tempArray = results
      {
        if let pages = totalPages {
          self.moviesTotalPages = pages
        }
        if self.loadingMoreAssets == false {
          if self.arrResults.count > 0 {
            self.moviesCollectionView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
          }
          if tempArray.count == 0 {
            self.showAlert(withTitle: "Error!", andMessage: "No Movies found, Please try with different title")
          }
          self.arrResults.removeAll(keepingCapacity: false)
        }

        self.arrResults += results as! [AnyObject]
        MBProgressHUD.hide(for: self.view, animated: true)
        
        self.moviesCollectionView.reloadData()
        self.fetchInProgress = false
      }
    }, failedBlock:
      {
        // Show Alert Please try again
        self.fetchInProgress = false
        print()
    })
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func posterCellSize(_ numberOfCellsInRow: Int) -> CGSize {

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

  func showAlert(withTitle title:String, andMessage message:String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
    self.present(alert, animated: true, completion: nil)
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

    if movieObject is TMDBMovieObject
    {
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
    MBProgressHUD.showAdded(to: self.view, animated: true)

    let movieObject = self.arrResults[(indexPath as IndexPath).item]
    if let tempID = (movieObject as! TMDBMovieObject).id
    {
      TMDBCatalogueManager.sharedInstance.getMovieDetails(withMovieId: String(tempID), successBlock: {(movieDetailsObject) ->
        Void in

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let movieDetailViewController = storyboard.instantiateViewController(withIdentifier: "movieDetails") as! TMDBMovieDetailsViewController
        movieDetailViewController.movieDetailsObject = movieDetailsObject

        MBProgressHUD.hide(for: self.view, animated: true)
        self.present(movieDetailViewController, animated: true, completion: {() -> Void in
        })
      }
        ,failedBlock:{
          self.showAlert(withTitle: "Error!", andMessage: "Please try again")
          MBProgressHUD.hide(for: self.view, animated: true)
      })
    }

  }
}

extension TMDBMoviesViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsetsMake(0, self.spaceBetweenCells(), self.spaceBetweenCells(), self.spaceBetweenCells())
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    let size = self.posterCellSize(self.minimumRowItemObjectsInRow)
    return size
  }
}
extension TMDBMoviesViewController: UITextFieldDelegate {

  // MARK: TextField Resign Responder

  @objc func didTapView() {
    self.view.endEditing(true)
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let text = textField.text {
      self.getMovies(withKeywords: text, forPageNumber: currPageNumber)
    }
    return true
  }

  func textFieldDidReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return true
  }
}
extension TMDBMoviesViewController: UIScrollViewDelegate {
  //MARK: UIScrollView_Delegate
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
