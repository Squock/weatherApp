//
//  DaysWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Admin on 27.01.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class DaysWeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var wheatherImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
