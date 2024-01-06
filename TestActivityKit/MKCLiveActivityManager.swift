//
//  MKCLiveActivityManager.swift
//  TestActivityKit
//
//  Created by huihui.zhang on 2024/1/3.
//

import Foundation
import MKCWidgetExtension
import ActivityKit

class MKCLiveActivityManager {
    static let shared = MKCLiveActivityManager()
    
    @discardableResult
    func startActivity() -> Activity<MKCWidgetAttributes>? {
        guard ActivityAuthorizationInfo().areActivitiesEnabled  else {
            print("no AuthorizationInfo")
            Task {
                for await enable in ActivityAuthorizationInfo().activityEnablementUpdates { // activityEnablementUpdates 这玩意是异步的
                    print("ActivityAuthorizationInfo activityEnablementUpdates:\(enable)")
                }
            }
            return nil
        }
        
        deleteActivity() // 结束掉所有的
        
        
        let attributes = MKCWidgetAttributes(title: "12月月度沟通会", startTime: Date(timeIntervalSinceNow: 10 * 60 * 60))
        let contentState = MKCWidgetAttributes.ContentState(state: .notStart, audience: 1000, barrage: 500)
        let activityContent = ActivityContent(state: contentState, staleDate: Date(timeIntervalSinceNow: 20 * 60 * 60))
        do {
            let current = try Activity.request(attributes: attributes, content: activityContent, pushType: nil)
            Task {
                for await tokenData in current.pushTokenUpdates { // push token变化
                    let mytoken = tokenData.map { String(format: "%02x", $0) }.joined()
                    print("activity push token", mytoken)
                }
            }
            Task {
                for await update in current.contentUpdates { // 动态数据内容变化了
                    print("content state update: tip=\(update.state.state)")
                }
            }
            Task {
                for await state in current.activityStateUpdates { // state变化了
                    print("activity state update: tip=\(state) id:\(current.id)")
                }
            }
            print("request success,id:\(String(describing: current.id))")
            return current
        } catch {
            print("error: \(error)")
            return nil
        }
    }
    
    func deleteActivity() {
        for activity in Activity<MKCWidgetAttributes>.activities { // 打印当前所有activity状态
            print("id:\(activity.id), state:\(activity.activityState)")
        }
        
        let currentActivities = Activity<MKCWidgetAttributes>.activities.filter({$0.activityState == .active}) // 当前或者的activity
        guard !currentActivities.isEmpty else {
            return
        }
        
        for act in currentActivities {
            Task {
                await act.end(nil, dismissalPolicy:.immediate)
            }
        }
    }
    
    
    func updateActivity(_ state: MKCWidgetAttributes.ContentState) {
        Task {
            guard !Activity<MKCWidgetAttributes>.activities.isEmpty else {return}
            let activityContent = ActivityContent(state: state, staleDate: Date(timeIntervalSinceNow: 20 * 60 * 60))
            let alertConfiguation = AlertConfiguration(title: "Live Update", body: "MKC live update to \(state.state.desc())", sound: .default)
            for act in Activity<MKCWidgetAttributes>.activities {
                await act.update(activityContent, alertConfiguration: alertConfiguation)
            }
        }
    }
}
