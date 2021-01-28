//
//  HomeViewController.swift
//  FlightScope
//
//  Created by Aaron Cleveland on 1/27/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties -
    let backgroundImage = UIImage(named: "homebackground")
    let stackSpacing: CGFloat = 16
    
    let homeTitle = UILabel()
    let homeSubTitle = UILabel()
    let homeButton = UIButton()
    let verticalStackView = UIStackView()
    let backgroundImageView = UIImageView()
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Move everything to a function, leaves the viewDidLoad less crowded.
        configureUserInterface()
    }
    
    // MARK: - Functions -
    private func configureUserInterface() {
        view.backgroundColor = .white
        constraints()
        
        // Created an initial image at the top so it's easier to change if needed.
        backgroundImageView.image = backgroundImage
        backgroundImageView.contentMode = .scaleAspectFill
        
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fill
        verticalStackView.spacing = stackSpacing
        
        homeTitle.attributedText = titleAttributedText()
        homeTitle.numberOfLines = 0
        homeTitle.font = .systemFont(ofSize: 36.0, weight: .bold)
        
        homeSubTitle.text = "Lives without limits the world is made to explore and appreciate it's beauty"
        homeSubTitle.numberOfLines = 0
        homeSubTitle.textColor = .customColor(.white)
        homeSubTitle.font = .systemFont(ofSize: 16.0, weight: .regular)
        
        homeButton.setTitle(NSLocalizedString("Explore Now", comment: "HomeViewController"), for: .normal)
        homeButton.setTitleColor(.customColor(.black), for: .normal)
        homeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        homeButton.backgroundColor = .customColor(.blue)
        homeButton.addTarget(self, action: #selector(homeButtonAction), for: .touchUpInside)
        homeButton.layer.cornerRadius = 10
        homeButton.setDimensions(width: 280, height: 51)
    }
    
    func titleAttributedText() -> NSAttributedString {
        // String variable containing the text.
        let fullString = "The best travel in the world"

        // Choose what you want to be colored.
        let coloredString = "best travel"

        // Get the range of the colored string.
        let rangeOfColoredString = (fullString as NSString).range(of: coloredString)

        // Create the attributedString.
        let attributedString = NSMutableAttributedString(string: fullString, attributes: [
                                                            .foregroundColor: UIColor.customColor(.white)])
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.customColor(.blue)], range: rangeOfColoredString)

        return attributedString
    }
    
    // MARK: - Actions -
    @objc func homeButtonAction() {
        let destinationVC = UINavigationController(rootViewController: DestinationViewController())
        destinationVC.modalPresentationStyle = .fullScreen
        present(destinationVC, animated: true, completion: nil)
    }
    
}

extension HomeViewController {
    private func constraints() {
        view.addSubview(backgroundImageView)
        backgroundImageView.anchor(top: view.topAnchor,
                                   bottom: view.bottomAnchor,
                                   leading: view.leadingAnchor,
                                   trailing: view.trailingAnchor)
        
        
        verticalStackView.addArrangedSubview(homeTitle)
        verticalStackView.addArrangedSubview(homeSubTitle)
        view.addSubview(verticalStackView)
        verticalStackView.centerY(inView: view)
        verticalStackView.anchor(leading: view.leadingAnchor,
                                 trailing: view.trailingAnchor,
                                 paddingLeading: standardPadding,
                                 paddingTrailing: -standardPadding)
        
        view.addSubview(homeButton)
        homeButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          paddingBottom: standardPadding,
                          paddingLeading: standardPadding,
                          paddingTrailing: -standardPadding)
    }
}
