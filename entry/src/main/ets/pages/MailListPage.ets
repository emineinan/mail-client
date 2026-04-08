import { Mail } from '../model/Mail';
import { MailFolder } from '../model/MailFolder';
import { MailListViewModel } from '../viewmodel/MailListViewModel';
import { SearchBar } from '../view/SearchBar';
import { MailItem } from '../view/MailItem';
import { vibrator } from '@kit.SensorServiceKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Component
export struct MailListPage {
  @State viewModel: MailListViewModel = new MailListViewModel();
  @State mailFolder: MailFolder = new MailFolder(0, '', $r('app.media.icon_all_mail'), 0);
  @State searchQuery: string = '';

  @Consume('pageStack') pageStack: NavPathStack;

  private triggerHapticFeedback() {
    try {
      vibrator.startVibration({
        type: 'time',
        duration: 50,
      }, {
        id: 0,
        usage: 'touch'
      }, (error: BusinessError) => {
        if (error) {
          console.error(`Failed to start vibration. Code: ${error.code}, message: ${error.message}`);
        }
      });
    } catch (err) {
      console.error('An unexpected error occurred while attempting to vibrate:', err);
    }
  }

  private getFilteredMails(): Mail[] {
    const mails = this.viewModel.getMailsByFolder(this.mailFolder.id);
    if (this.searchQuery.trim() === '') {
      return mails;
    }
    const query = this.searchQuery.toLowerCase();
    return mails.filter(mail =>
      mail.sender.toLowerCase().includes(query) ||
      mail.subject.toLowerCase().includes(query) ||
      mail.preview.toLowerCase().includes(query)
    );
  }

  @Builder
  SwipeActionButtons(mail: Mail) {
    Row() {
      Button() {
        Image($r('app.media.icon_trash'))
          .width(18)
          .height(18)
      }
      .type(ButtonType.Circle)
      .backgroundColor('#FF453A')
      .width(36)
      .height(36)
      .margin({ left: 8, right: 8 })
      .onClick(() => {
        this.triggerHapticFeedback();
        this.viewModel.deleteMail(mail.id);
      })

      Button() {
        Image($r('app.media.icon_all_mail'))
          .width(18)
          .height(18)
      }
      .type(ButtonType.Circle)
      .backgroundColor('#30D158')
      .width(36)
      .height(36)
      .margin({ right: 12 })
      .onClick(() => {
        this.triggerHapticFeedback();
        this.viewModel.archiveMail(mail.id);
      })
    }
    .height('100%')
    .justifyContent(FlexAlign.End)
  }

  build() {
    NavDestination() {
      Column() {
        List() {
          ListItem() {
            Column() {
              Blank().height(44)
              Text(this.mailFolder.name)
                .fontSize(22)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
                .margin({ bottom: 8 })
              SearchBar({ query: $searchQuery })
            }.width('100%')
          }

          ForEach(this.getFilteredMails(), (mail: Mail) => {
            ListItem() {
              MailItem({
                mail: mail,
                onMailClick: (mail: Mail) => {
                  this.pageStack.pushPathByName('MailDetailPage', mail);
                } })
            }
            .swipeAction({ end: this.SwipeActionButtons(mail) })
          }, (mail: Mail): string => mail.id.toString() + this.viewModel.mails.length)

          ListItem() {
            Blank().height(40)
          }
        }
        .width('100%')
        .height('100%')
        .alignListItem(ListItemAlign.Center)
        .listDirection(Axis.Vertical)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#000000')
    }.onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
      const params = ctx.pathInfo.param as MailFolder ;
      if (params) {
        this.mailFolder = params;
      }
    })
    .hideBackButton(true)
  }
}
