
export function arrayRemove<T>(arr: T[], value: T): T[] {

  return arr.filter((ele) => {
    return ele != value;
  });
}