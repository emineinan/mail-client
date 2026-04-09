@Component
export struct SearchBar {
  @Link query: string

  build() {
    Row() {
      Image($r('app.media.icon_search'))
        .width(14)
        .height(14)
        .margin({ right: 6 })

      TextInput({ text: this.query, placeholder: 'Search' })
        .fontSize(12)
        .placeholderColor('#8E8E93')
        .fontColor(Color.White)
        .backgroundColor(Color.Transparent)
        .padding(0)
        .layoutWeight(1)
        .height(18)
        .onChange((value: string) => {
          this.query = value
        })
    }
    .width('90%')
    .padding({
      left: 10,
      right: 10,
      top: 6,
      bottom: 6
    })
    .borderRadius(14)
    .backgroundColor('#1C1C1E')
    .margin({ top: 3, bottom: 3 })
  }
}
