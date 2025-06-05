#!/bin/bash

echo "********************************************"
echo "* Configuración de entorno virtual Python  *"
echo "********************************************"
echo ""

read -p "Ingrese el comando de Python (ej: python3, python, py): [python3] " PY_CMD
PY_CMD=${PY_CMD:-python3}

if ! command -v $PY_CMD &> /dev/null; then
    echo "ERROR: $PY_CMD no está disponible"
    exit 1
fi

read -p "Nombre del entorno virtual: [venv] " VENV_NAME
VENV_NAME=${VENV_NAME:-venv}


if [ -d "$VENV_NAME" ]; then
    read -p "El entorno $VENV_NAME existe. ¿Eliminarlo? (s/n): " resp
    [[ "$resp" =~ ^[sS]$ ]] && rm -rf "$VENV_NAME" || exit 0
fi

echo "Creando entorno $VENV_NAME con $PY_CMD..."
$PY_CMD -m venv "$VENV_NAME" || exit 1

source "$VENV_NAME/bin/activate"

read -p "Nombre del archivo de requerimientos: [requirements.txt] " REQ_FILE
REQ_FILE=${REQ_FILE:-requirements.txt}


if [[ "$REQ_FILE" != *.txt ]]; then
    REQ_FILE="$REQ_FILE.txt"
fi

pip install -r $REQ_FILE

echo ""
echo "Entorno $VENV_NAME creado con $PY_CMD"
echo "Para activar: source $VENV_NAME/bin/activate"