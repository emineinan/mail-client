@Component
export struct SearchBar {
  @Link query: string

  build() {
    Row() {
      Image($r('app.media.icon_search'))
        .width(16)
        .height(16)
        .margin({ right: 6 })

      TextInput({ text: this.query, placeholder: 'Search' })
        .fontSize(14)
        .placeholderColor('#8E8E93')
        .fontColor(Color.White)
        .backgroundColor(Color.Transparent)
        .padding(0)
        .layoutWeight(1)
        .height(20)
        .onChange((value: string) => {
          this.query = value
        })
    }
    .width('90%')
    .padding({
      left: 12,
      right: 12,
      top: 8,
      bottom: 8
    })
    .borderRadius(16)
    .backgroundColor('#1C1C1E')
    .margin({ top: 4, bottom: 4 })
  }
}
