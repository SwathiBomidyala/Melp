//
//  ViewController.swift
//  MelpDemo
//
//  Created by Bomidyala Swathi on 15/06/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    var weatherObj: Weather?
    let weatherViewModel = WeatherViewModel()
    
    @IBOutlet weak var stackViewDisplay: UIStackView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityCountryLabel: UILabel!
    
    @IBOutlet weak var messageDisplayLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var imageDisplay: CachingImage!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        searchBar.delegate = self
        self.view.backgroundColor = UIColor.init(displayP3Red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        dayLabel.text = Date().getDay()
        dateLabel.text = Date().getDate()
        
        updateUI()
        updateSearchBar()
        loadInitialContent()
    }
    
    func updateSearchBar() {
        //created a target for clear button
        if let searchTextField = self.searchBar.value(forKey: "searchField") as? UITextField , let clearButton = searchTextField.value(forKey: "_clearButton")as? UIButton {
            
            clearButton.addTarget(self, action: #selector(clearButtonAction), for: .touchUpInside)
        }
    }
    
    func loadInitialContent() {
        let locationManager = LocationManager.instance
        if locationManager.hasLocationAccess() {
            NotificationCenter.default.addObserver(self, selector: #selector(getDataBasedOnLocation), name: Notification.Name(NotificationConstants.locationUpdate), object: nil)
        }
        else if let historyKey = weatherViewModel.getLastSearchedLocation() {
            searchBar.text = historyKey
            self.view.showLoader(show: true)
            weatherViewModel.getSearchCityData(searchText: historyKey) { [weak self] response, error in
                self?.validateAndRefreshUI(response: response, error: error)
            }
        }
    }
    
    //Good to Have: Localisation can be implemented for strings
    func updateUI() {
        if let weatherObject = weatherObj {
            stackViewDisplay.isHidden = false
            messageDisplayLabel.isHidden = true
            cityCountryLabel.text = "\(weatherObject.name ?? ""), \(weatherObject.sys?.country ?? "")"
            humidityLabel.text = "Humidity: \(String(weatherObject.main?.humidity ?? 0))%"
            temperatureLabel.text = "Temperature: \(String(weatherObject.main?.temp ?? 0))°"
            windLabel.text = String(format: "Wind: %.2f km/h", weatherObject.wind?.speed ?? "")
            pressureLabel.text = "Pressure: \(String(weatherObject.main?.pressure ?? 0)) hPa"
            weatherDescriptionLabel.text = weatherObject.weather?.first?.description?.capitalized ?? ""
            
            self.imageDisplay.loadImageWithUrl(urlString: weatherObject.weather?.first?.icon?.getUrl() ?? "")
        }
        else {
            stackViewDisplay.isHidden = true
            messageDisplayLabel.isHidden = false
            
            if searchBar.text?.count ?? 0 > 0 {
                messageDisplayLabel.text =  "No city found"
            }
            else {
                messageDisplayLabel.text =  "Please enter the city in search box"
            }
        }
    }
    
    @objc func clearButtonAction(){
        weatherObj = nil
        updateUI()
    }
    
    @objc func getDataBasedOnLocation() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(NotificationConstants.locationUpdate), object: nil)
        
        if let lat = LocationManager.instance.fetchedLocation?.coordinate.latitude, let long = LocationManager.instance.fetchedLocation?.coordinate.latitude {
            self.view.showLoader(show: true)
            
            weatherViewModel.getUserLocationData(userLat: "\(lat)", userLong: "\(long)") { [weak self] response, error in
                self?.validateAndRefreshUI(response: response, error: error)
            }
            
        }
    }
    
    func validateAndRefreshUI(response: Weather?, error: String?) {
        if let errorString = error {
            self.weatherObj = nil
            DispatchQueue.main.async {
                self.messageDisplayLabel.text = errorString
                self.updateUI()
                self.view.showLoader(show: false)
            }
        }
        else if let result = response {
            self.weatherObj = result
            DispatchQueue.main.async {
                self.updateUI()
                self.view.showLoader(show: false)
            }
        }
    }
    
}

//MARK: -  Search bar delegate
extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.showLoader(show: true)
        weatherViewModel.getSearchCityData(searchText: searchBar.text ?? "") { [weak self] response, error in
            self?.validateAndRefreshUI(response: response, error: error)
        }
    }
    
}
