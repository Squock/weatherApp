//
//  DaysWeatherTableViewController.swift
//  WeatherApp
//
//  Created by Admin on 26.01.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class DaysWeatherTableViewController: UITableViewController {
    var units = ""
    var weatherData: DaysWeatherModel!
    var weatherList = [(day: String, main: DaysWeatherMainList, weather: [DaysWeatherArray])]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDaysWeather()
        parseList()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return weatherList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DaysWeatherTableViewCell
        cell.dayLabel.text = weatherList[indexPath.row].day
        cell.tempLabel.text = "\(weatherList[indexPath.row].main.tempMin)/\(weatherList[indexPath.row].main.tempMax)"
        
        for weather in weatherList[indexPath.row].weather{
            cell.wheatherImage.image = UIImage(named: "\(weather.main)")
        }
        return cell
    }
    func initDaysWeather(){
        let api = "https://api.openweathermap.org/data/2.5/forecast?"
        guard let data = try? JSONDecoder().decode(DaysWeatherModel.self, from: APIController().postData(latitude: UserDefaults.standard.double(forKey: "latitude"), longitude: UserDefaults.standard.double(forKey: "longitude"), units: units, api: api, view: self)) else{
            AlertErrorController().showAlert(title: "Внимание", message: "Ошибка сервера", in: self)
            return
        }
        weatherData = data
    }
    func parseList(){
        let daysFormatter = DateFormatter()
        daysFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd:MM:yyyy"
        daysFormatter.timeZone = TimeZone(secondsFromGMT: weatherData.city.timezone)
        for index in 1..<weatherData.list.count{
            guard let currentDay = daysFormatter.date(from: weatherData.list[index].dtTxt), let previousDay = daysFormatter.date(from: weatherData.list[index-1].dtTxt) else {return}
            let calendar = Calendar.current
            if calendar.component(.day, from: currentDay) != calendar.component(.day, from: previousDay){
                let day = dateFormatter.string(from: currentDay)
                self.weatherList.append((day: day, main: weatherData.list[index].main, weather: weatherData.list[index].weather))
            }
            
        }
    }
    @IBAction func closeAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

}
