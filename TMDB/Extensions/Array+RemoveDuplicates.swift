//
//  Array+RemoveDuplicates.swift
//  TMDB
//
//  Created by Taimur Ajmal on 10/2/18.
//  Copyright © 2018 Taimur Ajmal. All rights reserved.
//

import Foundation

extension Array where Element:Equatable {
  func removeDuplicates() -> [Element] {
    var result = [Element]()

    for value in self {
      if result.contains(value) == false {
        result.append(value)
      }
    }

    return result
  }
}
