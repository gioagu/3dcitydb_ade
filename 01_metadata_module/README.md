3D City Database Metadata Module
================

The 3D City Database Metadata Module a free extension to the free and open-source [3D City Database](http://www.3dcitydb.org). It is meant to extend and enhance the 3DCityDB in order to seamlessly handle Application Domain Extensions (ADEs) by means of providing a mechanism to "register" ADEs and deal with their corresponding database schemas (tables, stored procedures, etc.).

The conceptual schema is the result of cooperation work among the TU München, virtualcitySYSTEMS and AIT. The database schema of the Metadata Module has been implemented as PostgreSQL/PostGIS database schema which comes as a collection of SQL scripts by [AIT](https://www.ait.ac.at/en/) - Austrian Institute of Technology, [Center for Energy](https://www.ait.ac.at/en/about-the-ait/center/center-for-energy), [Smart Cities and Regions Research Field](https://www.ait.ac.at/en/research-fields/smart-cities-and-regions).

Originally developed within the [Energy ADE](https://github.com/gioagu/3dcitydb_ade/tree/master/02_energy_ade) for the 3DCityDB, the Metadata Module is now provided as a separate package which can be installed and used also for other ADEs (e.g. the [Utility Network ADE](https://github.com/gioagu/3dcitydb_ade/tree/master/03_utility_network_ade)) 

License
-------
3D City Database Metadata module is licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0). See the `LICENSE.txt` file for more details.

System requirements
-------------------
* PostgreSQL DBMS >= 9.1 
* PostGIS extension >= 2.0
* 3DCityDB = 3.3.1

**Please note:** the latest version of the **3DCityDB 4.0 is NOT supported** (yet). If you want to use the software contained in this repository, please check that you are using version 3.3.1!

Documentation
-------------
Documentation is included in the 3D City Database Extension for the Energy ADE and can be downloaded [here](https://github.com/gioagu/3dcitydb_ade/tree/master/02_energy_ade/manual).

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
The authors would like to thank Thomas Kolbe and Zhihang Yao (TU München), Claus Nagel (virtualcitySYSTEMS) for their suggestions and fruitful discussions.

More information
----------------
[OGC CityGML](http://www.opengeospatial.org/standards/citygml) is an open data model and XML-based format for the storage and exchange of semantic 3D city models. It is an application schema for the [Geography Markup Language version 3.1.1 (GML3)](http://www.opengeospatial.org/standards/gml), the extendible international standard for spatial data exchange issued by the Open Geospatial Consortium (OGC) and the ISO TC211. The aim of the development of CityGML is to reach a common definition of the basic entities, attributes, and relations of a 3D city model.

CityGML is an international OGC standard and can be used free of charge.
