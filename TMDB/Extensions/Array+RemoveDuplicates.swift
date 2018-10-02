//
//  Array+RemoveDuplicates.swift
//  TMDB
//
//  Created by Taimur Ajmal on 10/2/18.
//  Copyright © 2018 Taimur Ajmal. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
  func removeDuplicates() -> Array {
    return reduce(into: []) { result, element in
      if !result.contains(element) {
        result.append(element)
      }
    }
  }
}
