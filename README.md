3D City Database "plus"
================

This Git repository contains a number of additional utilities, extensions, etc. to the free and open-source [3D City Database](http://www.3dcitydb.org). They are meant to extend and enhance the 3DCityDB.



Originally developed within the [Energy ADE](https://github.com/gioagu/3dcitydb_ade/tree/master/02_energy_ade) for the 3DCityDB, the software is now provided as a set of modular packages. Currently, it consists of the *Utilities Package*, the *Metadata module*, the *Energy ADE* and the *Utility Network ADE* for PostgreSQL / PostGIS. 

License
-------
All software is licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0). See the `LICENSE.txt` file for more details.

System requirements
-------------------
* PostgreSQL DBMS >= 9.1 
* PostGIS extension >= 2.0
* 3DCityDB = 3.3.0

Documentation
-------------
Please refer to the README.md file contained in each subfolder. Information is given about the specification of each package / ADE as well about available information, documentation, installation procedures, etc.
In general, the most updated and comprehensive documentation is included in the 3D City Database Extension for the Energy ADE and can be downloaded [here](https://github.com/gioagu/3dcitydb_ade/tree/master/02_energy_ade/manual).

However, the user is encouraged to keep a copy of the 3DCityDB at hand. The 3DCityDB documentation can be accessed on-line [here](https://github.com/3dcitydb/3dcitydb/tree/master/Documentation).
Finally, a very useful hands-on tutorial for beginners, where the most important steps to set up the 3DCtyDB and use the Importer/Exporter are described, can be retrieved [here](https://github.com/3dcitydb/tutorials).

Contributing
------------
* To file bugs found in the software create a GitHub issue,
* To contribute code for fixing filed issues create a pull request with the issue id,
* To propose a new feature create a GitHub issue and open a discussion.

Active Developers
--------------------
* [Giorgio Agugiaro](mailto:giorgio.agugiaro@ait.ac.at)

Acknowledgements  
-----------------------------------
Please refer to the README.md files of each subfolder for details.

More information
----------------
[OGC CityGML](http://www.opengeospatial.org/standards/citygml) is an open data model and XML-based format for the storage and exchange of semantic 3D city models. It is an application schema for the [Geography Markup Language version 3.1.1 (GML3)](http://www.opengeospatial.org/standards/gml), the extendible international standard for spatial data exchange issued by the Open Geospatial Consortium (OGC) and the ISO TC211. The aim of the development of CityGML is to reach a common definition of the basic entities, attributes, and relations of a 3D city model.

CityGML is an international OGC standard and can be used free of charge.