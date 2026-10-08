import XCTest
@testable import iOSSettingsURI

final class SettingsURITests: XCTestCase {
    // MARK: - URL Generation Tests

    func testGeneralSettingsURL() {
        let url = SettingsURI.url(for: "General", path: "About")
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "App-Prefs:root=General&path=About")
    }

    func testRootOnlyURL() {
        let url = SettingsURI.url(for: "Bluetooth")
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "App-Prefs:root=Bluetooth")
    }

    func testEmptyRootReturnsNil() {
        XCTAssertNil(SettingsURI.url(for: ""))
        XCTAssertNil(SettingsURI.url(for: "   "))
    }

    func testWhitespaceTrimmingInRoot() {
        let url = SettingsURI.url(for: "  General  ")
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "App-Prefs:root=General")
    }

    func testWhitespaceTrimmingInPath() {
        let url = SettingsURI.url(for: "Privacy", path: "  LocationServices  ")
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "App-Prefs:root=Privacy&path=LocationServices")
    }

    func testEmptyPathIsIgnored() {
        let url = SettingsURI.url(for: "General", path: "")
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "App-Prefs:root=General")
    }

    // MARK: - Convenience Properties Tests

    func testGeneralShortcut() {
        let url = SettingsURI.general
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "App-Prefs:root=General")
    }

    func testAppSettingsShortcut() {
        let url = SettingsURI.appSettings
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "App-Prefs:root=General&path=About")
    }

    func testBluetoothShortcut() {
        let url = SettingsURI.bluetooth
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "App-Prefs:root=Bluetooth")
    }

    func testWiFiShortcut() {
        let url = SettingsURI.wiFi
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "App-Prefs:root=WIFI")
    }

    func testPrivacyShortcut() {
        let url = SettingsURI.privacy
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "App-Prefs:root=Privacy")
    }

    func testDisplayShortcut() {
        let url = SettingsURI.display
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "App-Prefs:root=Display")
    }

    func testBatteryShortcut() {
        let url = SettingsURI.battery
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "App-Prefs:root=Battery")
    }

    func testSoundsShortcut() {
        let url = SettingsURI.sounds
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "App-Prefs:root=Sounds")
    }

    // MARK: - Validation Tests

    func testValidationAcceptsSettingsScheme() {
        let url = URL(string: "App-Prefs:root=General")!
        XCTAssertTrue(SettingsURI.validate(url))
    }

    func testValidationRejectsInvalidScheme() {
        let url = URL(string: "https://example.com")!
        XCTAssertFalse(SettingsURI.validate(url))
    }

    func testValidationHandlesCaseInsensitivity() {
        let url = URL(string: "app-prefs:root=General")!
        XCTAssertTrue(SettingsURI.validate(url))
    }

    func testValidationRejectsURLWithoutScheme() {
        let url = URL(string: "root=General")!
        XCTAssertFalse(SettingsURI.validate(url))
    }

    // MARK: - Parsing Tests

    func testExtractRootFromURL() {
        let url = URL(string: "App-Prefs:root=Privacy&path=LocationServices")!
        let root = SettingsURI.extractRoot(from: url)
        XCTAssertEqual(root, "Privacy")
    }

    func testExtractPathFromURL() {
        let url = URL(string: "App-Prefs:root=Privacy&path=LocationServices")!
        let path = SettingsURI.extractPath(from: url)
        XCTAssertEqual(path, "LocationServices")
    }

    func testExtractPathReturnsNilWhenMissing() {
        let url = URL(string: "App-Prefs:root=General")!
        let path = SettingsURI.extractPath(from: url)
        XCTAssertNil(path)
    }

    func testExtractRootFromInvalidURLReturnsNil() {
        let url = URL(string: "https://example.com")!
        let root = SettingsURI.extractRoot(from: url)
        XCTAssertNil(root)
    }

    func testExtractPathFromInvalidURLReturnsNil() {
        let url = URL(string: "https://example.com")!
        let path = SettingsURI.extractPath(from: url)
        XCTAssertNil(path)
    }

    // MARK: - Edge Cases

    func testMultiplePathComponentsArePreserved() {
        let url = SettingsURI.url(for: "Privacy", path: "Location/Services")
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "App-Prefs:root=Privacy&path=Location/Services")
    }

    func testSpecialCharactersInRoot() {
        let url = SettingsURI.url(for: "MOBILE_DATA_SETTINGS_ID")
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "App-Prefs:root=MOBILE_DATA_SETTINGS_ID")
    }

    func testComplexSettingsPath() {
        let url = SettingsURI.url(for: "Privacy", path: "LocationServices/Maps")
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "App-Prefs:root=Privacy&path=LocationServices/Maps")
    }
}
