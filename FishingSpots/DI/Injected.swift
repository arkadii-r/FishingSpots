//
//  Injected.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 31.03.2026.
//

import Foundation

/**

 # Lazy dependency injection property wrapper

 Default implementations are defined in `Services.swift`.

 # Usage: #
 ```
 @Injected(\Services.userPreferences) var userPreferences: UserPreferences
 ```

 - parameter: `Services` *KeyPath* to property with target type

 Should be used in most of cases, allows to replace implementation by simple assignment different implementation to property directly.

 Also it is possible to replace `servicesContainer` by assignment new instance to `$<decorated_property>.servicesContainer`

 # Notes: #
  Delayed injection and lazy implementations registration in `Services.swift` allows to deal with circular dependencies easily

 */
@propertyWrapper
struct Injected<Service> {
    private let keyPath: KeyPath<Services, Service>

    lazy var wrappedValue: Service = {
        servicesContainer[keyPath: keyPath]
    }()

    var servicesContainer: Services = AppServices.shared

    var projectedValue: Injected<Service> {
        get { self }
        mutating set { self = newValue }
    }

    init(_ keyPath: KeyPath<Services, Service>) {
        self.keyPath = keyPath
    }
}
