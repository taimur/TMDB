//
//  MovieDetailTest.swift
//  TMDBTests
//
//  Created by Taimur Ajmal on 10/3/18.
//  Copyright © 2018 Taimur Ajmal. All rights reserved.
//

import XCTest
import ObjectMapper

@testable import TMDB

class MovieDetailTests: XCTestCase {
  var mock: BaseMock?
  let bundle = Bundle(for: MovieTests.self)

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testValidParse() {
    mock = BaseMock(file: "movie", error: nil, bundle: bundle)
    do {
      let jsonData = try mock!.json()
      if let movie = Mapper<MovieDetails>().map(JSONObject: jsonData) {
        /*
         var adult: Bool
         var backdropPath: String?
         var belongsToCollection: Bool?
         var budget: Int?
         var genres: [AnyObject]!
         var homepage: String?

         var id: Int?
         var imdbID: Int?
         var originalLanguage: String?
         var originalTitle: String?
         var overview: String?
         var popularity: Float?
         var posterPath: String?

         var productionCompanies: [AnyObject]!
         var productionCountries: [AnyObject]!

         var releaseDate: String?

         var revenue: Int?
         var runtime: Int?
         var spokenLanguages: [AnyObject]!

         var status: String?
         var tagline: String?

         var title: String?
         var video: Bool?
         var voteAverage: Float?
         var voteCount: Int?
         */
        XCTAssertEqual(movie.posterPath, "/bxVxZb5O9OxCO0oRUNdCnpy9NST.jpg")
        XCTAssertEqual(movie.adult, false)
        XCTAssertEqual(movie.backdropPath, "/pIUvQ9Ed35wlWhY2oU6OmwEsmzG.jpg")
        XCTAssertEqual(movie.belongsToCollection, false)
        XCTAssertEqual(movie.budget, 100000)
        XCTAssert((movie.genres.count ) > 0)
        XCTAssertEqual(movie.homepage, "my home")
        XCTAssertEqual(movie.overview, "Young hobbit Frodo Baggins, after inheriting a mysterious ring from his uncle Bilbo, must leave his home in order to keep it from falling into the hands of its evil creator.")
        XCTAssertEqual(movie.releaseDate, "2001-12-18")

        XCTAssertEqual(movie.id, 120)
        XCTAssertEqual(movie.originalTitle, "The Lord of the Rings: The Fellowship of the Ring")
        XCTAssertEqual(movie.originalLanguage, "Eng")
        XCTAssertEqual(movie.title, "The Lord of the Rings: The Fellowship of the Ring")

        XCTAssertEqual(movie.popularity, 46)
        XCTAssertEqual(movie.voteCount, 800)
        XCTAssertEqual(movie.video, false)
        XCTAssertEqual(movie.voteAverage, 8)
      }

    } catch {
      XCTFail("Parse should not fail")
    }
  }

  func testParseFail() {
    mock = BaseMock(file: "fail", error: nil, bundle: bundle)
    do {
      let jsonData = try mock!.json()
      if let movie = Mapper<Movie>().map(JSONObject: jsonData) {
        XCTAssertNotNil(movie)
        XCTAssertNil(movie.posterPath)
        XCTAssertNil(movie.adult)
        XCTAssertNil(movie.overview)
        XCTAssertNil(movie.genres)
        XCTAssertNil(movie.id)
        XCTAssertNil(movie.originalTitle)
        XCTAssertNil(movie.originalLanguage)
        XCTAssertNil(movie.title)
        XCTAssertNil(movie.backdropPath)
        XCTAssertNil(movie.popularity)
        XCTAssertNil(movie.voteCount)
        XCTAssertNil(movie.video)
        XCTAssertNil(movie.voteAverage)
      }
    } catch {
      XCTFail("Parse should not fail")
    }
  }

  func testParseEmpty() {
    mock = BaseMock(file: "error", error: nil, bundle: bundle)
    do {
      let jsonData = try mock!.json()
      //XCTAssertThrowsError(try JSONDecoder().decode(Movie.self, from: jsonData))
    } catch { }
  }
}
