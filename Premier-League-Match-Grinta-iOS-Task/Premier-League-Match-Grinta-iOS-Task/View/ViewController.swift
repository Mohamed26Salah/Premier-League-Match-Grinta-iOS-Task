//
//  ViewController.swift
//  Premier-League-Match-Grinta-iOS-Task
//
//  Created by Mohamed Salah on 12/10/2023.
//

import UIKit
import RxSwift
import RxCocoa
class ViewController: UIViewController {

    let disposeBag = DisposeBag()
       override func viewDidLoad() {
           super.viewDidLoad()

           // Do any additional setup after loading the view.
       }


}

//let headers = [
// "X-Auth-Token": SecurityConstants.Links.apiKey
//]
//
//APIManager().fetchGlobal(parsingType: Matches.self, baseURL: APIManager.EndPoint.matches(competitionCode: "PL").stringToUrl, headers: headers)
//    .observe(on: MainScheduler.instance)
//    .subscribe(
//        onNext: { test in
//         print(test)
//        },
//        onError: { error in
//            print(error)
//        }
//    )
//    .disposed(by: disposeBag)
