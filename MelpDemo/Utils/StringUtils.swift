//
//  StringUtils.swift
//  MelpDemo
//
//  Created by Bomidyala Swathi on 15/06/23.
//

import Foundation

extension String {
    func getUrl() -> String {
        return String(format: NetworkEndPoints.weatherImageURL, self)
    }
}
