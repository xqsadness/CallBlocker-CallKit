
import Foundation
import SwiftUI

struct TextShimmer: View {
    var text: String
    var textColor: Color
    var font: Font
    @State var animation = true
    
    var body: some View{
        ZStack{
            Text(text)
                .font(font)
                .foregroundColor(textColor)
            
            HStack(spacing: 0){
                ForEach(0..<text.count,id: \.self){index in
                    Text(String(text[text.index(text.startIndex, offsetBy: index)]))
                        .font(font)
                        .foregroundColor(randomColor())
                }
            }
            .mask(
                Rectangle()
                // For Some More Nice Effect Were Going to use Gradient...
                    .fill(
                        // You can use any Color Here...
                        LinearGradient(gradient: .init(colors: [Color.white.opacity(0.5),Color.white,Color.white.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                    )
                    .rotationEffect(.init(degrees: 70))
                    .padding(0)
                // Moving View Continously...
                // so it will create Shimmer Effect...
                    .offset(x: -150)
                    .offset(x: animation ? 300 : 0)
            )
            .onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                    withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: true)){
                        animation.toggle()
                    }
                }
            })
            
        }
        
    }
    
    func randomColor()->Color{
        let color = Color(red: 1, green: .random(in: 0...1), blue: .random(in: 0...1))
        return color
    }
}
