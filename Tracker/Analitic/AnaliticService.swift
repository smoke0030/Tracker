//
//  AnaliticService.swift
//  Tracker
//
//  Created by Сергей on 10.03.2024.
//

import Foundation
import YandexMobileMetrica

final class AnaliticService {
    
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "4e0855b4-0408-44c1-94dc-33c8bd601419") else { return }
        
        YMMYandexMetrica.activate(with: configuration)
    }
    
    
    static func report(event: String, params : [AnyHashable : Any]) {
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}

