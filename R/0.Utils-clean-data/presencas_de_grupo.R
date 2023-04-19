#Keeps presencas of group of interest
presencas_de_grupo <- function(presencas_db,
                               grupo = c("SGR", "FNM"),
                               avoid_actividade = "Sessão Inaugural"){
  
  
  data_return = presencas_db %>%
    #Keep only relevant records for this tab
    filter(grupo_accronym == grupo ,
           !actividade %in% avoid_actividade) %>%
    #only presentes
    filter(presente)
   
  
  return(data_return)          
  
}
