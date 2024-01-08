//
//  MKCWidgetLiveActivity.swift
//  MKCWidget
//
//  Created by huihui.zhang on 2024/1/3.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MKCLiveWidgetActivity: Widget {
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MKCWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here

            lockView(context, island: false)
                //.activityBackgroundTint(Color.cyan)
                //.activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.bottom) {
                    lockView(context, island: true)
                }
            } compactLeading: {
                Image("ecollege_live_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } compactTrailing: {
                Text(context.state.state.desc()).foregroundStyle(Color("islandTitle"))
                    .font(.system(size: 13,weight: .medium))
            } minimal: {
                Image("ecollege_live_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
    
    @ViewBuilder
    func lockHeaderView(_ context: ActivityViewContext<MKCWidgetAttributes>, island: Bool) -> some View {
            HStack { // header
                Image("ecollege_live_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
                    .padding(.leading, 15)
                VStack(alignment: .leading, content: {
                    HStack {
                        Text(context.attributes.title)
                            .foregroundStyle(island ? Color.white : Color("headerTitle"))
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                        Spacer()
                        Image(island ? "MK_logo_white" : "MK_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 68.5,height: 10)
                            .padding(.trailing, 18)
                    }
                    Text(context.attributes.subTitleString(state: context.state, island: island))
                })
                .padding(.leading, 10)
            }
            .padding(.top, island ? 0:16)
            .if(!island) { view in
                view.background(LinearGradient(gradient: Gradient(colors: [Color("ThemeColor"), Color.white]), startPoint: .top, endPoint: .bottom))
            }
    }
    
    @ViewBuilder
    func createProcessView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .frame(height:8)
                .background(Color("progressBar"))
            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: nil, content: {
                ForEach(0..<5) { index in
                    Circle()
                        .frame(width:6 ,height: 6)
                        .foregroundStyle(Color("progressDot"))
                        .padding(.leading,6)
                }
            })
        }
        .frame(width: 100)
        .offset(y:-8)
    }
    
    func createStateItem(_ state: MKCLiveActivityState, current: MKCLiveActivityState, island: Bool) -> some View {
        VStack {
            Image(state.imageIcon(current))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
            Text(state.desc())
                .font(.system(size: 12))
                .foregroundColor((state == current) ? Color("islandTitle") : (island ? Color.white : Color("StateText")))
                .opacity(state.hidenDesc(current) ? 0.0 : 1.0)
        }
    }
    
    @ViewBuilder
    func lockView(_ context: ActivityViewContext<MKCWidgetAttributes>, island: Bool) -> some View {
        VStack {
            lockHeaderView(context, island: island)
            HStack {
                ZStack {
                    HStack(spacing: 0) {
                        createStateItem(.notStart, current: context.state.state, island: island)
                        createProcessView()
                        createStateItem(.playing, current: context.state.state, island: island)
                        createProcessView()
                        createStateItem(.end, current: context.state.state, island: island)
                    }
                    .padding(.bottom,island ? 0 : 12)
                }
            }
            
        }
        .if(!island) { view in
            view.background(.white)
        }
    }
}

extension MKCWidgetAttributes {
    fileprivate static var preview: MKCWidgetAttributes {
        MKCWidgetAttributes(title: "12月月度沟通会", startTime: Date(timeIntervalSinceNow: 6 * 60 * 60))
    }
}

struct MKCLiveWidgetActivity_Previews: PreviewProvider {
    static let attributes = MKCWidgetAttributes(title: "12月月度沟通会", startTime: Date(timeIntervalSinceNow: 10 * 60 * 60))
    static let contentState = MKCWidgetAttributes.ContentState(state: .notStart, audience: 1000, barrage: 500)

    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
