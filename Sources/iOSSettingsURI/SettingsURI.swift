import Foundation

/// A utility for constructing and validating iOS Settings.app deep link URIs.
///
/// The Settings app on iOS supports deep linking through custom URI schemes.
/// This library provides a type-safe interface for generating, validating, and
/// opening Settings.app URLs for various system settings.
///
/// # Common Settings Routes:
/// - `General` — Main settings
/// - `Bluetooth` — Bluetooth settings
/// - `WiFi` — Wi-Fi settings
/// - `Sounds` — Sound & Haptics
/// - `Privacy` — Privacy settings
/// - `Display` — Display & Brightness
/// - `Battery` — Battery settings
///
/// # Example Usage:
/// ```swift
/// import iOSSettingsURI
///
/// // Open general settings
/// if let url = SettingsURI.general {
///     UIApplication.shared.open(url)
/// }
///
/// // Open a specific settings page
/// if let url = SettingsURI.url(for: "Bluetooth") {
///     UIApplication.shared.open(url)
/// }
///
/// // Build a custom settings URL
/// if let url = SettingsURI.url(for: "Privacy", path: "LocationServices") {
///     UIApplication.shared.open(url)
/// }
/// ```
public enum SettingsURI {
    private static let scheme = "App-Prefs"

    /// The main Settings app root URL.
    public static var general: URL? {
        url(for: "General")
    }

    /// The App-Specific Settings page (typically in General > About or app-specific settings).
    public static var appSettings: URL? {
        url(for: "General", path: "About")
    }

    /// Bluetooth settings.
    public static var bluetooth: URL? {
        url(for: "Bluetooth")
    }

    /// Wi-Fi settings.
    public static var wiFi: URL? {
        url(for: "WIFI")
    }

    /// Cellular/Mobile settings.
    public static var cellular: URL? {
        url(for: "MOBILE_DATA_SETTINGS_ID")
    }

    /// Sounds & Haptics settings.
    public static var sounds: URL? {
        url(for: "Sounds")
    }

    /// Privacy settings.
    public static var privacy: URL? {
        url(for: "Privacy")
    }

    /// Display & Brightness settings.
    public static var display: URL? {
        url(for: "Display")
    }

    /// Battery settings.
    public static var battery: URL? {
        url(for: "Battery")
    }

    /// Builds a Settings URI for a given root page and optional subpath.
    ///
    /// - Parameters:
    ///   - root: The root settings page (e.g., "General", "Privacy", "Bluetooth").
    ///   - path: An optional subpath within the settings page.
    /// - Returns: A URL for the Settings URI, or `nil` if the root is empty.
    ///
    /// # Example:
    /// ```swift
    /// let url = SettingsURI.url(for: "Privacy", path: "LocationServices")
    /// // Produces: "App-Prefs:root=Privacy&path=LocationServices"
    /// ```
    public static func url(for root: String, path: String? = nil) -> URL? {
        let normalizedRoot = root.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalizedRoot.isEmpty else {
            return nil
        }

        let urlString: String
        if let path = path?.trimmingCharacters(in: .whitespacesAndNewlines), !path.isEmpty {
            urlString = "\(scheme):root=\(normalizedRoot)&path=\(path)"
        } else {
            urlString = "\(scheme):root=\(normalizedRoot)"
        }

        return URL(string: urlString)
    }

    /// Validates whether a URL is a valid Settings URI.
    ///
    /// - Parameter url: The URL to validate.
    /// - Returns: `true` if the URL uses the `App-Prefs` scheme, `false` otherwise.
    ///
    /// # Example:
    /// ```swift
    /// let url = URL(string: "App-Prefs:root=General")!
    /// let isValid = SettingsURI.validate(url) // true
    /// ```
    public static func validate(_ url: URL) -> Bool {
        guard let scheme = url.scheme?.lowercased() else {
            return false
        }
        return scheme == "app-prefs"
    }

    /// Safely opens a Settings URI using the default application handler.
    ///
    /// - Parameter url: The Settings URI to open.
    /// - Returns: `true` if the URL was opened successfully, `false` otherwise.
    ///
    /// # Example:
    /// ```swift
    /// if let url = SettingsURI.general {
    ///     SettingsURI.open(url)
    /// }
    /// ```
    @available(iOS 10.0, *)
    public static func open(_ url: URL) -> Bool {
        guard validate(url) else {
            return false
        }
        return UIApplication.shared.canOpenURL(url) ? (UIApplication.shared.open(url), true).1 : false
    }

    /// Extracts the root page from a Settings URI.
    ///
    /// - Parameter url: The Settings URI to parse.
    /// - Returns: The root page name, or `nil` if the URL is invalid.
    ///
    /// # Example:
    /// ```swift
    /// let url = URL(string: "App-Prefs:root=Privacy&path=LocationServices")!
    /// let root = SettingsURI.extractRoot(from: url) // "Privacy"
    /// ```
    public static func extractRoot(from url: URL) -> String? {
        guard validate(url), let query = url.query else {
            return nil
        }
        let components = query.split(separator: "&").map(String.init)
        return components.first(where: { $0.hasPrefix("root=") })
            .flatMap { String($0.dropFirst(5)) }
    }

    /// Extracts the subpath from a Settings URI.
    ///
    /// - Parameter url: The Settings URI to parse.
    /// - Returns: The subpath, or `nil` if no path is present or the URL is invalid.
    ///
    /// # Example:
    /// ```swift
    /// let url = URL(string: "App-Prefs:root=Privacy&path=LocationServices")!
    /// let path = SettingsURI.extractPath(from: url) // "LocationServices"
    /// ```
    public static func extractPath(from url: URL) -> String? {
        guard validate(url), let query = url.query else {
            return nil
        }
        let components = query.split(separator: "&").map(String.init)
        return components.first(where: { $0.hasPrefix("path=") })
            .flatMap { String($0.dropFirst(5)) }
    }
}
