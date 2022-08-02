//
//  HomeViewModel.swift
//  Weather_RxSwift
//
//  Created by Florian on 29/07/2022.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewModel {
    
   
   
    static var shared = HomeViewModel()
    
    private let apiKey = "d527bad72b53226a57956f1aaaf091ed"
    let baseURL = URL(string: "http://api.openweathermap.org/data/2.5")!
    
    init() {
        Logging.URLRequests = { request in
            return true
        }
    }
    
    // MARK: - Api Calls
    func currentWeather(for city: String) -> Observable<Weather> {
        buildRequest(pathComponent: "weather", params: [("q", city)])
            .map { data in
                try JSONDecoder().decode(Weather.self, from: data)
            }
    }
    
    // MARK: - Private Methods
    
    private func buildRequest(method: String = "GET", pathComponent: String, params: [(String, String)]) -> Observable<Data> {
        let url = baseURL.appendingPathComponent(pathComponent)
        var request = URLRequest(url: url)
        let keyQueryItem = URLQueryItem(name: "appid", value: apiKey)
        let unitsQueryItem = URLQueryItem(name: "units", value: "metric")
        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        if method == "GET" {
            var queryItems = params.map { URLQueryItem(name: $0.0, value: $0.1) }
            queryItems.append(keyQueryItem)
            queryItems.append(unitsQueryItem)
            urlComponents.queryItems = queryItems
        } else {
            urlComponents.queryItems = [keyQueryItem, unitsQueryItem]
            
            let jsonData = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            request.httpBody = jsonData
            
        }
        
        request.url = urlComponents.url!
        request.httpMethod = method
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        return session.rx.data(request: request)
    }
    
}

public func iconNameToChar(icon: String) -> String {
    switch icon {
    case "01d":
        return "☀️"
    case "01n":
        return "🌑"
    case "02d":
        return "⛅️"
    case "02n":
        return "🌥"
    case "03d", "03n":
        return "☁️"
    case "09d", "09n":
        return "🌨"
    case "10d", "10n":
        return "🌧"
    case "11d", "11n":
        return "⛈"
    case "13d", "13n":
        return "🌨"
    case "50d", "50n":
        return "💨"
    default:
        return "☁️"
    }
}

