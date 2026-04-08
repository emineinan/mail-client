import { HomeViewModel } from '../viewmodel/HomeViewModel';
import { MailFolder } from '../model/MailFolder';
import { FolderItem } from '../view/FolderItem';

@Component
export struct HomePage {
  @Consume('pageStack') pageStack: NavPathStack;
  @State viewModel: HomeViewModel = new HomeViewModel();

  build() {
    NavDestination() {
      Column() {
        List() {
          ListItem() {
            Column() {
              Blank().height(44)
              Text('Mail')
                .fontSize(24)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
                .margin({ bottom: 12 })
            }.width('100%')
          }

          ForEach(this.viewModel.getMailFolders(), (folder: MailFolder) => {
            ListItem() {
              FolderItem({
                folder: folder,
                onFolderClick: (folder: MailFolder) => {
                  this.pageStack.pushPathByName('MailListPage', folder);
                }
              })
            }
          }, (folder: MailFolder): string => folder.id.toString())

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
    })
    .hideBackButton(true)
  }
}