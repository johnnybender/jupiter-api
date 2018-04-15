## Project description and background:

This is an updated version of the catalog of CDC "Organizations", "Programs", "Surveillance Systems", "Registries", and "Tools" from the CDC Integrated Surveillance Portal (Apollo / Jupiter) project of the Public Health Informatics Research Lab. The original project / website is located here: [Jupiter project site](http://jupiter.phiresearchlab.org/), and the original GitHub repository is located here: [Jupiter project GitHub](https://github.com/informaticslab/jupiter).

To give some background, this was an effort by CDC to catalog all programs, surveillance systems, registries, tools, data assets, etc. in order to understand various things, like the sources for data in surveillance systems, how collected data are being used, and to answer specific questions like, "what is the impact of the ICD-9 to ICD-10 upgrade on our programs?". Around 2014, a committee at CDC conducted several interviews and surveys, and had everyone at CDC document their "Programs", "Surveillance Systems", "Registries", and "Tools". The committe produced the final findings in PDF form. A year or so later, Thomas G. Savel, MD and team from the CDC Public Health Informatics Research Lab created a neo4j database instance to house these data and use as a system for ongoing documentation of CDC assets. Dr. Savel personally documented all the PDF findings from the CDC committee in the neo4j database.

I upgraded the neo4j database from a 2.x version, which required me to download historic versions of neo4j and update incrementally. I updated to version 3.3.4. The (upgraded) original database from the CDC Jupiter project is located in the "originalDatabase" folder. I modified the original database for a project in Spring 2018 by importing metadata from the [HHS Enterprise Data Inventory](https://catalog.data.gov/dataset/hhs-enterprise-data-inventory), and measures from the [National Quality Forum Quality Positioning System](https://www.qualityforum.org/QPS/).

Note that several parts of this project were made for demonstration / pilot purposes. Limitations include: (1) some nodes / relationships are more populated than others; (2) the neo4j database does not have a defined schema, which makes it challenging to query, (3) the modified version of the database includes the original node parameters from the Jupiter database, the HHS Enterprise Data Inventory, and the National Quality Forum Quality Positioning System - they don't match. I have documented some basic schema in the "parameters.cyp" file contained in the "cypher" folder, but these are not comprehensive (was not my focus for the project during Spring 2018).

Special thanks to Thomas G. Savel, MD, Director of the Informatics Innovation Unit at the Office of Public Health Scientific Services at CDC for providing background on this project. For more information, feel free to reach out at johnphillipbender@gmail.com.

## There are several ways to use this project: 

(1) *To use neo4j 3.3.4 with the modified database:* Fork / download this repository, rename the root directory to `NEO4J_Home`, and use `bin/neo4j start` to start neo4j 3.3.4 with the modified repository (note: the login credentials are currently set to `-u neo4j -p admin`, and you use `bin/neo4j stop` to stop neo4j 3.3.4).

(2) *To use neo4j 3.3.4 with the original database:* Fork / download this repository, rename the root directory to `NEO4J_HOME`, and replace the "data" folder in the root directory with the "data" folder in the "originalDatabase" folder, then use `bin/neo4j start` to start neo4j 3.3.4 with the modified repository (note: the login credentials are currently set to `-u neo4j -p admin`, and you use `bin/neo4j stop` to stop neo4j 3.3.4).

(3) *To use the modified database with a different version of neo4j:* Depending on what version of neo4j you have, you may need to incrementally download historic versions of neo4j to update the database to the current version. You will need to enable database updates in the "config" file of neo4j. In whatever version of neo4j you have, copy the "data" folder from the root directory to replace the "data" folder in your instance of neo4j. You can also modify the neo4j "config" file to specify the directory of your database.

(3) *To use the original database with a different version of neo4j:* Depending on what version of neo4j you have, you may need to incrementally download historic versions of neo4j to update the database to the current version. You will need to enable database updates in the "config" file of neo4j. In whatever version of neo4j you have, copy the "data" folder from the "originalDatabase" directory to replace the "data" folder in your instance of neo4j. You can also modify the neo4j "config" file to specify the directory of your database.

## Standard instructions for Neo4j below:

Neo4j 3.3.4
=======================================

Welcome to Neo4j release 3.3.4, a high-performance graph database.
This is the community distribution of Neo4j, including everything you need to
start building applications that can model, persist and explore graph-like data.

In the box
----------

Neo4j runs as a server application, exposing a Web-based management
interface and RESTful endpoints for data access.

Here in the installation directory, you'll find:

* bin - scripts and other executables
* conf - server configuration
* data - databases
* lib - libraries
* plugins - user extensions
* logs - log files
* import - location of files for LOAD CSV

Make it go
----------

For full instructions, see https://neo4j.com/docs/operations-manual/current/installation/

To get started with Neo4j, let's start the server and take a
look at the web interface ...

1. Open a console and navigate to the install directory.
2. Start the server:
   * Windows, use: bin\Neo4j.bat
   * Linux/Mac, use: ./bin/neo4j console
3. In a browser, open http://localhost:7474/
4. From any REST client or browser, open http://localhost:7474/db/data
   in order to get a REST starting point, e.g.
   curl -v http://localhost:7474/db/data
5. Shutdown the server by typing Ctrl-C in the console.

Learn more
----------

* Neo4j Home: https://neo4j.com/
* Getting Started: https://neo4j.com/docs/developer-manual/current/introduction/
* Neo4j Documentation: https://neo4j.com/docs/

License(s)
----------
Various licenses apply. Please refer to the LICENSE and NOTICE files for more
detailed information.

## Commands for reference
bin/neo4j start
bin/neo4j stop
bin/cypher-shell -u neo4j -p admin