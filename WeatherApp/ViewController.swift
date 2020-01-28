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
    @IBOutlet weak var daysWeatherButton: UIButton!
    @IBOutlet weak var wheatherImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()
        self.screenOrientation()
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
                let calendar = Calendar.current
                if calendar.component(.day, from: date) == calendar.component(.day, from: data.value(forKey: "date") as! Date){
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
            AlertErrorController().showAlert(title: "Внимание", message: "Ошибка", in: self)
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
        wheatherImage.image = UIImage(named: "\(main)")
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
    @IBAction func daysWeatherButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "DaysWeatherTableViewController", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var units = "metric"
        if segue.identifier == "DaysWeatherTableViewController"{
            let destination = (segue.destination as! DaysWeatherTableViewController)
            if segmentControl.selectedSegmentIndex == 1{
                units = "imperial"
            }
            destination.units = units
        }
    }
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            self.screenOrientation()
        })
    }
    
    func screenOrientation(){
        let screen = UIScreen.main.bounds
        var statusBarOrientation: UIInterfaceOrientation? {
            get {
                guard let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else {
                    #if DEBUG
                    fatalError("Could not obtain UIInterfaceOrientation from a valid windowScene")
                    AlertErrorController().showAlert(title: "Внимание", message: "Ошибка", in: self)
                    #else
                    return nil
                    #endif
                }
                return orientation
            }
        }
        let labelY = screen.height / 2 / 5
        if statusBarOrientation?.isLandscape == true{
            self.cityLabel.frame = CGRect(x: 0, y: labelY, width: screen.width / 2, height: 20)
            self.descriptionLabel.frame = CGRect(x: 0, y: labelY + 30, width: screen.width / 2, height: 20)
            self.tempLabel.frame = CGRect(x: 0, y: labelY + 60, width: screen.width / 2, height: 20)
            self.wheatherImage.frame = CGRect(x: 0, y: labelY + 60, width: screen.width / 4, height: 60)
            self.tempRangeLabel.frame = CGRect(x: 0, y: labelY + 90, width: screen.width / 2, height: 20)
            self.feelsLikeLabel.frame = CGRect(x: 0, y: labelY + 120, width: screen.width / 2, height: 20)
            self.segmentControl.frame = CGRect(x: screen.width / 8, y: labelY + 150, width: screen.width / 4, height: 20)
            self.daysWeatherButton.frame = CGRect(x: 0, y: labelY + 180, width: screen.width / 2, height: 20)
            self.dimView.frame = CGRect(x: screen.width / 2, y: 0, width: screen.width / 2, height: screen.height)
        }
        else{
            self.cityLabel.frame = CGRect(x: 0, y: labelY, width: screen.width, height: 20)
            self.descriptionLabel.frame = CGRect(x: 0, y: labelY + 30, width: screen.width, height: 20)
            self.wheatherImage.frame = CGRect(x: 0, y: labelY + 60, width: screen.width / 2, height: 60)
            self.tempLabel.frame = CGRect(x: 0, y: labelY + 60, width: screen.width, height: 20)
            self.tempRangeLabel.frame = CGRect(x: 0, y: labelY + 90, width: screen.width, height: 20)
            self.feelsLikeLabel.frame = CGRect(x: 0, y: labelY + 120, width: screen.width, height: 20)
            self.segmentControl.frame = CGRect(x: screen.width / 4, y: labelY + 170, width: screen.width / 2, height: 20)
            self.daysWeatherButton.frame = CGRect(x: 0, y: labelY + 210, width: screen.width, height: 20)
            self.dimView.frame = CGRect(x: 0, y: screen.height / 2, width: screen.width, height: screen.height)
            self.dimView.frame = CGRect(x: 0, y: 448, width: 414, height: 500)
        }
    }
    
}
