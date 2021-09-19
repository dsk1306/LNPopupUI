//
//  LNPopupUI.swift
//  LNPopupUI
//
//  Created by Leo Natan on 8/6/20.
//

import SwiftUI
@_exported import LNPopupController
import Combine

public extension View {
	
	/// Presents a popup bar with popup content.
	///
	/// - Parameters:
	///   - isBarPresented: A binding to whether the popup bar is presented.
	///   - isPopupOpen: A binding to whether the popup is open. (optional)
	///   - onOpen: A closure executed when the popup opens. (optional)
	///   - onClose: A closure executed when the popup closes. (optional)
	///   - popupContent: A closure returning the content of the popup.
	func popup<PopupContent>(isBarPresented: Binding<Bool>, isPopupOpen: Binding<Bool>? = nil, onOpen: (() -> Void)? = nil, onClose: (() -> Void)? = nil, @ViewBuilder popupContent: @escaping () -> PopupContent) -> some View where PopupContent : View {
		return ZStack {
			Text(isBarPresented.wrappedValue ? "1" : "2").hidden()
			Text(isPopupOpen?.wrappedValue ?? false ? "3" : "4").hidden()
			LNPopupViewWrapper<Self, PopupContent>(isBarPresented: isBarPresented, isOpen: isPopupOpen ?? Binding.constant(false), onOpen: onOpen, onClose: onClose, popupContent: popupContent) {
				self
			}.edgesIgnoringSafeArea(.all)
		}
	}
	
	/// Presents a popup bar with popup content.
	///
	/// - Parameters:
	///   - isBarPresented: A binding to whether the popup bar is presented.
	///   - isPopupOpen: A binding to whether the popup is open. (optional)
	///   - onOpen: A closure executed when the popup opens. (optional)
	///   - onClose: A closure executed when the popup closes. (optional)
	///   - popupContentController: A UIKit view controller to use as the popup content controller.
	func popup(isBarPresented: Binding<Bool>, isPopupOpen: Binding<Bool>? = nil, onOpen: (() -> Void)? = nil, onClose: (() -> Void)? = nil, popupContentController: UIViewController) -> some View {
		return LNPopupViewWrapper<Self, EmptyView>(isBarPresented: isBarPresented, isOpen: isPopupOpen ?? Binding.constant(false), onOpen: onOpen, onClose: onClose, popupContentController: popupContentController) {
			self
		}.edgesIgnoringSafeArea(.all)
	}
	
	/// Sets the popup interaction style.
	///
	/// - Parameter style: The popup interaction style.
	func popupInteractionStyle(_ style: LNPopupInteractionStyle) -> some View {
		return environment(\.popupInteractionStyle, style)
	}
	
	/// Sets the popup close button style.
	///
	/// - Parameter style: The popup close button style.
	func popupCloseButtonStyle(_ style: LNPopupCloseButtonStyle) -> some View {
		return environment(\.popupCloseButtonStyle, style)
	}
	
	/// Sets the popup bar style.
	///
	/// Setting a custom popup bar view will methis this modifier have no effect.
	///
	/// - Parameter style: The popup bar style.
	func popupBarStyle(_ style: LNPopupBarStyle) -> some View {
		return environment(\.popupBarStyle, style)
	}
	
	/// Sets the popup bar's progress style.
	///
	/// - Parameter style: The popup bar's progress style.
	func popupBarProgressViewStyle(_ style: LNPopupBarProgressViewStyle) -> some View {
		return environment(\.popupBarProgressViewStyle, style)
	}
	
	/// Enables or disables the popup bar marquee scrolling. When enabled, titles and subtitles that are longer than the space available will scroll text over time.
	///
	/// - Parameters:
	///   - enabled: Marquee scroll enabled.
	///   - scrollRate: The scroll rate, in points, of the title and subtitle marquee animation.
	///   - delay: The delay, in seconds, before starting the title and subtitle marquee animation.
	///   - coordinateAnimations: Coordinate the title and subtitle marquee scroll animations.
	func popupBarMarqueeScrollEnabled(_ enabled: Bool, scrollRate: CGFloat? = nil, delay: TimeInterval? = nil, coordinateAnimations: Bool? = nil) -> some View {
		return environment(\.popupBarMarqueeScrollEnabled, enabled).environment(\.popupBarMarqueeRate, scrollRate).environment(\.popupBarMarqueeDelay, delay).environment(\.popupBarCoordinateMarqueeAnimations, coordinateAnimations)
	}
	
