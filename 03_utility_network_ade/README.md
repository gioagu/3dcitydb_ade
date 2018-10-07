3D City Database extension for the CityGML Utility Network ADE
================

The 3D City Database extension for the CityGML Utility Network ADE is a free extension to the free and open-source [3D City Database](http://www.3dcitydb.org). It is meant to store, represent, and manage all Utility-Network-ADE-related entities and attributes, building upon the 3D City Database.

The schema of the 3D City Database extension has been derived from the [Utility Network ADE for CityGML](https://github.com/TatjanaKutzner/CityGML-UtilityNetwork-ADE) and has been realised as PostgreSQL/PostGIS database schema which comes as a collection of SQL scripts.

The 3D City Database Extension for the Utility Network ADE is developed by [AIT](https://www.ait.ac.at/en/) - Austrian Institute of Technology, [Center for Energy](https://www.ait.ac.at/en/about-the-ait/center/center-for-energy), [Smart Cities and Regions Research Field](https://www.ait.ac.at/en/research-fields/smart-cities-and-regions).

License
-------
3D City Database extension for the Utility Network ADE is licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0). See the `LICENSE.txt` file for more details.

Latest release
--------------
The current release of the 3DCityDB extension implements the [Utility Network ADE v.0.9.4](https://github.com/TatjanaKutzner/CityGML-UtilityNetwork-ADE) and the current release of the software is Beta.
Download the SQL scripts for PostgreSQL/PostGIS [here](https://github.com/gioagu/3dcitydb_ade/tree/master/03_utility_network_ade/postgresql).

System requirements
-------------------
* PostgreSQL DBMS >= 9.1 
* PostGIS extension >= 2.0
* 3DCityDB = 3.3.1

**Please note:** the latest version of the **3DCityDB 4.0 is NOT supported** (yet). If you want to use the software contained in this repository, please check that you are using version 3.3.1!

Documentation
-------------
Documentation for the 3D City Database Extension for the Utility Network ADE is planned but currently not available. Nevertheless, the design and implementation principles are the same as for the Energy ADE. Therefore the user is highly invited to read the documentation for the 3D City Database Extension for the Energy ADE which can be downloaded [here](https://github.com/gioagu/3dcitydb_ade/tree/master/02_energy_ade/manual) and contains also detailed information about installation of an ADE. Finally, several diagrams (OO-to-ER-model mapping, ER-diagrams) are available [here](https://github.com/gioagu/3dcitydb_ade/tree/master/03_utility_network_ade/diagrams).

In addition, the user is encouraged to keep a copy of the 3DCityDB at hand. It can be accessed on-line [here](https://github.com/3dcitydb/3dcitydb/tree/master/Documentation). Finally, a very useful hands-on tutorial for beginners, where the most important steps to set up the 3DCtyDB and use the Importer/Exporter are described, can be retrieved [here](https://github.com/3dcitydb/tutorials).

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
The authors would like to thank Tatjana Kutzner (TU München) for her suggestions and fruitful discussions.

More information
----------------
[OGC CityGML](http://www.opengeospatial.org/standards/citygml) is an open data model and XML-based format for the storage and exchange of semantic 3D city models. It is an application schema for the [Geography Markup Language version 3.1.1 (GML3)](http://www.opengeospatial.org/standards/gml), the extendible international standard for spatial data exchange issued by the Open Geospatial Consortium (OGC) and the ISO TC211. The aim of the development of CityGML is to reach a common definition of the basic entities, attributes, and relations of a 3D city model.

CityGML is an international OGC standard and can be used free of charge.
