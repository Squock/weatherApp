//
//  MapViewController.swift
//  WeatherApp
//
//  Created by Admin on 24.01.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController{
    @IBOutlet weak var mapView: GMSMapView!
    var delegate: MapViewControllerDelegate?
    var units = "metric"
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
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
        if statusBarOrientation?.isLandscape == true{
            mapView.frame = CGRect(x: 0, y: 0, width: screen.width / 2, height: screen.height)
        }
        else{
            mapView.frame = CGRect(x: 0, y: 0, width: 414, height: screen.height / 2)
        }
    }
}

extension MapViewController: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        mapView.clear()//Remove past marker
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        UserDefaults.standard.set(coordinate.latitude, forKey: "latitude")
        UserDefaults.standard.set(coordinate.longitude, forKey: "longitude")
        marker.map = mapView
        let api = "https://api.openweathermap.org/data/2.5/weather?"
        guard let data = try? JSONDecoder().decode(WeatherModel.self, from: APIController().postData(latitude: coordinate.latitude, longitude: coordinate.longitude, units: units, api: api, view: self)) else{
            AlertErrorController().showAlert(title: "Внимание", message: "Ошибка сервера", in: self)
            return
        }
        //mapView.frame
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 4)
        mapView.camera = camera
        self.screenOrientation()
        for weather in data.weather{
            delegate?.weather(description: weather.description, main: weather.main, city: data.name, temp: data.main.temp, tempMax: data.main.tempMax, tempMin: data.main.tempMin, feelsLike: data.main.feelsLike)
        }
    }
}
