
import UIKit
import Alamofire
import SwiftyJSON

class CityWhetherTableViewController: UITableViewController {
    
    var weatherInfo = WeatherInfo();
    var userLocation = UserLocation();
    
    var loadingView: UIView?
    
    @IBOutlet weak var lblGeocoords: UILabel!
    @IBOutlet weak var lblSunset: UILabel!
    @IBOutlet weak var lblSunrise: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblPressure: UILabel!
    @IBOutlet weak var lblcloud: UILabel!
    @IBOutlet weak var lblWeatherDesc: UILabel!
    @IBOutlet weak var lblWindDir: UILabel!
    @IBOutlet weak var lblTempr: UILabel!
    @IBOutlet weak var lblUpdatedDate: UILabel!
    @IBOutlet weak var lblWindSpeed: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad();
        self.weatherInfo = WeatherInfo();
        
        let bounds = UIScreen.main.bounds;
        let width = bounds.size.width
        let height = bounds.size.height
        
        self.loadingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height-40));
        self.loadingView?.backgroundColor = UIColor.darkGray;
        self.loadingView?.alpha = 0.5;
        
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        
        myActivityIndicator.center = (self.loadingView?.center)!;
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.startAnimating()
        
        self.loadingView?.addSubview(myActivityIndicator);
        
        self.view.addSubview(self.loadingView!);
        
        self.loadWheather();
    }
    
    func loadWheather() {
        
        let city = UtilitiesFunctions.removeWhiteSpaceByPlus(input: self.userLocation.city);
        let state = UtilitiesFunctions.removeWhiteSpaceByPlus(input: self.userLocation.state);
        let country = UtilitiesFunctions.removeWhiteSpaceByPlus(input: self.userLocation.country);
        
        let url:String = "http://api.openweathermap.org/data/2.5/weather?q=\(city),\(state),\(country)&APPID=d30a805c0ec576b72a78e0b87dabd064";
        
        Alamofire.request(url, method: .get).responseJSON { response in
            
            self.loadingView?.isHidden = true;
            
            switch(response.result){
                
            case .success(let jsn):
                
                let bigJosn = JSON(jsn);
                
                // guard for the wrong city name and wrong input
                guard bigJosn["cod"].intValue != 502 else {
                    self.title = bigJosn["message"].stringValue;
                    return;
                }
                
                // save user location to userdefaults

                self.weatherInfo.temp = bigJosn["main"]["temp"].doubleValue;
                self.weatherInfo.temp_min = bigJosn["main"]["temp_min"].doubleValue;
                self.weatherInfo.pressure = bigJosn["main"]["pressure"].intValue;
                self.weatherInfo.humidity = bigJosn["main"]["humidity"].intValue;
                self.weatherInfo.windSpeed = bigJosn["wind"]["speed"].doubleValue;
                self.weatherInfo.windDir = bigJosn["wind"]["deg"].intValue;
                
                let sunrise = bigJosn["sys"]["sunrise"].doubleValue;
                let sunset = bigJosn["sys"]["sunset"].doubleValue;
                
                self.weatherInfo.sunrise = Date(timeIntervalSince1970: TimeInterval(sunrise));
                self.weatherInfo.sunset = Date(timeIntervalSince1970: TimeInterval(sunset));
                                
                let updatedAt = bigJosn["dt"].intValue;

                self.weatherInfo.updatedAt = Date(timeIntervalSince1970: TimeInterval(updatedAt));
                
                self.userLocation.city = bigJosn["name"].stringValue;
                self.userLocation.country = bigJosn["sys"]["country"].stringValue;
                
                self.weatherInfo.cloud = bigJosn["clouds"]["all"].intValue;
                
                self.weatherInfo.lat = bigJosn["coord"]["lat"].doubleValue;
                self.weatherInfo.lon = bigJosn["coord"]["lon"].doubleValue;
                
                self.weatherInfo.weatherDescriptions.removeAll();
                
                if let arr = bigJosn["weather"].array{
                    for itm in arr {
                        let weather = itm["main"].stringValue;
                        self.weatherInfo.weatherDescriptions.append(weather);
                    }
                }

                self.userLocation.saveUserLocation();
                self.title = self.userLocation.getFormattedLocation();
                self.renderWeather();
                 
                break
            case .failure(let err):
                self.title = "Weather not found";
                print("Request failed with error: \(err)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {

        self.view.layoutIfNeeded();
        
        self.title = self.userLocation.getFormattedLocation();
    }
    
    func renderWeather() {
        self.lblTempr.text = self.weatherInfo.getTemprInFareinheit();
        self.lblHumidity.text = self.weatherInfo.getHumidity();
        self.lblSunrise.text = self.weatherInfo.getSunrise();
        self.lblSunset.text = self.weatherInfo.getSunset();
        self.lblGeocoords.text = self.weatherInfo.getCoords();
        
        self.lblWeatherDesc.text = self.weatherInfo.getWheatherDesc();
        
        self.lblPressure.text = self.weatherInfo.getPressure();
        
        self.lblWindSpeed.text = self.weatherInfo.getWindSpeed();
        self.lblWindDir.text = self.weatherInfo.getWindDirection();
        
        self.lblcloud.text = self.weatherInfo.getCloudiness();
        
        self.lblUpdatedDate.text = self.weatherInfo.getUpdatedDate();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        if let srcViewCOn = segue.source as? EnterLocationViewController {
            
            if let city = srcViewCOn.txtCity.text {
                self.userLocation.city = city;
            }else{
                self.userLocation.city = "";
            }
            
            if let state = srcViewCOn.txtState.text {
                self.userLocation.state = state;
            }else{
                self.userLocation.state = "";
            }
            
            if let country = srcViewCOn.txtCountry.text {
                self.userLocation.country = country;
            }else{
                self.userLocation.country = "";
            }
            
            self.loadingView?.isHidden = false;
            self.loadWheather();
        }
    }
}
