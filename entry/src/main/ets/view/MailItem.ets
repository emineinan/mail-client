import { Mail } from '../model/Mail';
import { vibrator } from '@kit.SensorServiceKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Component
export struct MailItem {
  @Prop mail: Mail;
  onMailClick: (mail: Mail) => void = () => {
  };

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

  build() {
    Column() {
      Row() {
        Text(this.mail.sender)
          .fontSize(16)
          .fontWeight(this.mail.isRead ? FontWeight.Normal : FontWeight.Bold)
          .fontColor(Color.White)
          .layoutWeight(1)

        Text(this.mail.date)
          .fontSize(12)
          .fontColor('#8E8E93')
      }
      .width('100%')

      Text(this.mail.subject)
        .fontSize(14)
        .fontWeight(this.mail.isRead ? FontWeight.Normal : FontWeight.Medium)
        .fontColor(this.mail.isRead ? '#CCCCCC' : Color.White)
        .margin({ top: 4 })
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      Text(this.mail.preview)
        .fontSize(12)
        .fontColor('#8E8E93')
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(2)
        .margin({ top: 4 })
        .width('100%')
        .textAlign(TextAlign.Start)
    }
    .onClick(() => {
      this.triggerHapticFeedback();
      this.onMailClick(this.mail);
    })
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .borderRadius(20)
    .backgroundColor('#1C1C1E')
    .alignItems(HorizontalAlign.Start)
  }
}