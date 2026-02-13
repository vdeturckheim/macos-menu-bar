import SwiftUI

enum YCBrand {
    static let orange = Color(red: 1.0, green: 0.4, blue: 0.0) // #FF6600
}

struct YCLogoView: View {
    var size: CGFloat = 80

    var body: some View {
        Image("YCLogo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: size * 0.15))
    }
}
