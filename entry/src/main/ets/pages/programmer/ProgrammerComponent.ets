import { KeyBoardBean } from '../../common/dataBean/KeyBoardBean'
import { KeyBoardData } from '../../constant/KeyBoardData'

@Component
export struct ProgrammerComponent {
  build() {
    Row() {
      this.LeftKeyBoardContent()
      Divider()
        .vertical(true)
        .padding({top: 16, bottom: 16})
      this.CenterScreenContent()
      Divider()
        .vertical(true)
        .padding({top: 16, bottom: 16})
      this.RightKeyBoardContent()
    }
    .width('100%')
    .height('100%')
    .margin({ top: 16 })
  }

  @Builder
  private LeftKeyBoardContent() {
    Column() {
      ForEach(KeyBoardData.ProgrammerLeftKeyList, (rowData: KeyBoardBean[]) => {
        Row() {
          ForEach(rowData, (item: KeyBoardBean) => {
            Row() {
              this.ButtonContent(item.text, () => {
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
    .width('25%')
    .height('100%')
  }

  @Builder
  private CenterScreenContent() {
    Column() {
      Column() {
        // TODO 运算字符
      }
      .alignItems(HorizontalAlign.End)
      .width('100%')

      Scroll() {
        Column() {
          // TODO 不同进制数据
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')
      }
      .scrollable(ScrollDirection.Vertical)
      .width('100%')
    }
    .justifyContent(FlexAlign.SpaceAround)
    .width('50%')
    .height('100%')
  }

  @Builder
  private RightKeyBoardContent() {
    Column() {
      ForEach(KeyBoardData.ProgrammerRightKeyList, (rowData: KeyBoardBean[]) => {
        Row() {
          ForEach(rowData, (item: KeyBoardBean) => {
            Row() {
              this.ButtonContent(item.text, () => {
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
    .width('25%')
    .height('100%')
  }

  // TODO
  @Builder
  private ButtonContent(text: string, onClick: (event: ClickEvent) => void) {
    Button() {
      Text(text)
    }
    .onClick(onClick)
  }
}