	/// Enables or disables the popup bar extension under the safe area.
	///
	/// - Parameter enabled: Extend the popup bar under safe area.
	func popupBarShouldExtendPopupBarUnderSafeArea(_ enabled: Bool) -> some View {
		return environment(\.popupBarShouldExtendPopupBarUnderSafeArea, enabled)
	}
	
	/// Enables or disables the popup bar to automatically inherit its appearance from the bottom docking view, such as toolbar or tab bar.
	///
	/// - Parameter enabled: Extend the popup bar under safe area.
	func popupBarInheritsAppearanceFromDockingView(_ enabled: Bool) -> some View {
		return environment(\.popupBarInheritsAppearanceFromDockingView, enabled)
	}
	
	/// Sets the popup bar's background style. Use `nil` or `LNBackgroundStyleInherit` to use the most appropriate background style for the environment.
	///
	/// - Parameter style: The popup bar's background style.
	@available(*, deprecated, message: "Use popupBarBackgroundEffect() instead.")
	func popupBarBackgroundStyle(_ style: UIBlurEffect.Style?) -> some View {
		let effect: UIBlurEffect?
		if style == nil {
			effect = nil
		//Use explicit value here to prevent a warning.
		} else if style!.rawValue == -9876 {
			effect = nil
		} else {
			effect = UIBlurEffect(style: style!)
		}
		return popupBarBackgroundEffect(effect)
	}
	
	/// Sets the popup bar's background effect. Use `nil` to use the most appropriate background style for the environment.
	///
	/// - Parameter effect: The popup bar's background effect.
	func popupBarBackgroundEffect(_ effect: UIBlurEffect?) -> some View {
		return environment(\.popupBarBackgroundEffect, effect)
	}
	
	/// Sets a custom popup bar view, instead of the default system-provided bars.
	///
	/// If a custom bar view is provided, setting the popup bar style has no effect.
	///
	/// - Parameters:
	///   - wantsDefaultTapGesture: Indicates whether the default tap gesture recognizer should be added to the popup bar.
	///   - wantsDefaultPanGesture: Indicates whether the default pan gesture recognizer should be added to the popup bar.
	///   - wantsDefaultHighlightGesture: Indicates whether the default highlight gesture recognizer should be added to the popup bar.
	///   - popupBarContent: A closure returning the content of the popup bar custom view
	func popupBarCustomView<PopupBarContent>(wantsDefaultTapGesture: Bool = true,
											 wantsDefaultPanGesture: Bool = true,
											 wantsDefaultHighlightGesture: Bool = true,
											 @ViewBuilder popupBarContent: @escaping () -> PopupBarContent) -> some View where PopupBarContent : View {
		return environment(\.popupBarCustomBarView, LNPopupBarCustomView(wantsDefaultTapGesture: wantsDefaultTapGesture, wantsDefaultPanGesture: wantsDefaultPanGesture, wantsDefaultHighlightGesture: wantsDefaultHighlightGesture, popupBarCustomBarView: AnyView(popupBarContent())))
	}
	
	/// Adds a context menu to the popup bar.
	///
	/// Use contextual menus to add actions that change depending on the user's
	/// current focus and task.
	///
	/// The following example creates a popup bar with a contextual menu.
	/// Note that the actions invoked by the menu selection could be coded
	/// directly inside the button closures or, as shown below, invoked via
	/// function references.
	///
	///		func selectHearts() { ... }
	///		func selectClubs() { ... }
	///		func selectSpades() { ... }
	///		func selectDiamonds() { ... }
	///
	///		TabView {
	///		}
	///		.popup(isBarPresented: $isPopupPresented, isPopupOpen: $isPopupOpen) {
	///			PlayerView(song: currentSong)
	///		}
	///		.popupBarContextMenu {
	///			Button("♥️ - Hearts", action: selectHearts)
	///			Button("♣️ - Clubs", action: selectClubs)
	///			Button("♠️ - Spades", action: selectSpades)
	///			Button("♦️ - Diamonds", action: selectDiamonds)
	///		}
	///
	/// - Parameter menuItems: A `contextMenu` that contains one or more menu items.
	func popupBarContextMenu<MenuItems>(@ViewBuilder menuItems: () -> MenuItems) -> some View where MenuItems : View {
		return environment(\.popupBarContextMenu, AnyView(menuItems()))
	}
	
