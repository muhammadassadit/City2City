//
//  AlertViewController.swift
//  City2CityApp
//
//  Created by muhammad on 10/14/19
//  Copyright © 2019 muhammad. All rights reserved.
//
import UIKit

class AlertViewController: UIViewController {
    
    
    @IBOutlet weak var alertMainView: UIView!
    @IBOutlet weak var alertCityLabel: UILabel!
    @IBOutlet weak var alertDescriptionLabel: UILabel!
    
    @IBOutlet weak var alertDegreeLabel: UILabel!
    @IBOutlet weak var alertHumidityLabel: UILabel!
    @IBOutlet weak var alertSpeedLabel: UILabel!
    
    //Tuple - collection of data structures
    //var alertTuple = (City?, Weather?)(nil, nil)
    
    var city: City!
    var weather: Weather!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertMainView.layer.cornerRadius = 25
        alertCityLabel.text = "\(city.name), \(city.state)"
        alertDescriptionLabel.text = weather.description

        alertDegreeLabel.text = "\(weather.temp) Degrees"
        alertHumidityLabel.text = "\(weather.humidity) Humidity"
        alertSpeedLabel.text = "\(weather.windSpeed!) Wind Speed"
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        if touch.view == view {
            dismiss(animated: true, completion: nil)
        }
    }
}


extension AlertViewController {
    
    static func newInstance(city: City, weather: Weather) -> AlertViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let weatherAlert = storyboard.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
        weatherAlert.city = city
        weatherAlert.weather = weather
        return weatherAlert
    }
    
}

