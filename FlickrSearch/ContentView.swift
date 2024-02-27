//
//  ContentView.swift
//  FlickrSearch
//
//  Created by Jacob Banks on 2/26/24.
//

import WebKit
import Combine
import SwiftUI

struct ContentView: View {

    var body: some View {
        NavigationStack {
            ImageListView()
        }
        .preferredColorScheme(.dark)
    }

}

#Preview {
    ContentView()
}
