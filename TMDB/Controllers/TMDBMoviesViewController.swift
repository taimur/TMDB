//
//  TMDBMoviesViewController.swift
//  TMDB
//
//  Created by Taimur Ajmal on 9/29/18.
//  Copyright © 2018 Taimur Ajmal. All rights reserved.
//

import UIKit

class TMDBMoviesViewController: UIViewController {

  //Collection View Items
  let minimumRowItemObjectsInRow = 3
  let reuseIdentifier = "cellIdentifier"
  let headerIdentifier = "headerIdentifier"

  @IBOutlet weak var moviesCollectionView:UICollectionView!
  private let layout = UICollectionViewFlowLayout()
  @IBOutlet weak var txtfSearch:UITextField!

  fileprivate var arrResults:[AnyObject] = [AnyObject]()
  fileprivate var moviesTotalPages = ""
  var currPageNumber = "1"

  var fetchInProgress:Bool = false // Avoid multiple calls
  var loadingMoreAssets:Bool = false // Pagination

  // Other controls
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var movielistSegControl:UISegmentedControl!
  @IBOutlet weak var lblFilterStatus:UILabel!
  @IBOutlet weak var btnResetFilter:UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupView()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func viewWillAppear(_ animated: Bool) {
  }

  // MARK: USER_DEFINED)_FUNCTIONS
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
    if self.fetchInProgress == true
    {
      return
    }

    self.fetchInProgress = true
    self.activityIndicator.startAnimating()
    TMDBCatalogueManager.sharedInstance.getMovies(withKeywords: keywords, forPageNumber: number, successBlock:{(results,totalPages) ->
      Void in

      if let _ = results
      {
        //print(results!)
        if let _ = totalPages
        {
          print(totalPages!)
          self.moviesTotalPages = totalPages!
        }
        if self.loadingMoreAssets == false
        {
          if self.arrResults.count > 0
          {
            self.moviesCollectionView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)

          }
          self.arrResults.removeAll(keepingCapacity: false)
        }

        self.arrResults += results as! [AnyObject]

        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidesWhenStopped = true
        self.moviesCollectionView.reloadData()
        self.fetchInProgress = false


      }

    }, failedBlock:
      {
        // Show Alert Please try again
        print()
    })
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func posterCellSize(_ numberOfCellsInRow: Int) -> CGSize {

    /*
     Images on the server have this 3 sizes -
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

extension TMDBMoviesViewController: UICollectionViewDelegate {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    return self.arrResults.count
  }
}

extension TMDBMoviesViewController: UICollectionViewDataSource {
  // MARK: - UICollectionViewDelegates
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    var cell: UICollectionViewCell = UICollectionViewCell()

    let movieObject = self.arrResults[(indexPath as IndexPath).item]

    if movieObject is TMDBMovieObject
    {
      let posterCell: TMDBCataloguePosterCell = (collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) ) as! TMDBCataloguePosterCell

      posterCell.contentView.backgroundColor = UIColor.clear
      posterCell.backgroundColor = UIColor.clear
      posterCell.lblMovieTitle.text = (movieObject as! TMDBMovieObject).title

      //posterCell.placeholderImage = UIImage(named: "title_placeholder.png")
      posterCell.imageViewContentMode = UIViewContentMode.scaleAspectFit

      if let posterPath = (movieObject as! TMDBMovieObject).poster_path
      {
        posterCell.imageURLString = posterPath
      }

      cell = posterCell
    }
    return cell

  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    let size: CGSize = CGSize(width: self.moviesCollectionView!.frame.size.width, height: 40)
    return size
  }

  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
    return UIEdgeInsetsMake(0, self.spaceBetweenCells(), self.spaceBetweenCells(), self.spaceBetweenCells())
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {

    let size = self.posterCellSize(self.minimumRowItemObjectsInRow)

    return size
  }


  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

    var view: UICollectionReusableView!

    let tempView = self.moviesCollectionView!.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier, for: indexPath)

    for subview in tempView.subviews
    {
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
extension TMDBMoviesViewController: UITextFieldDelegate {

  // MARK: TextField Resign Responder

  @objc func didTapView() {

    self.view.endEditing(true)
  }


  func textFieldDidEndEditing(_ textField: UITextField) {
    if text = textfield.text {
      self.getMovies(withKeywords: text, forPageNumber: currPageNumber)
    }

  }

  func textFieldDidReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)


    return true
  }
}


