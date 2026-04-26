workspace "UniCycle" "Multi-tenant marketplace for university ecosystems" {

    model {
        # 1. External Actors (People)
        student = person "Verified University Student" "A student with a valid .edu email address participating in their isolated campus marketplace." "Customer"
        uniAdmin = person "University Administrator" "Campus official who designates safe zones and monitors platform analytics." "Staff"

        # 2. External Systems (Boxes)
        identityProvider = softwareSystem "University Identity / SSO" "External university systems used to verify student enrollment." "External"
        externalMarketplaces = softwareSystem "Legacy Marketplaces" "Facebook Marketplace, Craigslist, etc." "External"

        # 3. The Group Boundary (The Dotted Box)
        group "UniCycle" {
            platformAdmin = person "Platform Administrator" "Manages the global infrastructure, onboards new universities, and maintains the multi-tenant database." "Staff"
            unicycle = softwareSystem "UniCycle Platform" "A multi-tenant, centralized circular economy platform providing isolated, high-trust marketplaces." "MainSystem"
        }

        # 4. Relationships (Arrows)
        student -> unicycle "Browses, buys, sells, and messages within their campus instance using"
        student -> externalMarketplaces "Currently uses for campus trading (High friction / Low trust)"
        platformAdmin -> unicycle "Configures tenants and manages global infrastructure using"
        uniAdmin -> unicycle "Designates safe zones and views campus analytics using"
        unicycle -> identityProvider "Verifies student identity via .edu routing using"
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
        }
    }
}