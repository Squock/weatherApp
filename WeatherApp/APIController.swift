//
//  APIController.swift
//  WeatherApp
//
//  Created by Admin on 24.01.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import GoogleMaps

class APIController{
    func postData(latitude: CLLocationDegrees, longitude: CLLocationDegrees, units: String, api: String, view: UIViewController)->Data{
        var dataResult = Data()
        let semaphore = DispatchSemaphore(value: 0)
        let api = "\(api)lat=\(latitude)&lon=\(longitude)&lang=ru&units=\(units)&appid=5c3125ea8576e95adb7fda6f1fade0c6"
        //let api = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&lang=ru&units=\(units)&appid=5c3125ea8576e95adb7fda6f1fade0c6"
        //https://api.openweathermap.org/data/2.5/forecast/daily?lat=%7Blat%7D&lon=%7Blon%7D&cnt=%7Bcnt%7D
        var request = URLRequest(url: URL(string: api)!)
        request.httpMethod = "GET"
        //request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request){(data, responce, error) in
            if error != nil{
                //DispatchQueue.main.async {
                  //  AlertError.showAlert(title: "Внимание", message: "Ошибка интернет соединения. Введите повторно ваш pin код", in: view)
                //}
                //AlertError().networkError(in: view)
                //ADD alert
                AlertErrorController().showAlert(title: "Внимание", message: "Ошибка сервера", in: view)
            }
            else{
                guard let data = data else {return}
               // let responceJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                //print("RESPONCE", responceJSON)
                dataResult = data
                semaphore.signal()
            }
            
        }
        task.resume()
        semaphore.wait()
        return dataResult
    }
}

