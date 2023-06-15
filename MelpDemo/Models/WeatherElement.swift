//
//  WeatherElement.swift
//  MelpDemo
//
//  Created by Bomidyala Swathi on 15/06/23.
//

import Foundation

// MARK: - WeatherElement
struct WeatherElement: Codable {
    let id: Int?
    let main, description, icon: String?
}
