MATCH (n) 
WHERE has(n.`dataProviders-Manual`) OR has(n.`dataProviders-Electronic`) OR has(n.`dataProvidersManual`) OR has(n.`dataProvidersElectronic`)
RETURN n.name, LABELS(n), n.`dataProviders-Electronic` AS `dataProvidersElectronic`, n.`dataProvidersElectronic` AS `dataProvidersElectronic2`, n.`dataProvidersManual` AS `dataProvidersManual`, n.`dataProviders-Manual` AS `dataProvidersManual2`

MATCH (n:Organization)-[r:OVERSEES]->(i:SurveillanceSystem) RETURN n.name, i.name

MATCH (n:Organization)-[r:MANAGES]->(i:SurveillanceSystem) RETURN n.name, i.name

MATCH (n:Organization)-->(i:SurveillanceSystem) RETURN n, i

