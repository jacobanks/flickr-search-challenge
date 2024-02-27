//
//  ProgressModifier.swift
//  FlickrSearch
//
//  Created by Jacob Banks on 2/27/24.
//

import Foundation
import SwiftUI

struct ProgressViewModifier: ViewModifier {

    @Binding var isLoading: Bool

    func body(content: Content) -> some View {
        VStack(spacing: 8) {
            if isLoading {
                ProgressView()
                    .controlSize(.large)
            }

            content
        }
    }

}

extension View {
    func progress(_ isLoading: Binding<Bool>) -> some View {
        modifier(ProgressViewModifier(isLoading: isLoading))
    }
}
