//
//  MapView.swift
//  KilimaniHackathon
//
//  Created by Muktar Aisak on 01/08/2024.
//

import Foundation
import CoreLocation
import UIKit
import SwiftUI
import MapKit

struct KilimaniArea: Identifiable {
    var id = UUID().uuidString
    let name: String
    let coordinate: CLLocationCoordinate2D
    let color: UIColor
    let description: String
    let lastIncidentDate: Date
}


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


extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

struct MapView: UIViewRepresentable {
    @EnvironmentObject var viewModel: MapViewModel

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        // Set the region to display
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -1.3009486021982272, longitude: 36.775468281625346),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        mapView.setRegion(region, animated: true)

        // Add overlays
        viewModel.areas.forEach { area in
            let polygon = MKPolygon(coordinates: area.coordinates, count: area.coordinates.count)
            mapView.addOverlay(polygon)
        }

        // Add gesture recognizer for tapping on the map
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(gestureRecognizer:)))
        mapView.addGestureRecognizer(tapGesture)

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {}

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polygon = overlay as? MKPolygon {
                let renderer = MKPolygonRenderer(polygon: polygon)
                if let area = parent.viewModel.areas.first(where: { $0.coordinates.first == polygon.points()[0].coordinate }) {
                    renderer.fillColor = area.color.withAlphaComponent(0.5)
                    renderer.strokeColor = area.color
                    renderer.lineWidth = 2
                }
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }

        @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
            let mapView = gestureRecognizer.view as! MKMapView
            let touchPoint = gestureRecognizer.location(in: mapView)
            let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)

            if let tappedArea = parent.viewModel.areas.first(where: { area in
                isCoordinateInsidePolygon(coordinate: touchCoordinate, polygon: MKPolygon(coordinates: area.coordinates, count: area.coordinates.count))
            }) {
                parent.viewModel.selectedArea = tappedArea
            } else {
                parent.viewModel.isShowingForm = true
            }
        }

        func isCoordinateInsidePolygon(coordinate: CLLocationCoordinate2D, polygon: MKPolygon) -> Bool {
            var inside = false
            var j = polygon.pointCount - 1
            for i in 0..<polygon.pointCount {
                let iPoint = polygon.points()[i].coordinate
                let jPoint = polygon.points()[j].coordinate
                if (iPoint.latitude > coordinate.latitude) != (jPoint.latitude > coordinate.latitude),
                   coordinate.longitude < (jPoint.longitude - iPoint.longitude) * (coordinate.latitude - iPoint.latitude) / (jPoint.latitude - iPoint.latitude) + iPoint.longitude {
                    inside = !inside
                }
                j = i
            }
            return inside
        }
    }
}

struct Mapping: View {
    @StateObject private var viewModel = MapViewModel()

    var body: some View {
        ZStack {
            MapView()
                .environmentObject(viewModel)
                .edgesIgnoringSafeArea(.all)
            if let selectedArea = viewModel.selectedArea {
                SheetView(area: selectedArea)
            } else if viewModel.isShowingForm {
                IncidentFormView()
            }
        }
    }
}

struct SheetView: View {
    let area: KilimaniArea

    var body: some View {
        VStack {
            Text(area.name)
                .font(.title)
            Text(area.description)
            Text("Last incident: \(area.lastIncidentDate, formatter: DateFormatter.shortDate)")
            Spacer()
        }
        .padding()
    }
}

struct IncidentFormView: View {
    @EnvironmentObject var viewModel: MapViewModel
    @State private var description = ""
    @State private var incidentType = "Noise"

    var body: some View {
        VStack {
            Text("Report Incident")
                .font(.title)
            TextField("Description", text: $description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Picker("Incident Type", selection: $incidentType) {
                Text("Noise").tag("Noise")
                Text("Theft").tag("Theft")
                Text("Flooding").tag("Flooding")
                Text("Blackout").tag("Blackout")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            Button("Submit") {
                // Handle form submission
                viewModel.isShowingForm = false
            }
            .padding()
            Spacer()
        }
        .padding()
    }
}

extension DateFormatter {
    static var shortDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}


#Preview {
    Mapping()
}
