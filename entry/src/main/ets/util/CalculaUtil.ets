import { InputBase } from '../common/dataBean/InputBaseEnum';
import { OperatorEnum } from '../common/dataBean/OperatorEnum';
import { ProgrammerLength } from '../common/dataBean/ProgrammerLength';
import { BigNumber } from 'bignumber.js';

/**
 * 实际计算方法
 * */
export function calculate(
  leftValue: string,
  rightValue: string,
  operator: OperatorEnum,
  includeDecimalModel: boolean = true
): BigNumber | Error {
  let left = new BigNumber(leftValue)
  let right = new BigNumber(rightValue)

  switch (operator) {
    case OperatorEnum.ADD:
      return left.plus(right)
    case OperatorEnum.MINUS:
      return left.minus(right)
    case OperatorEnum.MULTIPLY:
      return left.multipliedBy(right)
    case OperatorEnum.Divide:
      if (right.isZero()) {
        return Error("Err: 除数不能为零")
      }
      return includeDecimalModel ? left.dividedBy(right) : left.dividedToIntegerBy(right)
    case OperatorEnum.SQRT:
      if (left.isNegative()) {
        return Error("Err: 无效输入")
      }
      return left.sqrt()
    case OperatorEnum.POW2:
      return left.pow(2)
    case OperatorEnum.NUll:
      return left
  }

  return Error("Err: 错误的调用")
}


/**
 *
 * TODO 进制转换，十进制数会被转换为有符号数据，其他进制使用无符号数据
 *
 * */
export function baseConversion(
  src: string,
  target: InputBase,
  current: InputBase,
  currentLength: ProgrammerLength
): string {
  if (src.startsWith("Err")) {
    return "Err"
  }

  if (src.length == 0) {
    return src
  }

  if (target == current) {
    return src
  }

  let result = new BigNumber(src, current)

  return result.toString(target)
}