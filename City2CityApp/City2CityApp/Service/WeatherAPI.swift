//
//  WeatherAPI.swift
//  City2CityApp
//
//  Created by muhammad on 10/14/19
//  Copyright © 2019 muhammad. All rights reserved.
//

import Foundation



struct WeatherAPI {
    //https://api.openweathermap.org/data/2.5/weather?lat=42.3314&lon=83.0458&units=imperial&APPID=7cdcd7f9a8620c069b7159b27a5f7a34
    
    var city: City!
    
    init(city: City) {
        self.city = city
    }
    
    let base = "https://api.openweathermap.org/data/2.5/weather?"
    let key = "&units=imperial&APPID=7cdcd7f9a8620c069b7159b27a5f7a34"
    
    var getUrl: URL? {
        return URL(string: base + "lat=\(city.coordinates.latitude)&lon=\(city.coordinates.longitude)" + key )
    }
    
}
