3D City Database extension for the CityGML Scenario ADE
================

The 3D City Database extension for the CityGML Scenario ADE is a free extension to the free and open-source [3D City Database](http://www.3dcitydb.org). It is meant to store, represent, and manage all Scenario-ADE-related entities and attributes, building upon the 3D City Database.

The schema of the 3D City Database extension has been derived from the Scenario ADE for CityGML and has been realised as PostgreSQL/PostGIS database schema which comes as a collection of SQL scripts.

The 3D City Database Extension for the Scenario ADE is being developed by [AIT](https://www.ait.ac.at/en/) - Austrian Institute of Technology, [Center for Energy](https://www.ait.ac.at/en/about-the-ait/center/center-for-energy), [Smart Cities and Regions Research Field](https://www.ait.ac.at/en/research-fields/smart-cities-and-regions).

License
-------
3D City Database extension for the Scenario ADE is licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0). See the `LICENSE.txt` file for more details.

Latest release
--------------
The current release of the 3DCityDB extension implements the Scenario ADE v.0.2. 
Download the SQL scripts for PostgreSQL/PostGIS [here](https://github.com/gioagu/3dcitydb_ade/tree/master/04_scenario_ade/postgresql).

System requirements
-------------------
* PostgreSQL DBMS >= 9.1 (recommended 9.3 or higher)
* PostGIS extension >= 2.0
* 3DCityDB >= 3.3.2

Documentation
-------------
A documentation of the 3D City Database Extension for the Scenario ADE is available with the software and can be downloaded [here](https://github.com/gioagu/3dcitydb_ade/tree/master/04_scenario_ade/manual).

However, the user is encouraged to keep a copy of the 3DCityDB at hand. The 3DCityDB documentation can be accessed on-line [here](https://github.com/3dcitydb/3dcitydb/tree/master/Documentation).
Finally, a very useful hands-on tutorial for beginners, where the most important steps to set up the 3DCtyDB and use the Importer/Exporter are described, can be retrieved [here](https://github.com/3dcitydb/tutorials).

Contributing
------------
* To file bugs found in the software create a GitHub issue,
* To contribute code for fixing filed issues create a pull request with the issue id,
* To propose a new feature create a GitHub issue and open a discussion.

Active Developers
--------------------
* [Giorgio Agugiaro](mailto:g.agugiaro@tudelft.nl)

Acknowledgements  
-----------------------------------
the author would like to thank Edmund Widl (AIT), Pablo Puerto (CREM), Maximilian Sindram and Claus Nagel (virtualcitySYSTEMS), Thomas Kolbe (TU München) and Joachim Benner (KIT) for the suggestions and the fruitful discussions leading to the conception and implementation of this ADE.

More information
----------------
[OGC CityGML](http://www.opengeospatial.org/standards/citygml) is an open data model and XML-based format for the storage and exchange of semantic 3D city models. It is an application schema for the [Geography Markup Language version 3.1.1 (GML3)](http://www.opengeospatial.org/standards/gml), the extendible international standard for spatial data exchange issued by the Open Geospatial Consortium (OGC) and the ISO TC211. The aim of the development of CityGML is to reach a common definition of the basic entities, attributes, and relations of a 3D city model.

CityGML is an international OGC standard and can be used free of charge.
