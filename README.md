# FishingSpots

#### [Video Demo on Youtube](https://youtu.be/EyUWT2Y_dEk)

FishingSpots is a comprehensive iOS application designed for anglers to track, manage, and organize their fishing catches and locations. The app provides a convenient way to log detailed information about successful fishing trips, including the ability to record catch details, attach photos, track fishing spots with GPS coordinates, and maintain a complete history of fishing activities. Whether you're a casual angler or a dedicated fishing enthusiast, FishingSpots helps you build a personalized database of your fishing adventures.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Project Architecture](#project-architecture)
- [Project Structure and File Documentation](#project-structure-and-file-documentation)
- [Design Decisions](#design-decisions)
- [Technology Stack](#technology-stack)

## Overview

FishingSpots is a iOS application that empowers anglers with tools to:
- Discover and bookmark fishing locations
- Record detailed catch information including fish species, weight, and quantity
- Attach photographs to catch reports
- Track fishing history at specific locations
- Manage user authentication and profiles
- Visualize fishing spots on an interactive map

The application is built using **SwiftUI**, leveraging modern iOS development practices with a clean architecture approach. The app integrates with **Firebase** for authentication, real-time data synchronization, cloud storage for media files, enabling seamless cross-device access to your fishing records. The architecture emphasizes separation of concerns through a well-organized directory structure that includes dedicated layers for Views, ViewModels, Services, Entities, and Dependency Injection.

## Features

### Core Functionality

- **User Authentication**: Secure registration and login system with email/password authentication
- **Comprehensive History** - Maintain a complete historical record of all fishing trips and catches
- **Fishing Spot Management**: Add, view, and delete fishing locations with geographic coordinates
- **Catch Logging** - Detailed catch reports including fish species, weight, quantity, photos, and personal notes
- **Real-time Synchronization**: Instant data updates across devices using Firebase Firestore listeners
- **Photo Management** - Upload and store catch photos in Firebase Cloud Storage
- **Map Integration**: Visual representation of fishing spots with geographic data
- **Settings Management**: User profile and application preferences

### User Experience

- **Tabbed Navigation**: Intuitive navigation between spots list, map view, and settings
- **Design System**: Consistent UI components and color schemes throughout the application
- **Real-time Updates**: Reactive UI that updates instantly as new fishing data is added

## Project Architecture

FishingSpots follows a **modular, feature-based architecture** with clear separation of concerns. The codebase is organized into distinct layers:

### Architecture Layers

1. **Presentation Layer (Views & ViewModels)**: SwiftUI-based UI components using the MVVM pattern
2. **Domain Layer (Entities)**: Core business models representing fishing concepts
3. **Data Layer (DTOs & Repository)**: Firebase integration and data persistence
4. **Service Layer (DI & Services)**: Dependency injection and service orchestration through property wrappers and a centralized service registry
5. **Design System**: Centralized theming, custom components, and UI helpers


## Project Structure and File Documentation

### Application Entry Points

#### **FishingSpotsApp.swift**
The entry point of the SwiftUI application. This file contains the `FishingSpotsApp` struct marked with `@main`, which initializes the application window and sets up the `AppDelegate` using the `@UIApplicationDelegateAdaptor` property wrapper. This design allows the app to perform custom initialization before SwiftUI takes over the UI rendering.

#### **AppDelegate.swift**
Handles UIKit-level application lifecycle events. The `application(_:didFinishLaunchingWithOptions:)` method is called when the app finishes launching, and it invokes `AppServices.run()` to initialize all necessary services (Firebase, repositories, monitoring) before the user interface appears. This ensures all backend services are configured and ready before the app presents any UI.

### Core Entities (Entities/)

#### **FishingSpot.swift**
Represents a single fishing location with the following properties:
- `id`: Unique identifier for the spot
- `name`: User-provided name of the location
- `location`: Geographic location description
- `coordinate`: CLLocationCoordinate2D for GPS position
- `catchReports`: Array of catches associated with this spot
- `createdAt`: Timestamp when the spot was added

The struct includes computed properties:
- `coordinatesString`: Formatted latitude/longitude display
- `catchCount`: Total count of all fish caught at this spot

#### **CatchReport.swift**
Represents individual catch information with these properties:
- `id`: Unique identifier for the report
- `fish`: Species of fish caught
- `weight`: Weight in kilograms
- `count`: Number of fish caught in this instance
- `photoURL`: Optional URL to stored photo in cloud storage
- `date`: When the catch occurred
- `note`: Angler's notes about the catch

The struct includes a computed property:
- `weightString`: Formatted weight display (e.g., "2.50 KG")

### Service Layer (Services/)

#### **AuthService.swift**
Manages Firebase authentication operations with three primary async methods:

- `login(email:password:)`: Authenticates existing users with email/password credentials
- `register(username:email:password:)`: Creates new user accounts
- `logout()`: Signs out the current user from Firebase

#### **AuthMonitor.swift**
Observes Firebase authentication state changes using `Auth.auth().addStateDidChangeListener()`. This class publishes authentication state updates that drive navigation logic, ensuring the app always displays appropriate screens (login/register vs. main app) based on user authentication status.

#### **SpotsRepository.swift**
The primary data access layer managing all interactions with Firebase Firestore and Cloud Storage:

**Listener Management**:
- `bindSpotsListener()`: Establishes a real-time listener on the user's spots collection, publishing changes via Combine subjects. When new spots are added, they're immediately published through `newSpot` subject and all spots are updated through `spots` subject.
- `removeSpotsListener()`: Cleans up the listener to prevent memory leaks and unnecessary data transfers

**Spot Operations**:
- `loadSpots()`: Async function that fetches all spots for the current user, converting DTOs to domain models
- `addSpot(_:)`: Creates a new fishing spot in Firestore under the user's document
- `deleteSpot(_:)`: Removes a spot and all associated catch report photos from cloud storage

**Catch Report Operations**:
- `addCatchReport(for:report:)`: Appends a new catch report to a spot's catchReports array using Firestore's `arrayUnion` operation for atomic updates

**Storage Operations**:
- `uploadImage(image:)`: Compresses image to JPEG (quality: 0.5) and uploads to Firebase Cloud Storage, returning the download URL
- `deleteImage(url:)`: Removes photos from storage when spots are deleted


### Data Transfer Objects (DTO/)

**FishingSpotDTO.swift** and **CatchReportDTO.swift**: Intermediate data structures that match Firestore document structure. DTOs include Codable conformance for Firebase's automatic serialization/deserialization and a `domainModel` computed property that converts DTOs to domain entities. This separation allows changing Firestore structure without affecting domain models throughout the application.

### Dependency Injection System (DI/)

**Services.swift** - Implements the centralized service registry and dependency injection container. The `Services` class defines all application services as lazy properties, ensuring they're instantiated only when first accessed. This lazy initialization pattern reduces memory overhead at app startup and only loads services that are actually used. The `AppServices` class provides a singleton instance and an initialization method called at app launch. This design eliminates the need to pass services through view hierarchies or use global singletons directly, improving testability and reducing tight coupling between components.

**Injected.swift** - Provides a custom property wrapper for convenient service injection. This allows ViewModels to declare service dependencies cleanly using the `@Injected` property wrapper, automatically resolving services from the container without explicit initialization. This approach eliminates boilerplate injection code and provides a clear declaration of dependencies at the point of use.

### Design System (DesignSystem/)

Provides reusable SwiftUI components with consistent styling:
- Custom buttons with unified appearance
- Text field styles matching app branding
- Common color schemes and typography
- Shared layout components

### Feature Modules

- **AppFeature** - Contains the root application view and primary navigation logic, serving as the central hub

- **Login** - Handles user authentication interface and login workflow with email/password validation. Integrates with `AuthService` to handle login logic and transitions to main app on successful authentication

- **Register** - Manages new user registration with password validation and error handling. Creates both Firebase Auth account and user profile in Firestore

- **TabFeature** - Implements the main tabbed interface presenting: spots list, map and user settings

- **SpotList** - Presents a list view of all fishing spots with search and filtering capabilities for easy spot discovery

- **SpotDetail** - Shows comprehensive details of individual fishing spots and their complete catch history

- **Map** - Renders all fishing spots on an interactive map using GoogleMaps, with markers for each spot's GPS coordinates

- **AddSpot** - Allows users to create new fishing spots by selecting locations on a map

- **AddCatchReport** - Enables detailed logging of individual catch events with photo uploads

- **Settings** - Provides user management interface: current user profile, app preferences, logout functionality

## Design Decisions

### 1. **MVVM Over MVC**

**Decision**: Adopt the Model-View-ViewModel (MVVM) pattern rather than traditional MVC (Model-View-Controller).

**Rationale**: MVVM was chosen over traditional MVC because it provides clearer separation between UI and business logic. SwiftUI naturally supports this pattern, and it enables more straightforward unit testing of business logic without requiring UI context.

### 2. **Reactive Architecture with Combine**

**Decision**: Use Combine's `CurrentValueSubject` and `PassthroughSubject` binded to Firestore snapshot listeners for state management and data distribution.

**Rationale**: This design enables reactive updates throughout the application. When the Firestore listener detects changes, all subscribed views automatically update without manual refresh calls. This creates a seamless, real-time experience and ensures the UI is always current with the latest data. Users see updates instantly as data changes, creating a responsive and engaging experience.

**Implementation**: `SpotsRepository` publishes spots via `CurrentValueSubject` and new spots via `PassthroughSubject`, allowing multiple views to subscribe and react independently.

### 3. **Firebase for Backend**

**Decision**: Adopt Firebase (Firestore, Authentication, and Cloud Storage) as the complete backend infrastructure rather than building a custom REST API with a traditional relational database.

**Rationale**: A custom REST API with PostgreSQL would offer more granular control. However, this approach would require building and maintaining server infrastructure, implementing authentication pipelines, handling session management, building real-time update mechanisms (WebSockets), managing database migrations, and establishing monitoring/alerting systems. For an independent developer or small team, Firebase's serverless model dramatically accelerates reduces operational overhead. Therefore, Firebase was selected as the backend solution. It provides real-time database synchronization through Firestore without custom backend infrastructure. This reduces development complexity significantly. Firebase Authentication provides secure user management out-of-the-box with industry-standard security practices, and Cloud Storage simplifies image hosting without managing separate file servers.

### 4. **DTO Layer for Data Transformation**

**Decision**: Separate domain models (`FishingSpot`, `CatchReport`) from Firebase DTOs.

**Rationale**: This creates a clear boundary between infrastructure (Firebase) and business logic. If requirements change and Firestore structure needs modification, only the DTO and conversion layer need updating. Domain models remain stable, preventing cascading changes throughout the application. Additionally, DTOs can include Firestore-specific annotations while domain models stay clean and portable.

### 5. **Image Compression Before Upload**

**Decision**: Compress images to JPEG with 0.5 quality before uploading to Cloud Storage.

**Rationale**: Fishing photos can come from high-resolution cameras. Uploading full-resolution images wastes bandwidth and storage costs, and slow upload times frustrate users. A 0.5 quality JPEG provides excellent visual quality for fishing documentation while reducing file size by 80-90%. This balance between quality and efficiency is critical for a mobile app where users might have limited data plans or poor connectivity at fishing locations.

### 6. **Custom DI System Over Third-Party Frameworks**

**Decision**: Rather than adopting a third-party dependency injection framework, a lightweight custom DI system was implemented.

**Rationale**: This decision reduces external dependencies, decreases app bundle size, and provides full transparency about how dependencies are managed. The custom solution remains simple enough that modifications are straightforward, and developers can easily understand the injection mechanism without learning a complex framework's conventions.

## Technology Stack

- **Language** - Swift
- **UI**: SwiftUI
- **Design pattern**: MVVM
- **Reactive Programming** - Combine
- **Concurrency**: Swift's async/await for asynchronous operations
- **Backend**: Firebase (Authentication, Firestore Database, Cloud Storage)
- **Location Services**: CoreLocation
- **Maps** - Google Maps SDK for iOS
- **Dependency Management**: Manual dependency injection through service container
- **Graphics**: Google Gemini for icons generation

