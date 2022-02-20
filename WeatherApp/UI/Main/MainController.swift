//
//  MainController.swift
//  WeatherApp
//
//  Created by Doolot on 20/2/22.
//

import Foundation
import UIKit
import Kingfisher

class MainConntroller: UIViewController {
    
    private lazy var titleCity: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        view.text = "Biskek"
        return view
    }()
    
    private lazy var iconTemp: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var tempiraturaLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 25)
        view.text = "15c/5c"
        return view
    }()
    
    private lazy var cenetrTempiraturaLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 20)
        view.text = "Average 10c"
        return view
    }()
    
    private lazy var dayForcasrtTAble: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .black
        return view
    }()
    
    var dailyForecasts: [DailyForecast]? = nil
    
    override func viewDidLoad() {
        view.backgroundColor = .black
        
        view.addSubview(titleCity)
        titleCity.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeArea.top).offset(20)
        }
        
        view.addSubview(iconTemp)
        iconTemp.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleCity.snp.bottom).offset(10)
            make.height.width.equalTo(50)
        }
        
        view.addSubview(tempiraturaLabel)
        tempiraturaLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.iconTemp.snp.bottom).offset(10)
        }
                
        view.addSubview(cenetrTempiraturaLabel)
        cenetrTempiraturaLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.tempiraturaLabel.snp.bottom).offset(5)
        }
        
        view.addSubview(dayForcasrtTAble)
        dayForcasrtTAble.snp.makeConstraints { make in
            make.top.equalTo(cenetrTempiraturaLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeArea.bottom)
        }
        getWeagery()
    }
    private func getWeagery() {
            let cityKey = UserDefaults.standard.string(forKey: "City")!
            var url = URLComponents(string: "http://dataservice.accuweather.com/forecasts/v1/daily/5day/\(cityKey)")!
            url.queryItems = [
                URLQueryItem(name: "apikey", value: "VO9jkGVnMXyFdJTNVvpRrZG1ZyjnGbsc"),
                URLQueryItem(name: "language", value: "en"),
                URLQueryItem(name: "details", value: "false"),
                URLQueryItem(name: "metric", value: "true"),
            ]
            
            var request = URLRequest(url: url.url!)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                do {
                    if let data = data {
                        let model = try JSONDecoder().decode(WeaherModel.self, from: data)
                       
                        DispatchQueue.main.async {
                            self.setupView(model: model)
                        }
                        
                        dump(model)
                    }
                } catch {
                    
                }
            }.resume()
        }
    func setupView(model: WeaherModel?) {
            titleCity.text = UserDefaults.standard.string(forKey: "CityName")
            let dayOne = model?.dailyForecasts?[0]
            
            tempiraturaLabel.text = "\(dayOne?.temperature?.maximum?.value ?? 0)C / \(dayOne?.temperature?.minimum?.value ?? 0 )C"
            
            let s = ((dayOne?.temperature?.maximum?.value ?? 0) + (dayOne?.temperature?.minimum?.value ?? 0 )) / 2
            
            cenetrTempiraturaLabel.text = "Average \(s)C"
            
            let icom = dayOne?.night?.icon
            
            if (icom ?? 0) > 9 {
                iconTemp.kf.setImage(with: URL(string: "https://developer.accuweather.com/sites/default/files/\((icom ?? 0))-s.png")!)
            } else {
                iconTemp.kf.setImage(with: URL(string: "https://developer.accuweather.com/sites/default/files/0\((icom ?? 0))-s.png")!)
            }
            
            
            var newModel =  model?.dailyForecasts
            
            newModel?.remove(at: 0)
            
            self.dailyForecasts = newModel
            dayForcasrtTAble.reloadData()
        }
}

extension MainConntroller: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyForecasts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dailyForecasts?[indexPath.row]
        let cell = WeatehrCell()
        
        cell.fill(dayOne: model)
        
        return cell
    }
}
