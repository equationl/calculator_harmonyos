import { BigNumber } from 'bignumber.js'
import { getForbidBtn, InputBase } from '../../common/dataBean/InputBaseEnum'
import { KeyBoardBean } from '../../common/dataBean/KeyBoardBean'
import { OperatorEnum } from '../../common/dataBean/OperatorEnum'
import { ProgrammerLength } from '../../common/dataBean/ProgrammerLength'
import { KeyBoardData } from '../../constant/KeyBoardData'
import { baseConversion, calculate } from '../../util/CalculaUtil'
import { formatNumber } from '../../util/FormatUtil'

@Preview({ width: 1920, height: 1080 })
@Component
export struct ProgrammerComponent {
  @State
  currentInputBase: InputBase = InputBase.DEC
  @State
  currentLength: ProgrammerLength = ProgrammerLength.QWORD // TODO 需要限制长度
  @State
  forbidBtn: number[] = []
  @State
  showText: string = ""
  @State
  inputValue: string = "0"
  @State
  lastInputValue: string = ""
  @State
  inputOperator: OperatorEnum = OperatorEnum.NUll
  @State
  isFinalResult: boolean = false
  /**标记第一个值输入后，是否开始输入第二个值*/
  isInputSecondValue: Boolean = false
  /**标记是否已计算最终结果*/
  isCalculated: Boolean = false
  /**标记是否添加了非四则运算的“高级”运算符*/
  isAdvancedCalculated: Boolean = false
  /**标记是否处于错误状态*/
  isErr: Boolean = false
  /** 标记输入新的数字时是否需要清除当前输入值 */
  isNeedClrInput: Boolean = false

  build() {
    Row() {
      this.LeftKeyBoardContent()

      Divider()
        .vertical(true)
        .padding({ top: 16, bottom: 16 })

      this.CenterScreenContent()

      Divider()
        .vertical(true)
        .padding({ top: 16, bottom: 16 })

      this.RightKeyBoardContent()
    }
    .width('100%')
    .height('100%')
    .alignItems(VerticalAlign.Center)
  }

  aboutToAppear(): void {
    this.forbidBtn = getForbidBtn(this.currentInputBase)
  }

