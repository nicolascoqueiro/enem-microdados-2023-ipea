# ------------------------------------------------------------
# Script: 02_exploracao_dados.R
# Autor: Nicolas Coqueiro
# Projeto: ENEM Microdados 2023 - IPEA
# Descrição: Análise exploratória básica da amostra limpa
# ------------------------------------------------------------

# 1️⃣ Pacotes -------------------------------------------------------------------
library(readr)
library(dplyr)
library(ggplot2)
library(scales)

# 2️⃣ Caminhos -------------------------------------------------------------------
input_file <- "data/processed/enem_amostra_limpa.csv"
figures_dir <- "figures/"

# Cria pasta de figuras se não existir
if (!dir.exists(figures_dir)) dir.create(figures_dir)

# 3️⃣ Leitura dos dados ----------------------------------------------------------
enem <- read_csv(input_file, show_col_types = FALSE)

# 4️⃣ Estatísticas descritivas gerais --------------------------------------------
cat("Resumo geral das notas:\n")
summary(select(enem, starts_with("NU_NOTA_"), MEDIA_GERAL))

cat("\nNúmero total de participantes na amostra:", nrow(enem), "\n")

# 5️⃣ Distribuição da média geral -----------------------------------------------
p1 <- ggplot(enem, aes(x = MEDIA_GERAL)) +
  geom_histogram(fill = "#2E86AB", color = "white", bins = 40) +
  labs(
    title = "Distribuição da Média Geral - ENEM 2023 (Amostra)",
    x = "Média Geral",
    y = "Frequência"
  ) +
  theme_minimal()

ggsave(paste0(figures_dir, "distribuicao_media_geral.png"), p1, width = 7, height = 5)

# 6️⃣ Médias por sexo ------------------------------------------------------------
media_sexo <- enem %>%
  group_by(TP_SEXO) %>%
  summarise(
    media_geral = mean(MEDIA_GERAL, na.rm = TRUE),
    n = n()
  )

cat("\nMédia geral por sexo:\n")
print(media_sexo)

p2 <- ggplot(media_sexo, aes(x = TP_SEXO, y = media_geral, fill = TP_SEXO)) +
  geom_col() +
  geom_text(aes(label = round(media_geral, 1)), vjust = -0.5) +
  labs(
    title = "Média Geral por Sexo",
    x = "Sexo",
    y = "Média Geral"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

ggsave(paste0(figures_dir, "media_por_sexo.png"), p2, width = 6, height = 4)

# 7️⃣ Médias por raça ------------------------------------------------------------
media_raca <- enem %>%
  group_by(TP_COR_RACA) %>%
  summarise(media_geral = mean(MEDIA_GERAL, na.rm = TRUE)) %>%
  arrange(desc(media_geral))

cat("\nMédia geral por raça/cor:\n")
print(media_raca)

p3 <- ggplot(media_raca, aes(x = reorder(TP_COR_RACA, -media_geral), y = media_geral, fill = TP_COR_RACA)) +
  geom_col() +
  geom_text(aes(label = round(media_geral, 1)), vjust = -0.5) +
  labs(
    title = "Média Geral por Raça/Cor",
    x = "Raça/Cor",
    y = "Média Geral"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

ggsave(paste0(figures_dir, "media_por_raca.png"), p3, width = 7, height = 4)

# 8️⃣ Correlação entre notas -----------------------------------------------------
notas <- enem %>%
  select(NU_NOTA_CN, NU_NOTA_CH, NU_NOTA_LC, NU_NOTA_MT, NU_NOTA_REDACAO)

cor_matrix <- cor(notas, use = "pairwise.complete.obs")
cat("\nMatriz de correlação entre as notas:\n")
print(round(cor_matrix, 2))

# 🔟 Mensagem final --------------------------------------------------------------
cat("\n✅ Análise exploratória concluída com sucesso!\n")
cat("Gráficos salvos em:", figures_dir, "\n")

