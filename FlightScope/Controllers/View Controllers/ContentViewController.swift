//
//  ContentViewController.swift
//  FlightScope
//
//  Created by Aaron Cleveland on 1/28/21.
//

import UIKit

class ContentViewController: UIViewController {
    
    let destVC = DestinationViewController()
    let networkManager = NetworkManager()
    
    // MARK: - Properties -
    let scrollViewSpacing: CGFloat = 8
    let panelTitleHeight: CGFloat = 70
    
    var destination: Destination? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Computer Properties -
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.alwaysBounceVertical = false
        view.frame.size.height = 2000
        view.clipsToBounds = true
        return view
    }()
    
    lazy var panelLocation: UILabel = {
        let label = UILabel()
        label.textColor = .customColor(.black)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    lazy var panelImageView: ImageLoader = {
        let imageView = ImageLoader()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.setDimensions(width: UIScreen.screenWidth, height: UIScreen.screenWidth / 1.50)
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
    
    let placesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = .purple
        return cv
    }()

    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customColor(.green)
//        delegates()
//        getPlaces()
        updateUI()
        constraints()
    }
    
    func getPlaces() {
        guard let destinationCity = destination?.locationCity else { return }
        networkManager.fetchData(cityName: "\(destinationCity)") {
            return
        }
    }
    
//    func delegates() {
//        cameraDetails.delegate = self
//        scrollView.delegate = self
//    }
    
    func updateUI() {
        guard let destination = destination else { return }

        guard let urlString = destination.downloadLink,
              let url = URL(string: urlString) else { return }
        panelImageView.loadImageWithUrl(url)
        panelLocation.text = "\(destination.locationCity ?? "Unknown City"), \(destination.locationCountry ?? "Unknown Country")"
        cameraDetails.text =
            """
            Make: \(destination.exifMake ?? "No Camera")
            Model: \(destination.exifModel ?? "No Camera")
            ISO: \(destination.exifIso ?? "No ISO")
            Focal Length: \(destination.exifFocalLength ?? "No Focal")
            Exposure Time: \(destination.exifExposureTime ?? "No Exposure")
            Aperture: \(destination.exifAperture ?? "No Aperture")
            """
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }

}

extension ContentViewController {
    private func constraints() {
        view.addSubview(scrollView)
        scrollView.anchor(top: view.topAnchor,
                          bottom: view.bottomAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor)
        
        scrollView.addSubview(panelImageView)
        panelImageView.anchor(top: scrollView.topAnchor,
                              leading: scrollView.leadingAnchor,
                              trailing: scrollView.trailingAnchor)
        
        scrollView.addSubview(panelLocation)
        panelLocation.anchor(top: panelImageView.bottomAnchor,
                             leading: scrollView.leadingAnchor,
                             trailing: scrollView.trailingAnchor)
    }
}

extension ContentViewController: UITextViewDelegate {
    
}

extension ContentViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return panelImageView
    }
}

extension ContentViewController: UICollectionViewDelegate, UICollectionViewDataSource, {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return networkManager.placesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath)
        let places = networkManager.placesArray[indexPath.row]
    }
}

extension ContentViewController: UICollectionViewDelegateFlowLayout {
    
}
