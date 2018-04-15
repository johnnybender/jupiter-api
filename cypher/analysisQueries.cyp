////// *** Queries for Analysis *** //////

//// Public Health Tag ////
MERGE (v:Tag {name: "Public Health"})-[p:TAGS]->(n)

//// All Nodes with "Public Health" flag ////

MATCH (n)-[r:TAGS]-(p:Tag)
WHERE p.name = "Public Health" AND (labels(n) = ["Collaborative"] OR labels(n) = ["Dataset"] OR labels(n) = ["HealthSurvey"] OR labels(n) = ["Organization"] OR labels(n) = ["Program"] OR labels(n) = ["Registry"] OR labels(n) = ["SurveillanceSystem"] OR labels(n) = ["Tag"])
Return n.name, n.title, p.name, labels(n)

//// All Organizations (CDC Database & manually entered) ////

MATCH(n:Organization)
RETURN n.id, n.name, n.mission, labels(n)

///// ~~ Combine these (Entities) ~~ ////

    //// Datasets from CDC database ////

        // All datasets from CDC database //

        MATCH (n:Dataset)
        WHERE exists(n.lastUpdatedBy)
        RETURN n.id, n.name, labels(n)

    //// Datasets from HHS Enterprise Data Tracker  ////

        // All datasets from HHS Enterprise Data Tracker //

        MATCH (n:Dataset)
        WHERE not exists(n.lastUpdatedBy)
        RETURN n.title, n.description, labels(n), n.publisherName

        // All datasets from HHS Enterprise Data Tracker connected to any node//

        MATCH (n:Dataset)--(b)
        WHERE not exists(n.lastUpdatedBy)
        RETURN n, b

        // All datasets from HHS Enterprise Data Tracker connected to public health tag//

        MATCH (f:Tag)-[r:TAGS]->(n:Dataset)
        WHERE not exists(n.lastUpdatedBy) AND f.name = "Public Health"
        RETURN n.title, n.description, labels(n), n.publisherName, f.name

        // Datasets from HHS Enterprise Data Tracker with keyword //

        MATCH (n:Dataset)
        WHERE EXISTS (n.keyword)
        UNWIND (n.keyword) as P
        RETURN n.title, P

            // Datasets from HHS Enterprise Data Tracker with keyword contains 'public health'//

            //STATUS: Tagged//
            MATCH (n:Dataset)
            UNWIND (n.keyword) as P
            MATCH (n:Dataset)
            WHERE toLower(P) CONTAINS toLower('public health')
            RETURN n.title, P

            ╒══════════════════════════════════════════════════════════════╤══════════════════════════╕
            │"n.title"                                                     │"P"                       │
            ╞══════════════════════════════════════════════════════════════╪══════════════════════════╡
            │"CDC Emergency Text Messages"                                 │""public health""         │
            ├──────────────────────────────────────────────────────────────┼──────────────────────────┤
            │"National Intimate Partner and Sexual Violence Survey (NISVS)"│""Public Health Practice""│
            ├──────────────────────────────────────────────────────────────┼──────────────────────────┤
            │"U.S. Chronic Disease Indicators (CDI)"                       │""public health""         │
            ├──────────────────────────────────────────────────────────────┼──────────────────────────┤
            │"Veto Violence - Violence Education Tools Online"             │""public health""         │
            └──────────────────────────────────────────────────────────────┴──────────────────────────┘

            // Datasets from HHS Enterprise Data Tracker where description contains 'public health' //

            //STATUS: Tagged//
            MATCH(n:Dataset)
            WHERE toLower(n.description) CONTAINS toLower('public health')
            RETURN n.title, n.description, n.keyword

    //// Collaborative from CDC Database ////
    
        // All Collaborative from CDC database //

        MATCH (n:Collaborative) RETURN n.id, n.name, n.purpose, labels(n)

    //// HealthSurvey (CDC Database & manually entered) ////

        // All Healthsurvey //

        MATCH (n:HealthSurvey)
        RETURN n.id, n.name, labels(n)

    //// Programs (CDC Database & manually entered) ////

        // All Program //

        MATCH (n:Program) 
        RETURN n.id, n.name, n.purpose, n.`dataProviders-Electronic`, n.`dataProviders-Manual`, labels(n)

        // Programs tagged as "Public Health" based on NQF measure which have actual/intended use as "Public Health/Disease Surveillance" //

        MATCH (f:Tag)-[r:TAGS]->(z:Program)
        WHERE f.name = "Public Health"
        RETURN z.name, f.name as tag, labels(z)

    //// Tools ////

        MATCH(n:Tool)
        RETURN n.id, n.name, n.purpose, labels(n), n.geographicCoverageArea

    //// Registries ////

        MATCH(n:Registry)
        RETURN n.id, n.name, n.purpose, n.dataProvidersElectronic, n.dataProvidersManual, n.geographicCoverageArea, labels(n)

    //// Surveillance Systems ////

        MATCH(n:SurveillanceSystem)
        RETURN n.id, n.name, n.purpose, n.dataProvidersManual, n.dataProvidersElectronic, labels(n)






