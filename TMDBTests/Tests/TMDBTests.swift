//
//  TMDBTests.swift
//  TMDBTests
//
//  Created by Taimur Ajmal on 9/29/18.
//  Copyright © 2018 Taimur Ajmal. All rights reserved.
//

import XCTest
import OHHTTPStubs
import ObjectMapper

@testable import TMDB

class TMDBTests: XCTestCase {
   
    var mock: BaseMock?
    let bundle = Bundle(for: TMDBTests.self)
      override func setUp() {
        super.setUp()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        OHHTTPStubs.setEnabled(true)
        OHHTTPStubs.stubRequests(passingTest: { (request) -> Bool in

          if let url = request.url {

            print("request url \(url.path)")

            if url.absoluteString.contains("http://api.themoviedb.org/3/search/movie?api_key=2696829a81b1b5827d515ff121700838") {

              return true
            }
          }

          return false

        }, withStubResponse: { (_) -> OHHTTPStubsResponse in

          let response = OHHTTPStubsResponse(fileAtPath: OHPathForFile("movieSearchResponse.json", type(of: self))!, statusCode: 200, headers: ["Content-Type": "application/json"])

          return response

        })
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

  func testFetchMovies() {
    let expect = expectation(description: "fetch tags")
    TMDBCatalogueManager.sharedInstance.getMovies(withKeywords: "batman", forPageNumber: "1", successBlock: { (results, _) in
      do {
        if let movie = results?.lastObject as? Movie {
          XCTAssertEqual(movie.posterPath, "/j3SFJqZPeeB9g5JMU7UFLgEqj2T.jpg")
          XCTAssertEqual(movie.adult, false)
          XCTAssertEqual(movie.overview, "Batman learns that he has a violent, unruly pre-teen son with Talia al Ghul named Damian Wayne who is secretly being raised by Ra\'s al Ghul and the League of Assassins. When Ra\'s al Ghul apparently dies after a battle with Deathstroke, Batman must work to stop his long-lost son from taking revenge and guiding him to a righteous path, in addition to the chance for the pair to truly acknowledging each other as family.")
          XCTAssertEqual(movie.releaseDate, "2014-04-20")
          XCTAssert((movie.genres.count ) > 0)
          XCTAssertEqual(movie.id, 251519)
          XCTAssertEqual(movie.originalTitle, "Son of Batman")
          XCTAssertEqual(movie.originalLanguage, "en")
          XCTAssertEqual(movie.title, "Son of Batman")
          XCTAssertEqual(movie.backdropPath, "/omK35Mr3oks6bd5efrgsO7CzmLP.jpg")
          XCTAssertEqual(movie.popularity, 7)
          XCTAssertEqual(movie.voteCount, 434)
          XCTAssertEqual(movie.video, false)
          XCTAssertEqual(movie.voteAverage, 6)
        } else {
          XCTFail("Did not expect a nil object")
        }
      } catch {
        XCTFail("Fails on parsing model")
      }
      expect.fulfill()
        }, failedBlock: {
    })
    waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error, "Test time ount. \(error!.localizedDescription)")
    }
  }

  func testFetchMoviesDetails() {

    let expect = expectation(description: "fetch tags")
    TMDBCatalogueManager.sharedInstance.getMovieDetails(withMovieId: "75780", successBlock: { (responseMovieDetails) in
      do {
        if let movieDetails = responseMovieDetails {
          XCTAssertEqual(movieDetails.adult, false)
          XCTAssertEqual(movieDetails.backdropPath, "/ezXodpP429qK0Av89pVNlaXWJkQ.jpg")
          XCTAssertEqual(movieDetails.budget, 60000000)
          XCTAssert((movieDetails.genres.count ) > 0)
          XCTAssertEqual(movieDetails.homepage, "http://www.jackreachermovie.com/")

          XCTAssertEqual(movieDetails.id, 75780)
          XCTAssertEqual(movieDetails.imdbID, "tt0790724")
          XCTAssertEqual(movieDetails.originalLanguage, "en")
          XCTAssertEqual(movieDetails.originalTitle, "Jack Reacher")
          XCTAssertEqual(movieDetails.overview, "When a gunman takes five lives with six shots, all evidence points to the suspect in custody. On interrogation, the suspect offers up a single note: \"Get Jack Reacher!\" So begins an extraordinary chase for the truth, pitting Jack Reacher against an unexpected enemy, with a skill for violence and a secret to keep.")

          XCTAssertEqual(movieDetails.popularity, 14.165)
          XCTAssertEqual(movieDetails.posterPath, "/38bmEXmuJuInLs9dwfgOGCHmZ7l.jpg")
          XCTAssert((movieDetails.productionCompanies.count) > 0 )
          XCTAssert((movieDetails.productionCountries.count) > 0 )
          XCTAssertEqual(movieDetails.releaseDate, "2012-12-20")

          XCTAssertEqual(movieDetails.revenue, 218340595)
          XCTAssertEqual(movieDetails.runtime, 130)
          XCTAssert((movieDetails.spokenLanguages.count) > 0 )
          XCTAssertEqual(movieDetails.status, "Released")
          XCTAssertEqual(movieDetails.tagline, "The Law Has Limits. He Does Not.")

          XCTAssertEqual(movieDetails.title, "Jack Reacher")
          XCTAssertEqual(movieDetails.video, false)
          XCTAssertEqual(movieDetails.voteAverage, 6.4)
          XCTAssertEqual(movieDetails.voteCount, 3829)

        } else {
          XCTFail("Did not expect a nil object")
        }
      } catch {
        XCTFail("Fails on parsing model")
      }
      expect.fulfill()
    }, failedBlock: {
    })
    waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error, "Test time ount. \(error!.localizedDescription)")
    }
  }
  
}
