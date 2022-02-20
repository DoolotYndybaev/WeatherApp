//
//  SearchCityCell.swift
//  WeatherApp
//
//  Created by Doolot on 20/2/22.
//
import Foundation
import UIKit

class SeachCituSell: UITableViewCell {
    
    private lazy var cityName: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        view.text = "Biskek"
        return view
    }()
    
    private lazy var cityType: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        view.text = "City"
        return view
    }()
    
    private lazy var cityCoutry: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        view.text = "Kyrgistan"
        return view
    }()
    
    private lazy var contqanerView = UIView()
    
    override func layoutSubviews() {
        contqanerView.layer.cornerRadius = 8
        contqanerView.backgroundColor = .lightGray
        
        addSubview(contqanerView)
        contqanerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        
        contqanerView.addSubview(cityName)
        cityName.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(8)
        }
        
        contqanerView.addSubview(cityType)
        cityType.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-8)
            make.left.equalToSuperview().offset(8)
        }
        
        contqanerView.addSubview(cityCoutry)
        cityCoutry.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-8)
            make.right.equalToSuperview().offset(-8)
        }
    }
    
    func fill(model: SeacheModel?) {
        cityName.text = model?.localizedName
        cityType.text = model?.type
        
        cityCoutry.text = model?.country?.localizedName
    }
}
