//
//  ViewController.swift
//  WeatherApp
//
//  Created by Admin on 24.01.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, MapViewControllerDelegate{
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempRangeLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let controller = storyboard!.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        addChild(controller)
        dimView.addSubview(controller.view)
        controller.delegate = self
        controller.didMove(toParent: self)
    }
    func weather(description: String, main: String, city: String, temp: Double, tempMax: Double, tempMin: Double, feelsLike: Double) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Weather", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        let requestDel = NSFetchRequest<NSFetchRequestResult>(entityName: "Weather")
        if let result = try? context.fetch(requestDel) {
            for object in result {
                context.delete(object as! NSManagedObject)
            }
        }
        
        descriptionLabel.text = description
        cityLabel.text = city
        tempLabel.text = "\(temp)"
        tempRangeLabel.text = "\(tempMin) / \(tempMax)"
        feelsLikeLabel.text = "Ощущается как: \(feelsLike)"
        
        newUser.setValue(description, forKey: "descriptionData")
        newUser.setValue(main, forKey: "mainData")
        newUser.setValue(city, forKey: "cityData")
        newUser.setValue(temp, forKey: "tempData")
        newUser.setValue(tempMax, forKey: "tempMaxData")
        newUser.setValue(tempMin, forKey: "tempMinData")
        newUser.setValue(feelsLike, forKey: "feelsLikeData")
        print("sdsd", main)
    }
}
