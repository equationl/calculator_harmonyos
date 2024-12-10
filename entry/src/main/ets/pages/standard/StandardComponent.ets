import { KeyBoardBean } from '../../common/dataBean/KeyBoardBean'
import { KeyBoardData } from '../../constant/KeyBoardData'

@Preview({ width: 1920, height: 1080 })
@Component
export struct StandardComponent {
  build() {
    Column() {
      // 显示数据
      this.ShowScreenContent()

      Divider()
        .width('100%')
        .padding({left: 16, right: 16})

      Stack() {

        // 键盘
        this.KeyBoardContent()

        this.HistoryScreen()
      }
      .width('100%')
      .height('60%')
    }
    .width('100%')
    .height('100%')
  }


  @Builder
  private ShowScreenContent() {
    // TODO
    Column() {

    }
    .height('40%')
    .width('100%')
    .alignItems(HorizontalAlign.End)
    .justifyContent(FlexAlign.SpaceAround)
  }

  @Builder
  private KeyBoardContent() {
    Column() {
      ForEach(KeyBoardData.standardKeyBoardList, (btnRow: KeyBoardBean[]) => {
        Row() {
          ForEach(btnRow, (btn: KeyBoardBean) => {
            Row() {
              this.ButtonContent(btn, () => {
                // TODO
              })
            }
            .layoutWeight(1)
          })
        }
        .width('100%')
        .layoutWeight(1)
      })
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  private HistoryScreen() {
    // TODO
  }

  @Builder
  private ButtonContent(item: KeyBoardBean, onClick: (event: ClickEvent) => void) {
    Button(item.text)
      .width('100%')
      .height('100%')
      .onClick(onClick)
      .type(ButtonType.Normal)
      .backgroundColor(item.isFilled ? item.color : $r('app.color.button_background'))
      .fontColor(item.isFilled ? $r('sys.color.font_on_primary') : item.color)
      .fontWeight(FontWeight.Bold)
      .fontSize($r('app.float.button_font_size'))
  }
}