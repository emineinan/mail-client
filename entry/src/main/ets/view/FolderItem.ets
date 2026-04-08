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
      Row({ space: 8 }) {
        Image(this.folder.icon)
          .width(20)
          .height(20)

        Text(this.folder.name)
          .fontSize(16)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Medium)
      }

      if (this.folder.unreadCount > 0) {
        Text(this.folder.unreadCount.toString())
          .fontSize(12)
          .fontColor(Color.White)
          .backgroundColor('#0A84FF')
          .borderRadius(10)
          .width(20)
          .height(20)
          .textAlign(TextAlign.Center)
      }

    }
    .width('90%')
    .padding({
      left: 12,
      right: 12,
      top: 10,
      bottom: 10
    })
    .justifyContent(FlexAlign.SpaceBetween)
    .borderRadius(16)
    .backgroundColor('#1C1C1E')
    .margin({ top: 4, bottom: 4 })
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
