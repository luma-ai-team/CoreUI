//
//  Models.swift
//  AlertTryout
//
//  Created by Roi Mulia on 27/01/2023.
//

import UIKit

public class AlertViewModel {
    public let title: String?
    public let subtitle: String?
    public let visualAid: AlertVisualAid
    public let actionsInfo: AlertActionsInfo?
    public let appearance: AlertAppearance
    
    public init(title: String? = nil,
                subtitle: String? = nil,
                visualAid: AlertVisualAid,
                actionsInfo: AlertActionsInfo? = nil,
                appearance: AlertAppearance) {
        self.visualAid = visualAid
        self.title = title
        self.subtitle = subtitle
        self.actionsInfo = actionsInfo
        self.appearance = appearance
    }
    
    public init(title: String? = nil,
                subtitle: String? = nil,
                visualAid: AlertVisualAid,
                actionsInfo: AlertActionsInfo? = nil,
                colorScheme: ColorScheme) {
        self.visualAid = visualAid
        self.title = title
        self.subtitle = subtitle
        self.actionsInfo = actionsInfo
        let appearance = AlertAppearance(
            theme: colorScheme.foreground.luminance > 0.5 ? .light : .dark,
            titleColor: colorScheme.title,
            subtitleColor: colorScheme.title,
            regularButtonColor: colorScheme.active,
            destructiveButtonColor: .systemRed)
        self.appearance = appearance
    }
}

public enum AlertVisualAid: Equatable {
    case none
    case spinner
    case image(UIImage?)
    case progress(Float)
    case customView(UIView, CGSize? = nil)
}

public class AlertActionsInfo {
    public let buttonAxis: NSLayoutConstraint.Axis
    public let actions: [AlertAction]
    
    public init(buttonAxis: NSLayoutConstraint.Axis, actions: [AlertAction]) {
        self.buttonAxis = buttonAxis
        self.actions = actions
    }
}

public class AlertAppearance {
    public enum Theme {
        case light
        case dark

        var visualEffect: UIVisualEffect {
            switch self {
            case .light:
                return UIBlurEffect(style: .systemMaterialLight)
            case .dark:
                return UIBlurEffect(style: .systemMaterialDark)
            }
        }
    }

    static let `default`: AlertAppearance = .init(theme: .light,
                                                  titleColor: .black,
                                                  subtitleColor: .black,
                                                  regularButtonColor: .systemBlue,
                                                  destructiveButtonColor: .systemRed)
    
    public let theme: Theme
    public let titleColor: UIColor
    public let subtitleColor: UIColor
    public let regularButtonColor: UIColor
    public let destructiveButtonColor: UIColor
    
    public init(theme: Theme,
                titleColor: UIColor,
                subtitleColor: UIColor,
                regularButtonColor: UIColor,
                destructiveButtonColor: UIColor) {
        self.theme = theme
        self.titleColor = titleColor
        self.subtitleColor = subtitleColor
        self.regularButtonColor = regularButtonColor
        self.destructiveButtonColor = destructiveButtonColor
    }
}

public class AlertAction {
    public enum Style {
        case `default`
        case cancel
        case destructive
    }

    public let image: UIImage?
    public let title: String?
    public let style: Style
    public let handler: () -> ()

    public init(image: UIImage? = nil, title: String? = nil, style: Style, handler: @escaping () -> ()) {
        self.image = image
        self.title = title
        self.style = style
        self.handler = handler
    }
}
