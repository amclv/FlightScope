//
//  ContentViewController.swift
//  FlightScope
//
//  Created by Aaron Cleveland on 1/28/21.
//

import UIKit
import MapKit

class ContentViewController: UIViewController {
    
    let destVC = DestinationViewController()
    
    // MARK: - Properties -
    var destination: Destination? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Computer Properties -
    let scrollView: UIScrollView = {
        let v = UIScrollView()
        return v
    }()
    
    let contentView = UIView()
    
    lazy var panelLocation: UILabel = {
        let label = UILabel()
        label.textColor = .customColor(.black)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    lazy var panelImageView: ImageLoader = {
        let imageView = ImageLoader()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let cameraDetails: UITextView = {
        let camera = UITextView()
        camera.isEditable = false
        camera.backgroundColor = .customColor(.green)
        camera.font = .systemFont(ofSize: 16.0, weight: .light)
        camera.textColor = .customColor(.white)
        return camera
    }()
    
    lazy var mapView = MKMapView()
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customColor(.green)
        configUI()
        constraints()
        delegates()
    }
    
    func configUI() {
        configMapView()
    }
    
    func configMapView() {
        mapView.mapType = MKMapType.standard
        mapView.layer.cornerRadius = 10
    }
    
    // MARK: - Helper Functions -
    func delegates() {
        cameraDetails.delegate = self
        scrollView.delegate = self
        mapView.delegate = self
    }
    
    func updateUI() {
        guard let destination = destination,
              let urlString = destination.downloadLink,
              let url = URL(string: urlString),
              let lat = Double("\(destination.locationLatitude ?? "")"),
              let long = Double("\(destination.locationLongitude ?? "")"),
              let name = destination.locationName else { return }
        
        locationToMap(locationName: name, location: CLLocationCoordinate2D(latitude: lat, longitude: long))
        
        panelImageView.loadImageWithUrl(url)
        panelLocation.text = "\(destination.locationName ?? "Unknown Name")"
        cameraDetails.text =
            """
            Camera Details:

                Make: \(destination.exifMake ?? "No Camera")
                Model: \(destination.exifModel ?? "No Camera")
                ISO: \(destination.exifIso ?? "No ISO")
                Focal Length: \(destination.exifFocalLength ?? "No Focal")
                Exposure Time: \(destination.exifExposureTime ?? "No Exposure")
                Aperture: \(destination.exifAperture ?? "No Aperture")
            """
    }
    
    // MapView for FloatingPanel
    func locationToMap(locationName: String, location: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = locationName
        let coordinateRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.addAnnotation(annotation)
    }
    
}

extension ContentViewController {
    func constraints() {
        self.view.addSubview(scrollView)
        scrollView.anchor(top: view.topAnchor,
                          bottom: view.bottomAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor)
        
        // add three views to the scroll view
        scrollView.addSubview(panelImageView)
        panelImageView.anchor(top: scrollView.topAnchor,
                              leading: scrollView.leadingAnchor,
                              trailing: scrollView.trailingAnchor,
                              paddingTop: 0)
        panelImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        panelImageView.heightAnchor.constraint(equalToConstant: UIScreen.screenHeight / 2).isActive = true
        
        scrollView.addSubview(panelLocation)
        panelLocation.anchor(top: panelImageView.bottomAnchor,
                             leading: scrollView.leadingAnchor,
                             trailing: scrollView.trailingAnchor,
                             paddingTop: standardPadding)
        
        scrollView.addSubview(cameraDetails)
        cameraDetails.anchor(top: panelLocation.bottomAnchor,
                             leading: scrollView.leadingAnchor,
                             trailing: scrollView.trailingAnchor,
                             paddingTop: standardPadding,
                             paddingLeading: standardPadding,
                             paddingTrailing: -standardPadding)
        cameraDetails.heightAnchor.constraint(equalToConstant: UIScreen.screenHeight / 4).isActive = true
        
        scrollView.addSubview(mapView)
        mapView.anchor(top: cameraDetails.bottomAnchor,
                       bottom: scrollView.bottomAnchor,
                       leading: scrollView.leadingAnchor,
                       trailing: scrollView.trailingAnchor,
                       paddingLeading: standardPadding,
                       paddingTrailing: -standardPadding)
        mapView.heightAnchor.constraint(equalToConstant: UIScreen.screenHeight / 2).isActive = true
    }
}

extension ContentViewController: UITextViewDelegate {
    
}

extension ContentViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return panelImageView
    }
}

extension ContentViewController: MKMapViewDelegate {
    
}
