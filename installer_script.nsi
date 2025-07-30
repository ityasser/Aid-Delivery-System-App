!define VERSION "1.2.0.0"

!define APP_NAME "Aid Registry App"

!define INSTALLER_NAME "AidSystemSetup-${VERSION}.exe"
!define WM_CLOSE 0x0010   ;

OutFile "${INSTALLER_NAME}"
InstallDir "$PROGRAMFILES64\${APP_NAME}"
RequestExecutionLevel admin


VIAddVersionKey "ProductName" "Aid Registry Flutter App"
VIAddVersionKey "CompanyName" "IT-Yasser"
VIAddVersionKey "LegalCopyright" "© 2025 Your Company"
VIAddVersionKey "FileDescription" "Flutter Desktop App Installer"
VIProductVersion "${VERSION}"
VIAddVersionKey "ProductVersion" "${VERSION}"
VIAddVersionKey "FileVersion" "${VERSION}"

Icon "app_icon.ico"
UninstallIcon "app_icon.ico"

Page directory
Page instfiles
UninstPage uninstConfirm
UninstPage instfiles

Section "Install"
    ExecWait 'taskkill /F /IM aid_registry_flutter_app.exe'

    SetOutPath "$INSTDIR"
    File /r "build\windows\x64\runner\Release\*.*"
    WriteUninstaller "$INSTDIR\Uninstall.exe"

    ; اختياري: اختصار على سطح المكتب
    CreateShortCut "$DESKTOP\${APP_NAME}.lnk" "$INSTDIR\aid_registry_flutter_app.exe"

    Exec "$INSTDIR\aid_registry_flutter_app.exe"

SectionEnd

Section "Uninstall"
    Delete "$INSTDIR\aid_registry_flutter_app.exe"
    Delete "$DESKTOP\${APP_NAME}.lnk"
    Delete "$INSTDIR\Uninstall.exe"
    RMDir /r "$INSTDIR"
SectionEnd
