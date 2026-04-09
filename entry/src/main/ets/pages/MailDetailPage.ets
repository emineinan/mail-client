import { MailDetail, Recipient } from '../model/MailDetail';
import { MailDetailViewModel } from '../viewmodel/MailDetailViewModel';
import { MailListViewModel } from '../viewmodel/MailListViewModel';
import { promptAction } from '@kit.ArkUI';

@Component
export struct MailDetailPage {
  @State viewModel: MailDetailViewModel = new MailDetailViewModel();
  @State mailListViewModel: MailListViewModel = new MailListViewModel();
  @State mailDetail: MailDetail = this.viewModel.getMailDetailById(0)!
  @State isReplyVisible: boolean = false;
  @State replyText: string = '';
  @Consume('pageStack') pageStack: NavPathStack;
  private smartReplies: string[] = ['Got it, thanks!', 'I\'ll check it later.', 'On it now.', 'Sounds good.'];

  async sendReply() {
    if (this.replyText.trim() !== '') {
      // If it's a draft, move it to sent in the model
      await this.mailListViewModel.sendDraft(this.mailDetail.id);

      this.replyText = '';
      this.isReplyVisible = false;
      // Return to homepage and clear the stack
      this.pageStack.clear();
      this.pageStack.pushPathByName('HomePage', null);
    }
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Bottom }) {
        Scroll() {
          Column() {
            Blank().height(48)

            Text(this.mailDetail.subject)
              .fontSize(16)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Bold)
              .width('100%')
              .textAlign(TextAlign.Center)
              .margin({ bottom: 10 })

            Row() {
              Image($r('app.media.icon_profile'))
                .width(36)
                .height(36)
                .borderRadius(18)
                .margin({ right: 8 })

              Column() {
                Text(this.mailDetail.sender.name)
                  .fontSize(13)
                  .fontColor(Color.White)
                  .fontWeight(FontWeight.Medium)

                Text(this.mailDetail.sender.email)
                  .fontSize(10)
                  .fontColor('#AAAAAA')
              }
              .alignItems(HorizontalAlign.Start)
            }
            .width('90%')
            .backgroundColor('#1C1C1E')
            .padding(8)
            .borderRadius(12)
            .margin({ bottom: 10 })

            Text(this.mailDetail.body)
              .fontSize(12)
              .fontColor('#E0E0E0')
              .width('90%')
              .lineHeight(16)
              .margin({ bottom: 16 })

            if (!this.isReplyVisible) {
              Text('Smart Reply')
                .fontSize(11)
                .fontColor('#8E8E93')
                .margin({ bottom: 6 })

              Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center }) {
                ForEach(this.smartReplies, (reply: string) => {
                  Button(reply)
                    .fontSize(10)
                    .fontColor(Color.White)
                    .backgroundColor('#2C2C2E')
                    .margin(2)
                    .padding({ left: 8, right: 8 })
                    .height(24)
                    .borderRadius(12)
                    .onClick(() => {
                      this.replyText = reply;
                      this.sendReply();
                      promptAction.showToast({ message: 'Reply Sent' });
                    })
                })
              }
              .width('90%')
              .margin({ bottom: 80 })
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
            Row({ space: 6 }) {
              Image($r('app.media.icon_sent'))
                .width(14)
                .height(14)
              Text('Reply')
                .fontSize(13)
                .fontWeight(FontWeight.Medium)
                .fontColor(Color.White)
            }
          }
          .backgroundColor('#0A84FF')
          .height(34)
          .width('50%')
          .borderRadius(17)
          .margin({ bottom: 16 })
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
                .fontSize(11)
                .fontColor('#AAAAAA')
              Text(this.mailDetail.sender.name)
                .fontSize(11)
                .fontColor(Color.White)
                .fontWeight(FontWeight.Medium)
            }
            .width('90%')
            .margin({ bottom: 8 })

            TextArea({ placeholder: 'Type your reply...', text: this.replyText })
              .placeholderColor('#777777')
              .fontSize(12)
              .fontColor(Color.White)
              .backgroundColor('#1C1C1E')
              .width('90%')
              .height(60)
              .borderRadius(8)
              .margin({ bottom: 10 })
              .onChange((value: string) => {
                this.replyText = value;
              })

            Row({ space: 8 }) {
              Button('Cancel')
                .fontSize(11)
                .fontColor(Color.White)
                .backgroundColor('#3A3A3C')
                .height(32)
                .layoutWeight(1)
                .borderRadius(16)
                .onClick(() => {
                  this.isReplyVisible = false;
                  this.replyText = '';
                })

              Button('Send')
                .fontSize(11)
                .fontColor(Color.White)
                .backgroundColor('#0A84FF')
                .height(32)
                .layoutWeight(1)
                .borderRadius(16)
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
      this.mailListViewModel.initPreferences(ctx.pathStack.getContext());
    })
    .hideBackButton(true)
  }
}
