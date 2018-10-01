//
//  TMDBMovieDetailsViewController.swift
//  TMDB
//
//  Created by Taimur Ajmal on 10/1/18.
//  Copyright © 2018 Taimur Ajmal. All rights reserved.
//

import UIKit

class TMDBMovieDetailsViewController: UIViewController {

  var movieDetailsObject:TMDBMovieDetailsObject!

  @IBOutlet weak var imgPoster:UIImageView!
  @IBOutlet weak var imgBackdrop:UIImageView!
  @IBOutlet weak var lblMovieTitle:UILabel!
  @IBOutlet weak var lblSpokenLanguages:UILabel!
  @IBOutlet weak var lblYear:UILabel!

  @IBOutlet weak var lblGenres:UILabel!
  @IBOutlet weak var lblProductionCompanies:UILabel!

  @IBOutlet weak var lblTagline:UILabel!


  @IBOutlet weak var txtvOverview:UITextView!
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }
  override func viewWillAppear(_ animated: Bool) {
    self.setupView()
  }
  func setupView()
  {
    // Title
    self.lblMovieTitle.text = self.movieDetailsObject.title

    // Overview
    self.txtvOverview.text = self.movieDetailsObject.overview

    //Tagline
    self.lblTagline.text = self.movieDetailsObject.tagline

    //Release Year
    let dateString = self.movieDetailsObject.release_date

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    if dateString?.isEmpty == false
    {
      let date = dateFormatter.date(from: dateString!)
      dateFormatter.dateFormat = "yyyy"

      let strDate = dateFormatter.string(from: date!)
      self.lblYear.text = strDate
      self.lblYear.sizeToFit()
    }

    //Genres
    let arrGenres = NSMutableArray()

    arrGenres.addObjects(from: (self.movieDetailsObject.genres as NSArray).value(forKeyPath: "name") as! [Any])
    self.lblGenres.text = String(arrGenres.componentsJoined(by: " | "))

    //Spoken Languages
    let arrSpokenLanguages = NSMutableArray()

    arrSpokenLanguages.addObjects(from: (self.movieDetailsObject.spoken_languages as NSArray).value(forKeyPath: "name") as! [Any])
    self.lblSpokenLanguages.text = String(arrSpokenLanguages.componentsJoined(by: " , "))

    //SpokenLanguages
    let arrProductionCompanies = NSMutableArray()

    arrProductionCompanies.addObjects(from: (self.movieDetailsObject.production_companies as NSArray).value(forKeyPath: "name") as! [Any])
    self.lblProductionCompanies.text = self.lblProductionCompanies.text! + "\n" + String(arrProductionCompanies.componentsJoined(by: " , "))

    // Poster Image

    if let _ = movieDetailsObject.poster_path
    {
      let tempPosterURLString = TMDBUtilities().generateImageLink(withURLString: movieDetailsObject.poster_path!)


      self.imgPoster.sd_setImage(with: URL(string:tempPosterURLString), placeholderImage: nil,
                                 options: [])
      { (image, error, imageCacheType, imageUrl) in
        if image != nil
        {
          self.imgPoster.image = image
          //self.imageViewContentMode = UIViewContentMode.scaleToFill
        }
      }
    }

    // Backdrop Image
    if let _ = movieDetailsObject.backdrop_path
    {
      let tempImgBD = TMDBUtilities().generateImageLink(withURLString: movieDetailsObject.backdrop_path!)

      self.imgBackdrop.sd_setImage(with: URL(string:tempImgBD), placeholderImage: nil,
                                   options: [])
      { (image, error, imageCacheType, imageUrl) in
        if image != nil
        {

          self.imgBackdrop.image = image
          self.imgBackdrop.alpha = 0.0

          UIView.animate(withDuration: 1.0, animations: {
            self.imgBackdrop.alpha = 0.4
          })

        }
      }
    }
  }
  @IBAction func dimissView()
  {
    self.dismiss(animated: true, completion: nil)
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}