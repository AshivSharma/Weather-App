//
//  ViewController.swift
//  WeatherApp
//
//  Created by Ashiv Sharma on 8/14/19.
//  Copyright © 2019 Ashiv Sharma. All rights reserved.
//
import Foundation
import UIKit
//import AlamoFire
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation
import Alamofire

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    let gradientLayer = CAGradientLayer()
    
    let apiKey = "962a8d224feb9563cedaff124506d12a" //Define API Key
    var lat = 33.7490 //Define default latitude
    var lon = 84.3880// Define default longitude
    var activityIndicator: NVActivityIndicatorView! //Loading bar for making requests to the internet
    let locationManager = CLLocationManager() //Gathers user location
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        backgroundView.layer.addSublayer(gradientLayer)
        
        //Activity Indicator
        let indicatorSize: CGFloat = 70 //Define size of indicator
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize) // Define frame of indicator
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
        activityIndicator.backgroundColor = UIColor.black //Set background color
        view.addSubview(activityIndicator)
        
        //User Location Manager
        locationManager.requestWhenInUseAuthorization() //Pop "Allow or dont allow location"
        if(CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest //Retrieves information about location
            locationManager.startUpdatingLocation()
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        setBlueGradientBackground() //Sets the background to the blue gradient fucntion
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations[0]
        lat = location.coordinate.latitude //sets latitude
        lon = location.coordinate.longitude //Sets longitude
        
        //Fire request to site
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric").responseJSON
            {
            response in
            self.activityIndicator.stopAnimating() //Stop activity indicaator once a response is given
            
            if let responseStr = response.result.value
            {
                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0] //Values taken from the above website with given coordinates in json
                let jsonTemp = jsonResponse["main"]
                let iconName = jsonWeather["icon"].stringValue
                
                self.locationLabel.text = jsonResponse["name"].stringValue //sets locaiton label to "name" in json
                self.conditionImageView.image = UIImage(named: iconName) //sets the condition image to the iconName
                self.conditionLabel.text = jsonWeather["main"].stringValue //sets codniton label to the main within weather json
                self.temperatureLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue)))"
                
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE"
                self.dayLabel.text = dateFormatter.string(from: date)
                
                let suffix = iconName.suffix(1)
                if(suffix == "n")
                {
                    self.setGreyGradientBackground()
                }
                else
                {
                    self.setBlueGradientBackground()
                }
                
            }
            self.locationManager.stopUpdatingLocation()
            
    }
    }
    
    
    func setBlueGradientBackground() //Color for blue gradient background
    {
        let topColor = UIColor(red: 95.0/255.0, green: 165.0/255.0, blue: 1.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 114.0/255.0, blue: 184.0/255.0, alpha: 1.0).cgColor
        
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor,bottomColor]
    }
    
    func setGreyGradientBackground() // color for grey gradient backgorund
    {
        let topColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 72.0/255.0, blue: 72.0/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
    }

}


