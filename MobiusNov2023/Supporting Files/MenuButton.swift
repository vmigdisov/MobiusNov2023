//
//  MenuButton.swift
//  MobiusNov2023
//
//  Created by Vsevolod Migdisov on 02.08.2023.
//

import SwiftUI

struct MenuButtonView: View {
    let text: String
    let color: Color
    
    init(_ text: String, _ color: Color) {
        self.text = text
        self.color = color
    }
    
    var body: some View {
        Text(text)
            .foregroundColor(.white)
            .font(.title)
            .padding(Constants.padding)
            .background {
                capsule()
            }
    }
    
    func capsule() -> some View {
        Capsule()
            .fill(color)
    }
    
    // MARK: - Drawing constants
    
    enum Constants {
        static let padding: CGFloat = 32
    }
}

struct MenuButtonView_Previews: PreviewProvider {
    static var previews: some View {
        MenuButtonView("CMDeviceMotion", .cyan)
    }
}
