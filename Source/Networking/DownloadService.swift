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
  case firstError = ""
  case secondError
  case thirdError
  case fourthError
  case fifthError
  case sixthError
  case seventhError
  case eighthError
  case ninthError
  case tenthError
  case eleventhError
}

protocol DownloadServiceType {
  func fetchDataFromJSON(completion: @escaping (Result<[CatCellViewModel], DownloadServiceError>) -> Void)
}

class DownloadService: DownloadServiceType {

   var cellViewModels = [CatCellViewModel]()

  func fetchDataFromJSON(completion: @escaping (Result<[CatCellViewModel], DownloadServiceError>) -> Void) {
    Alamofire.request("https://cat-fact.herokuapp.com/facts").responseJSON { [weak self] response in
      guard let strongSelf = self else { return }
      guard let json = response.result.value as? [String:Any] else {completion(Result.failure(DownloadServiceError.secondError));return}
      guard let data = json["all"] as? [[String: Any]] else {completion(Result.failure(DownloadServiceError.thirdError)); return}
      for dataItem in data {
        var cellViewModel = CatCellViewModel(name: "-", text: "-")
        let textforCell = dataItem["text"] as? String ?? "-"
        cellViewModel.text = textforCell
        let user = dataItem["user"] as? Dictionary<String, Any>
        if let unwrappedUser = user {
          for userInfo in unwrappedUser {
            if userInfo.key == "name" {
              let nameInfoTuple = userInfo.value as! Dictionary<String, Any>
              for names in nameInfoTuple {
                if names.key == "first" {
                  let firstName = names.value as! String
                  cellViewModel.name = firstName
                }
                if names.key == "last" {
                  cellViewModel.name.append(contentsOf: " \(names.value)")
                }
              }
              strongSelf.cellViewModels.append(cellViewModel) // finish
            } else {
              strongSelf.cellViewModels.append(cellViewModel)
            }
          }
        } else {
          strongSelf.cellViewModels.append(cellViewModel)
        }
      }
      completion(Result.success(strongSelf.cellViewModels))
    }
  }


  private func generateCellViewModels() -> [CatCellViewModel] {
    var array = [CatCellViewModel]()
    let first = CatCellViewModel(name: "Tom", text: "Cat from Cartoons")
    let second = CatCellViewModel(name: "Tom jerryy,Tom jerryy", text: "Cat from Cartoons,Cat from Cartoons")
    let third = CatCellViewModel(name: "Tom jerryy,Tom jerryy,Tom jerryy", text: "Cat from Cartoons,Cat from Cartoons,Cat from Cartoons")
    let fourth = CatCellViewModel(name: "Tom jerryy,Tom jerryy,Tom jerryy", text: "Great Cat")
    let fifth = CatCellViewModel(name: "Tom", text: "Cats see and hear extremely well. They can see in the dark and hear many sounds that humans are not able to hear. To feel their way round, cats use their whiskers.")
    let sixth = CatCellViewModel(name: "Tom jerryy lalallala", text: "Good Cat")
    array.append(first)
    array.append(second)
    array.append(third)
    array.append(fourth)
    array.append(fifth)
    array.append(sixth)
    return array
  }
}

