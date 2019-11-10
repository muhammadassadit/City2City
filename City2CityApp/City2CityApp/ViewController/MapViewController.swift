//
//  MapViewController.swift
//  City2CityApp
//
//  Created by muhammad on 10/14/19
//  Copyright © 2019 muhammad. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    //dependency injection - give an object's dependency from the outside
    var city: City!
    var weather: Weather!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let region = MKCoordinateRegion(center: city.coordinates, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.region = region
        
        WeatherService.shared.getWeather(from: city) { [weak self] wthr in
            if let weather = wthr {
                self?.weather = weather
                print("\(self!.city.name), \(self!.city.state) Weather: \(weather.description)")
            }
        }
        
        let weatherButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(weatherButtonTapped))
        navigationItem.rightBarButtonItem = weatherButton
        
    }
    
    @objc func weatherButtonTapped() {
        
        let alert = AlertViewController.newInstance(city: city, weather: weather)
        present(alert, animated: true, completion: nil)
    }
    

}
