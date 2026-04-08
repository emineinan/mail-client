import { MailDetail, Recipient } from '../model/MailDetail';
import { MailDetailViewModel } from '../viewmodel/MailDetailViewModel';
import { promptAction } from '@kit.ArkUI';

@Component
export struct MailDetailPage {
  @State viewModel: MailDetailViewModel = new MailDetailViewModel();
  @State mailDetail: MailDetail = this.viewModel.getMailDetailById(0)!
  @State isReplyVisible: boolean = false;
  @State replyText: string = '';
  @Consume('pageStack') pageStack: NavPathStack;
  private smartReplies: string[] = ['Got it, thanks!', 'I\'ll check it later.', 'On it now.', 'Sounds good.'];

  sendReply(): void {
    if (this.replyText.trim() !== '') {
      this.replyText = '';
      this.isReplyVisible = false;
    }
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Bottom }) {
        Scroll() {
          Column() {
            Blank().height(48)

            Text(this.mailDetail.subject)
              .fontSize(20)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Bold)
              .width('100%')
              .textAlign(TextAlign.Center)
              .margin({ bottom: 16 })

            Row() {
              Image($r('app.media.icon_profile'))
                .width(44)
                .height(44)
                .borderRadius(22)
                .margin({ right: 12 })

              Column() {
                Text(this.mailDetail.sender.name)
                  .fontSize(16)
                  .fontColor(Color.White)
                  .fontWeight(FontWeight.Medium)

                Text(this.mailDetail.sender.email)
                  .fontSize(12)
                  .fontColor('#AAAAAA')
              }
              .alignItems(HorizontalAlign.Start)
            }
            .width('90%')
            .backgroundColor('#1C1C1E')
            .padding(12)
            .borderRadius(16)
            .margin({ bottom: 16 })

            Text(this.mailDetail.body)
              .fontSize(15)
              .fontColor('#E0E0E0')
              .width('90%')
              .lineHeight(22)
              .margin({ bottom: 24 })

            if (!this.isReplyVisible) {
              Text('Smart Reply')
                .fontSize(14)
                .fontColor('#8E8E93')
                .margin({ bottom: 12 })

              Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center }) {
                ForEach(this.smartReplies, (reply: string) => {
                  Button(reply)
                    .fontSize(12)
                    .fontColor(Color.White)
                    .backgroundColor('#2C2C2E')
                    .margin(4)
                    .padding({ left: 12, right: 12 })
                    .height(32)
                    .borderRadius(16)
                    .onClick(() => {
                      this.replyText = reply;
                      this.sendReply();
                      promptAction.showToast({ message: 'Reply Sent' });
                    })
                })
              }
              .width('90%')
              .margin({ bottom: 120 })
            }
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
        }
        .width('100%')
        .height('100%')
        .scrollBar(BarState.Off)

        // Reply Button
        if (!this.isReplyVisible) {
          Button() {
            Row({ space: 8 }) {
              Image($r('app.media.icon_sent'))
                .width(18)
                .height(18)
              Text('Reply')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor(Color.White)
            }
          }
          .backgroundColor('#0A84FF')
          .height(48)
          .width('60%')
          .borderRadius(24)
          .margin({ bottom: 20 })
          .onClick(() => {
            this.isReplyVisible = true;
          })
        }

        // Reply UI Overlay
        if (this.isReplyVisible) {
          Column() {
            Blank().height(40)
            Row() {
              Text('To: ')
                .fontSize(14)
                .fontColor('#AAAAAA')
              Text(this.mailDetail.sender.name)
                .fontSize(14)
                .fontColor(Color.White)
                .fontWeight(FontWeight.Medium)
            }
            .width('90%')
            .margin({ bottom: 12 })

            TextArea({ placeholder: 'Type your reply...', text: this.replyText })
              .placeholderColor('#777777')
              .fontSize(14)
              .fontColor(Color.White)
              .backgroundColor('#1C1C1E')
              .width('90%')
              .height(80)
              .borderRadius(12)
              .margin({ bottom: 16 })
              .onChange((value: string) => {
                this.replyText = value;
              })

            Row({ space: 12 }) {
              Button('Cancel')
                .fontSize(14)
                .fontColor(Color.White)
                .backgroundColor('#3A3A3C')
                .height(40)
                .layoutWeight(1)
                .borderRadius(20)
                .onClick(() => {
                  this.isReplyVisible = false;
                  this.replyText = '';
                })

              Button('Send')
                .fontSize(14)
                .fontColor(Color.White)
                .backgroundColor('#0A84FF')
                .height(40)
                .layoutWeight(1)
                .borderRadius(20)
                .onClick(() => {
                  this.sendReply();
                  promptAction.showToast({ message: 'Reply Sent' });
                })
            }
            .width('90%')
          }
          .width('100%')
          .height('100%')
          .backgroundColor('#000000')
          .alignItems(HorizontalAlign.Center)
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#000000')
    }.onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
      const params = ctx.pathInfo.param as MailDetail;
      if (params) {
        this.mailDetail = params;
        this.mailDetail = this.viewModel.getMailDetailById(params.id)!
      }
    })
    .hideBackButton(true)
  }
}