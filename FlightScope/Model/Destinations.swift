//
//  Destinations.swift
//  FlightScope
//
//  Created by Aaron Cleveland on 1/26/21.
//

import Foundation

// MARK: - Destination
struct Destination: Codable, Equatable {
    let undefined: String?
    let createdAt: String?
    let downloadLink: String?
    let photoLink: String?
    let locationTitle: String?
    let locationName: String?
    let locationCity: String?
    let locationCountry: String?
    let locationLatitude: String?
    let locationLongitude: String?
    let tags: String?
    let exifMake: String?
    let exifModel: String?
    let exifExposureTime: String?
    let exifAperture: String?
    let exifFocalLength: String?
    let exifIso: String?
    let views: String?
    let downloads: String?
    let photoTitle: String?
    let destinationDescription: String?
    let color: String?

    enum CodingKeys: String, CodingKey {
        case undefined = "undefined"
        case createdAt = "created_at"
        case downloadLink = "download_link"
        case photoLink = "photo_link"
        case locationTitle = "location_title"
        case locationName = "location_name"
        case locationCity = "location_city"
        case locationCountry = "location_country"
        case locationLatitude = "location_latitude"
        case locationLongitude = "location_longitude"
        case tags = "tags"
        case exifMake = "exif_make"
        case exifModel = "exif_model"
        case exifExposureTime = "exif_exposure_time"
        case exifAperture = "exif_aperture"
        case exifFocalLength = "exif_focal_length"
        case exifIso = "exif_iso"
        case views = "views"
        case downloads = "downloads"
        case photoTitle = "photo_title"
        case destinationDescription = "description"
        case color = "color"
    }
}

typealias Destinations = [Destination]


