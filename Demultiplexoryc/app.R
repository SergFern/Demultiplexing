#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyFiles)
library(tidyverse)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Demultiplexoryc"),

    # Sidebar with a slider input for number of bins 
    fluidRow(column(width = 4),column(div(h1("Demultiplexoryc",img(src="dna_free.png"))),width = 8)),
        column(width = 1), # Blank column to center MainPanel
        mainPanel(width = 8, style="margin-left:4%; margin-right:4%",
          wellPanel(
              # textInput('carrera', 'Direccion completa de la carrera a demultiplexar.')
              shinyDirButton('carrera', 'Seleccionar carrera', 'Seleccionar carrera', multiple = FALSE),
              br(),
              textOutput('path_carrera')
          ),
          wellPanel(
              checkboxInput('CheckSampleSheet',label = 'La carrera incluye ya la samplesheet?', value = FALSE),       
              conditionalPanel(
                  condition = "input.CheckSampleSheet == false",
                  fileInput('samplesheet', 'Seleccionar SampleSheet', accept = '.csv'))
              ),
          wellPanel(
              
              checkboxInput('UMI','La carrera contiene UMIs.', value = TRUE),
              conditionalPanel(
                  condition = "input.UMI == true",
                  sliderInput('UMIsize', 'Longitud del UMI', value = 10, min = 1, max = 20),
                  sliderInput("IndexSize", "Longitud del Index", value = 8, min = 1, max = 20))
              ),
         
          wellPanel(actionButton('upload', label = 'Subir y Demultiplexar')),
          wellPanel(actionButton('debug', label = 'debug'))
        )
    )


# Define server logic required to draw a histogram
server <- function(input, output) {
    
    options( shiny.maxRequestSize = 1000 * 1024 ^ 2 )
    checks <- reactiveValues()
    checks$sobreescribir <- NULL
    
    shinyDirChoose(input, id = 'carrera', roots=c(carreras='/mnt/NAS'), filetypes=c(''))
    # shinyDirChoose(input, id = 'carrera', roots=c(carreras='/media'), filetypes=c(''))
    
    carrera <- reactive({
        if(is.list(input$carrera[1])){
        return(str_c('/mnt/NAS',str_c(input$carrera$path, collapse = '/')))}else{return('Enter valid path')}
        })
    
    # carrera <- reactive({
    #     if(is.list(input$carrera[1])){
    #     return(str_c('/media',str_c(input$carrera$path, collapse = '/')))}else{return('Enter valid path')}
    #     })
    
    output$path_carrera <- renderText({carrera()})

    #############################################################.
    ######################## Modal popups designs ##################
    #############################################################.
    
    
    Check_path_integrity <- reactive({
        
        if(!dir.exists(carrera())){
            
            showModal(modalDialog(
                fluidPage(
                    h1(strong("Warning"),align="center"),
                    hr(),
                    fluidRow(column(4,offset = 4,
                                    div(style='max-width:150px;max-height:150px;width:3%;height:5%;', 
                                        img(src="caution-icon.png", height='150', width='150', align="middle")))),
                    h2(paste("No se puede encontrar la carpeta. Asegurese que la direccion esta bien introducida y no contiene espacios." ,sep = ''), align = 'center'),
                    easyClose = TRUE,
                    footer = NULL
                )))
            
            return(FALSE)
            
            }else{return(TRUE)}
    })
    
    Check_sample_sheet <- reactive({

        if(input$CheckSampleSheet == FALSE && is.null(input$samplesheet)){
        
            showModal(modalDialog(
                fluidPage(
                    h1(strong("Warning"),align="center"),
                    hr(),
                    fluidRow(column(4,offset = 4,
                                    div(style='max-width:150px;max-height:150px;width:3%;height:5%;', 
                                        img(src="caution-icon.png", height='150', width='150', align="middle")))),
                    h2(paste("La SampleSheet es requerida para lanzar el demultiplexado." ,sep = ''), align = 'center'),
                    easyClose = TRUE,
                    footer = NULL
                )))
            return(FALSE)
            
        }else{return(TRUE)}

    })
    
    Overwite_samplesheet <- function(){
            
            showModal(modalDialog(
                fluidPage(
                    h1(strong("Warning"),align="center"),
                    hr(),
                    fluidRow(column(4,offset = 4,
                                    div(style='max-width:150px;max-height:150px;width:3%;height:5%;', 
                                        img(src="caution-icon.png", height='150', width='150', align="middle")))),
                    h2(paste("Esta carrera ya contiene una SampleSheet, desea sobreescribirla?." ,sep = ''), align = 'center'),
                    fluidRow(
                        column(2),
                        actionButton('sobreescribir_ss_si', 'Si', icon = icon('file-import')),
                        actionButton('sobreescribir_ss_cancel', 'Calcelar subida', icon = icon('ban')),
                        actionButton('sobreescribir_ss_continue', 'Continuar subida', icon = icon('arrow-right')))),
                easyClose = FALSE,
                footer = NULL
            ))
        return()
    }
    
    #######################################################.
    ###################### MAIN function ##################
    #######################################################.
    
    execute_main <- function(){
        
        command <- paste(
            '../scripts/server_demultiplexing.sh',
            carrera(),
            nombre_carrera(),
            input$UMI,
            input$UMIsize,
            input$IndexSize)
        # print('script going on')
        print(paste0('Executing command: ',command, sep = 0))
        system(command = command)
        return()
    }
    
    #######################################################.
    ###################### UPLOAD #########################
    #######################################################.
    
    observeEvent(input$upload,{
        
        # withProgress(?
        
        if(!Check_path_integrity()){
            return()
        }
        
        if(!Check_sample_sheet()){# Checks case there is samplesheet input or samplesheet present.
            return()
        }
        
        if(input$CheckSampleSheet){execute_main()} # Execute main right away it the SS is already provided
            
        if(!input$CheckSampleSheet && input$samplesheet[1] != 0){
            # This means samplesheet is being introduced through the app. We
            # need to copy it into the runs directory.
            if(file.copy(input$samplesheet$datapath, paste0(carrera(),'/SampleSheet.csv')) == FALSE){
                #Case the is a SS already present despite introducing a new one.
                Overwite_samplesheet() # Shows popup modalMenu
            }else{execute_main()} # Si no hay samplesheet en la carrera de destino que se ejecute el programa.
        }
        
    })
##########################################################################.
############ ObserveEvents for Modal menu por SS overwrite ###############
##########################################################################.
    
    observeEvent(input$sobreescribir_ss_cancel, {
        removeModal()
        checks$sobreescribir <- 'CANCEL'
        return()
    })
    
    observeEvent(input$sobreescribir_ss_continue, {
        removeModal()
        checks$sobreescribir <- FALSE
        execute_main()
        return()
    })
    
    observeEvent(input$sobreescribir_ss_si,{
        #Overwrites existing samplesheet.
        file.copy(input$samplesheet$datapath, paste0(carrera(),'/SampleSheet.csv'), overwrite = TRUE)
        removeModal()
        checks$sobreescribir <- TRUE
        execute_main()
        return()
    })
    
    ##########################################################################.
    ######################### Debugger #########
    ##########################################################################.
    
    observeEvent(input$debug, {browser()})
    
}

# Run the application 
shinyApp(ui = ui, server = server)
