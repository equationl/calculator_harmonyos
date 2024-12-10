import { KeyBoardBean } from '../common/dataBean/KeyBoardBean';
import { OperatorEnum } from '../common/dataBean/OperatorEnum';

export class KeyBoardData {
  private static defaultFunctionColor = $r('app.color.button_function')
  private static defaultEqualColor = $r('app.color.button_equal')
  private static defaultNumberColor = $r('app.color.button_number')

  // 数字按键
  static KeyIndex_0 = 0
  static KeyIndex_1 = 1
  static KeyIndex_2 = 2
  static KeyIndex_3 = 3
  static KeyIndex_4 = 4
  static KeyIndex_5 = 5
  static KeyIndex_6 = 6
  static KeyIndex_7 = 7
  static KeyIndex_8 = 8
  static KeyIndex_9 = 9
  static KeyIndex_A = 17  // 不按照顺序往下编号是因为在程序员键盘中使用的是 ascii 索引， 而数字 9 和 A 间隔了 7 位
  static KeyIndex_B = 18
  static KeyIndex_C = 19
  static KeyIndex_D = 20
  static KeyIndex_E = 21
  static KeyIndex_F = 22

  // 运算按键
  static KeyIndex_Add = 100
  static KeyIndex_Minus = 101
  static KeyIndex_Multiply = 102
  static KeyIndex_Divide = 103
  static KeyIndex_NegativeNumber = 104
  static KeyIndex_Point = 105
  static KeyIndex_Reciprocal = 106
  static KeyIndex_Pow2 = 107
  static KeyIndex_Sqrt = 108
  static KeyIndex_Percentage = 109
  static KeyIndex_Lsh = 110
  static KeyIndex_Rsh = 111
  static KeyIndex_And = 112
  static KeyIndex_Or = 113
  static KeyIndex_Not = 114
  static KeyIndex_XOr = 117

  // 操作按键
  static KeyIndex_Equal = 1000
  static KeyIndex_CE = 1001
  static KeyIndex_Clear = 1002
  static KeyIndex_Back = 1003

  // 记忆按键
  static KeyIndex_MemoryClear = 1004
  static KeyIndex_MemoryRead = 1005
  static KeyIndex_MemoryPlus = 1006
  static KeyIndex_MemoryMinus = 1007
  static KeyIndex_MemorySave = 1008
  static KeyIndex_MemoryList = 1009


  static ProgrammerLeftKeyList = [
    [
      new KeyBoardBean('C', this.defaultFunctionColor, this.KeyIndex_Clear),
      new KeyBoardBean("⇦", this.defaultFunctionColor,  this.KeyIndex_Back)
    ],
    [
      new KeyBoardBean("CE", this.defaultFunctionColor,  this.KeyIndex_CE),
      new KeyBoardBean(OperatorEnum.Divide, this.defaultFunctionColor,  this.KeyIndex_Divide)
    ],
    [
      new KeyBoardBean("NOT", this.defaultFunctionColor, this.KeyIndex_Not),
      new KeyBoardBean(OperatorEnum.MULTIPLY, this.defaultFunctionColor,  this.KeyIndex_Multiply)
    ],
    [
      new KeyBoardBean("XOR", this.defaultFunctionColor,  this.KeyIndex_XOr),
      new KeyBoardBean(OperatorEnum.MINUS, this.defaultFunctionColor,  this.KeyIndex_Minus)
    ],
    [
      new KeyBoardBean("AND", this.defaultFunctionColor, this.KeyIndex_And),
      new KeyBoardBean(OperatorEnum.ADD, this.defaultFunctionColor,  this.KeyIndex_Add)
    ],
    [
      new KeyBoardBean("OR", this.defaultFunctionColor,  this.KeyIndex_Or),
      new KeyBoardBean("=", this.defaultEqualColor,  this.KeyIndex_Equal, true)
    ],
  ]

  static ProgrammerRightKeyList = [
    [
      new KeyBoardBean("D", this.defaultNumberColor,  this.KeyIndex_D),
      new KeyBoardBean("E", this.defaultNumberColor,  this.KeyIndex_E),
      new KeyBoardBean("F", this.defaultNumberColor,  this.KeyIndex_F)
    ],
    [
      new KeyBoardBean("A", this.defaultNumberColor,  this.KeyIndex_A),
      new KeyBoardBean("B", this.defaultNumberColor,  this.KeyIndex_B),
      new KeyBoardBean("C", this.defaultNumberColor,  this.KeyIndex_C)
    ],
    [
      new KeyBoardBean("7", this.defaultNumberColor,  this.KeyIndex_7),
      new KeyBoardBean("8", this.defaultNumberColor,  this.KeyIndex_8),
      new KeyBoardBean("9", this.defaultNumberColor,  this.KeyIndex_9)
    ],
    [
      new KeyBoardBean("4", this.defaultNumberColor,  this.KeyIndex_4),
      new KeyBoardBean("5", this.defaultNumberColor,  this.KeyIndex_5),
      new KeyBoardBean("6", this.defaultNumberColor,  this.KeyIndex_6)
    ],
    [
      new KeyBoardBean("1", this.defaultNumberColor,  this.KeyIndex_1),
      new KeyBoardBean("2", this.defaultNumberColor,  this.KeyIndex_2),
      new KeyBoardBean("3", this.defaultNumberColor,  this.KeyIndex_3)
    ],
    [
      new KeyBoardBean("<<", this.defaultFunctionColor, this.KeyIndex_Lsh),
      new KeyBoardBean("0", this.defaultNumberColor,  this.KeyIndex_0),
      new KeyBoardBean(">>", this.defaultFunctionColor,  this.KeyIndex_Rsh)
    ]
  ]

  static BitOperationList = [
    OperatorEnum.NOT,
    OperatorEnum.AND,
    OperatorEnum.OR,
    OperatorEnum.XOR,
    OperatorEnum.LSH,
    OperatorEnum.RSH
  ]
}