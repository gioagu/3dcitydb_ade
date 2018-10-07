3D City Database Utilities Package
================

The 3D City Database Utilities Package for PostgreSQL is a set of stored procedures, views and updatable views for the free and open-source [3D City Database](http://www.3dcitydb.org). The 3D City Database Utilities are meant to provide additional functionalities and help data management of data stored in the 3D City Database. Originally developed within the Energy ADE for the 3DCityDB, they are now provided as a separate package which can be installed and used independently.

The 3D City Database Utilities Package is developed by [AIT](https://www.ait.ac.at/en/) - Austrian Institute of Technology, [Center for Energy](https://www.ait.ac.at/en/about-the-ait/center/center-for-energy), [Smart Cities and Regions Research Field](https://www.ait.ac.at/en/research-fields/smart-cities-and-regions).

License
-------
The 3D City Database Utilities are licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0). See the `LICENSE.txt` file for more details.

System requirements
-------------------
* PostgreSQL DBMS >= 9.1 
* PostGIS extension >= 2.0
* 3DCityDB = 3.3.1

**Please note:** the latest version of the **3DCityDB 4.0 is NOT supported** (yet). If you want to use the software contained in this repository, please check that you are using version 3.3.1!

Documentation
-------------
Documentation of the 3DCityDB Utilities Package is available [here](https://github.com/gioagu/3dcitydb_ade/tree/master/00_utilities_package/manual/).

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

More information
----------------
[OGC CityGML](http://www.opengeospatial.org/standards/citygml) is an open data model and XML-based format for the storage and exchange of semantic 3D city models. It is an application schema for the [Geography Markup Language version 3.1.1 (GML3)](http://www.opengeospatial.org/standards/gml), the extendible international standard for spatial data exchange issued by the Open Geospatial Consortium (OGC) and the ISO TC211. The aim of the development of CityGML is to reach a common definition of the basic entities, attributes, and relations of a 3D city model.

CityGML is an international OGC standard and can be used free of charge.
