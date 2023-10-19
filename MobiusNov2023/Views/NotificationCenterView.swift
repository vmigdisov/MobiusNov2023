//
//  NotificationCenterView.swift
//  MobiusNov2023
//
//  Created by Vsevolod Migdisov on 03.08.2023.
//

import SwiftUI
import Foundation

struct NotificationCenterView: View {
    @State var isLocked = false
    
    var body: some View {
        Text(isLocked ?  "****" : "100 ₽")
            .font(Constants.lockFont)
            .foregroundColor(.accentColor)
            .onReceive(
                NotificationCenter.default.publisher(
                    for: UIDevice.orientationDidChangeNotification
                )
            ) { _ in
                if UIDevice.current.orientation == .faceDown {
                    isLocked.toggle()
                }
            }
    }
    
    // MARK: - Drwaing constants
    
    private enum Constants {
        static let lockFont = Font.system(size: 150, weight: .ultraLight)
    }
}

struct NotificationCenterView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationCenterView()
    }
}
