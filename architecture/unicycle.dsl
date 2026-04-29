workspace "UniCycle" "Multi-tenant marketplace for university ecosystems" {

    model {
        # 1. External Actors
        student = person "Verified University Student" "A student with a valid .edu email address participating in their isolated campus marketplace." "Customer"
        uniAdmin = person "University Administrator" "Campus official who designates safe zones and monitors platform analytics." "Staff"

        # 2. External Systems
        identityProvider = softwareSystem "University Identity / SSO" "External university systems used to verify student enrollment." "External"
        externalMarketplaces = softwareSystem "Legacy Marketplaces" "Facebook Marketplace, Craigslist, etc." "External"

        # 3. The Group Boundary
        group "UniCycle" {
            platformAdmin = person "Platform Administrator" "Manages the global infrastructure, onboards new universities, and maintains the multi-tenant database." "Staff"

            unicycle = softwareSystem "UniCycle Platform" "A multi-tenant, centralized circular economy platform providing isolated, high-trust marketplaces." "MainSystem" {

                # --- NEW: C2 CONTAINERS ---
                webApp = container "Web Application" "Provides the marketplace UI, login, and listing creation for users." "React" "WebBrowser"
                apiApp = container "API Application" "Provides marketplace functionality, JWT authentication, and secure routing via a JSON/HTTP API." "Spring Boot" "Backend"
                database = container "Database" "Stores multi-tenant university data, user profiles, and active listings." "PostgreSQL" "Database"
            }
        }

        # 4. Relationships
        student -> externalMarketplaces "Currently uses for campus trading (High friction / Low trust)"

        # Interactions with the Web App
        student -> webApp "Browses, buys, sells, and messages within their campus instance using" "HTTPS"
        platformAdmin -> webApp "Configures tenants and manages global infrastructure using" "HTTPS"
        uniAdmin -> webApp "Designates safe zones and views campus analytics using" "HTTPS"

        # Internal Container Interactions
        webApp -> apiApp "Makes API requests to" "JSON/HTTPS"
        apiApp -> database "Reads from and writes to" "SQL/TCP"

        # Backend to External Systems
        apiApp -> identityProvider "Verifies student identity via .edu routing using" "JSON/HTTPS"
    }

    views {
        # VIEW 1: The System Landscape (Level 0)
        systemLandscape "Landscape" "The System Landscape view for the UniCycle platform." {
            include *
            autoLayout
        }

        # VIEW 2: The System Context (Level 1)
        systemContext unicycle "Context" "The System Context view for the UniCycle Platform." {
            include *
            autoLayout
        }

        # VIEW 3: The Container Diagram (Level 2) - NEW!
        container unicycle "Containers" "The Container view for the UniCycle Platform." {
            include *
            autoLayout
        }

        # 5. Styling
        styles {
            element "Customer" {
                background #519823
                color #ffffff
                shape person
            }
            element "Staff" {
                background #128297
                color #ffffff
                shape person
            }
            element "MainSystem" {
                background #1168bd
                color #ffffff
                shape roundedbox
            }
            element "External" {
                background #c82424
                color #ffffff
                shape roundedbox
            }
            # Container-specific shapes
            element "WebBrowser" {
                background #1168bd
                color #ffffff
                shape WebBrowser
            }
            element "Backend" {
                background #1168bd
                color #ffffff
                shape roundedbox
            }
            element "Database" {
                background #1168bd
                color #ffffff
                shape Cylinder
            }
        }
    }
}