# Configurações globais do projeto ENEM 2023 - IPEA

# Pacotes principais
library(dplyr)
library(ggplot2)
library(readr)
library(stringr)
library(readxl)
library(scales)

# Diretórios
dir_data_raw <- "data/raw/" #no raw, importar o csv do inep bruto. Não tem como importar no github, pelo tamanho da base.
dir_data_processed <- "data/processed/"
dir_figures <- "figures/"
dir_src <- "src/"

# Função de verificação de pasta
check_dir <- function(path) {
  if (!dir.exists(path)) dir.create(path, recursive = TRUE)
}

check_dir(dir_figures)
check_dir(dir_data_processed)
