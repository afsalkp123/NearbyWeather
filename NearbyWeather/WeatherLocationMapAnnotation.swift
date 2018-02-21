//
//  WeatherLocationMapAnnotation.swift
//  NearbyWeather
//
//  Created by Erik Maximilian Martens on 04.02.18.
//  Copyright © 2018 Erik Maximilian Martens. All rights reserved.
//

import Foundation
import MapKit

class WeatherLocationMapAnnotation: NSObject, MKAnnotation {
    let weatherDTO: WeatherInformationDTO
    var coordinate: CLLocationCoordinate2D
    
    init(weatherDTO: WeatherInformationDTO) {
        self.weatherDTO = weatherDTO
        self.coordinate = CLLocationCoordinate2D(latitude: weatherDTO.coordinates.latitude, longitude: weatherDTO.coordinates.longitude)
    }
    
    convenience init?(weatherDTO: WeatherInformationDTO?) {
        guard let weatherDTO = weatherDTO else { return nil }
        
        self.init(weatherDTO: weatherDTO)
    }
}
