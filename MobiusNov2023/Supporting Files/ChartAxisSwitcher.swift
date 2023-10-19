//
//  ChartAxisSwitcher.swift
//  MobiusNov2023
//
//  Created by Vsevolod Migdisov on 03.08.2023.
//

import SwiftUI

final class ChartAxisSwitcherViewModel: ObservableObject {
    @Published var showX = false
    @Published var showY = false
    @Published var showZ = true
}

struct ChartAxisSwitcher: View {
    @ObservedObject var viewModel: ChartAxisSwitcherViewModel
    
    var body: some View {
        HStack(spacing: Constants.spacing) {
            buttonView("X", viewModel.showX) { viewModel.showX.toggle() }
            buttonView("Y", viewModel.showY) { viewModel.showY.toggle() }
            buttonView("Z", viewModel.showZ) { viewModel.showZ.toggle() }
        }
        .padding()
        .padding(.horizontal)
    }
    
    func buttonView(
        _ text: String,
        _ isSelected: Bool,
        onTap: @escaping () -> Void
    ) -> some View {
        Button(action: onTap) {
            Text(text)
                .foregroundColor(isSelected ? Color.white : Color.purple)
                .frame(width: Constants.buttonSize, height: Constants.buttonSize)
        }
        .overlay {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke(isSelected ? Color.clear :  Color.purple)
        }
        .background {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .fill(isSelected ? Color.purple :  Color.clear)
        }
    }
    
    // MARK: - Drawing constants
    
    enum Constants {
        static let cornerRadius: CGFloat = 12
        static let spacing: CGFloat = 16
        static let buttonSize: CGFloat = 48
    }
}

struct ChartAxisSwitcher_Previews: PreviewProvider {
    static var previews: some View {
        ChartAxisSwitcher(
            viewModel: ChartAxisSwitcherViewModel()
        )
    }
}
