
@Preview
@Entry
@Component
struct StartWidgetCard {

  build() {
    Column() {
      Image($r('app.media.startIcon'))
        .height('60%')

      Text('打开计算器')
        .padding({top: 4})
    }
    .padding('10vp')
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      postCardAction(this, {
        "action": 'router',
        "abilityName": 'EntryAbility',
      });
    })
  }
}