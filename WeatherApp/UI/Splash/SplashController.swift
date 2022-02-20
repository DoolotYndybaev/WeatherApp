//
//  ViewController.swift
//  WeatherApp
//
//  Created by Doolot on 20/2/22.
//

import UIKit

class SplashController: UIViewController {

    var api = "VO9jkGVnMXyFdJTNVvpRrZG1ZyjnGbsc"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        if UserDefaults.standard.string(forKey: "City") != nil {
            navigationController?.pushViewController(MainConntroller(), animated: true)
        } else {
            navigationController?.pushViewController(SearchController(), animated: true)
        }

    }


}

