import { authentication } from '@kit.AccountKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { CalculatorMode } from '../constant/CalculatorMode';
import { ProgrammerComponent } from './programmer/ProgrammerComponent';
import { StandardComponent } from './standard/StandardComponent';
import { common } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State showModel: number = CalculatorMode.Standard

  windowClass?: window.Window

  build() {
    Stack({alignContent: Alignment.TopStart}) {
      Row() {
        SymbolGlyph($r('sys.symbol.rectangle_portrait_rotate'))

        Text(this.showModel == CalculatorMode.Standard ? '标准' : '程序员')
      }
      .height($r('app.float.top_title_bar_height'))
      .width('100%')
      .padding(8)
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Top)
      .onClick(() => {
        this.changeShowModel()
      })

      if (this.showModel == CalculatorMode.Standard) {
        StandardComponent()
      }
      else if (this.showModel == CalculatorMode.Programmer) {
        ProgrammerComponent()
      }
    }
    .width('100%')
    .height('100%')
  }

  aboutToAppear() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    this.init()
    this.loginWithHuaweiID();
  }

  aboutToDisappear(): void {
    this.windowClass?.off('windowSizeChange');
  }

  private async init() {
    let context = getContext(this) as common.UIAbilityContext;
    this.windowClass = await context.windowStage.getMainWindow()

    // 监听屏幕变化
    this.windowClass?.on('windowSizeChange', (size) => {
      let viewWidth = px2vp(size.width);
      let viewHeight = px2vp(size.height);

      if (viewWidth > viewHeight) {
        this.showModel = CalculatorMode.Programmer
      } else {
        this.showModel = CalculatorMode.Standard
      }
    });
  }

  /**
   * Sample code for using HUAWEI ID to log in to atomic service.
   * According to the Atomic Service Review Guide, when a atomic service has an account system,
   * the option to log in with a HUAWEI ID must be provided.
   * The following presets the atomic service to use the HUAWEI ID silent login function.
   * To enable the atomic service to log in successfully using the HUAWEI ID, please refer
   * to the HarmonyOS HUAWEI ID Access Guide to configure the client ID and fingerprint certificate.
   */
  private loginWithHuaweiID() {
    // Create a login request and set parameters
    let loginRequest = new authentication.HuaweiIDProvider().createLoginWithHuaweiIDRequest();
    // Whether to forcibly launch the HUAWEI ID login page when the user is not logged in with the HUAWEI ID
    loginRequest.forceLogin = false;
    // Execute login request
    let controller = new authentication.AuthenticationController();
    controller.executeRequest(loginRequest).then((data) => {
      let loginWithHuaweiIDResponse = data as authentication.LoginWithHuaweiIDResponse;
      let authCode = loginWithHuaweiIDResponse.data?.authorizationCode;
      // Send authCode to the backend in exchange for unionID, session

    }).catch((error: BusinessError) => {
      hilog.error(0x0000, 'testTag', 'error: %{public}s', JSON.stringify(error));
      if (error.code == authentication.AuthenticationErrorCode.ACCOUNT_NOT_LOGGED_IN) {
        // HUAWEI ID is not logged in, it is recommended to jump to the login guide page

      }
    });
  }

  private changeShowModel() {
    let newShowModel = this.showModel += 1
    if (newShowModel > CalculatorMode.Programmer) {
      newShowModel= CalculatorMode.Standard
    }

    // if (this.showModel == CalculatorMode.Programmer) {
    //   this.setOrientation(window.Orientation.LANDSCAPE)
    // }

    this.setOrientation(newShowModel)
  }

  private async setOrientation(orientation: number) {
    this.windowClass?.setPreferredOrientation(orientation).then(() => {
      console.info('setWindowOrientation: ' + orientation + ' Succeeded.');
    }).catch((err: BusinessError) => {
      console.info('setWindowOrientation: ' + orientation + ' Failed. Cause: ' + JSON.stringify(err));
    });
  }
}