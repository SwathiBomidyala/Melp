//
//  NetworkConstants.swift
//  MelpDemo
//
//  Created by Bomidyala Swathi on 15/06/23.
//

import Foundation

enum RequestType : String {
    case GET = "GET", POST = "POST"
}

enum NetworkEndPoints {
    static let weatherDetailsWithCoordinates = "https://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&appid=\(AccessKey.GeoApiKey)"
    static let weatherDetailsWithAddress = "https://api.openweathermap.org/data/2.5/weather?q=%@,US&appid=\(AccessKey.GeoApiKey)"
    static let weatherImageURL = "https://openweathermap.org/img/wn/%@@2x.png"
}
