#styles

theme_realiza <- function(){
  
  theme(axis.ticks = element_blank(),
        axis.title = element_text(size = 12),
        axis.title.y = element_text(margin = margin(r = 40)),
        axis.text = element_text(size = 11),
        plot.title.position = 'plot',
        plot.title = element_text(face = 'bold'),
        plot.background = element_blank(),
        panel.background = element_blank(),
        panel.grid.minor.y =  element_line(linetype = "dotted", color = "gray"),
        panel.grid.major.y =  element_line(linetype = "dotted", color = "gray"),
        legend.title = element_blank(),
        legend.position = "top",
        legend.text = element_text(size = 12),
        legend.key = element_rect(fill = NA)
  )
  
}