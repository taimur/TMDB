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
    TMDBCatalogueManager.sharedInstance.getMovies(withKeywords: "Batman", forPageNumber: "1", successBlock: { (results, _) in
      let movies = results as? [Movie]
      XCTAssertNotNil(movies, "Movies Fetched successfully")
      expect.fulfill()
    }, failedBlock: {
    })
    waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error, "Test time ount. \(error!.localizedDescription)")
    }
  }

  func testFetchMoviesDetails() {

    let expect = expectation(description: "fetch tags")
    TMDBCatalogueManager.sharedInstance.getMovies(withKeywords: "Batman", forPageNumber: "1", successBlock: { (results, _) in
      let movies = results as? [MovieDetails]
      XCTAssertNotNil(movies, "Movies Fetched successfully")
      expect.fulfill()
    }, failedBlock: {
    })
    waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error, "Test time ount. \(error!.localizedDescription)")
    }
  }
}
