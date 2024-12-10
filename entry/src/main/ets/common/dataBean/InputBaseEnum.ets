import { KeyBoardData } from '../../constant/KeyBoardData'

export enum InputBase {
  HEX = 16,
  DEC = 10,
  OCT = 8,
  BIN = 2
}

export function getForbidBtn(base: InputBase): number[] {
  let forbidBtnList: number[] = []
  
  if (base <= InputBase.DEC) {
    let newList = [
      KeyBoardData.KeyIndex_A,
      KeyBoardData.KeyIndex_B,
      KeyBoardData.KeyIndex_C,
      KeyBoardData.KeyIndex_D,
      KeyBoardData.KeyIndex_E,
      KeyBoardData.KeyIndex_F
    ]
    forbidBtnList.push(...newList)
  }
  if (base <= InputBase.OCT) {
    let newList = [
       KeyBoardData.KeyIndex_8,
       KeyBoardData.KeyIndex_9
    ]
    forbidBtnList.push(...newList)
  }
  if (base <= InputBase.BIN) {
    let newList = [
      KeyBoardData.KeyIndex_7,
      KeyBoardData.KeyIndex_6,
      KeyBoardData.KeyIndex_5,
      KeyBoardData.KeyIndex_4,
      KeyBoardData.KeyIndex_3,
      KeyBoardData.KeyIndex_2
    ]
    forbidBtnList.push(...newList)
  }

  return forbidBtnList
}