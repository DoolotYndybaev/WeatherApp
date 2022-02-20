//
//  SearchController.swift
//  WeatherApp
//
//  Created by Doolot on 20/2/22.
//

import Foundation
import UIKit
import SnapKit

class SearchController: UIViewController {
    private lazy var searchField: UITextField = {
        let view = UITextField()
        view.layer.cornerRadius = 8
        view.backgroundColor = .black
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 20)
        view.attributedPlaceholder =
        NSAttributedString(string: "City name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        view.leftViewMode = .always
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    private lazy var serachButton: UIButton = {
        let view = UIButton()
        view.layer.cornerRadius = 8
        view.backgroundColor = .black
        view.setTitle("Search", for: .normal)
        view.addTarget(self, action: #selector(clickSearch(view:)), for: .touchUpInside)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    private lazy var seacheTable: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .black
        return view
    }()
    
    private var models: [SeacheModel]? = nil
    
    @objc func clickSearch(view: UIButton) {
        getSearchCity()
    }
    
    private func getSearchCity() {
        var url = URLComponents(string: "http://dataservice.accuweather.com/locations/v1/cities/autocomplete")!
        url.queryItems = [
            URLQueryItem(name: "q", value: searchField.text ?? String()),
            URLQueryItem(name: "apikey", value: "VO9jkGVnMXyFdJTNVvpRrZG1ZyjnGbsc"),
            URLQueryItem(name: "language", value: "en"),
        ]
        
        var request = URLRequest(url: url.url!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                if let data = data {
                    let model = try JSONDecoder().decode([SeacheModel].self, from: data)
                    
                    self.models = model
                    
                    DispatchQueue.main.async {
                        self.seacheTable.reloadData()
                    }
                    
                    dump(model)
                }
            } catch {
                
            }
        }.resume()
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .black
        
        view.addSubview(searchField)
        searchField.snp.makeConstraints { make in
            make.top.equalTo(view.safeArea.top).offset(10)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(40)
            make.width.equalTo(200)
        }
        
        view.addSubview(serachButton)
        serachButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeArea.top).offset(10)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(40)
            make.left.equalTo(searchField.snp.right).offset(10)
        }
        
        view.addSubview(seacheTable)
        seacheTable.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeArea.bottom)
            make.left.right.equalToSuperview()
            make.top.equalTo(searchField.snp.bottom).offset(16)
        }
    }
}

extension SearchController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = models?[indexPath.row]
        
        if let model = model {
            UserDefaults.standard.set(model.key ?? String(),forKey: "City")
            UserDefaults.standard.set(model.localizedName ?? String(),forKey: "CityName")

            
            navigationController?.pushViewController(MainConntroller(), animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 + 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models?[indexPath.row]
        let cell = SeachCituSell()
        
        cell.fill(model: model)
        
        return cell
    }
}
