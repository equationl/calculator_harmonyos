import { Lottie, LottieController } from '@jjr/lottie_component';

@Entry
@Component
struct StartWidgetCard {
  controller: LottieController = new LottieController()

  build() {
    Column() {
      Lottie({
        controller: this.controller,
        animationPath: 'lottie/calculator.json',
        autoPlay: true,
        loop: true
      })
        .width('100%')
        .height('100%')
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