// Returns a list of nodes with dataProviderManual and dataProviderElectronic named
MATCH (n) 
WHERE exists(n.`dataProviders-Manual`) OR exists(n.`dataProviders-Electronic`) OR exists(n.`dataProvidersManual`) OR exists(n.`dataProvidersElectronic`)
RETURN n.name, LABELS(n), n.`dataProviders-Electronic` AS `dataProvidersElectronic`, n.`dataProvidersElectronic` AS `dataProvidersElectronic2`, n.`dataProvidersManual` AS `dataProvidersManual`, n.`dataProviders-Manual` AS `dataProvidersManual2`

// Returns the programs that use NQF measures intended for public health
MATCH (a:Program)
MATCH (b:Measure)
UNWIND b.actualPlannedUse as x
MATCH (a:Program)-[r:USES]->(b:Measure)
WHERE x = "Public Health/Disease Surveillance"
RETURN a.name, x
╒═════════════════════════════════════════════════════════════╤════════════════════════════════════╕
│"a.name"                                                     │"x"                                 │
╞═════════════════════════════════════════════════════════════╪════════════════════════════════════╡
│"Medicare Physician Quality Reporting System (PQRS)"         │"Public Health/Disease Surveillance"│
├─────────────────────────────────────────────────────────────┼────────────────────────────────────┤
│" Physician Feedback/Quality and Resource Use Reports (QRUR)"│"Public Health/Disease Surveillance"│
├─────────────────────────────────────────────────────────────┼────────────────────────────────────┤
│" Physician Value-Based Payment Modifier (VBM)"              │"Public Health/Disease Surveillance"│
├─────────────────────────────────────────────────────────────┼────────────────────────────────────┤
│"Hospital Compare"                                           │"Public Health/Disease Surveillance"│
├─────────────────────────────────────────────────────────────┼────────────────────────────────────┤
│" Medicare Shared Savings Program (MSSP)"                    │"Public Health/Disease Surveillance"│
├─────────────────────────────────────────────────────────────┼────────────────────────────────────┤
│" Hospital Inpatient Quality Reporting"                      │"Public Health/Disease Surveillance"│
├─────────────────────────────────────────────────────────────┼────────────────────────────────────┤
│" Physician Compare"                                         │"Public Health/Disease Surveillance"│
├─────────────────────────────────────────────────────────────┼────────────────────────────────────┤
│" Million Hearts"                                            │"Public Health/Disease Surveillance"│
└─────────────────────────────────────────────────────────────┴────────────────────────────────────┘

// Return all organizations that are not under CDC
MATCH (n:Organization)
WHERE NOT (n)-[:IS_AN_OFFICE_OR_AGENCY_OF]->({name: "US Centers for Disease Control and Prevention "}) AND NOT n.name = "US Centers for Disease Control and Prevention "
RETURN n.name

// Query for all the measures classified as public health used by programs
MATCH (p:Tag)
MATCH (n:Program)-[r:USES]->(q:Measure)
MATCH (p:Tag {name: "Public Health"})-[x:TAGS]->(q)
RETURN DISTINCT q.title
╒══════════════════════════════════════════════════════════════════════╕
│"q.title"                                                             │
╞══════════════════════════════════════════════════════════════════════╡
│"Unexpected Complications in Term Newborns"                           │
├──────────────────────────────────────────────────────────────────────┤
│"Preventive Care and Screening: Tobacco Use: Screening and Cessation I│
│ntervention"                                                          │
└──────────────────────────────────────────────────────────────────────┘
