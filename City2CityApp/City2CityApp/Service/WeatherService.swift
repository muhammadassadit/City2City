//
//  WeatherService.swift
//  City2CityApp
//
//  Created by muhammad on 10/14/19
//  Copyright © 2019 muhammad. All rights reserved.
//

import Foundation


final class WeatherService {
    
    static let shared = WeatherService()
    private init() {}
    
    
    func getWeather(from city: City, completion: @escaping (Weather?) -> Void) {
        
        guard let url = WeatherAPI(city: city).getUrl else {
            completion(nil)
            return //exit the scope for the function - return the function
        }
        
        //API Request - URLSessions and data task
        //Data task start in a suspended state
        URLSession.shared.dataTask(with: url) { (dat, _, err) in
            
            if let error = err {
                print("Bad Data Task: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let data = dat {
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                    let weather = Weather(dict: jsonResponse)
                    completion(weather)
                } catch {
                    print("Couldn't Serialize Object: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
            }
            
        }.resume()
    }
    
    
    
    
    
}
