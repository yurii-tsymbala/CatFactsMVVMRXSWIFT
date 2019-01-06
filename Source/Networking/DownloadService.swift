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
  case firstError = "Bad Url"
  case secondError = "Bad JSON"
  case thirdError  = "Type Cast Error"
}

protocol DownloadServiceType {
  typealias DownloadHandler = (Result<[CatCellViewModel], DownloadServiceError>) -> Void
  func fetchDataFromJSON(completion: @escaping DownloadHandler)
}

class DownloadService: DownloadServiceType {

   private var cellViewModels = [CatCellViewModel]()

  func fetchDataFromJSON(completion: @escaping DownloadHandler) {
    Alamofire.request("https://cat-fact.herokuapp.com/facts").responseJSON { [weak self] response in
      guard let strongSelf = self else { return }
      guard let json = response.result.value as? [String:Any] else {completion(Result.failure(DownloadServiceError.secondError));return}
      guard let data = json["all"] as? [[String: Any]] else {completion(Result.failure(DownloadServiceError.thirdError)); return}
      for dataItem in data {
        var cellViewModel = CatCellViewModel(name: "", text: "")
        let textforCell = dataItem["text"] as? String ?? ""
        cellViewModel.text = textforCell
        let user = dataItem["user"] as? Dictionary<String, Any>
        if let unwrappedUser = user {
          for userInfo in unwrappedUser {
            if userInfo.key == "name" {
              let nameInfoTuple = userInfo.value as! Dictionary<String, Any>
              for names in nameInfoTuple {
                if names.key == "first" {
                  let firstName = names.value as! String
                  let fullName = (("\(firstName) ") + cellViewModel.name)
                  cellViewModel.name = fullName
                }
                if names.key == "last" {
                  cellViewModel.name.append(" ")
                  let lastName = names.value as! String
                  cellViewModel.name.append(contentsOf: lastName)
                }
              }
              strongSelf.cellViewModels.append(cellViewModel)
            }
          }
        } else {
          if cellViewModel.name.isEmpty {
            cellViewModel.name = "Unnamed"
          }
          strongSelf.cellViewModels.append(cellViewModel)
        }
      }
      completion(Result.success(strongSelf.cellViewModels))
    }
  }
}

