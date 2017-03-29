//
//  PageVC.swift
//  Weather Gift
//
//  Created by Angela Zhang on 3/4/17.
//  Copyright © 2017 Angela Zhang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherLocation {
    var name = ""
    var coordinates = ""
    var currentTemp = -999.99
    var dailySummary = ""
    
    func getWeather(completed: @escaping () -> ()) {
        
        let weatherURL = urlBase + urlAPIKey + coordinates
        print(weatherURL)
        Alamofire.request(weatherURL).responseJSON {response in
            switch response.result {
            case .success(let value) :
                let json = JSON(value)
                if let temperature = json["currently"]["temperature"].double {
                    print("TEMP inside getWeather = \(temperature)")
                    self.currentTemp = temperature
                } else {
                    print("Could not return a termperature!")
                }
                print("%%%%% currentTemp = \(self.currentTemp) for location = \(self.name)")
                if let summary = json["daily"]["summary"].string {
                    print("SUMMARY inside getWeather = \(summary)")
                    self.dailySummary = summary
                } else {
                    print("Could not return a Summary!")
                }
            case .failure (let error):
                print(error)
            }
            completed()
        }
    }
}


