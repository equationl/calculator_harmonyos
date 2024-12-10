

/**
 * 格式化显示的数字
 *
 * @param addSplitChar 添加的分隔符
 * @param splitLength 间隔多少个字符添加分割符
 * @param isAddLeadingZero 是否在不满足 [splitLength] 一组的数字前添加 0
 * @param formatDecimal 是否格式化小数部分（移除末尾多余的0）
 * @param formatInteger 是否格式化整数部分（添加分隔符或前导0）
 * @param isReverseSplit 是否反转分割信息，正常情况下会将不满足分组的数据置于前面，
 * 当该值设置为 true 时会反转分组，将不满足分组的数据置于尾部，
 * 该参数为 true 时将忽略 [isAddLeadingZero] 和 [formatDecimal] 并且不会判断字符中的前导 '-'
 * */
export function formatNumber(
  src: string,
  addSplitChar: string = ",",
  splitLength: number = 3,
  isAddLeadingZero: boolean = false,
  formatDecimal: boolean = false,
  formatInteger: boolean = true,
  isReverseSplit: boolean = false,
): string {
  // 如果是错误提示信息则不做处理
  if (src.startsWith("Err")) return src

  let stringBuilder: string[] = src.split('')

  let pointIndex = stringBuilder.indexOf('.')

  let integer: string[]
  let decimal: string[]

  if (pointIndex == -1) {
    integer = stringBuilder // 整数部分
    decimal = [] // 小数部分
  }
  else {
    let stringList = src.split('.')
    integer = stringList[0].split('') // 整数部分
    decimal = stringList[1].split('') // 小数部分
    decimal.splice(0, 0, '.')
  }

  let addCharCount = 0

  if (formatInteger) {
    if (isReverseSplit) {
      // 给整数部分添加逗号分隔符
      if (integer.length > splitLength) {
        for (let i = splitLength; i <= integer.length; i+=splitLength) {
          integer.splice(i + addCharCount, 0, addSplitChar)
          addCharCount++
        }
      }
    }
    else {
      // 给整数部分添加逗号分隔符
      if (integer.length > splitLength) {
        let end = integer[0] == '-' ? 2 : 1 // 判断是否有前导符号
        for (let i = integer.length-splitLength; i >= end; i+=splitLength) {
          integer.splice(i, 0, addSplitChar)
          addCharCount++
        }
      }

      if (isAddLeadingZero) { // 添加前导 0 补满一组
        let realLength = integer.length - addCharCount
        if (realLength % splitLength != 0) {
          for (let i = 0; i < (4 - realLength % splitLength);i++) {
            integer.splice(0, 0, '0')
          }
        }
      }
    }
  }

  if (formatDecimal) {
    // 移除小数部分末尾占位的 0
    if (decimal.length > 0) {
      while (decimal[decimal.length - 1] == '0') {
        decimal.pop()
      }
      if (decimal.length == 1) { // 上面我们给小数部分首位添加了点号 ”.“ ，所以如果长度为 1 则表示不存在有效小数，则将点号也删除掉
        decimal.splice(0, 1)
      }
    }
  }

  integer.push(...decimal)

  return integer.join('')
}