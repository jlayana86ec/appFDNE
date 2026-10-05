@echo off
echo Generando la keystore para FEDENADOR...
echo.
"C:\Program Files\Android\Android Studio1\jbr\bin\keytool.exe" -genkey -v -keystore fedenador-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias fedenador
echo.
echo Listo. Revisa arriba si hubo algun error.
pause
