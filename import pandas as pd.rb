# Importa a biblioteca pandas e a chama de 'pd'.
# Pandas é uma ferramenta poderosa para trabalhar com tabelas de dados.
import pandas as pd

# Importa bibliotecas para gráficos
try:
    import matplotlib.pyplot as plt
    import seaborn as sns # Seaborn para gráficos mais estilizados
    PLOT_ENABLED = True
except ImportError:
    PLOT_ENABLED = False
    print("Atenção: Bibliotecas matplotlib e/ou seaborn não encontradas. O gráfico não será gerado.")
    print("Para gerar gráficos, instale-as com: pip install matplotlib seaborn")

try:
    # Tenta executar o código abaixo. Se der erro, ele pula para o 'except'.

    # Carregar os arquivos CSV
    # Lê o arquivo 'arquivo1.csv' e guarda os dados na tabela 'df1'.
    df1 = pd.read_csv('arquivo1.csv')
    # Lê o arquivo 'arquivo2.csv' e guarda os dados na tabela 'df2'.
    df2 = pd.read_csv('arquivo2.csv')

    # Unir os arquivos com base em uma coluna comum
    # Junta as tabelas df1 e df2.
    # 'on="id"' significa que vai usar a coluna 'id' para encontrar linhas correspondentes.
    # 'how="inner"' significa que só vai manter as linhas que têm o mesmo 'id' em AMBAS as tabelas.
    dados_unidos = pd.merge(df1, df2, on='id', how='inner')

    # Verificar se dados_unidos não está vazio antes de prosseguir
    if dados_unidos.empty:
        print("Nenhum dado correspondente encontrado após a união dos arquivos. O relatório e o gráfico não serão gerados.")
    else:
        # Calcular a evolução econômica
        # Cria uma nova coluna chamada 'evolucao'.
        # O valor de 'evolucao' para cada linha será o valor da coluna 'receita' menos o da coluna 'gastos'.
        dados_unidos['evolucao'] = dados_unidos['receita'] - dados_unidos['gastos']

        # Identificar situações econômicas
        # Cria uma nova coluna chamada 'situacao'.
        # Para cada valor na coluna 'evolucao':
        #   - se for maior que 0, 'situacao' será 'Positiva'.
        #   - senão (se for 0 ou menor), 'situacao' será 'Negativa'.
        # Isso é feito usando uma função 'lambda', que é uma forma rápida de definir uma pequena regra.
        dados_unidos['situacao'] = dados_unidos['evolucao'].apply(
            lambda x: 'Positiva' if x > 0 else 'Negativa'
        )

        # Salvar os resultados
        # Salva a tabela 'dados_unidos' em um novo arquivo CSV chamado 'resultado_analise.csv'.
        # 'index=False' evita que os números de índice das linhas sejam salvos no arquivo.
        nome_arquivo_resultado = 'resultado_analise.csv'
        dados_unidos.to_csv(nome_arquivo_resultado, index=False)

        # Informa ao usuário que a análise terminou e onde o resultado foi salvo.
        print(f"Análise concluída. Resultados salvos em '{nome_arquivo_resultado}'.")
        
        # Exibir os resultados
        # Mostra na tela as colunas relevantes da tabela 'dados_unidos'.
        print("\nResumo da Análise:")
        colunas_para_exibir = ['id', 'evolucao', 'situacao']
        # Adicionado nome_cliente para melhor contexto no resumo, se existir
        if 'nome_cliente' in dados_unidos.columns:
            colunas_para_exibir.insert(1, 'nome_cliente')
        print(dados_unidos[colunas_para_exibir])

        # Gerar e salvar o gráfico se as bibliotecas estiverem disponíveis e houver dados
        if PLOT_ENABLED: # Não precisa verificar dados_unidos.empty novamente, já está dentro do else
            try:
                # Configurar estilo do Seaborn para gráficos mais bonitos
                sns.set_theme(style="whitegrid")

                plt.figure(figsize=(10, 6)) # Define o tamanho da figura

                # Usar 'nome_cliente' para o eixo x se existir, senão 'id'
                # Convertendo para string para garantir que o Seaborn trate como categórico
                x_axis_col_name = 'nome_cliente' if 'nome_cliente' in dados_unidos.columns else 'id'
                
                # Certificar que a coluna do eixo x seja tratada como string/categoria para o plot
                dados_plot = dados_unidos.copy()
                dados_plot[x_axis_col_name] = dados_plot[x_axis_col_name].astype(str)

                barplot = sns.barplot(x=x_axis_col_name, y='evolucao', data=dados_plot, palette="viridis", hue=x_axis_col_name, dodge=False, legend=False)

                plt.title('Evolução Financeira por Cliente', fontsize=16)
                plt.xlabel('Cliente', fontsize=12)
                plt.ylabel('Evolução (Receita - Gastos)', fontsize=12)
                plt.xticks(rotation=45, ha='right') # Rotaciona os nomes dos clientes para melhor leitura

                # Adicionar os valores nas barras
                for p in barplot.patches:
                    barplot.annotate(format(p.get_height(), '.0f'), # .0f para números inteiros
                                   (p.get_x() + p.get_width() / 2., p.get_height()),
                                   ha = 'center', va = 'center',
                                   xytext = (0, 9),
                                   textcoords = 'offset points',
                                   fontsize=10)

                plt.tight_layout() # Ajusta o layout para não cortar nada

                nome_arquivo_grafico = 'grafico_evolucao_financeira.png'
                plt.savefig(nome_arquivo_grafico)
                print(f"\nGráfico da evolução salvo em '{nome_arquivo_grafico}'.")
                # Opcional: Mostrar o gráfico (descomente a linha abaixo se quiser que apareça na tela)
                # plt.show()
            except Exception as e_plot:
                print(f"Ocorreu um erro ao gerar o gráfico: {e_plot}")

# Se o erro for 'Arquivo não encontrado':
except FileNotFoundError as e:
    print(f"Erro: Arquivo não encontrado. Verifique os nomes e caminhos dos arquivos: {e}")
# Se o erro for 'Coluna não encontrada' (por exemplo, falta 'id', 'receita' ou 'gastos' nos CSVs):
except KeyError as e:
    # e.args[0] mostra qual coluna está faltando.
    print(f"Erro: Coluna '{e.args[0]}' ausente em um dos arquivos CSV. Verifique o cabeçalho dos arquivos.")
# Para qualquer outro tipo de erro inesperado:
except Exception as e:
    print(f"Ocorreu um erro inesperado durante o processamento dos dados: {e}")
    pip install pandas matplotlib seaborn
    python analise_financeira.py
    # Instala as bibliotecas necessárias
    # e tenta rodar o script novamente
# Instruções para o usuário em caso de erro
print("\nPara garantir que o script funcione corretamente:")
print("1. Certifique-se de que os arquivos 'arquivo1.csv' e 'arquivo2.csv' estão na mesma pasta que este script.")
print("2. Verifique se os arquivos CSV contêm as colunas 'id', 'receita' e 'gastos'.")
print("3. Se as bibliotecas pandas, matplotlib ou seaborn não estiverem instaladas, execute no terminal:")
print("   pip install pandas matplotlib seaborn")
                    
