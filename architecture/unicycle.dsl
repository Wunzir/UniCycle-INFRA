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

                webApp = container "Web Application" "Provides the marketplace UI, login, and listing creation for users." "React" "WebBrowser"
                database = container "Database" "Stores multi-tenant university data, user profiles, and active listings." "PostgreSQL" "Database"

                apiApp = container "API Application" "Provides marketplace functionality, JWT authentication, and secure routing via a JSON/HTTP API." "Spring Boot" "Backend" {

                    # --- NEW: Updated C3 Components ---
                    securityComponent = component "Security Filter" "Validates JWT tokens and secures endpoints." "Spring Security" "Component"
                    authController = component "Sign In API" "Endpoint for user authentication and token generation." "Spring MVC RestController" "Component"

                    profileController = component "Profile API" "Endpoints for managing user profiles, personal listings, and reviews." "Spring MVC RestController" "Component"
                    profileService = component "Profile Service" "Contains business logic for user accounts and reviews." "Spring Bean" "Component"

                    listingController = component "Listings API" "Endpoints for creating and browsing marketplace listings." "Spring MVC RestController" "Component"
                    listingService = component "Listing Service" "Contains core business logic and multi-tenant routing for items." "Spring Bean" "Component"

                    repository = component "Database Repository" "Handles data access to the database." "Spring Data JPA" "Component"
                }
            }
        }

        # 4. Relationships
        student -> externalMarketplaces "Currently uses for campus trading (High friction / Low trust)"

        # Interactions with the Web App
        student -> webApp "Browses, buys, sells, and messages within their campus instance using" "HTTPS"
        platformAdmin -> webApp "Configures tenants and manages global infrastructure using" "HTTPS"
        uniAdmin -> webApp "Designates safe zones and views campus analytics using" "HTTPS"

        # React talking to Spring Boot endpoints
        webApp -> authController "Makes API requests to authenticate using" "JSON/HTTPS"
        webApp -> profileController "Makes API requests for profile data using" "JSON/HTTPS"
        webApp -> listingController "Makes API requests for marketplace items using" "JSON/HTTPS"

        # Security Validation Arrows
        authController -> securityComponent "Delegates token generation to"
        profileController -> securityComponent "Validates tokens and permissions using"
        listingController -> securityComponent "Validates tokens and permissions using"

        securityComponent -> identityProvider "Verifies student identity via .edu routing using" "JSON/HTTPS"

        # Internal Business Logic Routing
        profileController -> profileService "Delegates business logic to"
        listingController -> listingService "Delegates business logic to"

        profileService -> repository "Uses for data access"
        listingService -> repository "Uses for data access"

        # Spring Boot talking to Postgres
        repository -> database "Reads from and writes to" "SQL/TCP"
    }

    views {
        systemLandscape "Landscape" "The System Landscape view for the UniCycle platform." {
            include *
            autoLayout
        }

        systemContext unicycle "Context" "The System Context view for the UniCycle Platform." {
            include *
            autoLayout
        }

        container unicycle "Containers" "The Container view for the UniCycle Platform." {
            include *
            autoLayout
        }

        component apiApp "Components" "The Component view for the API Application." {
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
            element "Component" {
                background #ffffff
                color #1168bd
                shape Component
            }
        }
    }
}