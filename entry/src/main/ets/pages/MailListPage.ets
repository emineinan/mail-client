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

  @Builder
  SwipeActionButtons() {
    Row() {
      Button() {
        Image($r('app.media.icon_trash'))
          .width(20)
          .height(20)
      }
      .type(ButtonType.Circle)
      .backgroundColor('#FF453A')
      .width(40)
      .height(40)
      .margin({ left: 8, right: 8 })
      .onClick(() => {
        this.triggerHapticFeedback();
      })

      Button() {
        Image($r('app.media.icon_all_mail'))
          .width(20)
          .height(20)
      }
      .type(ButtonType.Circle)
      .backgroundColor('#30D158')
      .width(40)
      .height(40)
      .margin({ right: 16 })
      .onClick(() => {
        this.triggerHapticFeedback();
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
              Blank().height(36)
              Text(this.mailFolder.name)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
                .margin({ bottom: 12 })
              SearchBar()
            }.width('100%')
          }

          ForEach(this.viewModel.getMailsByFolder(this.mailFolder.id), (mail: Mail) => {
            ListItem() {
              MailItem({
                mail: mail,
                onMailClick: (mail: Mail) => {
                  this.pageStack.pushPathByName('MailDetailPage', mail);
                } })
            }
            .swipeAction({ end: this.SwipeActionButtons.bind(this) })
          }, (mail: Mail): string => mail.id.toString())

          ListItem() {
            Blank().height(36)
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
