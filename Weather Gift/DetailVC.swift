//
//  DeatilVC.swift
//  Weather Gift
//
//  Created by Angela Zhang on 3/4/17.
//  Copyright © 2017 Angela Zhang. All rights reserved.
//

import UIKit
import CoreLocation

class DetailVC: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var currentImage: UIImageView!
    
    var currentPage = 0
    var locationsArray = [WeatherLocation] ()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        updateUserInterface()
        locationsArray[currentPage].getWeather {
            self.updateUserInterface()
            print("************", self.locationsArray[self.currentPage].currentTemp)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if currentPage == 0 {
            getLocation()
        }
       
    }
    
    
    func updateUserInterface() {
        let isHidden = (locationsArray[currentPage].currentTemp == -999.9)
        temperatureLabel.isHidden = isHidden
        locationLabel.isHidden = isHidden
        
        locationLabel.text = locationsArray[currentPage].name
        dateLabel.text = locationsArray[currentPage].coordinates
        let curTemperature = String(format: "%3.f", locationsArray[currentPage].currentTemp) + "°" 
        
        temperatureLabel.text = curTemperature
        print("%%% curTemperature inside updateUserInterface = \(curTemperature)")
        summaryLabel.text = locationsArray[currentPage].dailySummary
        
    }
}

extension DetailVC: CLLocationManagerDelegate {
    
    func getLocation(){
        let status = CLLocationManager.authorizationStatus()
        handleLocationAuthorizationStatus(status)
    }
    func handleLocationAuthorizationStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied:
            print("I'm sorry - I can't show location. User has not authorized it")
        case .restricted:
            print("Access denied")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleLocationAuthorizationStatus(status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if currentPage == 0 {
            let geoCoder = CLGeocoder()
            currentLocation = locations.last
            
            let currentLat = "\(currentLocation.coordinate.latitude)"
            let currentLong = "\(currentLocation.coordinate.longitude)"
            print("Coordinates are: " + currentLat + currentLong)
            
            var place = " "
            geoCoder.reverseGeocodeLocation(currentLocation, completionHandler: {placemarks, error in
                if placemarks != nil {
                    let placemark = placemarks!.last
                    place = (placemark?.name)!
                } else {
                    print("error in retrieving place. Error code: \(error)")
                    place = "Parts Unknown"
                }
                print (place)
                self.locationsArray[0].name = place
                self.locationsArray[0].coordinates = currentLat + "," + currentLong
                self.locationsArray[0].getWeather{
                self.updateUserInterface()
                }
                
            })
            
        }
        locationManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error getting location-error code \(error)")
    }
}

