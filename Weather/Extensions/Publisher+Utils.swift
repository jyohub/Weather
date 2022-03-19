//
//  Publisher+Utils.swift
//  Weather
//
//  Created by jyohub on 2022/03/13.
//

import Combine

extension Publisher {
    
  func asResult() -> AnyPublisher<Result<Output, Failure>, Never> {
    self.map(Result.success)
      .catch { error in
        Just(.failure(error))
      }
      .eraseToAnyPublisher()
  }
}
