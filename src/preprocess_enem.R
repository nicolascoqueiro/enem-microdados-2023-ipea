# ===============================
# Script: preprocess_enem.R
# Objetivo: Criar amostra e tratar dados do ENEM 2023
# ===============================

# Pacotes necessários
library(dplyr)   # manipulação de dados
library(readr)   # leitura e escrita de CSV

# Caminhos
raw_file <- "data/raw/MICRODADOS_ENEM_2023.csv"          # arquivo original
processed_file <- "data/processed/enem_2023_amostra.csv" # arquivo tratado

# 1. Carregar dados (somente se a memória suportar)
enem <- read_delim(raw_file, delim = ";", col_types = cols())  # col_types = cols() detecta tipos automaticamente

# 2. Criar amostra aleatória (20.000 registros)
set.seed(123)
tamanho_amostra <- 20000
enem_amostra <- enem %>% slice_sample(n = tamanho_amostra)

# 3. Checar nomes de colunas
colnames(enem_amostra)

# 4. Checar tipos de colunas
str(enem_amostra)

# 5. Verificar valores ausentes
na_contagem <- colSums(is.na(enem_amostra))
print(na_contagem)

# 6. Tratar valores ausentes simples nas notas
notas_cols <- c("NU_NOTA_CN", "NU_NOTA_CH", "NU_NOTA_LC", "NU_NOTA_MT", "NU_NOTA_REDACAO")

# Conferir se as colunas existem antes de substituir
notas_existentes <- notas_cols[notas_cols %in% colnames(enem_amostra)]

enem_amostra[notas_existentes] <- lapply(enem_amostra[notas_existentes],
                                         function(x) ifelse(is.na(x), 0, x))

# 7. Salvar a amostra tratada
write_csv(enem_amostra, processed_file)

cat("Pré-processamento concluído! Amostra salva em:", processed_file, "\n")
