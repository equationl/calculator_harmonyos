@Entry
@Component
struct StartWidgetCard {
  @State x: number = 1
  @State y: number = 1

  build() {
    Column() {
      Button('Click to enlarge')
        .onClick(() => {
          this.x = 1.1
          this.y = 1.1
        })
        .scale({ x: this.x, y: this.y })
        .animation({
          curve: Curve.EaseOut,
          playMode: PlayMode.AlternateReverse,
          duration: 200,
          onFinish: () => {
            this.x = 1
            this.y = 1
          }
        })
    }
    .padding('10vp')
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      postCardAction(this, {
        "action": 'router',
        "abilityName": 'EntryAbility',
        "params": {
          "message": 'router test'
        }
      });
    })
  }
}