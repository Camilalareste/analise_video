import pandas as pd

try:
    # Carregar os arquivos CSV
    df1 = pd.read_csv('arquivo1.csv')
    df2 = pd.read_csv('arquivo2.csv')

    # Unir os arquivos com base em uma coluna comum
    dados_unidos = pd.merge(df1, df2, on='id', how='inner')

    # Calcular a evolução econômica
    dados_unidos['evolucao'] = dados_unidos['receita'] - dados_unidos['gastos']

    # Identificar situações econômicas
    dados_unidos['situacao'] = dados_unidos['evolucao'].apply(
        lambda x: 'Positiva' if x > 0 else 'Negativa'
    )

    # Salvar os resultados
    dados_unidos.to_csv('resultado_analise.csv', index=False)

    print("Análise concluída. Resultados salvos em 'resultado_analise.csv'.")
    # Exibir os resultados
    print(dados_unidos[['id', 'evolucao', 'situacao']])

except FileNotFoundError as e:
    print(f"Erro: Arquivo não encontrado. {e}")
except KeyError as e:
    print(f"Erro: Coluna ausente no arquivo CSV. {e}")
except Exception as e:
    print(f"Ocorreu um erro inesperado: {e}")





