//
//  DownloadService.swift
//  CatFacts
//
//  Created by Yurii Tsymbala on 1/4/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation

enum DownloadServiceError: Error {
  case firstError
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
  func fetchDataFromJSON(completion: @escaping (Result<[CatCellViewModel], Error>) -> Void)
}

class DownloadService: DownloadServiceType {

  private var cats: [Cat]!

  func fetchDataFromJSON(completion: @escaping (Result<[CatCellViewModel], Error>) -> Void) {
 completion(Result.success(generateCellViewModels()))
    //    let jsonURL = URL(string: "https://cat-fact.herokuapp.com/facts")!
    //    URLSession.shared.dataTask(with: jsonURL) { [weak self]  (data,_,error) in
    //      guard let strongSelf = self else { return }
    //      if error == nil {
    //        guard let data = data else { completion(Result.failure(DownloadServiceError.thirdError)); return }
    //        do {
    //          let decoder = JSONDecoder()
    //          strongSelf.cats = try decoder.decode([Cat].self, from: data)
    //          if let successfullyParsedCats = strongSelf.cats {
    //            // successfullyCats конвертнути в целлвюмоделс і передати в комплішн
    //          } else {
    //            completion(Result.failure(DownloadServiceError.fifthError))
    //          }
    //        } catch _ {
    //          completion(Result.failure(DownloadServiceError.fourthError))
    //        }
    //      } else {
    //        if let _ = error {
    //          completion(Result.failure(DownloadServiceError.firstError))
    //        } else {
    //          completion(Result.failure(DownloadServiceError.secondError))
    //        }
    //      }
    //      }.resume()
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

