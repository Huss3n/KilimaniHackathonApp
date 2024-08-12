//
//  MapViewModel.swift
//  KilimaniHackathon
//
//  Created by Muktar Aisak on 02/08/2024.
//

import Foundation
import SwiftUI
import MapKit

final class MapViewModel: ObservableObject {
    @Published var selectedArea: KilimaniArea?
    @Published var isShowingForm = false
    @Published var areas: [KilimaniArea] = [
        KilimaniArea(
            name: "Flood Prone Area",
            coordinate: CLLocationCoordinate2D(latitude: -1.3009486021982272, longitude: 36.775468281625346),
            color: .red,
            description: "This area is prone to flooding.",
            lastIncidentDate: Date()
        ),
        KilimaniArea(
            name: "Noise Pollution Area",
            coordinate: CLLocationCoordinate2D(latitude: -1.3019486021982272, longitude: 36.776468281625346),
            color: .blue,
            description: "This area has high noise pollution.",
            lastIncidentDate: Date()
        ),
        KilimaniArea(
            name: "Theft Prone Area",
            coordinate: CLLocationCoordinate2D(latitude: -1.3029486021982272, longitude: 36.777468281625346),
            color: .yellow,
            description: "This area is prone to theft.",
            lastIncidentDate: Date()
        ),
        KilimaniArea(
            name: "Blackout Prone Area",
            coordinate: CLLocationCoordinate2D(latitude: -1.3039486021982272, longitude: 36.778468281625346),
            color: .green,
            description: "This area experiences frequent blackouts.",
            lastIncidentDate: Date()
        )
    ]
}
