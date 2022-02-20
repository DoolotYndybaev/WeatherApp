//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Doolot on 20/2/22.
//
import Foundation
import UIKit
import SnapKit

class WeatehrCell: UITableViewCell {
    
    private lazy var dayeTempiratura: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        view.text = "15c day"
        return view
    }()
    
    private lazy var nitheTempiratura: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        view.text = "nitge -1c"
        return view
    }()
    
    private lazy var iconWeatehr: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    override func layoutSubviews() {
        addSubview(dayeTempiratura)
        dayeTempiratura.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        addSubview(nitheTempiratura)
        nitheTempiratura.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        addSubview(iconWeatehr)
        iconWeatehr.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(40)
        }
    }
    func fill(dayOne: DailyForecast?) {
            dayeTempiratura.text = "\(dayOne?.temperature?.maximum?.value ?? 0)C"
            
            nitheTempiratura.text = "\(dayOne?.temperature?.minimum?.value ?? 0 )C"
            
            let icom = dayOne?.night?.icon
            
            if (icom ?? 0) > 9 {
                iconWeatehr.kf.setImage(with: URL(string: "https://developer.accuweather.com/sites/default/files/\((icom ?? 0))-s.png")!)
            } else {
                iconWeatehr.kf.setImage(with: URL(string: "https://developer.accuweather.com/sites/default/files/0\((icom ?? 0))-s.png")!)
            }
        }
}
