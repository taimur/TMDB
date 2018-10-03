//
//  TMDBMovieDetailsViewController.swift
//  TMDB
//
//  Created by Taimur Ajmal on 10/1/18.
//  Copyright © 2018 Taimur Ajmal. All rights reserved.
//

import UIKit

class TMDBMovieDetailsViewController: UIViewController {

  var movieDetails: MovieDetails!

  @IBOutlet weak var imgPoster: UIImageView!
  @IBOutlet weak var imgBackdrop: UIImageView!
  @IBOutlet weak var lblMovieTitle: UILabel!
  @IBOutlet weak var lblSpokenLanguages: UILabel!
  @IBOutlet weak var lblYear: UILabel!

  @IBOutlet weak var lblGenres: UILabel!
  @IBOutlet weak var lblProductionCompanies: UILabel!

  @IBOutlet weak var lblTagline: UILabel!

  @IBOutlet weak var txtvOverview: UITextView!
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }
  override func viewWillAppear(_ animated: Bool) {
    self.setupView()
  }
  func setupView() {
    // Title
    self.lblMovieTitle.text = self.movieDetails.title

    // Overview
    self.txtvOverview.text = self.movieDetails.overview

    //Tagline
    self.lblTagline.text = self.movieDetails.tagline

    //Release Year
    let dateString = self.movieDetails.releaseDate

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    if dateString.isEmpty == false {
      let date = dateFormatter.date(from: dateString)
      dateFormatter.dateFormat = "yyyy"

      let strDate = dateFormatter.string(from: date!)
      self.lblYear.text = strDate
      self.lblYear.sizeToFit()
    }

    //Genres
    let arrGenres = NSMutableArray()

    arrGenres.addObjects(from: ((self.movieDetails.genres as NSArray).value(forKeyPath: "name") as? [Any])!)
    self.lblGenres.text = String(arrGenres.componentsJoined(by: " | "))

    //Spoken Languages
    let arrSpokenLanguages = NSMutableArray()

    arrSpokenLanguages.addObjects(from: ((self.movieDetails.spokenLanguages as NSArray).value(forKeyPath: "name") as? [Any])!)
    self.lblSpokenLanguages.text = String(arrSpokenLanguages.componentsJoined(by: " , "))

    //SpokenLanguages
    let arrProductionCompanies = NSMutableArray()

    arrProductionCompanies.addObjects(from: ((self.movieDetails.productionCompanies as NSArray).value(forKeyPath: "name") as? [Any])!)
    self.lblProductionCompanies.text = self.lblProductionCompanies.text! + "\n" + String(arrProductionCompanies.componentsJoined(by: " , "))

    // Poster Image

    if movieDetails.posterPath.isEmpty == false {
      let tempPosterURLString = TMDBUtilities().generateImageLink(withURLString: movieDetails.posterPath)

      self.imgPoster.sd_setImage(with: URL(string: tempPosterURLString), placeholderImage: nil,
                                 options: []) { (image, _, _, _) in
        if image != nil {
          self.imgPoster.image = image
          //self.imageViewContentMode = UIViewContentMode.scaleToFill
        }
      }
    }

    // Backdrop Image
    if movieDetails.backdropPath.isEmpty == false {
      let tempImgBD = TMDBUtilities().generateImageLink(withURLString: movieDetails.backdropPath)

      self.imgBackdrop.sd_setImage(with: URL(string: tempImgBD), placeholderImage: nil,
                                   options: []) { (image, _, _, _) in
        if image != nil {

          self.imgBackdrop.image = image
          self.imgBackdrop.alpha = 0.0

          UIView.animate(withDuration: 1.0, animations: {
            self.imgBackdrop.alpha = 0.4
          })

        }
      }
    }
  }
  @IBAction func dimissView() {
    self.dismiss(animated: true, completion: nil)
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
