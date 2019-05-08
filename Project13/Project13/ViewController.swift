//
//  ViewController.swift
//  Project13
//
//  Created by Roberto Manese III on 5/7/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import UIKit
import MapKit

enum MapType: String {
    case Standard, MutedStandard, Hybrid, HybridFlyover, Satellite, SatelliteFlyover
}

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapKit: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")

        mapKit.addAnnotations([london, oslo, paris, rome, washington])

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Map Type", style: .plain, target: self, action: #selector(didChangeMapType))
    }

    @objc func didChangeMapType() {
        let ac = UIAlertController(title: "Select Map Type", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: MapType.Standard.rawValue, style: .default, handler: changeMapType))
        ac.addAction(UIAlertAction(title: MapType.MutedStandard.rawValue, style: .default, handler: changeMapType))
        ac.addAction(UIAlertAction(title: MapType.Hybrid.rawValue, style: .default, handler: changeMapType))
        ac.addAction(UIAlertAction(title: MapType.HybridFlyover.rawValue, style: .default, handler: changeMapType))
        ac.addAction(UIAlertAction(title: MapType.Satellite.rawValue, style: .default, handler: changeMapType))
        ac.addAction(UIAlertAction(title: MapType.SatelliteFlyover.rawValue, style: .default, handler: changeMapType))
        present(ac, animated: true)
    }

    private func changeMapType(action: UIAlertAction) {
        guard let type = action.title else { return }

        switch type {
        case MapType.Standard.rawValue:
            mapKit.mapType = .standard
        case MapType.MutedStandard.rawValue:
            mapKit.mapType = .mutedStandard
        case MapType.Hybrid.rawValue:
            mapKit.mapType = .hybrid
        case MapType.HybridFlyover.rawValue:
            mapKit.mapType = .hybridFlyover
        case MapType.Satellite.rawValue:
            mapKit.mapType = .satellite
        case MapType.SatelliteFlyover.rawValue:
            mapKit.mapType = .satelliteFlyover
        default:
            break
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        let identifier = "Capital"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.pinTintColor = .blue
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        let vc = WebPageViewController()
        vc.location = capital.title
        navigationController?.pushViewController(vc, animated: false)
    }

}

