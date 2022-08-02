//
//  HomeTableViewCell.swift
//  Weather_RxSwift
//
//  Created by Florian on 01/08/2022.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var iconLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var item: cellData! {
        didSet {
            setProductData()
        }
    }
    
    private func setProductData() {
        cityLbl.text = item.city
        tempLbl.text = item.temp
        iconLbl.text = item.icon
    }
}
