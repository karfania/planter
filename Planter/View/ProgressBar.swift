//
//  Progressbar.swift
//  tempPlanterViews
//
//  Created by Kory Arfania on 12/5/23.
//
import SwiftUI
struct ProgressBar: View {
    var percentage: CGFloat

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color.gray)

                Rectangle()
                    .frame(width: min(CGFloat(self.percentage / 100.0) * geometry.size.width, geometry.size.width), height: geometry.size.height)
            }
            .cornerRadius(5.0)
        }
    }
}

#Preview {
    HomeView()
}
