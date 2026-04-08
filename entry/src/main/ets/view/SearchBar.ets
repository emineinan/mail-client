@Component
export struct SearchBar {
  @State query: string = ''

  build() {
    Row() {
      Image($r('app.media.icon_search'))
        .width(20)
        .height(20)
        .margin({ right: 8 })

      TextInput({ text: this.query, placeholder: 'Search' })
        .fontSize(14)
        .placeholderColor('#8E8E93')
        .fontColor(Color.White)
        .backgroundColor(Color.Transparent)
        .padding(0)
        .layoutWeight(1)
        .height(24)
    }
    .width('90%')
    .padding({
      left: 16,
      right: 16,
      top: 12,
      bottom: 12
    })
    .borderRadius(20)
    .backgroundColor('#1C1C1E')
    .margin({ top: 10, bottom: 10 })
  }
}