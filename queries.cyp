MATCH (n) 
WHERE exists(n.`dataProviders-Manual`) OR exists(n.`dataProviders-Electronic`) OR exists(n.`dataProvidersManual`) OR exists(n.`dataProvidersElectronic`)
RETURN n.name, LABELS(n), n.`dataProviders-Electronic` AS `dataProvidersElectronic`, n.`dataProvidersElectronic` AS `dataProvidersElectronic2`, n.`dataProvidersManual` AS `dataProvidersManual`, n.`dataProviders-Manual` AS `dataProvidersManual2`

MATCH (n:Organization)-[r:OVERSEES]->(i:SurveillanceSystem) RETURN n.name, i.name

MATCH (n:Organization)-[r:MANAGES]->(i:SurveillanceSystem) RETURN n.name, i.name

MATCH (n:Organization)-->(i:SurveillanceSystem) RETURN n, i

CREATE (n:Organization { name: 'Andres', title: 'Developer' })

// This was used to load and create nodes for the csv NQF file
LOAD CSV FROM "file:///nqfMeasures.csv" AS line
CREATE (:Measure {title: line[1], nqf: line[2],	description: line[3], numerator: line[4], denominator: line[5], exclusions: line[6], riskAdjustment: line[7], measureType: line[8],	measureFormat: line[9], program: split((line[10]), ","), condition: split((line[11]), ","), nonConditionSpecific: split((line[12]), ","), careSetting: split((line[13]), ","), nationalQualityStrategyPriorities: line[14], actualPlannedUse: split((line[15]), ","),	dataSource: split((line[16]), ","), levelOfAnalysis: split((line[17]), ","), targetPopulation: split((line[18]), ","), harmonizationAction: line[19], measuresConsideredInHarmonizationRequest: line[20], updatedDate: line[21], endorsementType: line[22], endorsementDate: line[23], measureUnderReview: line[24], correspondingMeasures: line[25], measureSteward: line[26], measureStewardEmailAddress: line[27], measureStewardWebsiteUrl: line[28], measureDisclaimer: line[29], measureStewardCopyright: line[30], projectShortTitle: line[31]})

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




MATCH (n:Tag)
WHERE n.name = "Public Health"
WITH n.name AS name, COLLECT(n) AS nodelist, COUNT(*) AS count
WHERE count > 1
CALL apoc.refactor.mergeNodes(nodelist) YIELD node
RETURN node