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

            lockView(context)
                //.activityBackgroundTint(Color.cyan)
                //.activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom")
                    Text("i am huihui.zhang")
                }
            } compactLeading: {
                Image("ecollege_live_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } compactTrailing: {
                Text(context.state.state.desc()).foregroundStyle(Color("islandTitle"))
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
    func lockHeaderView(_ context: ActivityViewContext<MKCWidgetAttributes>) -> some View {
            HStack { // header
                Image("ecollege_live_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 48, height: 48)
                    .padding(.leading, 15)
                    .padding(.top, 15)

                VStack(alignment: .leading, content: {
                    HStack {
                        Text(context.attributes.title)
                            .foregroundStyle(Color("headerTitle"))
                            .font(.system(size: 16))
                            .fontWeight(.bold)
                        Spacer()
                        Image("MK_logo")
                            .resizable()
                            .frame(width: 68.5,height: 10)
                            .padding(.trailing, 18)
                    }
                    .padding(.bottom, 4)
                    
                    Text(context.attributes.subTitleString(state: context.state))
                })
                .padding(.leading, 10)
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color.accent, Color.white]), startPoint: .top, endPoint: .bottom))
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
    }
    
    func createStateItem(_ state: MKCLiveActivityState) -> some View {
        VStack {
            Circle().foregroundColor(.pink).overlay {
                Image(state.imageIcon())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .bold()
            }.frame(width: 32, height: 32)
            Text(state.desc())
                .font(.system(size: 12))
        }
    }
    
    @ViewBuilder
    func lockView(_ context: ActivityViewContext<MKCWidgetAttributes>) -> some View {
        VStack {
            lockHeaderView(context)
            HStack {
                ZStack {
                    HStack(spacing: 0) {
                        createStateItem(.notStart)
                        createProcessView()
                        createStateItem(.playing)
                        createProcessView()
                        createStateItem(.end)
                    }
                    .padding(.leading,15)
                    .padding(.trailing,15)
                    .padding(.bottom,12)
                }
            }
            
        }
        .background(.white)
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
