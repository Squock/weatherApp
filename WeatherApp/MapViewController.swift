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

}
extension MapViewController: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        mapView.clear()//Remove past marker
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        UserDefaults.standard.set(coordinate.latitude, forKey: "latitude")
        UserDefaults.standard.set(coordinate.longitude, forKey: "longitude")
        marker.map = mapView
        guard let data = try? JSONDecoder().decode(WeatherModel.self, from: APIController().postData(latitude: coordinate.latitude, longitude: coordinate.longitude, units: units)) else{
            print("Error: No data to decode1")
            return
        }
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude - 50, longitude: coordinate.longitude - 10, zoom: 3)
        mapView.camera = camera
        for weather in data.weather{
            delegate?.weather(description: weather.description, main: weather.main, city: data.name, temp: data.main.temp, tempMax: data.main.tempMax, tempMin: data.main.tempMin, feelsLike: data.main.feelsLike)
        }
    }
}
