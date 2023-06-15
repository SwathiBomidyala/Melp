//
//  WeatherModel.swift
//  MelpDemo
//
//  Created by Bomidyala Swathi on 15/06/23.
//

import Foundation

//Good to Have: Names can be improvised according to the backend models. ex: Coord can be Coordinate, applicable for all the models.
// MARK: - Weather
struct Weather: Codable {
    let coord: Coord?
    let weather: [WeatherElement]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
}
