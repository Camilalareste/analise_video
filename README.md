# analise_video
analise de dados e insights  cruzar dados e da relatório 
import pandas as pd
import glob
import os

# Caminho onde estão os CSVs
caminho_csvs = r"C:\Users\Pichau\Downloads"  # ajuste se seus CSVs estiverem em outra pasta!
os.chdir(caminho_csvs)

# Encontra todos os arquivos CSV na pasta
csv_files = glob.glob("*.csv")

# Lê e une todos os arquivos CSV
df = pd.concat([pd.read_csv(f) for f in csv_files], ignore_index=True)

# Salva o resultado em um novo arquivo CSV
df.to_csv("todos_dados_unificados.csv", index=False, encoding="utf-8")

print("Todos os arquivos CSV foram unidos em: todos_dados_unificados.csv")