	/// Gives a low-level access to the `LNPopupBar` object for customization, beyond what is exposed by LNPopupUI.
	///
	///	The popup bar customization closure is called after all other popup bar modifiers have been applied.
	///
	/// - Parameters:
	///   - customizer: A customizing closure that is called to customize the popup bar object.
	///   - popupBar: The popup bar to customize.
	func popupBarCustomizer(_ customizer: @escaping (_ popupBar: LNPopupBar) -> Void) -> some View {
		return environment(\.popupBarCustomizer, customizer)
	}
	
	/// Gives a low-level access to the `LNPopupContentView` object for customization, beyond what is exposed by LNPopupUI.
	///
	///	The popup content view customization closure is called after all other popup content view modifiers have been applied.
	///
	/// - Parameters:
	///   - customizer: A customizing closure that is called to customize the popup content view object.
	///   - popupContentView: The popup content view to customize.
	func popupContentViewCustomizer(_ customizer: @escaping (_ popupContentView: LNPopupContentView) -> Void) -> some View {
		return environment(\.popupContentViewCustomizer, customizer)
	}
}

public extension View {
	/// Configures the view's popup bar title and subtitle.
	///
	/// - Parameters:
	///   - localizedTitleKey: The localized title key to display.
	///   - localizedSubtitleKey: The localized subtitle key to display. Defaults to `nil`.
	///   - tableName: The name of the string table to search. If `nil`, use the table in the `Localizable.strings` file.
	///   - bundle: The bundle containing the strings file. If `nil`, use the main bundle.
	///   - titleComment: Contextual information about the title key-value pair.
	///   - subtitleComment: Contextual information about the subtitle key-value pair.
	func popupTitle(_ localizedTitleKey: LocalizedStringKey, subtitle localizedSubtitleKey: LocalizedStringKey? = nil, tableName: String? = nil, bundle: Bundle? = nil, titleComment: String? = nil, subtitleComment: String? = nil) -> some View {
		let subtitle: String?
		if let localizedSubtitleKey = localizedSubtitleKey {
			subtitle = NSLocalizedString(localizedSubtitleKey.stringKey, tableName: tableName, bundle: bundle ?? .main, value: localizedSubtitleKey.stringKey, comment: subtitleComment ?? "")
		} else {
			subtitle = nil
		}
		
		return popupTitle(verbatim: NSLocalizedString(localizedTitleKey.stringKey, tableName: tableName, bundle: bundle ?? .main, value: localizedTitleKey.stringKey, comment: titleComment ?? ""), subtitle: subtitle)
	}
	
	@_disfavoredOverload
	/// Configures the view's popup bar title and subtitle.
	///
	/// - Parameters:
	///   - titleContent: The localized title key to display.
	///   - subtitleContent: The localized subtitle key to display. Defaults to `nil`.
	func popupTitle<S>(_ titleContent: S, subtitle subtitleContent: S? = nil) -> some View where S : StringProtocol {
		let subtitle: String?
		if let subtitleContent = subtitleContent {
			subtitle = String(subtitleContent)
		} else {
			subtitle = nil
		}
		
		return popupTitle(verbatim: String(titleContent), subtitle: subtitle)
	}
	
	/// Configures the view's popup bar title and subtitle.
	///
	/// - Parameters:
	///   - title: The title to display.
	///   - subtitle: The subtitle to display. Defaults to `nil`.
	func popupTitle<S>(verbatim title: S, subtitle: S? = nil) -> some View where S : StringProtocol {
		return popupTitle(verbatim: String(title), subtitle: subtitle == nil ? nil : String(subtitle!))
	}
	
	/// Configures the view's popup bar title and subtitle.
	///
	/// - Parameters:
	///   - title: The title to display.
	///   - subtitle: The subtitle to display. Defaults to `nil`.
	func popupTitle(verbatim title: String, subtitle: String? = nil) -> some View {
		return preference(key: LNPopupTitlePreferenceKey.self, value: LNPopupTitleData(title: title, subtitle: subtitle))
	}
	
	/// Configures the view's popup bar image.
	///
	/// - Parameters:
	///   - image: The image to use.
	func popupImage(_ image: Image) -> some View {
		return preference(key: LNPopupImagePreferenceKey.self, value: image)
	}
	
	/// Configures the view's popup bar progress.
	///
	/// - Parameters:
	///   - progress: The popup bar progress.
	func popupProgress(_ progress: Float) -> some View {
		return preference(key: LNPopupProgressPreferenceKey.self, value: progress)
	}
	
