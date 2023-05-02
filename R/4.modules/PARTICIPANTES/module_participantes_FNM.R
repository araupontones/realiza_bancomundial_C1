ui_participantes_FNM <- function(id){
  
  
  
  tagList(
    sidebarLayout(
      
      sidebarPanel(
        width = 2,
        selectInput(NS(id,"periodo"), 
                    label = h4("Periodo"),
                    choices = choices_periodo)
        
        
      ),
      
      mainPanel(
        
        fluidRow(
          h4("O Banco seleccionou 350 mulheres para participar da abordagem conecta. 
         O gráfico abaixo mostra o numero de mulheres agendadas para as actividades 
         e numero das mulheres que participaram das actividades. bla bla")
         
        ),
        
        fluidRow(
          
          
          
          column(width = 6,
                 mainPanel(
                   withSpinner(plotlyOutput(NS(id,"plot_actividades"), width = '450px'), color = "black")
                 )
          ),
          column(width = 6,
                 mainPanel(
                   withSpinner(plotlyOutput(NS(id,"plot_emprendedoras"), width =  "500px"), color = "black")
                 )
          )
        ),
      )
      
      
    )
    
    
    
    
  )
}

#server 

server_participantes_FNM <- function(id, db_emprendedoras, db_presencas
){
  
  moduleServer(id, function(input, output, session){
    
    grupo_modulo <- identify_grupo(id)
    
    #Data for this module ===========================================================
    data_module <- presencas_de_grupo(presencas_db = db_presencas,
                                      grupo = grupo_modulo,
                                      avoid_actividade = activities_sgr,
                                      keep = c("Presente", "Ausente", "Pendente")
    ) %>%
      mutate(
        
        #Nome do evento is missing in these two actividades
        Nome_do_evento = ifelse(actividade %in% c("Sessões individuais", 'Sessões de coaching'),
                                Emprendedora, Nome_do_evento),
        
        actividade = factor(actividade,
                            levels= activities_fnm,
                            ordered = T),
        actividade =recode_fnm(actividade) 
      )
    
    #reactive data actividades ==============================================================
    
    
    data_plot_actividades <- reactive({
      
      data_module %>%
        #keep only one record for each evento
        group_by(actividade, Nome_do_evento, Data) %>%
        slice(1) %>%
        ungroup() %>%
        #count how many eventos of each actividade were conducted
        group_by(actividade) %>%
        summarise(agendadas = n(), .groups = 'drop')
      
      
      
    })
    
    
    #plot
    output$plot_actividades <- renderPlotly({
      
      
      plot <- data_plot_actividades() %>%
        ggplot(aes(x = actividade,
                   y = agendadas)) +
        geom_col(width = .7,
                 fill = palette[3]) +
        labs(y = 'Numero de actividades',
             x = "") +
        theme_realiza() +
        theme(axis.text.x = element_text(angle = 45))
      
      
      ggplotly(plot) %>%
        config(displayModeBar = F)
      
    })    
    
    
    #reactive data emprendedoras ===================================================
    
    data_plot_emprendedoras <- reactive({
      data_module %>%
        group_by(actividade) %>%
        summarise(Agendadas = n(),
                  Presentes = sum(presente, na.rm = T)
        ) %>%
        pivot_longer(-actividade,
                     names_to = "status",
                     values_to = "total")
      
      
    })
    
    
    #plot 
    output$plot_emprendedoras <- renderPlotly({
      
      print(unique(data_plot_emprendedoras()$actividade))
      
      plot <- data_plot_emprendedoras() %>%
        ggplot(aes(x = actividade,
                   y = total,
                   fill = status)) +
        geom_col(width = .7,
                 position = 'dodge2') +
        scale_fill_manual(values = palette) +
        labs(y = "Numero de Mulheres",
             x = ""
        ) +
        theme_realiza() +
        theme(axis.text.x = element_text(angle = 45))
      
      
      ggplotly(plot) %>%
        config(displayModeBar = F)
      
      
      
    })
    
    
    
    
    
    
    
    
    
  })
  
}