import { OperatorEnum } from './OperatorEnum'

export class HistoryBean {
  showText: string
  lastInputText: string
  inputText: string
  operator: OperatorEnum
  result: string
  time: string = new Date().toISOString()

  constructor(showText: string, lastInputText: string, inputText: string, operator: OperatorEnum, result: string) {
    this.showText = showText
    this.lastInputText = lastInputText
    this.inputText = inputText
    this.operator = operator
    this.result = result
  }
}