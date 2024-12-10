

/**
 * TODO 格式化显示的数字
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
  let result = ""

  return result
}