  @Builder
  private LeftKeyBoardContent() {
    Column() {
      ForEach(KeyBoardData.ProgrammerLeftKeyList, (rowData: KeyBoardBean[]) => {
        Row() {
          ForEach(rowData, (item: KeyBoardBean) => {
            Row() {
              this.ButtonContent(item, () => {
                this.clickBtn(item.index)
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
        // 计算公式
        Text(this.showText)
          .padding(8)
          .fontSize($r('app.float.show_normal_font_size'))
          .fontWeight(FontWeight.Lighter)

        // 输入值或计算结果
        Scroll() {
          Text(
            formatNumber(
              this.inputValue,
              this.currentInputBase == InputBase.DEC ? "," : " ",
              this.currentInputBase == InputBase.HEX || this.currentInputBase == InputBase.BIN ? 4 : 3,
              false,
              false,
              true
            )
          )
            .fontSize($r('app.float.show_large_font_size'))
            .fontWeight(FontWeight.Bold)
        }
        .scrollable(ScrollDirection.Horizontal)
      }
      .alignItems(HorizontalAlign.End)
      .width('100%')

      Scroll() {
        Column() {
          // 不同进制数据
          this.BaseDataItem(InputBase.HEX)

          this.BaseDataItem(InputBase.DEC)

          this.BaseDataItem(InputBase.OCT)

          this.BaseDataItem(InputBase.BIN)
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
              this.ButtonContent(item, () => {
                this.clickBtn(item.index)
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
  private BaseDataItem(inputBase: InputBase) {
    Row() {
      Text(InputBase[inputBase])
        .fontSize(this.currentInputBase == inputBase ? $r('app.float.input_title_content_font_size') :
        $r('app.float.input_normal_font_size'))
        .fontWeight(this.currentInputBase == inputBase ? FontWeight.Bold : FontWeight.Normal)

      Text(
        formatNumber(
          baseConversion(this.inputValue, inputBase, this.currentInputBase, this.currentLength),
          inputBase == InputBase.DEC ? "," : " ",
          inputBase == InputBase.HEX || inputBase == InputBase.BIN ? 4 : 3,
          inputBase == InputBase.BIN && this.inputValue != "0" ? true : false
        )
      )
        .fontSize($r('app.float.input_normal_font_size'))
        .padding({ left: 8 })
    }
    .alignItems(VerticalAlign.Center)
    .padding(2)
    .onClick(() => {
      this.changeInputBase(inputBase)
    })
  }

  @Builder
  private ButtonContent(item: KeyBoardBean, onClick: (event: ClickEvent) => void) {

    Button(item.text)
      .width('100%')
      .height('100%')
      .onClick(onClick)
      .type(ButtonType.Normal)
      .enabled(item.isAvailable && !this.forbidBtn.includes(item.index))
      .backgroundColor(item.isFilled ? item.color : $r('app.color.button_background'))
      .fontColor(item.isFilled ? $r('sys.color.font_on_primary') : item.color)
      .fontWeight(FontWeight.Bold)
      .fontSize($r('app.float.button_font_size'))
  }

  // ==================================================================================================================

  // 更换当前使用的进制
  private changeInputBase(newInputBase: InputBase) {
    this.inputValue = baseConversion(this.inputValue, newInputBase, this.currentInputBase, this.currentLength)
    this.lastInputValue = baseConversion(this.lastInputValue, newInputBase, this.currentInputBase, this.currentLength)

    this.currentInputBase = newInputBase
    this.forbidBtn = getForbidBtn(newInputBase)
  }

  // 点击按钮
  // 48 == "0"
  private clickBtn(no: number) {
    if (this.isErr) {
      // viewStates.value = ProgrammerState(
      //   inputBase = viewStates.value.inputBase,
      //   currentLength = viewStates.value.currentLength
      // )
      this.reset()

      this.isErr = false
      this.isAdvancedCalculated = false
      this.isCalculated = false
      this.isInputSecondValue = false
    }

    if (no >= KeyBoardData.KeyIndex_0 && no <= KeyBoardData.KeyIndex_F) {
      let newValue: string
      if (this.inputValue == "0") {
        if (this.inputOperator != OperatorEnum.NUll) {
          this.isInputSecondValue = true
        }
        if (this.isAdvancedCalculated && this.inputOperator == OperatorEnum.NUll) { // 如果在输入高级运算符后直接输入数字，则重置状态
          this.isAdvancedCalculated = false
          this.isCalculated = false
          this.isInputSecondValue = false
          // viewStates.value = ProgrammerState(inputBase = viewStates.value.inputBase)
          this.reset()
          newValue = no.toString()
        }

        newValue = String.fromCharCode(48 + no)
      } else if (this.inputOperator != OperatorEnum.NUll && !this.isInputSecondValue) {
        this.isCalculated = false
        this.isInputSecondValue = true
        newValue = String.fromCharCode(48 + no)
      } else if (this.isCalculated) {
        this.isCalculated = false
        this.isInputSecondValue = false
        // viewStates.value = ProgrammerState(inputBase = viewStates.value.inputBase)
        this.reset()
        newValue = String.fromCharCode(48 + no)
      } else if (this.isAdvancedCalculated && this.inputOperator == OperatorEnum.NUll) { // 如果在输入高级运算符后直接输入数字，则重置状态
        this.isAdvancedCalculated = false
        this.isCalculated = false
        this.isInputSecondValue = false
        //viewStates.value = ProgrammerState(inputBase = viewStates.value.inputBase)
        this.reset()
        newValue = no.toString()
      } else if (!this.isCalculated && this.isInputSecondValue && this.isNeedClrInput) {
        this.isNeedClrInput = false
        newValue = no.toString()
      } else {
        newValue = this.inputValue + String.fromCharCode(48 + no)
      }

      // if (!viewStates.value.isShowAscii) {
      //   // 溢出判断
      //   if (lengthOverFlow(viewStates, newValue)) return
      // }

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
      case KeyBoardData.KeyIndex_And:
        this.clickArithmetic(OperatorEnum.AND)
        break
      case KeyBoardData.KeyIndex_Or:
        this.clickArithmetic(OperatorEnum.OR)
        break
      case KeyBoardData.KeyIndex_XOr:
        this.clickArithmetic(OperatorEnum.XOR)
        break
      case KeyBoardData.KeyIndex_Lsh:
        this.clickArithmetic(OperatorEnum.LSH)
        break
      case KeyBoardData.KeyIndex_Rsh:
        this.clickArithmetic(OperatorEnum.RSH)
        break
      case KeyBoardData.KeyIndex_Not: // fixme 不限制长度的话无法取反
        this.clickNot()
        break
      case KeyBoardData.KeyIndex_CE:
        if (this.isCalculated) {
          this.clickClear()
        }
        else {
          this.clickCE()
        }
        break
      case KeyBoardData.KeyIndex_Clear:
        this.clickClear()
        break
      case KeyBoardData.KeyIndex_Back:
        this.clickBack()
        break
      case KeyBoardData.KeyIndex_Equal:
        this.clickEqual()
        break

    }


  }

  private clickArithmetic(operator: OperatorEnum) {
    this.inputOperator = operator
    this.isFinalResult = false
    this.lastInputValue = this.inputValue

    if (this.isCalculated) {
      this.isCalculated = false
      this.isInputSecondValue = false
    }

    if (this.isAdvancedCalculated) {
      this.isInputSecondValue = false

      if (this.inputOperator == OperatorEnum.NUll) { // 第一次添加操作符
        this.showText = this.showText + operator
      } else { // 不是第一次添加操作符，则需要把计算结果置于左边，并去掉高级运算的符号
        this.isCalculated = false
        this.isInputSecondValue = false

        this.clickEqual()

        this.lastInputValue = this.inputValue
        this.showText = this.inputValue + this.showText
      }
    } else {
      if (this.inputOperator == OperatorEnum.NUll) { // 第一次添加操作符
        this.showText = this.inputValue + operator
      } else { // 不是第一次添加操作符
        this.isCalculated = false
        this.isInputSecondValue = true
        this.isNeedClrInput = true
        this.lastInputValue = this.inputValue
        this.showText = this.inputValue + operator
      }
    }
  }

  private clickEqual() {
    if (this.inputOperator == OperatorEnum.NUll) {
      if (this.isAdvancedCalculated) {
        this.showText = this.showText + "="
        this.isFinalResult = true
        this.lastInputValue = this.inputValue
      } else {
        this.showText = this.inputValue + "="
        this.isFinalResult = true
        this.lastInputValue = this.inputValue
      }
      this.isCalculated = true
    } else {
      let result = this.programmerCalculate()

      if (typeof result === 'string') {
        let resultText: string = baseConversion(result, this.currentInputBase, InputBase.DEC, this.currentLength)
        let inputValue: string
        if (this.inputValue.substring(0, 1) == "-") {
          inputValue = "(" + this.inputValue + ")"
        } else {
          inputValue = this.inputValue
        }
        if (this.isAdvancedCalculated) {
          let index = this.showText.indexOf(this.inputOperator)
          if (index != -1 && index == (this.showText.length - 1)) {
            this.inputValue = resultText
            this.showText = this.showText + inputValue + "="
            this.isFinalResult = true
          } else {
            this.inputValue = resultText
            this.showText = this.showText + "="
            this.isFinalResult = true
          }
        } else {
          if (this.isCalculated) {
            this.inputValue = resultText
            this.showText = inputValue + this.inputOperator + this.lastInputValue + "="
            this.isFinalResult = true
          } else {
            this.lastInputValue = this.inputValue
            this.inputValue = resultText
            this.showText = this.lastInputValue + this.inputOperator + inputValue + "="
            this.isFinalResult = true
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
    }

    this.isAdvancedCalculated = false
  }

  private programmerCalculate(): string | Error {
    let leftText: string
    let rightText: string
    if (this.isCalculated) {
      leftText =  baseConversion(this.inputValue, InputBase.DEC, this.currentInputBase, this.currentLength)
      rightText = baseConversion(this.lastInputValue, InputBase.DEC, this.currentInputBase, this.currentLength)
    }
    else {
      leftText =  baseConversion(this.lastInputValue, InputBase.DEC, this.currentInputBase, this.currentLength)
      rightText = baseConversion(this.inputValue, InputBase.DEC, this.currentInputBase, this.currentLength)
    }

    // TODO 应该是转为 long 来计算
    let leftNumber = Number.parseInt(leftText)
    let rightNumber = Number.parseInt(rightText)

    if (KeyBoardData.BitOperationList.indexOf(this.inputOperator) != -1) {
      switch (this.inputOperator) {
        case OperatorEnum.AND:
          return (leftNumber & rightNumber).toString()
        case OperatorEnum.OR:
          return (leftNumber | rightNumber).toString()
        case OperatorEnum.XOR:
          return (leftNumber ^ rightNumber).toString()
        case OperatorEnum.LSH:
          return (leftNumber << rightNumber).toString()
        case OperatorEnum.RSH:
          return (leftNumber >> rightNumber).toString()
        default :
          return Error("Err: 错误的调用")
      }
    }
    else {
      let result = calculate(leftText, rightText, this.inputOperator, false)
      if (result instanceof BigNumber) {
        return result.toFixed()
      }

      return result
    }
  }

  private clickNot() {
    // 转换成十进制的 long 类型来计算， 然后转回当前进制
    // val result = viewStates.value.inputValue.baseConversion(InputBase.DEC, viewStates.value.inputBase).toLong() // 转至十进制 long
    //   .inv().toString()  // 计算
    //   .baseConversion(viewStates.value.inputBase, InputBase.DEC) // 转回当前进制

    // FIXME need confirm
    let result = (!Number.parseInt(baseConversion(this.inputValue, InputBase.DEC, this.currentInputBase, this.currentLength))).toString()
    result = baseConversion(result, this.currentInputBase, InputBase.DEC, this.currentLength)


    this.inputValue = result
    if (this.isInputSecondValue) {
      this.showText = this.lastInputValue + this.inputOperator + OperatorEnum.NOT + (this.inputValue)
      this.isFinalResult = false
    }
    else {
      this.inputOperator = OperatorEnum.NUll
      this.lastInputValue = result
      this.showText = OperatorEnum.NOT + (this.inputValue)
      this.isFinalResult = false

      this.isInputSecondValue = true
    }

    this.isAdvancedCalculated = true
  }

  private clickCE() {
    this.inputValue = "0"
  }

  private clickClear() {
    this.isInputSecondValue = false
    this.isCalculated = false
    this.isAdvancedCalculated = false
    this.isErr = false

    this.reset()
  }

  private clickBack() {
    if (this.inputValue != "0") {
      if (this.inputValue.length == 0) return

      let newValue = this.inputValue.substring(0, this.inputValue.length - 1)
      if (newValue.length == 0 || newValue == "-") newValue = ""
      this.inputValue = newValue
    }
  }

  private reset() {
    this.showText = ""
    this.inputValue = "0"
    this.inputOperator = OperatorEnum.NUll
    this.lastInputValue = ""
  }
}