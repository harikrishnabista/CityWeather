//
//  WeatherInfo.swift
//  CityWhether
//
//  Created by Hari Krishna Bista on 12/17/16.
//  Copyright © 2016 meroApp. All rights reserved.
//

import UIKit

class WeatherInfo{
    var temp:Double?
    var temp_min:Double?
    var temp_max: Double?
    var pressure: Int?
    var humidity: Int?
    var visibility: Int?
    var sunrise: Date?
    var sunset: Date?
    var coudiness: String?
    var lat: Double?
    var lon: Double?
    var city: String?
    var state: String?
    var country: String?
    var weatherDescriptions:[String] = [];
    
    var windSpeed: Double?
    var windDir: Int?
    var updatedAt: Date?
    var cloud:Int?
    
    func getWheatherDesc() -> String {

        var temp="";
        for (i,str) in self.weatherDescriptions.enumerated() {
            
            if(i == self.weatherDescriptions.count-1){
                temp = temp + str;
            }else{
                temp = temp + str + ", ";
            }
        }
        
        return temp;
    }
    
    func getUpdatedDate() -> String {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm a";
        let time = formatter.string(from: self.sunrise!);

        return "Last updated at \(time)";
    }
    
    func getTempr() -> String {
        return "\(self.temp!) K";
    }

    //T(°F) = T(K) × 9/5 - 459.67
    func getTemprInFareinheit() -> String {
        let farein = self.temp! * 9/5 - 459.67;
        return "\(String(format: "%.2f", farein)) °F";
    }
    
    func getHumidity() -> String {
        return "\(self.humidity!) %";
    }
    
    func getWindSpeed() -> String {
        return "\(self.windSpeed!) m/s";
    }
    
    func getCloudiness() -> String {
        return "\(self.cloud!)";
    }
    
    func getCoords() -> String {
        return "[\(self.lat!),\(self.lon!)]";
    }
    
    func getWindDirection() -> String {
        
        let directions = ["North", "North East", "North Eeast", "East North", "East", "South East", "South East", "South East",
            "South", "SSW", "South West", "West South", "West", "West North", "North West", "North West"];
        
        let i:Int = Int((Double(self.windDir!) + 11.25)/22.5);
        
        return "\(directions[i%16])";
        
//        return "\(self.windDir!)";
    }
    
    func getSunrise() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let time = formatter.string(from: self.sunrise!);
        
        return time;
    }
    
    func getSunset() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let time = formatter.string(from: self.sunset!);
        return time;
    }
    
    func getPressure() -> String {
        return "\(self.pressure!) hpa";
    }
    
}
