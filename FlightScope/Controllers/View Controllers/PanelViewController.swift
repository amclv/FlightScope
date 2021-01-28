//
//  PanelViewController.swift
//  FlightScope
//
//  Created by Aaron Cleveland on 1/27/21.
//
// SCROLL VIEW NOTES:
// scrollView's .contentSize.width is now
// scrollView's width (defined by subviews' leading and trailing anchors
//
// and scrollView's .contentSize.height is now
// redView-Height + 20-pts-spacing +
// greenView-Height + 20-pts-spacing +
// blueView-Height +
// 8-pts top-padding + 8-pts bottom-padding
// or 956

import UIKit

class PanelViewController: UIViewController {
    
    let destVC = DestinationViewController()
    
    // MARK: - Properties -
    let scrollViewSpacing: CGFloat = 8
    let panelTitleHeight: CGFloat = 70
    
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
    
    let contentView: UIView = {
        let cv = UIView()
        return cv
    }()
    
    let panelLocation: UILabel = {
        let label = UILabel()
        label.textColor = .customColor(.black)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    let panelImageView: ImageLoader = {
        let imageView = ImageLoader()
        imageView.contentMode = .scaleAspectFill
        imageView.setDimensions(width: UIScreen.screenWidth, height: UIScreen.screenHeight / 2)
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
    
    let vStack = CustomStackView(style: .vertical, distribution: .fill, alignment: .leading)

    override func viewDidLoad() {
        super.viewDidLoad()
        constraints()
        updateUI()
        view.backgroundColor = .customColor(.green)
        
        cameraDetails.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
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

}

extension PanelViewController {
    private func constraints() {
        view.addSubview(scrollView)
        scrollView.anchor(top: view.topAnchor,
                          bottom: view.bottomAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor)
        
        scrollView.addSubview(contentView)
        contentView.anchor(top: scrollView.topAnchor,
                           bottom: scrollView.bottomAnchor,
                           leading: scrollView.leadingAnchor,
                           trailing: scrollView.trailingAnchor)
    
        contentView.addSubview(panelImageView)
        panelImageView.anchor(top: contentView.topAnchor,
                              leading: contentView.leadingAnchor,
                              trailing: contentView.trailingAnchor)
        
        vStack.addArrangedSubview(panelLocation)
        vStack.addArrangedSubview(cameraDetails)
        cameraDetails.setDimensions(width: 200, height: 200)
        contentView.addSubview(vStack)
        vStack.anchor(top: panelImageView.bottomAnchor,
                      bottom: contentView.bottomAnchor,
                      leading: contentView.leadingAnchor,
                      trailing: contentView.trailingAnchor,
                      paddingTop: standardPadding,
                      paddingBottom: standardPadding,
                      paddingLeading: standardPadding,
                      paddingTrailing: -standardPadding)
    }
}

extension PanelViewController: UITextViewDelegate {
    
}

