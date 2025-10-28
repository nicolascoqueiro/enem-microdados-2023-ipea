# ------------------------------------------------------------
# Script: 01_limpeza_dados.R
# Autor: Nicolas Coqueiro
# Projeto: ENEM Microdados 2023 - IPEA
# Descrição: Limpeza e padronização da amostra dos microdados
# ------------------------------------------------------------

# 1️⃣ Pacotes -------------------------------------------------------------------
library(readr)
library(dplyr)
library(stringr)
library(readxl)

# 2️⃣ Caminhos -------------------------------------------------------------------
input_file <- "data/processed/enem_2023_amostra.csv"
dict_file <- "Dicionário_Microdados_Enem_2023.xlsx"
output_file <- "data/processed/enem_amostra_limpa.csv"

# 3️⃣ Leitura da amostra ---------------------------------------------------------
enem <- read_csv(input_file, show_col_types = FALSE)

# 4️⃣ Seleção de colunas de interesse --------------------------------------------
enem <- enem %>%
  select(
    NU_INSCRICAO,
    TP_SEXO,
    TP_FAIXA_ETARIA,
    TP_COR_RACA,
    TP_ESCOLA,
    TP_ENSINO,
    TP_DEPENDENCIA_ADM_ESC,
    TP_PRESENCA_CN,
    TP_PRESENCA_CH,
    TP_PRESENCA_LC,
    TP_PRESENCA_MT,
    NU_NOTA_CN,
    NU_NOTA_CH,
    NU_NOTA_LC,
    NU_NOTA_MT,
    NU_NOTA_REDACAO,
    Q001, Q002, Q003, Q004, Q005
  )

# 5️⃣ Remover linhas com notas ausentes ------------------------------------------
enem <- enem %>%
  filter(
    !is.na(NU_NOTA_CN),
    !is.na(NU_NOTA_CH),
    !is.na(NU_NOTA_LC),
    !is.na(NU_NOTA_MT),
    !is.na(NU_NOTA_REDACAO)
  )

# 6️⃣ Aplicar rótulos legíveis com base no dicionário -----------------------------
enem <- enem %>%
  mutate(
    TP_SEXO = recode(TP_SEXO,
                     "M" = "Masculino",
                     "F" = "Feminino"),
    
    TP_COR_RACA = recode(TP_COR_RACA,
                         "0" = "Não declarado",
                         "1" = "Branca",
                         "2" = "Preta",
                         "3" = "Parda",
                         "4" = "Amarela",
                         "5" = "Indígena"),
    
    TP_ESCOLA = recode(TP_ESCOLA,
                       "1" = "Não respondeu",
                       "2" = "Pública",
                       "3" = "Privada",
                       "4" = "Exterior"),
    
    TP_ENSINO = recode(TP_ENSINO,
                       "1" = "Ensino Regular",
                       "2" = "Educação Especial",
                       "3" = "Educação de Jovens e Adultos (EJA)"),
    
    TP_DEPENDENCIA_ADM_ESC = recode(TP_DEPENDENCIA_ADM_ESC,
                                    "1" = "Federal",
                                    "2" = "Estadual",
                                    "3" = "Municipal",
                                    "4" = "Privada")
  )

# 7️⃣ Converter tipos adequadamente ----------------------------------------------
enem <- enem %>%
  mutate(
    across(starts_with("NU_NOTA_"), as.numeric),
    TP_FAIXA_ETARIA = as.factor(TP_FAIXA_ETARIA),
    TP_COR_RACA = as.factor(TP_COR_RACA),
    TP_ESCOLA = as.factor(TP_ESCOLA),
    TP_SEXO = as.factor(TP_SEXO)
  )

# 8️⃣ Criar coluna de média geral ------------------------------------------------
enem <- enem %>%
  mutate(
    MEDIA_GERAL = rowMeans(select(., NU_NOTA_CN, NU_NOTA_CH, NU_NOTA_LC, NU_NOTA_MT, NU_NOTA_REDACAO), na.rm = TRUE)
  )

# 9️⃣ Remover duplicatas ---------------------------------------------------------
enem <- enem %>%
  distinct(NU_INSCRICAO, .keep_all = TRUE)

# 🔟 Salvar dados limpos ---------------------------------------------------------
write_csv(enem, output_file)

cat("✅ Limpeza concluída com sucesso!\n")
cat("Arquivo salvo em:", output_file, "\n")
cat("Total de registros finais:", nrow(enem), "\n")
