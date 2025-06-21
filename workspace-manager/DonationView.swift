import SwiftUI

struct DonationView: View {
  var body: some View {
    Link(destination: URL(string: "https://ko-fi.com/jtpotato")!) {
      VStack(alignment: .leading) {
        Text("This program is free to use but only possible through the support of users like you.")
          .foregroundColor(.primary)  // Adapts to light/dark mode
        Text("If you find this useful, please consider donating by clicking here. 🩵")
          .foregroundColor(.primary)  // Adapts to light/dark mode
      }
      .padding()
      .background(Color.gray.opacity(0.2))
      .cornerRadius(12)
      .overlay(
        RoundedRectangle(cornerRadius: 12)
          .stroke(Color.gray.opacity(0.5), lineWidth: 2)
      )
    }
    .padding(.bottom)
  }
}

#Preview {
  DonationView()
}
