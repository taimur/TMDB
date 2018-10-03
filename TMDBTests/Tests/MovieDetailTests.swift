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
    mock = BaseMock(file: "movieDetails", error: nil, bundle: bundle)
    do {
      let jsonData = try mock!.json()
      if let movie = Mapper<MovieDetails>().map(JSONObject: jsonData) {

        XCTAssertEqual(movie.adult, false)
        XCTAssertEqual(movie.backdropPath, "/ezXodpP429qK0Av89pVNlaXWJkQ.jpg")
        XCTAssertEqual(movie.budget, 100000)
        XCTAssert((movie.genres.count ) > 0)
        XCTAssertEqual(movie.homepage, "http://www.jackreachermovie.com/")

        XCTAssertEqual(movie.id, 75780)
        XCTAssertEqual(movie.imdbID, "tt0790724")
        XCTAssertEqual(movie.originalLanguage, "en")
        XCTAssertEqual(movie.originalTitle, "Jack Reacher")
        XCTAssertEqual(movie.overview, "When a gunman takes five lives with six shots, all evidence points to the suspect in custody. On interrogation, the suspect offers up a single note: 'Get Jack Reacher!' So begins an extraordinary chase for the truth, pitting Jack Reacher against an unexpected enemy, with a skill for violence and a secret to keep.")

        XCTAssertEqual(movie.popularity, 13.265)
        XCTAssertEqual(movie.posterPath, "/38bmEXmuJuInLs9dwfgOGCHmZ7l.jpg")
        XCTAssert((movie.productionCompanies.count) > 0 )
        XCTAssert((movie.productionCountries.count) > 0 )
        XCTAssertEqual(movie.releaseDate, "2012-12-20")

        XCTAssertEqual(movie.revenue, 218340595)
        XCTAssertEqual(movie.runtime, 130)
        XCTAssert((movie.spokenLanguages.count) > 0 )
        XCTAssertEqual(movie.status, "Released")
        XCTAssertEqual(movie.tagline, "The Law Has Limits. He Does Not.")

        XCTAssertEqual(movie.title, "The Law Has Limits. He Does Not.")
        XCTAssertEqual(movie.video, false)
        XCTAssertEqual(movie.voteAverage, 6.4)
        XCTAssertEqual(movie.voteCount, 3721)


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
      if let movie = Mapper<MovieDetails>().map(JSONObject: jsonData) {
        XCTAssertNotNil(movie)
        XCTAssertNil(movie.adult)
        XCTAssertNil(movie.backdropPath)
        XCTAssertNil(movie.budget)
        XCTAssertNil(movie.genres.count)
        XCTAssertNil(movie.homepage)

        XCTAssertNil(movie.id)
        XCTAssertNil(movie.imdbID)
        XCTAssertNil(movie.originalLanguage)
        XCTAssertNil(movie.originalTitle)
        XCTAssertNil(movie.overview)

        XCTAssertNil(movie.popularity)
        XCTAssertNil(movie.posterPath)
        XCTAssertNil(movie.productionCompanies.count)
        XCTAssertNil(movie.productionCountries.count)
        XCTAssertNil(movie.releaseDate)

        XCTAssertNil(movie.revenue)
        XCTAssertNil(movie.runtime)
        XCTAssertNil(movie.spokenLanguages.count)
        XCTAssertNil(movie.status)
        XCTAssertNil(movie.tagline)

        XCTAssertNil(movie.title)
        XCTAssertNil(movie.video)
        XCTAssertNil(movie.voteAverage)
        XCTAssertNil(movie.voteCount)

        XCTAssertNil(movie.title)

        XCTAssertNil(movie.popularity)
        XCTAssertNil(movie.voteCount)
        XCTAssertNil(movie.video)
        XCTAssertNil(movie.voteAverage)
      }
    } catch {
      XCTFail("Parse should not fail")
    }
  }
}
