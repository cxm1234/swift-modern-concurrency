//
//  AddressEncoder.swift
//  Blabber_Mike
//
//  Created by ming on 2024/7/29.
//

import Foundation
import CoreLocation
import Contacts

enum AddressEncoder {
    
    static func addressFor(location: CLLocation, completion: @escaping (String?, Error?) -> Void) {
        let geocoder = CLGeocoder()
        Task {
            do {
                guard let placemark = try await geocoder.reverseGeocodeLocation(location).first,
                      let address = placemark.postalAddress else {
                    completion(nil, "No address found")
                    return
                }
                completion(CNPostalAddressFormatter.string(from: address, style: .mailingAddress), nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
}
