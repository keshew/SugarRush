import SwiftUI

extension Text {
    func Bowlby(size: CGFloat,
                color: Color = .white,
                    outlineWidth: CGFloat = 1,
                    colorOutline: Color = Color(red: 145/255, green: 17/255, blue: 38/255)) -> some View {
        self.font(.custom("BowlbyOneSC-Regular", size: size))
            .foregroundColor(color)
            .outlineText(color: colorOutline, width: outlineWidth)
    }
}

