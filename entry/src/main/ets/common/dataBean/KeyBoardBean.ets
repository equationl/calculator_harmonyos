
export class KeyBoardBean {
  text: string
  /**
   * 设置按钮颜色，设置范围取决于 [isFilled]
   * */
  background: Color
  index: number
  /**
   * 是否填充该按钮，如果为 true 则 [background] 用于填充该按钮背景；否则，[background] 用于设置该按钮字体颜色
   * */
  isFilled: Boolean
  isAvailable: Boolean

  constructor(text: string, background: Color, index: number, isFilled: boolean = false, isAvailable: boolean = true) {
    this.text = text
    this.background = background
    this.index = index
    this.isFilled = isFilled
    this.isAvailable = isAvailable
  }
}