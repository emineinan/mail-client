import { MailFolder } from '../model/MailFolder';
import { vibrator } from '@kit.SensorServiceKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Component
export struct FolderItem {
  @Prop folder: MailFolder;
  onFolderClick: (mailFolder: MailFolder) => void = () => {
  };

  build() {
    Row() {
      Row({ space: 12 }) {
        Image(this.folder.icon)
          .width(24)
          .height(24)

        Text(this.folder.name)
          .fontSize(18)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Medium)
      }

      if (this.folder.unreadCount > 0) {
        Text(this.folder.unreadCount.toString())
          .fontSize(14)
          .fontColor(Color.White)
          .backgroundColor('#0A84FF')
          .borderRadius(12)
          .width(24)
          .height(24)
          .textAlign(TextAlign.Center)
      }

    }
    .width('90%')
    .padding({
      left: 16,
      right: 16,
      top: 14,
      bottom: 14
    })
    .justifyContent(FlexAlign.SpaceBetween)
    .borderRadius(20)
    .backgroundColor('#1C1C1E')
    .margin({ top: 6, bottom: 6 })
    .onClick(() => {
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
      this.onFolderClick(this.folder);
    })
  }
}
