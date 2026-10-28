import SwiftUI
import UIKit

struct ContentView: View {
    // 标准坏点检测8色，全部改用RGB，兼容新版SwiftUI
    let testColors: [(name: String, color: Color)] = [
        ("Black", Color(red:0, green:0, blue:0)),
        ("White", Color(red:1, green:1, blue:1)),
        ("Red", Color(red:1, green:0, blue:0)),
        ("Green", Color(red:0, green:1, blue:0)),
        ("Blue", Color(red:0, green:0, blue:1)),
        ("Yellow", Color(red:1, green:1, blue:0)),
        ("Cyan", Color(red:0, green:1, blue:1)),
        ("Magenta", Color(red:1, green:0, blue:1))
    ]
    
    @State private var currentIndex = 0
    @State private var showColorName = false
    @State private var originalBrightness: CGFloat = 0.2
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        ZStack {
            testColors[currentIndex].color
                .ignoresSafeArea()
            
            if showColorName {
                Text(testColors[currentIndex].name)
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 6)
            }
            
            VStack {
                Spacer()
                VStack(spacing:8) {
                    Text("\(currentIndex+1) / \(testColors.count)")
                        .font(.caption)
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 3)
                    
                    ProgressView(value: Double(currentIndex), total: Double(testColors.count - 1))
                        .tint(.white)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
        .statusBarHidden(true)
        .onTapGesture {
            withAnimation(.easeInOut) {
                currentIndex = (currentIndex + 1) % testColors.count
            }
        }
        .onLongPressGesture(minimumDuration: 0.3, maximumDistance: 30) {} onPressingChanged: { isPressing in
            showColorName = isPressing
        }
        .gesture(
            DragGesture(minimumDistance: 30)
                .onEnded { value in
                    let dx = value.translation.width
                    withAnimation(.easeInOut) {
                        if dx > 40 {
                            currentIndex = currentIndex - 1 < 0 ? testColors.count - 1 : currentIndex - 1
                        } else if dx < -40 {
                            currentIndex = (currentIndex + 1) % testColors.count
                        }
                    }
                }
        )
        .onAppear {
            originalBrightness = UIScreen.main.brightness
            UIScreen.main.brightness = 1.0
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background || newPhase == .inactive {
                UIScreen.main.brightness = originalBrightness
            } else if newPhase == .active {
                UIScreen.main.brightness = 1.0
            }
        }
    }
}

#Preview {
    ContentView()
}
