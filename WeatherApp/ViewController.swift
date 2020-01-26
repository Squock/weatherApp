//
//  ViewController.swift
//  WeatherApp
//
//  Created by Admin on 24.01.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController, MapViewControllerDelegate{
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempRangeLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        addChild(controller)
        dimView.addSubview(controller.view)
        controller.delegate = self
        controller.didMove(toParent: self)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Weather")
        fetchRequest.returnsObjectsAsFaults = false
        do{
            
            let result = try context.fetch(fetchRequest)
            for data in result as! [NSManagedObject]{
                let timeInterval = date.timeIntervalSince(data.value(forKey: "date") as! Date) / 60 / 60 / 24
                if timeInterval >= 1{
                    controller.mapView(controller.mapView, didTapAt: CLLocationCoordinate2D(latitude: UserDefaults.standard.double(forKey: "latitude"), longitude: UserDefaults.standard.double(forKey: "longitude")))
                }
                else{
                    guard let descriptionData = data.value(forKey: "descriptionData") as? String, let cityData = data.value(forKey: "cityData") as? String else {return}
                    setLabelText(description: descriptionData, city: cityData, temp: data.value(forKey: "tempData") as! Double, tempMin: data.value(forKey: "tempMinData") as! Double, tempMax: data.value(forKey: "tempMaxData") as! Double, feelsLike: data.value(forKey: "feelsLikeData") as! Double)
                    
                    let camera = GMSCameraPosition.camera(withLatitude: UserDefaults.standard.double(forKey: "latitude") - 50, longitude: UserDefaults.standard.double(forKey: "longitude") - 10, zoom: 3)
                    controller.mapView.camera = camera
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: UserDefaults.standard.double(forKey: "latitude"), longitude: UserDefaults.standard.double(forKey: "longitude"))
                    marker.map = controller.mapView
                    controller.mapView(controller.mapView, didTapAt: CLLocationCoordinate2D(latitude: UserDefaults.standard.double(forKey: "latitude"), longitude: UserDefaults.standard.double(forKey: "longitude")))
                }
            }
        } catch{
            print("FAILED")
        }
        
        
    }
    func weather(description: String, main: String, city: String, temp: Double, tempMax: Double, tempMin: Double, feelsLike: Double) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let requestDel = NSFetchRequest<NSFetchRequestResult>(entityName: "Weather")
        if let result = try? context.fetch(requestDel) {
            for object in result {
                context.delete(object as! NSManagedObject)
            }
        }
        setLabelText(description: description, city: city, temp: temp, tempMin: tempMin, tempMax: tempMax, feelsLike: feelsLike)
        CoreData().saveCoreData(description: description, main: main, city: city, temp: temp, tempMax: tempMax, tempMin: tempMin, feelsLike: feelsLike)
    }
    
    func setLabelText(description: String, city: String, temp: Double, tempMin: Double, tempMax: Double, feelsLike: Double){
        descriptionLabel.text = description
        cityLabel.text = city
        tempLabel.text = "\(temp)"
        tempRangeLabel.text = "\(tempMin) / \(tempMax)"
        feelsLikeLabel.text = "Ощущается как: \(feelsLike)"
    }
    @IBAction func segmentControlAction(_ sender: UISegmentedControl) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        addChild(controller)
        dimView.addSubview(controller.view)
        controller.delegate = self
        controller.didMove(toParent: self)
        if sender.selectedSegmentIndex == 1{
            controller.units = "imperial"
            controller.mapView(controller.mapView, didTapAt: CLLocationCoordinate2D(latitude: UserDefaults.standard.double(forKey: "latitude"), longitude: UserDefaults.standard.double(forKey: "longitude")))
        }
        else{
            controller.mapView(controller.mapView, didTapAt: CLLocationCoordinate2D(latitude: UserDefaults.standard.double(forKey: "latitude"), longitude: UserDefaults.standard.double(forKey: "longitude")))
        }
    }
    
}
