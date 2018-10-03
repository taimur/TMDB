//
//  TMDBCataloguePosterCell.swift
//  TMDB
//
//  Created by Taimur Ajmal on 9/30/18.
//  Copyright © 2018 Taimur Ajmal. All rights reserved.
//

import UIKit
import SDWebImage
import MarqueeLabel

let kMovielabelHeight: CGFloat = 32
let kMovieReleaseDateHeight: CGFloat = 20
let kDisplacement:CGFloat = 15.0

class TMDBCataloguePosterCell: UICollectionViewCell {
  var imageViewBackgroundColor: UIColor = UIColor.white {
    didSet {
      self.imageView.backgroundColor = self.imageViewBackgroundColor
    }
  }

  var imageViewContentMode: UIViewContentMode = UIViewContentMode.scaleAspectFit {
    didSet {
      self.imageView.contentMode = self.imageViewContentMode
    }
  }
  var animateTouch = true

  var lblMovieTitle: MarqueeLabel!

  var imageURLString: String! {
    didSet {
      self.downloadImage(self.imageURLString)
    }
  }

  var imageView: UIImageView!

  var lblReleasedte: UILabel!

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.imageView = UIImageView(frame: self.bounds)
    self.backgroundColor = UIColor.white

    self.imageView.contentMode = self.imageViewContentMode
    self.imageView.isUserInteractionEnabled = true
    self.contentView.addSubview(self.imageView)

    // Release Data
    let frameReleasedte = CGRect(x: 0, y: frame.size.height - (kMovieReleaseDateHeight + kDisplacement ), width: frame.size.width, height: kMovieReleaseDateHeight)

    self.lblReleasedte = UILabel(frame: frameReleasedte)

    self.lblReleasedte.textColor = UIColor.white
    self.lblReleasedte.layer.borderColor = UIColor.white.cgColor
    self.lblReleasedte.layer.borderWidth = 1.0
    self.lblReleasedte.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    self.lblReleasedte.font =  UIFont(name: "Helvetica-Bold", size: 12.0)
    self.lblReleasedte.textAlignment = NSTextAlignment.center
    self.contentView.addSubview(self.lblReleasedte)

    //Mobie Title label
    let labelFrame = CGRect(x: 0, y: frame.size.height - (kMovielabelHeight - kDisplacement ), width: frame.size.width, height: kMovielabelHeight)

    self.lblMovieTitle = MarqueeLabel(frame: labelFrame)
    self.lblMovieTitle.marqueeType = .MLContinuous
    self.lblMovieTitle.rate = 10
    self.lblMovieTitle.fadeLength = 10.0
    self.lblMovieTitle.trailingBuffer = 30.0

    self.lblMovieTitle.textColor = UIColor.darkGray
    self.lblMovieTitle!.font =  UIFont(name: "Helvetica", size: 14.0)
    self.lblMovieTitle.textAlignment = NSTextAlignment.center

    self.lblMovieTitle.backgroundColor = UIColor.clear
    self.contentView.addSubview(self.lblMovieTitle)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    self.imageView.image = nil
  }

  func downloadImage(_ urlString: String) {

    //Detail of image fetching can be found be at https://developers.themoviedb.org/3/getting-started/images
    //After studyng image sizes. I have figured images can be retrieved in 300 / 500 / 600 and the size is not dynamic
    // For verification check this image link with several width values
    //https://image.tmdb.org/t/p/w800/vR9YvUJCead23MOWwVzv9776eb1.jpg

    //let width:String = String(format: "w%.0f", self.imageView.frame.width * UIScreen.main.scale)
    //let height:String = String(format: "h%.0f", self.imageView.frame.height * UIScreen.main.scale)

    let  tempURLString = TMDBUtilities().generateImageLink(withURLString: urlString)

    let url: URL = URL(string: tempURLString)!

    self.imageView.sd_setImage(with: url, placeholderImage: nil,
                               options: []) { (image, _, _, _) in
      if image != nil {
        self.imageView.image = image
        //self.imageViewContentMode = UIViewContentMode.scaleToFill
      }
    }

  }
  func baseURL() -> String {
    return "https://image.tmdb.org/t/p/"
  }

  func animatedImageViewAlphaFade(_ alpha: CGFloat) {
    if self.animateTouch == false {
      return
    }

    UIView.animate(withDuration: 0.1, animations: { () -> Void in
      self.imageView.alpha = alpha
    })
  }
}
