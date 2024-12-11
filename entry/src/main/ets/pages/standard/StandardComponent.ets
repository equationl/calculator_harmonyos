import { KeyBoardBean } from '../../common/dataBean/KeyBoardBean'
import { OperatorEnum } from '../../common/dataBean/OperatorEnum'
import { KeyBoardData } from '../../constant/KeyBoardData'
import { calculate } from '../../util/CalculaUtil'
import { formatNumber } from '../../util/FormatUtil'
import { hilog } from '@kit.PerformanceAnalysisKit'
import { BigNumber } from 'bignumber.js'
import { HistoryBean } from '../../common/dataBean/HistoryBean'
import { window } from '@kit.ArkUI'
import { common } from '@kit.AbilityKit'
import { BusinessError } from '@kit.BasicServicesKit'

@Preview
@Component
export struct StandardComponent {
  @State
  lastShowText: string = ""
  @State
  lastInputValue: string = ""
  @State
  showText: string = ""
  @State
  inputValue: string = "0"
  @State
  isFinalResult: boolean = false
  @State
  inputOperator: OperatorEnum = OperatorEnum.NUll
  @State
  isShowHistory: boolean = false
  @State
  historyData: HistoryBean[] = []
  /**标记第一个值输入后，是否开始输入第二个值*/
  private isInputSecondValue: Boolean = false
  /**标记是否已计算最终结果*/
  private isCalculated: Boolean = false
  /**标记是否添加了非四则运算的“高级”运算符*/
  private isAdvancedCalculated: Boolean = false
  /**标记是否处于错误状态*/
  private isErr: Boolean = false
  /** 标记输入新的数字时是否需要清除当前输入值 */
  private isNeedClrInput: Boolean = false

  windowClass?: window.Window

  build() {
    Column() {
      // 顶部菜单
      this.TopBar()

      // 显示数据
      this.ShowScreenContent()

      Divider()
        .width('100%')
        .padding({ left: 16, right: 16 })

      Stack() {

        // 键盘
        this.KeyBoardContent()

        // 历史记录
        if (this.isShowHistory) {
          this.HistoryScreen()
        }
      }
      .width('100%')
      .height('60%')
    }
    .width('100%')
    .height('100%')
  }

  aboutToAppear(): void {
    this.init()
  }

  @Builder
  private TopBar() {
    Row() {
      Row() {
        SymbolGlyph($r('sys.symbol.rectangle_portrait_rotate'))

        Text('标准')
      }
      .height('100%')
      .width('50%')
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Top)
      .onClick(() => {
        this.setOrientation(window.Orientation.LANDSCAPE)
      })


      Row() {
        SymbolGlyph($r('sys.symbol.arrow_counterclockwise_clock'))
          .onClick(() => {
            this.isShowHistory = !this.isShowHistory
          })
      }
      .height('100%')
      .width('50%')
      .justifyContent(FlexAlign.End)
      .alignItems(VerticalAlign.Top)
    }
    .height($r('app.float.top_title_bar_height'))
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  private ShowScreenContent() {
    Column() {
      // 上一个计算结果
      Text(this.lastShowText)
        .fontSize($r('app.float.show_small_font_size'))
        .fontWeight(FontWeight.Lighter)
        .padding({ left: 12, right: 12, bottom: 16 })
        .opacity(0.5)

      // 当前工作区
      Column() {
        // 计算公式
        Scroll() {
          Row() {
            Text(this.showText)
              .fontSize($r('app.float.show_small_font_size'))
              .fontWeight(FontWeight.Lighter)
          }
          .padding({ right: 8, top: 8, bottom: 8 })
        }
        .scrollable(ScrollDirection.Horizontal)

        // 输入值或计算结果
        Row() {
          Text(formatNumber(this.inputValue, ",", 3, false, this.isFinalResult, true, false))
            .fontSize($r('app.float.show_large_font_size'))
            .fontWeight(FontWeight.Bold)
        }
        .padding({ right: 8, top: 8, bottom: 8 })
      }
      .alignItems(HorizontalAlign.End)
    }
    .height('40%')
    .width('100%')
    .alignItems(HorizontalAlign.End)
    .justifyContent(FlexAlign.SpaceAround)
    .onClick(() => {
      this.isShowHistory = false
    })
  }

