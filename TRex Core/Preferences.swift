import Cocoa
import Combine
import SwiftUI

public class Preferences: ObservableObject {
    public static let shared = Preferences()
    static let userDefaults = UserDefaults(suiteName: "X93LWC49WV.TRex.preferences")!

    enum PreferencesKeys: String {
        case CaptureSound
        case ResultNotification
        case ShowMenuBarIcon
        case IgnoreLineBreaks
        case RecongitionLanguage
        case NeedsOnboarding
        case MenuBarIcon
        case AutoOpenCapturedURL
        case AutoOpenQRCodeURL
        case AutoOpenProvidedURL
        case AutoOpenProvidedURLAddNewLine
        case AutoRunShortcut
        case CustomWords
    }

    public enum MenuBarIcon: String, CaseIterable {
        case Option1
        case Option2
        case Option3
        case Option4
        case Option5
        case Option6

        public func image() -> Image {
            Image(nsImage: nsImage())
        }

        public func nsImage() -> NSImage {
            var image: NSImage?
            let imageConfig = NSImage.SymbolConfiguration(pointSize: 50, weight: .heavy, scale: .large)
            switch self {
            case .Option1:
                image = NSImage(named: "trex")
            case .Option2:
                image = NSImage(systemSymbolName: "perspective", accessibilityDescription: nil)?.withSymbolConfiguration(imageConfig)
            case .Option3:
                image = NSImage(systemSymbolName: "crop", accessibilityDescription: nil)?.withSymbolConfiguration(imageConfig)
            case .Option4:
                image = NSImage(systemSymbolName: "textbox", accessibilityDescription: nil)?.withSymbolConfiguration(imageConfig)
            case .Option5:
                image = NSImage(systemSymbolName: "doc.text.fill.viewfinder", accessibilityDescription: nil)?.withSymbolConfiguration(imageConfig)
            case .Option6:
                image = NSImage(systemSymbolName: "text.cursor", accessibilityDescription: nil)?.withSymbolConfiguration(imageConfig)
            }
            image?.isTemplate = true
            return image!
        }
    }

    public enum RecongitionLanguage: String, CaseIterable {
        case English = "🇺🇸 English"
        case French = "🇫🇷 French"
        case Italian = "🇮🇹 Italian"
        case German = "🇩🇪 German"
        case Spanish = "🇪🇸 Spanish"
        case Portuguese = "🇵🇹 Portuguese"
        case Chinese = "🇨🇳 Chinese"

        func languageCode() -> String {
            switch self {
            case .English:
                return "en_US"
            case .French:
                return "fr-FR"
            case .Italian:
                return "it-IT"
            case .German:
                return "de-DE"
            case .Spanish:
                return "es-ES"
            case .Portuguese:
                return "pt-BR"
            case .Chinese:
                return "zh-Hans"
            }
        }
    }

    @Published public var needsOnboarding: Bool {
        didSet {
            Preferences.setValue(value: needsOnboarding, key: .NeedsOnboarding)
        }
    }

    @Published public var captureSound: Bool {
        didSet {
            Preferences.setValue(value: captureSound, key: .CaptureSound)
        }
    }

    @Published public var resultNotification: Bool {
        didSet {
            Preferences.setValue(value: resultNotification, key: .ResultNotification)
        }
    }

    @Published public var showMenuBarIcon: Bool {
        didSet {
            Preferences.setValue(value: showMenuBarIcon, key: .ShowMenuBarIcon)
        }
    }

    @Published public var ignoreLineBreaks: Bool {
        didSet {
            Preferences.setValue(value: ignoreLineBreaks, key: .IgnoreLineBreaks)
        }
    }

    @Published public var autoOpenCapturedURL: Bool {
        didSet {
            Preferences.setValue(value: autoOpenCapturedURL, key: .AutoOpenCapturedURL)
        }
    }

    @Published public var autoOpenQRCodeURL: Bool {
        didSet {
            Preferences.setValue(value: autoOpenQRCodeURL, key: .AutoOpenQRCodeURL)
        }
    }

    @Published public var autoOpenProvidedURL: String {
        didSet {
            Preferences.setValue(value: autoOpenProvidedURL, key: .AutoOpenProvidedURL)
        }
    }

    @Published public var autoOpenProvidedURLAddNewLine: Bool {
        didSet {
            Preferences.setValue(value: autoOpenProvidedURLAddNewLine, key: .AutoOpenProvidedURLAddNewLine)
        }
    }

    @Published public var autoRunShortcut: String {
        didSet {
            Preferences.setValue(value: autoRunShortcut, key: .AutoRunShortcut)
        }
    }

    @Published public var recongitionLanguage: RecongitionLanguage {
        didSet {
            Preferences.setValue(value: recongitionLanguage.rawValue, key: .RecongitionLanguage)
        }
    }

    @Published public var menuBarIcon: MenuBarIcon {
        didSet {
            Preferences.setValue(value: menuBarIcon.rawValue, key: .MenuBarIcon)
        }
    }

    @Published public var customWords: String {
        didSet {
            Preferences.setValue(value: customWords.components(separatedBy: ","), key: .CustomWords)
        }
    }

    public var customWordsList: [String] {
        customWords.components(separatedBy: ",")
    }

    init() {
        needsOnboarding = Preferences.getValue(key: .NeedsOnboarding) as? Bool ?? true
        captureSound = Preferences.getValue(key: .CaptureSound) as? Bool ?? true
        resultNotification = Preferences.getValue(key: .ResultNotification) as? Bool ?? false
        showMenuBarIcon = Preferences.getValue(key: .ShowMenuBarIcon) as? Bool ?? true
        ignoreLineBreaks = Preferences.getValue(key: .IgnoreLineBreaks) as? Bool ?? false
        autoOpenCapturedURL = Preferences.getValue(key: .AutoOpenCapturedURL) as? Bool ?? false
        autoOpenQRCodeURL = Preferences.getValue(key: .AutoOpenQRCodeURL) as? Bool ?? false
        autoOpenProvidedURL = Preferences.getValue(key: .AutoOpenProvidedURL) as? String ?? ""
        autoOpenProvidedURLAddNewLine = Preferences.getValue(key: .AutoOpenProvidedURLAddNewLine) as? Bool ?? true
        autoRunShortcut = Preferences.getValue(key: .AutoRunShortcut) as? String ?? ""
        customWords = Preferences.getValue(key: .CustomWords) as? String ?? ""
        recongitionLanguage = .English
        if let lang = Preferences.getValue(key: .RecongitionLanguage) as? String {
            recongitionLanguage = RecongitionLanguage(rawValue: lang) ?? .English
        }
        menuBarIcon = .Option1
        if let mbitem = Preferences.getValue(key: .MenuBarIcon) as? String {
            menuBarIcon = MenuBarIcon(rawValue: mbitem) ?? .Option1
        }
    }

    static func removeAll() {
        let domain = Bundle.main.bundleIdentifier!
        userDefaults.removePersistentDomain(forName: domain)
        userDefaults.synchronize()
    }

    private static func setValue(value: Any?, key: PreferencesKeys) {
        userDefaults.setValue(value, forKey: key.rawValue)
        userDefaults.synchronize()
    }

    private static func getValue(key: PreferencesKeys) -> Any? {
        userDefaults.value(forKey: key.rawValue)
    }
}
