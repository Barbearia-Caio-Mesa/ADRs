workspace "Caio Mesa Barber" "Arquitetura do sistema de gestão para barbearia" {

    model {
        # Atores
        user = person "Usuário" "Cliente buscando serviços ou o administrador gerenciando a barbearia." "User"

        # Sistemas Externos
        twilio = softwareSystem "Twilio API" "Sistema externo para envio de notificações via WhatsApp." "External System"

        # O seu Sistema
        barberSystem = softwareSystem "Sistema Caio Mesa Barber" "Plataforma central de gestão e portfólio." {
            
            # Nível 2 - Containers
            cloudflare = container "Cloudflare" "Firewall, DNS e roteamento de tráfego." "CDN / Reverse Proxy"
            
            landing = container "Site Institucional" "Site público para visualização de serviços." "React + Next.js (Static Web Apps)" "Web Browser"
            spa = container "Painel Administrativo" "Interface pós-login para gestão da barbearia." "React + TypeScript (Static Web Apps)" "Web Browser"
            
            api = container "API Core" "Provê funcionalidades de negócio." "Java Spring Boot (Container Apps)"
            
            database = container "Banco de Dados" "Armazena usuários, agendamentos e configurações." "Azure SQL Serverless" "Database"
            blob = container "Blob Storage" "Armazena imagens do portfólio." "Azure Blob Storage" "Storage"
            
            functions = container "Job Python" "Processamento assíncrono (Acionado via Timer Trigger e API)." "Azure Functions (Python)"
        }

        # Relacionamentos
        user -> cloudflare "Acessa o domínio" "HTTPS"
        
        cloudflare -> landing "Roteia tráfego" "HTTPS"
        cloudflare -> spa "Roteia tráfego" "HTTPS"
        cloudflare -> api "Protege e roteia requisições" "HTTPS"
        
        landing -> api "Consome dados" "JSON/HTTPS"
        spa -> api "Envia e recebe dados" "JSON/HTTPS"
        
        # A API Centraliza o acesso ao Blob Storage
        api -> blob "Gerencia, faz upload e acessa imagens" "HTTPS"
        api -> database "Lê e escreve" "JDBC"
        
        # O Job Python agora interage com a API e o Twilio
        api -> functions "Aciona rotinas sob demanda" "REST API"
        functions -> api "Consulta dados e atualiza status" "JSON/HTTPS"
        functions -> twilio "Solicita envio de mensagens" "REST API"
        
        twilio -> user "Envia notificações via WhatsApp"
    }

    views {
        systemContext barberSystem "Contexto" {
            include *
            autolayout lr
        }

        container barberSystem "Containers" {
            include *
            autolayout lr
        }

        styles {
            element "Element" {
                color #ffffff
            }
            element "Person" {
                background #08427b
                shape Person
            }
            element "Software System" {
                background #1168bd
            }
            element "External System" {
                background #999999
            }
            element "Container" {
                background #438dd5
            }
            element "Web Browser" {
                shape WebBrowser
            }
            element "Database" {
                shape Cylinder
            }
        }
        
        theme https://static.structurizr.com/themes/microsoft-azure-2023.01.24/theme.json
    }
}