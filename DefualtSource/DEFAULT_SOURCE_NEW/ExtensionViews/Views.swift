
import Foundation
import SwiftUI

//MARK: - Confetti Cannon
public extension View {
    @ViewBuilder func confettiCannon(
        counter: Binding<Int>,
        num: Int = 20,
        confettis: [ConfettiType] = ConfettiType.allCases,
        colors: [Color] = [.blue, .red, .green, .yellow, .pink, .purple, .orange],
        confettiSize: CGFloat = 10.0,
        rainHeight: CGFloat = 600.0,
        fadesOut: Bool = true,
        opacity: Double = 1.0,
        openingAngle: Angle = .degrees(60),
        closingAngle: Angle = .degrees(120),
        radius: CGFloat = 300,
        repetitions: Int = 0,
        repetitionInterval: Double = 1.0
    ) -> some View {
        ZStack {
            self
            ConfettiCannon(
                counter: counter,
                num: num,
                confettis: confettis,
                colors: colors,
                confettiSize: confettiSize,
                rainHeight: rainHeight,
                fadesOut: fadesOut,
                opacity: opacity,
                openingAngle: openingAngle,
                closingAngle: closingAngle,
                radius: radius,
                repetitions: repetitions,
                repetitionInterval: repetitionInterval
            )
        }
    }
}

// MARK: - Custom view extension for ui building
extension View{
    // Mark: Closes the keyboard by resigning the first responder in the application.
    func closeKeyBoard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    // Mark: Disables the view with opacity
    func disableWithOpacity(_ condition: Bool) -> some View{
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
    
    // Mark: Horizontally aligns the view within its frame.
    func hAlign(_ alignment: Alignment) -> some View{
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    // Mark: Vertically aligns the view within its frame.
    func vAlign(_ alignment: Alignment) -> some View{
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    // Mark: Sets the frame width and height for the view.
    func frameWH(width: CGFloat?, height: CGFloat?) -> some View{
        self
            .frame(width: width, height: height)
    }
    
    // Mark: custom border view with padding
    func border (_ width: CGFloat, _ color: Color) -> some View{
        self
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background{
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(color,lineWidth: width)
            }
    }
    
    // Mark: custom fill view with padding
    func fillView (_ color: Color) -> some View{
        self
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background{
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(color)
            }
    }
    
    // Mark: Applies a corner radius to a view with the specified corners.
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    
    // Mark: Applies a linear gradient to a view with specified colors and frame height.
    func linearGradient()->some View{
        LinearGradient(gradient: Gradient(colors: [Color(hex: "2C2A4B"), Color(hex: "1E1E2F")]), startPoint: .top, endPoint: .bottom)
            .frame(height: 90)
    }
    
    // Mark:  Applies an angular gradient to a view with specified colors.
    func angularGradient()->some View{
        AngularGradient(gradient: Gradient(colors: [.red, .purple, .blue, .green, .yellow, .red]), center: .center)
    }
    
    // Mark: Applies a background color and corner radius to a view.
    func rounded(backgroundColor: Color) -> some View {
        modifier (Rounded(backgroundColor: backgroundColor))
    }
    
    // Mark: Styles a text with specified foreground color and font.
    func styledText(text: String, foregroundColor: Color, font: Font) -> some View {
        Text(text)
            .foregroundColor(foregroundColor)
            .font(font)
    }
    
    // Mark: Applies a custom button style with specified background color, text color, and corner radius.
    func customButtonStyle(backgroundColor: Color, textColor: Color, cornerRadius: CGFloat) -> some View {
        self.modifier(CustomButtonModifier(backgroundColor: backgroundColor, textColor: textColor, cornerRadius: cornerRadius))
    }
    
    // Mark: Places a placeholder view over a text field
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}

extension View {
#if os(iOS)
    func onBackground(_ f: @escaping () -> Void) -> some View {
        self.onReceive(
            NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification),
            perform: { _ in f() }
        )
    }
    
    func onForeground(_ f: @escaping () -> Void) -> some View {
        self.onReceive(
            NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification),
            perform: { _ in f() }
        )
    }
#else
    func onBackground(_ f: @escaping () -> Void) -> some View {
        self.onReceive(
            NotificationCenter.default.publisher(for: NSApplication.willResignActiveNotification),
            perform: { _ in f() }
        )
    }
    
    func onForeground(_ f: @escaping () -> Void) -> some View {
        self.onReceive(
            NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification),
            perform: { _ in f() }
        )
    }
#endif
}

extension View {
    func popup<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        return ZStack {
            self
            
            if isPresented.wrappedValue {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation {
                            isPresented.wrappedValue = false
                        }
                    }
                
                content()
                    .transition(.scale)
            }
        }
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
