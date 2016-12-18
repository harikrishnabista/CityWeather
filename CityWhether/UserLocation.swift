//
//  UserLocation.swift
//  CityWhether
//
//  Created by Hari Krishna Bista on 12/17/16.
//  Copyright © 2016 meroApp. All rights reserved.
//

import UIKit

class UserLocation: NSObject,NSCoding {
    var city:String = "";
    var state:String = "";
    var country:String = "";
    
    override init() {
        if let usr = UserLocation.getUserLocation(){
            self.city = usr.city;
            self.state = usr.state;
            self.country = usr.country;
        }
    }
    
    func getFormattedLocation() -> String {
        
        var tempLoc = "";
        
        if(!self.city.isEmpty){
            tempLoc = tempLoc + self.city;
        }
        
        if(!self.state.isEmpty){
            tempLoc = tempLoc + ", " + self.state;
        }
        
        if(!self.country.isEmpty){
            tempLoc = tempLoc + ", " + self.country;
        }
        
        if(tempLoc.isEmpty){
            return "Search for new city";
        }
        
        return tempLoc;
    }
    
    init(newCity:String, newState:String, newCountry:String) {
        self.city = newCity;
        self.country = newCountry;
        self.state = newState;
    }
    
    func saveUserLocation() {
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self);
        userDefaults.set(encodedData, forKey: "userLoc")
        userDefaults.synchronize()
    }
    
    static func getUserLocation() -> UserLocation? {
        //retrieve data
        let userDefaults = UserDefaults.standard;
        
        if let decoded  = userDefaults.object(forKey: "userLoc") as? Data {
            let decodedUserLoc = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UserLocation;
            return decodedUserLoc;
        }
        
        return nil;
    }
    
    //protocol methods
    required convenience init(coder aDecoder: NSCoder) {
        let city = aDecoder.decodeObject(forKey: "city") as! String;
        let state = aDecoder.decodeObject(forKey: "state") as! String;
        let country = aDecoder.decodeObject(forKey: "country") as! String;
        
        self.init(newCity:city, newState:state, newCountry:country);
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.city, forKey: "city");
        aCoder.encode(self.state, forKey: "state");
        aCoder.encode(self.country, forKey: "country");
    }
}
