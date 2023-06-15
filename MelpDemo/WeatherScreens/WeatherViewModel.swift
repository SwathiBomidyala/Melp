//
//  WeatherViewModel.swift
//  MelpDemo
//
//  Created by Bomidyala Swathi on 15/06/23.
//

import Foundation

class WeatherViewModel {
    
    private var weatherData: Weather?
    
    //Good to Have: Can move to separate utils
    func saveLastSearchedLocation(text: String) {
        print("saved city \(text)")
        UserDefaults.standard.setValue(text, forKey: UserDefaultsConstants.previouslySearchedCity)
    }
    
    func getLastSearchedLocation() -> String? {
        return UserDefaults.standard.value(forKey: UserDefaultsConstants.previouslySearchedCity) as? String
    }
    
    //Fetch data with city name input
    func getSearchCityData(searchText: String, completion: @escaping((Weather?, String?)-> Void)) {
        saveLastSearchedLocation(text: searchText)
        
        DispatchQueue.global().async {
            let url = String(format: NetworkEndPoints.weatherDetailsWithAddress, searchText)
            NetworkManager.instance.getAPIData(for: Weather.self, url: url, requestType: RequestType.GET) { response, error in
                completion(response, error)
            }
        }
    }
    
    //Fetch data with location
    func getUserLocationData(userLat: String, userLong: String, completion: @escaping((Weather?, String?)-> Void)) {
        DispatchQueue.global().async {
            let url = String(format: NetworkEndPoints.weatherDetailsWithCoordinates, userLat, userLong)
            NetworkManager.instance.getAPIData(for: Weather.self, url: url, requestType: RequestType.GET) { response, error in
                completion(response, error)
            }
        }
    }

}

