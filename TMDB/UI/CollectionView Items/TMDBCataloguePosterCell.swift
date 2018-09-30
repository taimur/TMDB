//
//  TMDBCataloguePosterCell.swift
//  TMDB
//
//  Created by Taimur Ajmal on 9/30/18.
//  Copyright © 2018 Taimur Ajmal. All rights reserved.
//

import UIKit
import SDWebImage

let kMovielabelHeight: CGFloat = 32

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
    didSet
    {
      self.downloadImage(self.imageURLString)
    }
  }



  var imageView: UIImageView!

  override init(frame: CGRect)
  {
    super.init(frame: frame)

    self.imageView = UIImageView(frame: self.bounds)

    self.backgroundColor = UIColor.white

    // TODO: Change me!!
    self.imageView.contentMode = self.imageViewContentMode
    self.imageView.isUserInteractionEnabled = true
    self.contentView.addSubview(self.imageView)

    //premium label
    let labelFrame = CGRect(x: 0, y: frame.size.height - (kMovielabelHeight - 10.0 ), width: frame.size.width, height: kMovielabelHeight)

    //self.lblMovieTitle = UILabel(frame: labelFrame)

    self.lblMovieTitle = MarqueeLabel(frame: labelFrame)
    self.lblMovieTitle.type = .continuous
    self.lblMovieTitle.speed = .duration(10)
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

    let url:URL = URL(string: tempURLString)!

    self.imageView.sd_setImage(with: url, placeholderImage: nil,
                               options: [])
    { (image, error, imageCacheType, imageUrl) in
      if image != nil {
        self.imageView.image = image
        //self.imageViewContentMode = UIViewContentMode.scaleToFill
      }
    }

  }
  func baseURL() -> String
  {
    return "https://image.tmdb.org/t/p/"
  }

  //MARK: Touch detection

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first as UITouch!
    {
      if touch.view == self.imageView {
        self.animatedImageViewAlphaFade(0.7)
      }
    }
    super.touchesBegan(touches , with:event)
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first as UITouch! {
      if touch.view == self.imageView {
        self.animatedImageViewAlphaFade(1.0)
      }
    }
    super.touchesCancelled(touches , with:event)
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first as UITouch! {
      if touch.view == self.imageView {
        self.animatedImageViewAlphaFade(1.0)
      }
    }
    super.touchesEnded(touches , with:event)
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first as UITouch! {
      if touch.view == self.imageView {
        self.animatedImageViewAlphaFade(0.7)
      }
    }
    super.touchesMoved(touches , with:event)
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
