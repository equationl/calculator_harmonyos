
export enum ProgrammerLength {
  QWORD = 64,
  DWORD = 32,
  WORD = 16,
  BYTE = 8
}

export function getHexLength(from: ProgrammerLength): number {
  switch (from) {
    case ProgrammerLength.QWORD:
      return 16
    case ProgrammerLength.DWORD:
      return 8
    case ProgrammerLength.WORD:
      return 4
    case ProgrammerLength.BYTE:
      return 2
  }
}