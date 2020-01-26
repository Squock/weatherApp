//
//  CoreData.swift
//  WeatherApp
//
//  Created by Admin on 26.01.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import CoreData
import GoogleMaps
import GooglePlaces

class CoreData{
    func saveCoreData(description: String, main: String, city: String, temp: Double, tempMax: Double, tempMin: Double, feelsLike: Double){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Weather", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(description, forKey: "descriptionData")
        newUser.setValue(main, forKey: "mainData")
        newUser.setValue(city, forKey: "cityData")
        newUser.setValue(temp, forKey: "tempData")
        newUser.setValue(tempMax, forKey: "tempMaxData")
        newUser.setValue(tempMin, forKey: "tempMinData")
        newUser.setValue(feelsLike, forKey: "feelsLikeData")
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        newUser.setValue(date, forKey: "date")
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
}
