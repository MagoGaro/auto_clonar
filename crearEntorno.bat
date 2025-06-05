@echo off

echo ********************************************
echo * Configuracion de entorno virtual Python  *
echo ********************************************
echo.


echo Ingrese el comando de Python que desea usar (ej: python, py, python3)
echo Dejar vacio para usar el predeterminado (py):
set /p PY_CMD="> "
if "%PY_CMD%"=="" set PY_CMD=py

%PY_CMD% --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: %PY_CMD% no está disponible.
    echo Por favor instala Python o verifica el comando.
    pause
    exit /b
)

echo Ingrese el nombre del entorno virtual:
echo Dejar vacio para usar el predeterminado (venv):
set /p VENV_NAME="> "
if "%VENV_NAME%"=="" set VENV_NAME=venv

if exist %VENV_NAME% (
    echo El entorno virtual %VENV_NAME% ya existe.
    echo ¿Desea eliminarlo y crear uno nuevo? (s/n)
    set /p respuesta=
    if /i "%respuesta%"=="s" (
        rmdir /s /q %VENV_NAME%
        echo Entorno virtual eliminado.
    ) else (
        echo Operacion cancelada.
        pause
        exit /b
    )
)

echo Creando entorno virtual con %PY_CMD%...
%PY_CMD% -m venv %VENV_NAME%
if %errorlevel% neq 0 (
    echo ERROR: No se pudo crear el entorno virtual.
    pause
    exit /b
)

call %VENV_NAME%\Scripts\activate

echo Ingrese el nombre del archivo de requerimientos:
echo Dejar vacio para usar el predeterminado (requirements.txt):
set /p REQ_FILE="> "
if "%REQ_FILE%"=="" (
    set REQ_FILE=requirements.txt
) else (
    echo %REQ_FILE% | find ".txt" > nul
    if %errorlevel% neq 0 (
        set REQ_FILE=%REQ_FILE%.txt
    )
)

echo Instalando dependencias...
pip install -r %REQ_FILE%

echo.
echo Entorno %VENV_NAME% creado exitosamente con %PY_CMD%
echo Para activar: %VENV_NAME%\Scripts\activate
pause