import os
import pandas as pd
import subprocess
from openpyxl import load_workbook

def clonar_repositorios_desde_excel(archivo_excel, hoja=0):  
    try:
        df = pd.read_excel(archivo_excel, sheet_name=hoja)
        
        if 'Estudiante' not in df.columns or 'Repositorio' not in df.columns:
            raise ValueError("El archivo Excel debe contener las columnas 'Estudiante' y 'Repositorio'")
            
        for index, row in df.iterrows():
            estudiante = str(row['Estudiante']).strip()
            repositorio = str(row['Repositorio']).strip()
            
            if not estudiante or not repositorio:
                print(f"Advertencia: Fila {index+2} tiene datos faltantes. Estudiante: '{estudiante}', Repositorio: '{repositorio}'")
                continue
                
            try:
                os.makedirs(estudiante, exist_ok=True)
                print(f"Carpeta creada para {estudiante}")
            except OSError as e:
                print(f"Error al crear carpeta para {estudiante}: {e}")
                continue
                
            try:
                comando = ['git', 'clone', repositorio, estudiante]
                resultado = subprocess.run(comando, capture_output=True, text=True)
                
                if resultado.returncode == 0:
                    print(f"Repositorio clonado exitosamente para {estudiante}")
                else:
                    print(f"Error al clonar repositorio para {estudiante}:")
                    print(resultado.stderr)
                    
            except Exception as e:
                print(f"Error al ejecutar git clone para {estudiante}: {e}")
                
    except Exception as e:
        print(f"Error al procesar el archivo Excel: {e}")

if __name__ == "__main__":
    archivo_excel = input("Ingrese la ruta del archivo Excel: ").strip()
    archivo_excel = archivo_excel + '.xlsx'
    if not os.path.isfile(archivo_excel):
        print(f"Error: El archivo '{archivo_excel}' no existe.")
    else:
        clonar_repositorios_desde_excel(archivo_excel)