  @Builder
  private KeyBoardContent() {
    Column() {
      ForEach(KeyBoardData.standardKeyBoardList, (btnRow: KeyBoardBean[]) => {
        Row() {
          ForEach(btnRow, (btn: KeyBoardBean) => {
            Row() {
              this.ButtonContent(btn, () => {
                this.clickBtn(btn.index)
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
    Column() {
      if (this.historyData.length == 0) {
        Text("还没有历史记录")
      }
      else {
        List({ space: 20, initialIndex: 0 }) {
          ForEach(this.historyData, (item: HistoryBean) => {
            ListItem() {
              Column() {
                Text(item.showText)
                  .fontSize(22)
                  .fontWeight(FontWeight.Lighter)
                Text(item.result)
                  .fontSize(32)
                  .fontWeight(FontWeight.Bold)
                  .padding({top: 4})
              }
              .width('100%')
              .alignItems(HorizontalAlign.End)
              .onClick(() => {
                this.clickHistoryItem(item)
              })
            }
          }, (item: HistoryBean) => item.time)
        }
        .listDirection(Axis.Vertical)
        .scrollBar(BarState.Off)
        .friction(0.6)
        //.divider({ strokeWidth: 2, color: 0xFFFFFF, startMargin: 20, endMargin: 20 }) // 每行之间的分界线
        .edgeEffect(EdgeEffect.Spring) // 边缘效果设置为Spring
        .width('100%')
        .height('90%')


        // 删除
        Row() {
          SymbolGlyph($r('sys.symbol.trash_fill'))
            .onClick(() => {
              this.historyData = []
              this.isShowHistory = false
            })
        }
        .width('100%')
        .height('10%')
        .justifyContent(FlexAlign.End)
      }
    }
    .width('100%')
    .height('100%')
    .padding(8)
    .backgroundColor($r('sys.color.container_modal_background'))
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

  // =================================================================================================================

  private async init() {
    let context = getContext(this) as common.UIAbilityContext;
    this.windowClass = await context.windowStage.getMainWindow()
  }

  private async setOrientation(orientation: number) {
    this.windowClass?.setPreferredOrientation(orientation).then(() => {
      console.info('setWindowOrientation: ' + orientation + ' Succeeded.');
    }).catch((err: BusinessError) => {
      console.info('setWindowOrientation: ' + orientation + ' Failed. Cause: ' + JSON.stringify(err));
    });
  }

  private clickBtn(no: number) {
    if (this.isErr) {
      //viewStates.value = StandardState()
      this.reset()
      this.isErr = false
      this.isAdvancedCalculated = false
      this.isCalculated = false
      this.isInputSecondValue = false
    }

    if (no >= KeyBoardData.KeyIndex_0 && no <= KeyBoardData.KeyIndex_9) {
      let newValue: string
      if (this.inputValue == "0") {
        if (this.inputOperator != OperatorEnum.NUll) {
          this.isInputSecondValue = true
        }
        if (this.isAdvancedCalculated && this.inputOperator == OperatorEnum.NUll) {
          this.isAdvancedCalculated = false
          this.isCalculated = false
          this.isInputSecondValue = false
          //viewStates.value = StandardState()
          this.reset()
          newValue = no.toString()
        }
        newValue = no.toString()
      } else if (this.inputOperator != OperatorEnum.NUll && !this.isInputSecondValue) {
        this.isCalculated = false
        this.isInputSecondValue = true
        newValue = no.toString()
      } else if (this.isCalculated) {
        this.isCalculated = false
        this.isInputSecondValue = false

        let tempLastShowText: string
        if (!this.isAdvancedCalculated) {
          tempLastShowText = this.showText + this.inputValue
        } else {
          tempLastShowText = this.lastShowText
        }
        this.reset()
        this.lastShowText = tempLastShowText
        newValue = no.toString()
      } else if (this.isAdvancedCalculated && this.inputOperator == OperatorEnum.NUll) {
        this.isAdvancedCalculated = false
        this.isCalculated = false
        this.isInputSecondValue = false
        this.reset()
        newValue = no.toString()
      } else if (!this.isCalculated && this.isInputSecondValue && this.isNeedClrInput) {
        this.isNeedClrInput = false
        newValue = no.toString()
      } else {
        newValue = this.inputValue + no.toString()
      }

      this.inputValue = newValue
      this.isFinalResult = false
    }

    switch (no) {
      case KeyBoardData.KeyIndex_Add:
        this.clickArithmetic(OperatorEnum.ADD)
        break
      case KeyBoardData.KeyIndex_Minus:
        this.clickArithmetic(OperatorEnum.MINUS)
        break
      case KeyBoardData.KeyIndex_Multiply:
        this.clickArithmetic(OperatorEnum.MULTIPLY)
        break
      case KeyBoardData.KeyIndex_Divide:
        this.clickArithmetic(OperatorEnum.Divide)
        break
      case KeyBoardData.KeyIndex_NegativeNumber:
        if (this.inputValue != "0") {
          let newValue: string
          if (this.inputValue.substring(0, 1) == "-") {
            newValue = this.inputValue.substring(1, this.inputValue.length)
          } else {
            newValue = "-" + this.inputValue
          }
          this.inputValue = newValue
          this.isFinalResult = false
        }
        break
      case KeyBoardData.KeyIndex_Point:
        if (this.inputValue.indexOf('.') == -1) {
          this.inputValue = this.inputValue + "."
        }
        break
      case KeyBoardData.KeyIndex_Reciprocal:
        this.clickReciprocal()
        break
      case KeyBoardData.KeyIndex_Pow2:
        this.clickPow2()
        break
      case KeyBoardData.KeyIndex_Sqrt:
        this.clickSqrt()
        break
      case KeyBoardData.KeyIndex_Percentage:
        if (this.isInputSecondValue && this.lastInputValue != "" && this.inputOperator != OperatorEnum.NUll) {
          let temp = calculate(this.inputValue, "100", OperatorEnum.Divide)
          if (temp instanceof Error) {
            hilog.error(0x0000, 'el', 'error: Percentage fail' + temp.message);
            break
          }

          let result = calculate(this.lastInputValue, temp.toFixed(), OperatorEnum.MULTIPLY)
          if (result instanceof Error) {
            hilog.error(0x0000, 'el', 'error: Percentage fail' + result.message);
            break
          }

          this.inputValue = result.toFixed()
          this.isFinalResult = true
          this.showText = `${this.lastInputValue}${this.inputOperator}` +
          formatNumber(result.toFixed(), ",", 3, false, true, false)
        } else {
          this.inputValue = "0"
          this.showText = "0"
          this.lastInputValue = ""
          this.inputOperator = OperatorEnum.NUll
        }
        break
      case KeyBoardData.KeyIndex_CE:
        if (this.isCalculated) {
          this.clickClear()
        } else {
          this.inputValue = "0"
        }
        break
      case KeyBoardData.KeyIndex_Clear:
        this.clickClear()
        break
      case KeyBoardData.KeyIndex_Back:
        if (this.inputValue != "0") {
          let newValue = this.inputValue.substring(0, this.inputValue.length - 1)
          if (newValue.length <= 0) {
            newValue = "0"
          }
          this.inputValue = newValue
        }
        break
      case KeyBoardData.KeyIndex_Equal:
        this.clickEqual()
        break
    }
  }

  private clickArithmetic(operator: OperatorEnum) {
    this.lastInputValue = this.inputValue
    this.isFinalResult = false

    let tempInputOperator = operator

    if (this.isCalculated) {
      this.isCalculated = false
      this.isInputSecondValue = false
      this.lastShowText = !this.isAdvancedCalculated ? this.showText + this.inputValue : this.lastShowText
      this.inputOperator = tempInputOperator
    }

    if (this.isAdvancedCalculated) {
      this.isInputSecondValue = false

      if (this.inputOperator == OperatorEnum.NUll) { // 第一次添加操作符
        this.showText = `${this.showText}${operator}`
        this.inputOperator = tempInputOperator

      } else { // 不是第一次添加操作符，则需要把计算结果置于左边，并去掉高级运算的符号
        this.isCalculated = false
        this.isInputSecondValue = false

        this.clickEqual()

        this.lastInputValue = this.inputValue
        this.showText = `${this.inputValue}${operator}`
        this.inputValue = this.inputValue
        this.inputOperator = tempInputOperator

      }

    } else {
      if (this.inputOperator == OperatorEnum.NUll) { // 第一次添加操作符
        this.showText = `${this.inputValue}${operator}`
        this.inputOperator = tempInputOperator

      } else { // 不是第一次添加操作符
        this.isCalculated = false
        this.isInputSecondValue = true
        this.isNeedClrInput = true

        this.lastInputValue = this.inputValue
        this.showText = `${this.inputValue}${operator}`
        this.inputValue = this.inputValue
        this.inputOperator = tempInputOperator

      }
    }
  }

  private clickReciprocal() {
    let result = calculate("1", this.inputValue, OperatorEnum.Divide)
    let resultText: string
    if (result instanceof BigNumber) {
      resultText = result.toFixed()
    } else {
      this.isErr = true
      resultText = result.message
    }

    let tempInputValue = resultText

    if (this.isInputSecondValue) {
      this.showText = `${this.lastInputValue}${this.inputOperator}1/(${this.inputValue})`
      this.isFinalResult = false
      this.lastShowText = this.showText.indexOf("=") != -1 ? this.showText + this.inputValue : this.lastShowText
      this.inputValue = tempInputValue
    } else {
      this.inputOperator = OperatorEnum.NUll
      this.lastInputValue = this.inputValue
      this.showText = `1/(${this.inputValue})`
      this.isFinalResult = false

      this.inputValue = tempInputValue
    }

    this.isAdvancedCalculated = true
  }

  private clickPow2() {
    let result = calculate(this.inputValue, "0", OperatorEnum.POW2)
    let resultText: string
    if (result instanceof BigNumber) {
      resultText = result.toFixed()
    } else {
      this.isErr = true
      resultText = result.message
    }

    let tempInputValue = resultText

    if (this.isInputSecondValue) {
      this.showText = `${this.lastInputValue}${this.inputOperator}(${this.inputValue})${OperatorEnum.POW2}`
      this.isFinalResult = false
      this.lastShowText = this.showText.indexOf("=") != -1 ? this.showText + this.inputValue : this.lastShowText
      this.inputValue = tempInputValue
    } else {
      this.inputOperator = OperatorEnum.NUll
      this.lastInputValue = resultText
      this.showText = `(${this.inputValue})${OperatorEnum.POW2}`
      this.isFinalResult = false

      this.inputValue = tempInputValue
    }

    this.isAdvancedCalculated = true
  }

  private clickSqrt() {
    let result = calculate(this.inputValue, "0", OperatorEnum.SQRT)
    let resultText: string
    if (result instanceof BigNumber) {
      resultText = result.toFixed()
    } else {
      this.isErr = true
      resultText = result.message
    }

    let tempInputValue = resultText

    if (this.isInputSecondValue) {
      this.showText = `${this.lastInputValue}${this.inputOperator}${OperatorEnum.SQRT}(${this.inputValue})`
      this.isFinalResult = false
      this.lastShowText = this.showText.indexOf("=") != -1 ? this.showText + this.inputValue : this.lastShowText
      this.inputValue = tempInputValue
    } else {
      this.inputOperator = OperatorEnum.NUll
      this.lastInputValue = resultText
      this.showText = `${OperatorEnum.SQRT}(${this.inputValue})`
      this.isFinalResult = false
      this.inputValue = tempInputValue
    }

    this.isAdvancedCalculated = true
  }

  private clickClear() {
    this.isInputSecondValue = false
    this.isCalculated = false
    this.isAdvancedCalculated = false
    this.isErr = false
    //viewStates.value = StandardState(memoryData = viewStates.value.memoryData)
    this.reset()
  }

  private clickEqual() {
    let inputValueCache = this.inputValue

    if (this.inputOperator == OperatorEnum.NUll) { // 没有添加操作符
      if (this.isAdvancedCalculated) {
        this.lastInputValue = this.inputValue
        this.showText = `${this.showText}=`
        this.isFinalResult = true
      } else {
        this.lastInputValue = this.inputValue
        this.showText = `${this.inputValue}=`
        this.isFinalResult = true
      }

      this.isCalculated = true
      this.onCalculateFinish(inputValueCache)
    } else { // 添加了操作符
      let calValue1: string
      let calValue2: string
      if (this.isCalculated) {
        calValue1 = this.inputValue
        calValue2 = this.lastInputValue
      } else {
        calValue1 = this.lastInputValue
        calValue2 = this.inputValue
      }
      let result = calculate(calValue1, calValue2, this.inputOperator)
      if (result instanceof BigNumber) {
        let resultText = result.toFixed()
        let inputValue = this.inputValue.substring(0, 1) == "-" ? `(${this.inputValue})` : this.inputValue
        if (this.isAdvancedCalculated) {
          let index = this.showText.indexOf(this.inputOperator)
          if (index != -1 && index == this.showText.length - 1) {
            this.inputValue = resultText
            this.showText = `${this.showText}${inputValue}=`
            this.isFinalResult = true
          } else {
            this.inputValue = resultText
            this.showText = `${this.showText}=`
            this.isFinalResult = true
          }
        } else {
          if (this.isCalculated) { // 当前已经计算过结果
            this.inputValue = resultText
            this.showText = `${inputValue}${this.inputOperator}${this.lastInputValue}=`
            this.isFinalResult = true
            this.lastShowText = !this.isAdvancedCalculated ? this.showText + this.inputValue : this.lastShowText
          } else { // 这是第一次计算
            this.inputValue = resultText
            this.showText = `${this.lastInputValue}${this.inputOperator}${inputValue}=`
            this.isFinalResult = true
            this.lastInputValue = inputValue
          }
        }
        this.isCalculated = true
      } else {
        this.inputValue = result.message
        this.showText = ""
        this.isFinalResult = true
        this.isCalculated = false
        this.isErr = true
      }

      this.onCalculateFinish(inputValueCache)
    }

  }

  private onCalculateFinish(inputValueCache: string) {
    this.isAdvancedCalculated = false
    if (!this.isErr) {
      this.historyData.push(
        new HistoryBean(
         this.showText,
          this.lastInputValue,
          inputValueCache,
          this.inputOperator,
          this.inputValue
        )
      )
    }
  }

  private clickHistoryItem(item: HistoryBean) {
    this.inputValue = item.result
    this.lastInputValue = item.lastInputText
    this.inputOperator = item.operator
    this.showText = item.showText
    this.isFinalResult = true
  }

  private reset() {
    this.lastInputValue = ""
    this.lastShowText = ""
    this.showText = ""
    this.inputValue = "0"
    this.isFinalResult = false
  }
}