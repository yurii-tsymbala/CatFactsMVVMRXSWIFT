//
//  DownloadService.swift
//  CatFacts
//
//  Created by Yurii Tsymbala on 1/4/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation
import Alamofire

enum DownloadServiceError: String {
  case firstError = "Request Error"
  case secondError = "Data Response Error"
  case thirdError  = "Json Decoding Error"
}

protocol DownloadServiceType {
  typealias DownloadHandler = (Result<[CatCellViewModel], DownloadServiceError>) -> Void
  func fetchDataFromJSON(completion: @escaping DownloadHandler)
}

class DownloadService: DownloadServiceType {

  private var cellViewModels = [CatCellViewModel]()

  func fetchDataFromJSON(completion: @escaping DownloadHandler) {
    let jsonURL = URL(string: "https://cat-fact.herokuapp.com/facts")!
    URLSession.shared.dataTask(with: jsonURL) { [weak self]  (dataResponse,_,error) in
      guard let strongSelf = self else { return }
      if error == nil {
        guard let dataResponse = dataResponse else { completion(Result.failure(DownloadServiceError.secondError)); return }
        do {
          let json = try JSONDecoder().decode(Cats.self, from: dataResponse)
          for cat in json.cats {
            if let catUserName = cat.user?.name.fullName {
              strongSelf.cellViewModels.append(CatCellViewModel(name: catUserName,
                                                                text: cat.text))
            } else {
              strongSelf.cellViewModels.append(CatCellViewModel(name: "Unnamed",
                                                                text: cat.text))
            }
          }
          completion(Result.success(strongSelf.cellViewModels))
        } catch _ {
          completion(Result.failure(DownloadServiceError.thirdError))
        }
      } else {
        completion(Result.failure(DownloadServiceError.firstError))
      }
      }.resume()
  }
}