	/// Sets the bar button items to display on the popup bar.
	///
	/// @note For compact popup bars, this is equivalent to trailing button items.
	///
	/// - Parameter content: A view that appears on the trailing edge of the popup bar.
	func popupBarItems<Content>(@ViewBuilder _ content: () -> Content) -> some View where Content : View {
		return preference(key: LNPopupTrailingBarItemsPreferenceKey.self, value: LNPopupAnyViewWrapper(anyView: AnyView(content().edgesIgnoringSafeArea(.all))))
	}
	
	/// Sets the bar button items to display on the popup bar.
	///
	/// @note For prominent popup bars, leading bar items are positioned in the trailing edge of the popup bar.
	///
	/// - Parameter leading: A view that appears on the leading edge of the popup bar.
	func popupBarItems<LeadingContent>(@ViewBuilder leading: () -> LeadingContent) -> some View where LeadingContent: View {
		return preference(key: LNPopupLeadingBarItemsPreferenceKey.self, value: LNPopupAnyViewWrapper(anyView: AnyView(leading().edgesIgnoringSafeArea(.all))))
	}
	
	/// Sets the bar button items to display on the popup bar.
	///
	/// - Parameter trailing: A view that appears on the trailing edge of the popup bar.
	func popupBarItems<TrailingContent>(@ViewBuilder trailing: () -> TrailingContent) -> some View where TrailingContent: View {
		return preference(key: LNPopupTrailingBarItemsPreferenceKey.self, value: LNPopupAnyViewWrapper(anyView: AnyView(trailing().edgesIgnoringSafeArea(.all))))
	}
	
	/// Sets the bar button items to display on the popup bar.
	///
	/// @note For prominent popup bars, leading and trailing bar items are positioned in the trailing edge of the popup bar.
	///
	/// - Parameter leading: A view that appears on the leading edge of the popup bar.
	/// - Parameter trailing: A view that appears on the trailing edge of the popup bar.
	func popupBarItems<LeadingContent, TrailingContent>(@ViewBuilder leading: () -> LeadingContent, @ViewBuilder trailing: () -> TrailingContent) -> some View where LeadingContent: View, TrailingContent: View {
		return preference(key: LNPopupLeadingBarItemsPreferenceKey.self, value: LNPopupAnyViewWrapper(anyView: AnyView((leading()))))
			.preference(key: LNPopupTrailingBarItemsPreferenceKey.self, value: LNPopupAnyViewWrapper(anyView: AnyView((trailing()))))
	}
	
	/// Designates this view as the popup interaction container. Only gestures within this view will be considered for popup interaction, such as dismissal.
	///
	/// @note This method layers a background view behind this view. The background view might interfere with interaction of elements behind it. Use with care.
	func popupInteractionContainer() -> some View {
		return background(LNPopupUIInteractionContainerBackgroundView())
	}
}

public extension View {
	/// Configures the view's popup bar image.
	///
	/// - Parameters:
	///   - name: The name of the image resource to lookup.
	///   - bundle: The bundle to search for the image resource and localization content. If `nil`, uses the main `Bundle`. Defaults to `nil`.
	@available(*, deprecated)
	func popupImage(_ name: String, bundle: Bundle? = nil) -> some View {
		return popupImage(Image(name, bundle: bundle))
	}
	
	/// Configures the view's popup bar image with a system symbol image.
	///
	/// - Parameters:
	///   - systemName: The name of the system symbol image. Use the SF Symbols app to look up the names of system symbol images.
	@available(*, deprecated)
	func popupImage(systemName: String) -> some View {
		return popupImage(Image(systemName: systemName))
	}
	
	/// Configures the view's popup bar image based on a `UIImage`.
	///
	/// - Parameters:
	///   - uiImage: The image to use
	@available(*, deprecated)
	func popupImage(_ uiImage: UIImage) -> some View {
		return popupImage(Image(uiImage: uiImage))
	}
	
	/// Configures the view's popup bar image based on a `CGImage`.
	///
	/// - Parameters:
	///   - cgImage: the base graphical image
	///   - scale: the scale factor the image is intended for (e.g. 1.0, 2.0, 3.0)
	///   - orientation: the orientation of the image
	@available(*, deprecated)
	func popupImage(_ cgImage: CGImage, scale: CGFloat, orientation: UIImage.Orientation = .up) -> some View {
		return popupImage(Image(decorative: cgImage, scale: scale, orientation: UIImageOrientationToImageOrientation(orientation)))
	}
}
