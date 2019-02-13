-- 3D City Database "Metadata Module" for ADEs v. 0.1
--
--                     August 2017
--
-- 3D City Database: http://www.3dcitydb.org
--
-- 
--                        Copyright 2017
-- Austrian Institute of Technology G.m.b.H., Austria
-- Center for Energy - Smart Cities and Regions Research Field
-- http://www.ait.ac.at/en/research-fields/smart-cities-and-regions/
-- 
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
-- 
--     http://www.apache.org/licenses/LICENSE-2.0
--     
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- ***********************************************************************
-- **************** 03_metadata_module_TABLE_DATA.sql ********************
--
-- This script populates and updates some tables needed to set up the
-- metadata module in the 3DCityDB.
--
-- ***********************************************************************
-- ***********************************************************************

----------------------------------------------------------------
-- Table ADE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.ade CASCADE;
CREATE TABLE citydb.ade (
id serial PRIMARY KEY,
name varchar(1000),
description varchar(4000),
version varchar(50),
db_prefix varchar(10) UNIQUE NOT NULL,
xml_schemamapping_file text,
drop_db_script text,
creation_date timestamp(0) with time zone DEFAULT now(),
creation_person varchar(256) DEFAULT user
);
--ALTER TABLE citydb.ade OWNER TO postgres;

----------------------------------------------------------------
-- Table SCHEMA
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.schema CASCADE;
CREATE TABLE citydb.schema (
id serial PRIMARY KEY,
ade_id integer,
is_ade_root numeric(1,0),
citygml_version varchar(50),
xml_namespace_uri character varying(4000),
xml_namespace_prefix character varying(50),
xml_schema_location character varying(4000),
xml_schemafile bytea,
xml_schemafile_type character varying(256)
);
--ALTER TABLE citydb.schema OWNER TO postgres;

CREATE INDEX schema_ade_id_fkx ON citydb.schema USING btree (ade_id);
CREATE INDEX schema_is_ade_root_inx ON citydb.schema USING btree (is_ade_root);

ALTER TABLE IF EXISTS citydb.schema ADD CONSTRAINT schema_ade_fk FOREIGN KEY (ade_id) REFERENCES citydb.ade (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

----------------------------------------------------------------
-- Table SCHEMA_REFERENCING
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.schema_referencing;
CREATE TABLE citydb.schema_referencing (
referencing_id integer NOT NULL,
referenced_id integer NOT NULL,
CONSTRAINT schema_referencing_pky PRIMARY KEY (referenced_id,referencing_id)
);
--ALTER TABLE citydb.schema OWNER TO postgres;

CREATE INDEX schema_ref_local_id_inx ON citydb.schema_referencing USING btree (referenced_id) WITH (FILLFACTOR = 90);
CREATE INDEX schema_ref_ref_id_inx ON citydb.schema_referencing USING btree (referencing_id) WITH (FILLFACTOR = 90);

ALTER TABLE IF EXISTS citydb.schema_referencing ADD CONSTRAINT schema_ref_schema_fk1 FOREIGN KEY (referenced_id) REFERENCES citydb.schema (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS citydb.schema_referencing ADD CONSTRAINT schema_ref_schema_fk2 FOREIGN KEY (referencing_id) REFERENCES citydb.schema (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

----------------------------------------------------------------
-- Table SCHEMA_TO_OBJECTCLASS
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.schema_to_objectclass;
CREATE TABLE citydb.schema_to_objectclass (
schema_id integer NOT NULL,
objectclass_id integer NOT NULL,
CONSTRAINT schema_to_objectclass_pk PRIMARY KEY (schema_id,objectclass_id)
);
--ALTER TABLE citydb.schema OWNER TO postgres;

CREATE INDEX sch_to_objc_sch_id_inx ON citydb.schema_to_objectclass USING btree (schema_id) WITH (FILLFACTOR = 90);
CREATE INDEX sch_to_objc_objc_id_inx ON citydb.schema_to_objectclass USING btree (objectclass_id) WITH (FILLFACTOR = 90);

ALTER TABLE IF EXISTS citydb.schema_to_objectclass ADD CONSTRAINT sch_to_objclass_sch_fk FOREIGN KEY (schema_id) REFERENCES citydb.schema (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS citydb.schema_to_objectclass ADD CONSTRAINT sch_to_objclass_objc_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


----------------------------------------------------------------
-- ALTER Table OBJECTCLASS
----------------------------------------------------------------
ALTER TABLE citydb.objectclass
	DROP COLUMN IF EXISTS tablename,
	DROP COLUMN IF EXISTS is_ade_class,
	DROP COLUMN IF EXISTS baseclass_id;

ALTER TABLE citydb.objectclass
	ADD COLUMN tablename varchar(30),      --- This is to guarantee compatibility with Oracle.
	ADD COLUMN is_ade_class numeric(1,0),
	ADD COLUMN baseclass_id integer;

CREATE INDEX objectclass_is_ade_class_inx ON citydb.objectclass USING btree (is_ade_class);
CREATE INDEX objectclass_baseclass_id_fkx ON citydb.objectclass USING btree (baseclass_id);

ALTER TABLE citydb.objectclass ADD CONSTRAINT objectclass_baseclass_id_fk FOREIGN KEY (baseclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

----------------------------------------------------------------
-- UPDATE table OBJECTCLASS and enter new values for "vanilla" entries
----------------------------------------------------------------
WITH s AS (
SELECT * FROM (VALUES 
(  0,0,'Undefined',NULL,NULL,NULL),
(  1,0,'_GML','cityobject',NULL,NULL),
(  2,0,'_Feature','cityobject',1,1),
(  3,0,'_CityObject','cityobject',2,2),
(  4,0,'LandUse','land_use',3,3),
(  5,0,'GenericCityObject','generic_cityobject',3,3),
(  6,0,'_VegetationObject','cityobject',3,3),
(  7,0,'SolitaryVegetationObject','solitary_vegetat_object',6,3),
(  8,0,'PlantCover','plant_cover',6,3),
(  9,0,'WaterBody','waterbody',105,3),
( 10,0,'_WaterBoundarySurface','waterboundary_surface',3,3),
( 11,0,'WaterSurface','waterboundary_surface',10,3),
( 12,0,'WaterGroundSurface','waterboundary_surface',10,3),
( 13,0,'WaterClosureSurface','waterboundary_surface',10,3),
( 14,0,'ReliefFeature','relief_feature',3,3),
( 15,0,'_ReliefComponent','relief_component',3,3),
( 16,0,'TINRelief','tin_relief',15,3),
( 17,0,'MassPointRelief','masspoint_relief',15,3),
( 18,0,'BreaklineRelief','breakline_relief',15,3),
( 19,0,'RasterRelief','raster_relief',15,3),
( 20,0,'_Site','cityobject',3,3),
( 21,0,'CityFurniture','city_furniture',3,3),
( 22,0,'_TransportationObject','cityobject',3,3),
( 23,0,'CityObjectGroup','cityobjectgroup',3,3),
( 24,0,'_AbstractBuilding','building',20,3),
( 25,0,'BuildingPart','building',24,3),
( 26,0,'Building','building',24,3),
( 27,0,'BuildingInstallation','building_installation',3,3),
( 28,0,'IntBuildingInstallation','building_installation',3,3),
( 29,0,'_BuildingBoundarySurface','thematic_surface',3,3),
( 30,0,'BuildingCeilingSurface','thematic_surface',29,3),
( 31,0,'InteriorBuildingWallSurface','thematic_surface',29,3),
( 32,0,'BuildingFloorSurface','thematic_surface',29,3),
( 33,0,'BuildingRoofSurface','thematic_surface',29,3),
( 34,0,'BuildingWallSurface','thematic_surface',29,3),
( 35,0,'BuildingGroundSurface','thematic_surface',29,3),
( 36,0,'BuildingClosureSurface','thematic_surface',29,3),
( 37,0,'_BuildingOpening','opening',3,3),
( 38,0,'BuildingWindow','opening',37,3),
( 39,0,'BuildingDoor','opening',37,3),
( 40,0,'BuildingFurniture','building_furniture',3,3),
( 41,0,'BuildingRoom','room',3,3),
( 42,0,'TransportationComplex','transportation_complex',22,3),
( 43,0,'Track','transportation_complex',42,3),
( 44,0,'Railway','transportation_complex',42,3),
( 45,0,'Road','transportation_complex',42,3),
( 46,0,'Square','transportation_complex',42,3),
( 47,0,'TrafficArea','traffic_area',22,3),
( 48,0,'AuxiliaryTrafficArea','traffic_area',22,3),
( 49,0,'FeatureCollection','cityobject',2,2),
( 50,0,'Appearance','appearance',2,2),
( 51,0,'_SurfaceData','surface_data',2,2),
( 52,0,'_Texture','surface_data',51,2),
( 53,0,'X3DMaterial','surface_data',51,2),
( 54,0,'ParameterizedTexture','surface_data',52,2),
( 55,0,'GeoreferencedTexture','surface_data',52,2),
( 56,0,'_TextureParametrization','textureparam',1,1),
( 57,0,'CityModel','citymodel',49,2),
( 58,0,'Address','address',2,2),
( 59,0,'ImplicitGeometry','implicit_geometry',1,1),
( 60,0,'OuterBuildingCeilingSurface','thematic_surface',29,3),
( 61,0,'OuterBuildingFloorSurface','thematic_surface',29,3),
( 62,0,'_AbstractBridge','bridge',20,3),
( 63,0,'BridgePart','bridge',62,3),
( 64,0,'Bridge','bridge',62,3),
( 65,0,'BridgeInstallation','bridge_installation',3,3),
( 66,0,'IntBridgeInstallation','bridge_installation',3,3),
( 67,0,'_BridgeBoundarySurface','bridge_thematic_surface',3,3),
( 68,0,'BridgeCeilingSurface','bridge_thematic_surface',67,3),
( 69,0,'InteriorBridgeWallSurface','bridge_thematic_surface',67,3),
( 70,0,'BridgeFloorSurface','bridge_thematic_surface',67,3),
( 71,0,'BridgeRoofSurface','bridge_thematic_surface',67,3),
( 72,0,'BridgeWallSurface','bridge_thematic_surface',67,3),
( 73,0,'BridgeGroundSurface','bridge_thematic_surface',67,3),
( 74,0,'BridgeClosureSurface','bridge_thematic_surface',67,3),
( 75,0,'OuterBridgeCeilingSurface','bridge_thematic_surface',67,3),
( 76,0,'OuterBridgeFloorSurface','bridge_thematic_surface',67,3),
( 77,0,'_BridgeOpening','bridge_opening',3,3),
( 78,0,'BridgeWindow','bridge_opening',77,3),
( 79,0,'BridgeDoor','bridge_opening',77,3),
( 80,0,'BridgeFurniture','bridge_furniture',3,3),
( 81,0,'BridgeRoom','bridge_room',3,3),
( 82,0,'BridgeConstructionElement','bridge_constr_element',3,3),
( 83,0,'_AbstractTunnel','tunnel',20,3),
( 84,0,'TunnelPart','tunnel',83,3),
( 85,0,'Tunnel','tunnel',83,3),
( 86,0,'TunnelInstallation','tunnel_installation',3,3),
( 87,0,'IntTunnelInstallation','tunnel_installation',3,3),
( 88,0,'_TunnelBoundarySurface','tunnel_thematic_surface',3,3),
( 89,0,'TunnelCeilingSurface','tunnel_thematic_surface',88,3),
( 90,0,'InteriorTunnelWallSurface','tunnel_thematic_surface',88,3),
( 91,0,'TunnelFloorSurface','tunnel_thematic_surface',88,3),
( 92,0,'TunnelRoofSurface','tunnel_thematic_surface',88,3),
( 93,0,'TunnelWallSurface','tunnel_thematic_surface',88,3),
( 94,0,'TunnelGroundSurface','tunnel_thematic_surface',88,3),
( 95,0,'TunnelClosureSurface','tunnel_thematic_surface',88,3),
( 96,0,'OuterTunnelCeilingSurface','tunnel_thematic_surface',88,3),
( 97,0,'OuterTunnelFloorSurface','tunnel_thematic_surface',88,3),
( 98,0,'_TunnelOpening','tunnel_opening',3,3),
( 99,0,'TunnelWindow','tunnel_opening',98,3),
(100,0,'TunnelDoor','tunnel_opening',98,3),
(101,0,'TunnelFurniture','tunnel_furniture',3,3),
(102,0,'HollowSpace','tunnel_hollow_space',3,3),
(103,0,'TexCoordList','textureparam',56,1),
(104,0,'TexCoordGen','textureparam',56,1),
(105,0,'_WaterObject','waterbody',3,3)
) AS foo(ID,IS_ADE_CLASS,CLASSNAME,TABLENAME,SUPERCLASS_ID,BASECLASS_ID) ORDER BY ID
)
UPDATE citydb.objectclass AS o SET tablename=s.tablename, is_ade_class=s.is_ade_class, baseclass_id=s.baseclass_id FROM s WHERE o.id=s.id;

TRUNCATE citydb.schema CASCADE;
INSERT INTO citydb.schema
(id, is_ade_root, citygml_version, xml_namespace_prefix, xml_namespace_uri, xml_schema_location)
VALUES
-- place holder for 1, which was eventually deleted.
( 2, 0,  NULL,'gml' , 'http://www.opengis.net/gml'                            ,'http://schemas.opengis.net/gml/3.1.1/base/gml.xsd'                         ),
( 3, 0,  NULL,'xAL' , 'urn:oasis:names:tc:ciq:xsdschema:xAL:2.0'              ,'http://docs.oasis-open.org/election/external/xAL.xsd'                      ),
( 4, 0,  NULL,'sch' , 'http://www.ascc.net/xml/schematron'                    , NULL                                                                       ),
( 5, 0, '1.0','core', 'http://schemas.opengis.net/citygml/1.0'                ,'http://schemas.opengis.net/citygml/1.0/cityGMLBase.xsd'                    ),
( 6, 0, '1.0','app' , 'http://schemas.opengis.net/citygml/appearance/1.0'     ,'http://schemas.opengis.net/citygml/appearance/1.0/appearance.xsd'          ),
( 7, 0, '1.0','bldg', 'http://schemas.opengis.net/citygml/building/1.0'       ,'http://schemas.opengis.net/citygml/building/1.0/building.xsd'              ),
( 8, 0, '1.0','frn' , 'http://schemas.opengis.net/citygml/cityfurniture/1.0'  ,'http://schemas.opengis.net/citygml/cityfurniture/1.0/cityFurniture.xsd'    ),
( 9, 0, '1.0','grp' , 'http://schemas.opengis.net/citygml/cityobjectgroup/1.0','http://schemas.opengis.net/citygml/cityobjectgroup/1.0/cityObjectGroup.xsd'),
(10, 0, '1.0','gen' , 'http://schemas.opengis.net/citygml/generics/1.0'       ,'http://schemas.opengis.net/citygml/generics/1.0/generics.xsd'              ),
(11, 0, '1.0','luse', 'http://schemas.opengis.net/citygml/landuse/1.0'        ,'http://schemas.opengis.net/citygml/landuse/1.0/landUse.xsd'                ),
(12, 0, '1.0','dem' , 'http://schemas.opengis.net/citygml/relief/1.0'         ,'http://schemas.opengis.net/citygml/relief/1.0/relief.xsd'                  ),
(13, 0, '1.0','tran', 'http://schemas.opengis.net/citygml/transportation/1.0' ,'http://schemas.opengis.net/citygml/transportation/1.0/transportation.xsd'  ),
(14, 0, '1.0','veg' , 'http://schemas.opengis.net/citygml/vegetation/1.0'     ,'http://schemas.opengis.net/citygml/vegetation/1.0/vegetation.xsd'          ),
(15, 0, '1.0','wtr' , 'http://schemas.opengis.net/citygml/waterbody/1.0'      ,'http://schemas.opengis.net/citygml/waterbody/1.0/waterBody.xsd'            ),
(16, 0, '1.0','tex' , 'http://schemas.opengis.net/citygml/texturedsurface/1.0','http://schemas.opengis.net/citygml/texturedsurface/1.0/texturedSurface.xsd'),
(17, 0, '2.0','core', 'http://schemas.opengis.net/citygml/2.0'                ,'http://schemas.opengis.net/citygml/2.0/cityGMLBase.xsd'                    ),
(18, 0, '2.0','app' , 'http://schemas.opengis.net/citygml/appearance/2.0'     ,'http://schemas.opengis.net/citygml/appearance/2.0/appearance.xsd'          ),
(19, 0, '2.0','brid', 'http://schemas.opengis.net/citygml/bridge/2.0'         ,'http://schemas.opengis.net/citygml/bridge/2.0/bridge.xsd'                  ),
(20, 0, '2.0','bldg', 'http://schemas.opengis.net/citygml/building/2.0'       ,'http://schemas.opengis.net/citygml/building/2.0/building.xsd'              ),
(21, 0, '2.0','frn' , 'http://schemas.opengis.net/citygml/cityfurniture/2.0'  ,'http://schemas.opengis.net/citygml/cityfurniture/2.0/cityFurniture.xsd'    ),
(22, 0, '2.0','grp' , 'http://schemas.opengis.net/citygml/cityobjectgroup/2.0','http://schemas.opengis.net/citygml/cityobjectgroup/2.0/cityObjectGroup.xsd'),
(23, 0, '2.0','gen' , 'http://schemas.opengis.net/citygml/generics/2.0'       ,'http://schemas.opengis.net/citygml/generics/2.0/generics.xsd'              ),
(24, 0, '2.0','luse', 'http://schemas.opengis.net/citygml/landuse/2.0'        ,'http://schemas.opengis.net/citygml/landuse/2.0/landUse.xsd'                ),
(25, 0, '2.0','dem' , 'http://schemas.opengis.net/citygml/relief/2.0'         ,'http://schemas.opengis.net/citygml/relief/2.0/relief.xsd'                  ),
(26, 0, '2.0','tran', 'http://schemas.opengis.net/citygml/transportation/2.0' ,'http://schemas.opengis.net/citygml/transportation/2.0/transportation.xsd'  ),
(27, 0, '2.0','tun' , 'http://schemas.opengis.net/citygml/tunnel/2.0'         ,'http://schemas.opengis.net/citygml/tunnel/2.0/tunnel.xsd'                  ),
(28, 0, '2.0','veg' , 'http://schemas.opengis.net/citygml/vegetation/2.0'     ,'http://schemas.opengis.net/citygml/vegetation/2.0/vegetation.xsd'          ),
(29, 0, '2.0','wtr' , 'http://schemas.opengis.net/citygml/waterbody/2.0'      ,'http://schemas.opengis.net/citygml/waterbody/2.0/waterBody.xsd'            ),
(30, 0, '2.0','tex' , 'http://schemas.opengis.net/citygml/texturedsurface/2.0','http://schemas.opengis.net/citygml/texturedsurface/1.0/texturedSurface.xsd')
;
WITH s AS (
SELECT max(id) AS newid FROM citydb.schema)
SELECT setval('citydb.schema_id_seq', s.newid, true) FROM s;



INSERT INTO citydb.schema_to_objectclass 
(schema_id,objectclass_id)
VALUES
--( 1,  0), -- Undefined -- "Undefined"
( 2,  1), -- Geography Markup Language -- "_GML"
( 2,  2), -- Geography Markup Language -- "_Feature"
( 2, 49), -- Geography Markup Language -- "FeatureCollection"
-- CityGML 1.0
( 5,  3), -- CityGML Core 1.0 -- "_CityObject"
(11,  4), -- LandUse 1.0 -- "LandUse"
(10,  5), -- Generics 1.0 -- "GenericCityObject"
(14,  6), -- Vegetation 1.0 -- "_VegetationObject"
(14,  7), -- Vegetation 1.0 -- "SolitaryVegetationObject"
(14,  8), -- Vegetation 1.0 -- "PlantCover"
(15,  9), -- WaterBody 1.0 -- "WaterBody"
(15, 10), -- WaterBody 1.0 -- "_WaterBoundarySurface"
(15, 11), -- WaterBody 1.0 -- "WaterSurface"
(15, 12), -- WaterBody 1.0 -- "WaterGroundSurface"
(15, 13), -- WaterBody 1.0 -- "WaterClosureSurface"
(12, 14), -- Relief 1.0 -- "ReliefFeature"
(12, 15), -- Relief 1.0 -- "_ReliefComponent"
(12, 16), -- Relief 1.0 -- "TINRelief"
(12, 17), -- Relief 1.0 -- "MassPointRelief"
(12, 18), -- Relief 1.0 -- "BreaklineRelief"
(12, 19), -- Relief 1.0 -- "RasterRelief"
( 5, 20), -- CityGML Core 1.0 -- "_Site"
( 8, 21), -- CityFurniture 1.0 -- "CityFurniture"
(13, 22), -- Transportation 1.0 -- "_TransportationObject"
( 9, 23), -- CityObjectGroup 1.0 -- "CityObjectGroup"
( 7, 24), -- Building 1.0 -- "_AbstractBuilding"
( 7, 25), -- Building 1.0 -- "BuildingPart"
( 7, 26), -- Building 1.0 -- "Building"
( 7, 27), -- Building 1.0 -- "BuildingInstallation"
( 7, 28), -- Building 1.0 -- "IntBuildingInstallation"
( 7, 29), -- Building 1.0 -- "_BuildingBoundarySurface"
( 7, 30), -- Building 1.0 -- "BuildingCeilingSurface"
( 7, 31), -- Building 1.0 -- "InteriorBuildingWallSurface"
( 7, 32), -- Building 1.0 -- "BuildingFloorSurface"
( 7, 33), -- Building 1.0 -- "BuildingRoofSurface"
( 7, 34), -- Building 1.0 -- "BuildingWallSurface"
( 7, 35), -- Building 1.0 -- "BuildingGroundSurface"
( 7, 36), -- Building 1.0 -- "BuildingClosureSurface"
( 7, 37), -- Building 1.0 -- "_BuildingOpening"
( 7, 38), -- Building 1.0 -- "BuildingWindow"
( 7, 39), -- Building 1.0 -- "BuildingDoor"
( 7, 40), -- Building 1.0 -- "BuildingFurniture"
( 7, 41), -- Building 1.0 -- "BuildingRoom"
(13, 42), -- Transportation 1.0 -- "TransportationComplex"
(13, 43), -- Transportation 1.0 -- "Track"
(13, 44), -- Transportation 1.0 -- "Railway"
(13, 45), -- Transportation 1.0 -- "Road"
(13, 46), -- Transportation 1.0 -- "Square"
(13, 47), -- Transportation 1.0 -- "TrafficArea"
(13, 48), -- Transportation 1.0 -- "AuxiliaryTrafficArea"
( 6, 50), -- Appearance 1.0 -- "Appearance"
( 6, 51), -- Appearance 1.0 -- "_SurfaceData"
( 6, 52), -- Appearance 1.0 -- "_Texture"
( 6, 53), -- Appearance 1.0 -- "X3DMaterial"
( 6, 54), -- Appearance 1.0 -- "ParameterizedTexture"
( 6, 55), -- Appearance 1.0 -- "GeoreferencedTexture"
( 6, 56), -- Appearance 1.0 -- "_TextureParametrization"
( 5, 57), -- CityGML Core 1.0 -- "CityModel"
( 5, 58), -- CityGML Core 1.0 -- "Address"
( 5, 59), -- CityGML Core 1.0 -- "ImplicitGeometry"
( 7, 60), -- Building 1.0 -- "OuterBuildingCeilingSurface"
( 7, 61), -- Building 1.0 -- "OuterBuildingFloorSurface"
( 6,103), -- Appearance 1.0 -- "TexCoordList"
( 6,104), -- Appearance 1.0 -- "TexCoordGen"
(15,105), -- WaterBody 1.0 -- "_WaterObject"
-- CityGML 2.0
(17,  3), -- CityGML Core 2.0 -- "_CityObject"
(24,  4), -- LandUse 2.0 -- "LandUse"
(23,  5), -- Generics 2.0 -- "GenericCityObject"
(28,  6), -- Vegetation 2.0 -- "_VegetationObject"
(28,  7), -- Vegetation 2.0 -- "SolitaryVegetationObject"
(28,  8), -- Vegetation 2.0 -- "PlantCover"
(29,  9), -- WaterBody 2.0 -- "WaterBody"
(29, 10), -- WaterBody 2.0 -- "_WaterBoundarySurface"
(29, 11), -- WaterBody 2.0 -- "WaterSurface"
(29, 12), -- WaterBody 2.0 -- "WaterGroundSurface"
(29, 13), -- WaterBody 2.0 -- "WaterClosureSurface"
(25, 14), -- Relief 2.0 -- "ReliefFeature"
(25, 15), -- Relief 2.0 -- "_ReliefComponent"
(25, 16), -- Relief 2.0 -- "TINRelief"
(25, 17), -- Relief 2.0 -- "MassPointRelief"
(25, 18), -- Relief 2.0 -- "BreaklineRelief"
(25, 19), -- Relief 2.0 -- "RasterRelief"
(17, 20), -- CityGML Core 2.0 -- "_Site"
(21, 21), -- CityFurniture 2.0 -- "CityFurniture"
(26, 22), -- Transportation 2.0 -- "_TransportationObject"
(22, 23), -- CityObjectGroup 2.0 -- "CityObjectGroup"
(20, 24), -- Building 2.0 -- "_AbstractBuilding"
(20, 25), -- Building 2.0 -- "BuildingPart"
(20, 26), -- Building 2.0 -- "Building"
(20, 27), -- Building 2.0 -- "BuildingInstallation"
(20, 28), -- Building 2.0 -- "IntBuildingInstallation"
(20, 29), -- Building 2.0 -- "_BuildingBoundarySurface"
(20, 30), -- Building 2.0 -- "BuildingCeilingSurface"
(20, 31), -- Building 2.0 -- "InteriorBuildingWallSurface"
(20, 32), -- Building 2.0 -- "BuildingFloorSurface"
(20, 33), -- Building 2.0 -- "BuildingRoofSurface"
(20, 34), -- Building 2.0 -- "BuildingWallSurface"
(20, 35), -- Building 2.0 -- "BuildingGroundSurface"
(20, 36), -- Building 2.0 -- "BuildingClosureSurface"
(20, 37), -- Building 2.0 -- "_BuildingOpening"
(20, 38), -- Building 2.0 -- "BuildingWindow"
(20, 39), -- Building 2.0 -- "BuildingDoor"
(20, 40), -- Building 2.0 -- "BuildingFurniture"
(20, 41), -- Building 2.0 -- "BuildingRoom"
(26, 42), -- Transportation 2.0 -- "TransportationComplex"
(26, 43), -- Transportation 2.0 -- "Track"
(26, 44), -- Transportation 2.0 -- "Railway"
(26, 45), -- Transportation 2.0 -- "Road"
(26, 46), -- Transportation 2.0 -- "Square"
(26, 47), -- Transportation 2.0 -- "TrafficArea"
(26, 48), -- Transportation 2.0 -- "AuxiliaryTrafficArea"
(18, 50), -- Appearance 2.0 -- "Appearance"
(18, 51), -- Appearance 2.0 -- "_SurfaceData"
(18, 52), -- Appearance 2.0 -- "_Texture"
(18, 53), -- Appearance 2.0 -- "X3DMaterial"
(18, 54), -- Appearance 2.0 -- "ParameterizedTexture"
(18, 55), -- Appearance 2.0 -- "GeoreferencedTexture"
(18, 56), -- Appearance 2.0 -- "_TextureParametrization"
(17, 57), -- CityGML Core 2.0 -- "CityModel"
(17, 58), -- CityGML Core 2.0 -- "Address"
(17, 59), -- CityGML Core 2.0 -- "ImplicitGeometry"
(20, 60), -- Building 2.0 -- "OuterBuildingCeilingSurface"
(20, 61), -- Building 2.0 -- "OuterBuildingFloorSurface"
(19, 62), -- Bridge 2.0 -- "_AbstractBridge"
(19, 63), -- Bridge 2.0 -- "BridgePart"
(19, 64), -- Bridge 2.0 -- "Bridge"
(19, 65), -- Bridge 2.0 -- "BridgeInstallation"
(19, 66), -- Bridge 2.0 -- "IntBridgeInstallation"
(19, 67), -- Bridge 2.0 -- "_BridgeBoundarySurface"
(19, 68), -- Bridge 2.0 -- "BridgeCeilingSurface"
(19, 69), -- Bridge 2.0 -- "InteriorBridgeWallSurface"
(19, 70), -- Bridge 2.0 -- "BridgeFloorSurface"
(19, 71), -- Bridge 2.0 -- "BridgeRoofSurface"
(19, 72), -- Bridge 2.0 -- "BridgeWallSurface"
(19, 73), -- Bridge 2.0 -- "BridgeGroundSurface"
(19, 74), -- Bridge 2.0 -- "BridgeClosureSurface"
(19, 75), -- Bridge 2.0 -- "OuterBridgeCeilingSurface"
(19, 76), -- Bridge 2.0 -- "OuterBridgeFloorSurface"
(19, 77), -- Bridge 2.0 -- "_BridgeOpening"
(19, 78), -- Bridge 2.0 -- "BridgeWindow"
(19, 79), -- Bridge 2.0 -- "BridgeDoor"
(19, 80), -- Bridge 2.0 -- "BridgeFurniture"
(19, 81), -- Bridge 2.0 -- "BridgeRoom"
(19, 82), -- Bridge 2.0 -- "BridgeConstructionElement"
(27, 83), -- Tunnel 2.0 -- "_AbstractTunnel"
(27, 84), -- Tunnel 2.0 -- "TunnelPart"
(27, 85), -- Tunnel 2.0 -- "Tunnel"
(27, 86), -- Tunnel 2.0 -- "TunnelInstallation"
(27, 87), -- Tunnel 2.0 -- "IntTunnelInstallation"
(27, 88), -- Tunnel 2.0 -- "_TunnelBoundarySurface"
(27, 89), -- Tunnel 2.0 -- "TunnelCeilingSurface"
(27, 90), -- Tunnel 2.0 -- "InteriorTunnelWallSurface"
(27, 91), -- Tunnel 2.0 -- "TunnelFloorSurface"
(27, 92), -- Tunnel 2.0 -- "TunnelRoofSurface"
(27, 93), -- Tunnel 2.0 -- "TunnelWallSurface"
(27, 94), -- Tunnel 2.0 -- "TunnelGroundSurface"
(27, 95), -- Tunnel 2.0 -- "TunnelClosureSurface"
(27, 96), -- Tunnel 2.0 -- "OuterTunnelCeilingSurface"
(27, 97), -- Tunnel 2.0 -- "OuterTunnelFloorSurface"
(27, 98), -- Tunnel 2.0 -- "_TunnelOpening"
(27, 99), -- Tunnel 2.0 -- "TunnelWindow"
(27,100), -- Tunnel 2.0 -- "TunnelDoor"
(27,101), -- Tunnel 2.0 -- "TunnelFurniture"
(27,102), -- Tunnel 2.0 -- "HollowSpace"
(18,103), -- Appearance 2.0 -- "TexCoordList"
(18,104), -- Appearance 2.0 -- "TexCoordGen"
(29,105); -- WaterBody 2.0 -- "_WaterObject"

INSERT INTO citydb.schema_referencing
(referenced_id, referencing_id)
VALUES
( 2, 5), -- GML -- CityGML Core 2.0
( 3, 5), -- xAL -- CityGML Core 2.0
( 4, 5), -- Schematron -- CityGML Core 2.0
-- CityGML 1.0
( 5, 6), -- CityGML Core 1.0 -- Appearance 1.0
( 5, 7), -- CityGML Core 1.0 -- Building 1.0
( 5, 8), -- CityGML Core 1.0 -- CityFurniture 1.0
( 5, 9), -- CityGML Core 1.0 -- CityObjectGroup 1.0
( 5,10), -- CityGML Core 1.0 -- Generics 1.0
( 5,11), -- CityGML Core 1.0 -- LandUse 1.0
( 5,12), -- CityGML Core 1.0 -- Relief 1.0
( 5,13), -- CityGML Core 1.0 -- Transportation 1.0
( 5,14), -- CityGML Core 1.0 -- Vegetation 1.0
( 5,15), -- CityGML Core 1.0 -- WaterBody 1.0
( 5,16), -- CityGML Core 1.0 -- Textured Surface 1.0
-- CityGML 2.0
( 2,17), -- GML -- CityGML Core 2.0
( 3,17), -- xAL -- CityGML Core 2.0
( 4,17), -- Schematron -- CityGML Core 2.0
(17,18), -- CityGML Core 2.0 -- Appearance 2.0
(17,19), -- CityGML Core 2.0 -- Bridge 2.0
(17,20), -- CityGML Core 2.0 -- Building 2.0
(17,21), -- CityGML Core 2.0 -- CityFurniture 2.0
(17,22), -- CityGML Core 2.0 -- CityObjectGroup 2.0
(17,23), -- CityGML Core 2.0 -- Generics 2.0
(17,24), -- CityGML Core 2.0 -- LandUse 2.0
(17,25), -- CityGML Core 2.0 -- Relief 2.0
(17,26), -- CityGML Core 2.0 -- Transportation 2.0
(17,27), -- CityGML Core 2.0 -- Tunnel 2.0
(17,28), -- CityGML Core 2.0 -- Vegetation 2.0
(17,29), -- CityGML Core 2.0 -- WaterBody 2.0
(17,30); -- CityGML Core 2.0 -- Textured Surface 2.0


----------------------------------------------------------------
-- Function citydb_pkg.GET_OBJECTCLASS_INFO
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.get_objectclass_info(integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.get_objectclass_info(
	class_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar)
RETURNS TABLE (
	db_prefix varchar,
	classname varchar,
	is_ade_class numeric(1,0)
)
AS $$
DECLARE
BEGIN
IF class_id IS NOT NULL THEN
	-- get more info about the objectclass
	EXECUTE format('SELECT a.db_prefix, o.classname, o.is_ade_class
		FROM %I.ade a, %I.schema_to_objectclass so, %I.objectclass o, %I.schema s
		WHERE 
		  so.schema_id = s.id AND
		  o.id = so.objectclass_id AND
		  s.ade_id = a.id AND
		  o.id= %L
		LIMIT 1',	
		schema_name, schema_name, schema_name, schema_name, class_id) INTO db_prefix, classname, is_ade_class;
	--RAISE NOTICE '% % %', db_prefix, classname, is_ade_class;
	RETURN NEXT;
ELSE
	RAISE NOTICE 'citydb_pkg.get_classname: Class_id is NULL';
	-- RETURN NEXT -- outputs an empty row i.e. (,,)
END IF;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.get_objectclass_info (class_id: %, schema_name "%"): %', class_id, schema_name, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.get_objectclass_info(integer, varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function citydb_pkg.GET_CLASSNAME
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.get_classname(integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.get_classname(
	class_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar)
RETURNS varchar
AS $BODY$
DECLARE
	classname varchar;
BEGIN
IF class_id IS NOT NULL THEN
	-- get the classname of the class
	EXECUTE format('SELECT classname FROM %I.objectclass WHERE id=%L',schema_name,class_id) INTO classname;
	--RAISE NOTICE 'classname %', classname
	RETURN classname;
ELSE
	RAISE NOTICE 'citydb_pkg.get_classname: Class_id is NULL';
	RETURN NULL;
END IF;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.get_classname (class_id: %, schema_name "%"): %', class_id, schema_name, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.get_classname(integer, varchar) OWNER TO postgres;

-- CREATES backup versions of the delete_cityobject and get_envelope_cityobject functions
-- This is nothing else than a copy and paste of the functions from the vanilla 3DCityDB 3.3.1.
----------------------------------------------------------------
-- Function citydb_pkg.DELETE_CITYOBJECT_orig 
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_pkg.delete_cityobject_orig(
	co_id integer,
	delete_members integer DEFAULT 0,
	cleanup integer DEFAULT 0,
	schema_name text DEFAULT 'citydb'::text)
  RETURNS integer AS
$BODY$
DECLARE
	deleted_id INTEGER;
	class_id INTEGER;
BEGIN
EXECUTE format('SELECT objectclass_id FROM %I.cityobject WHERE id = %L', schema_name, co_id) INTO class_id;
-- class_id can be NULL if object has already been deleted
IF class_id IS NOT NULL THEN
    CASE
      WHEN class_id = 4 THEN deleted_id := citydb_pkg.delete_land_use(co_id, schema_name);
      WHEN class_id = 5 THEN deleted_id := citydb_pkg.delete_generic_cityobject(co_id, schema_name);
      WHEN class_id = 7 THEN deleted_id := citydb_pkg.delete_solitary_veg_obj(co_id, schema_name);
      WHEN class_id = 8 THEN deleted_id := citydb_pkg.delete_plant_cover(co_id, schema_name);
      WHEN class_id = 9 THEN deleted_id := citydb_pkg.delete_waterbody(co_id, schema_name);
      WHEN class_id = 11 OR 
           class_id = 12 OR 
           class_id = 13 THEN deleted_id := citydb_pkg.delete_waterbnd_surface(co_id, schema_name);
      WHEN class_id = 14 THEN deleted_id := citydb_pkg.delete_relief_feature(co_id, schema_name);
      WHEN class_id = 16 OR 
           class_id = 17 OR 
           class_id = 18 OR 
           class_id = 19 THEN deleted_id := citydb_pkg.delete_relief_component(co_id, schema_name);
      WHEN class_id = 21 THEN deleted_id := citydb_pkg.delete_city_furniture(co_id, schema_name);
      WHEN class_id = 23 THEN deleted_id := citydb_pkg.delete_cityobjectgroup(co_id, delete_members, schema_name);
      WHEN class_id = 25 OR 
           class_id = 26 THEN deleted_id := citydb_pkg.delete_building(co_id, schema_name);
      WHEN class_id = 27 OR 
           class_id = 28 THEN deleted_id := citydb_pkg.delete_building_installation(co_id, schema_name);
      WHEN class_id = 30 OR 
           class_id = 31 OR 
           class_id = 32 OR 
           class_id = 33 OR 
           class_id = 34 OR 
           class_id = 35 OR 
           class_id = 36 OR 
           class_id = 60 OR 
           class_id = 61 THEN deleted_id := citydb_pkg.delete_thematic_surface(co_id, schema_name);
      WHEN class_id = 38 OR 
           class_id = 39 THEN deleted_id := citydb_pkg.delete_opening(co_id, schema_name);
      WHEN class_id = 40 THEN deleted_id := citydb_pkg.delete_building_furniture(co_id, schema_name);
      WHEN class_id = 41 THEN deleted_id := citydb_pkg.delete_room(co_id, schema_name);
      WHEN class_id = 43 OR 
           class_id = 44 OR 
           class_id = 45 OR 
           class_id = 46 THEN deleted_id := citydb_pkg.delete_transport_complex(co_id, schema_name);
      WHEN class_id = 47 OR 
           class_id = 48 THEN deleted_id := citydb_pkg.delete_traffic_area(co_id, schema_name);
      WHEN class_id = 63 OR 
           class_id = 64 THEN deleted_id := citydb_pkg.delete_bridge(co_id, schema_name);
      WHEN class_id = 65 OR 
           class_id = 66 THEN deleted_id := citydb_pkg.delete_bridge_installation(co_id, schema_name);
      WHEN class_id = 68 OR 
           class_id = 69 OR 
           class_id = 70 OR 
           class_id = 71 OR 
           class_id = 72 OR 
           class_id = 73 OR 
           class_id = 74 OR 
           class_id = 75 OR 
           class_id = 76 THEN deleted_id := citydb_pkg.delete_bridge_them_srf(co_id, schema_name);
      WHEN class_id = 78 OR 
           class_id = 79 THEN deleted_id := citydb_pkg.delete_bridge_opening(co_id, schema_name);		 
      WHEN class_id = 80 THEN deleted_id := citydb_pkg.delete_bridge_furniture(co_id, schema_name);
      WHEN class_id = 81 THEN deleted_id := citydb_pkg.delete_bridge_room(co_id, schema_name);
      WHEN class_id = 82 THEN deleted_id := citydb_pkg.delete_bridge_constr_element(co_id, schema_name);
      WHEN class_id = 84 OR 
           class_id = 85 THEN deleted_id := citydb_pkg.delete_tunnel(co_id, schema_name);
      WHEN class_id = 86 OR 
           class_id = 87 THEN deleted_id := citydb_pkg.delete_tunnel_installation(co_id, schema_name);
      WHEN class_id = 88 OR 
           class_id = 89 OR 
           class_id = 90 OR 
           class_id = 91 OR 
           class_id = 92 OR 
           class_id = 93 OR 
           class_id = 94 OR 
           class_id = 95 OR 
           class_id = 96 THEN deleted_id := citydb_pkg.delete_tunnel_them_srf(co_id, schema_name);
      WHEN class_id = 99 OR 
           class_id = 100 THEN deleted_id := citydb_pkg.delete_tunnel_opening(co_id, schema_name);
      WHEN class_id = 101 THEN deleted_id := citydb_pkg.delete_tunnel_furniture(co_id, schema_name);
      WHEN class_id = 102 THEN deleted_id := citydb_pkg.delete_tunnel_hollow_space(co_id, schema_name);
    ELSE
        RAISE NOTICE 'Can not delete chosen object with ID % and objectclass_id %.', co_id, class_id;
    END CASE;
END IF;

IF cleanup <> 0 THEN
    EXECUTE 'SELECT citydb_pkg.cleanup_implicit_geometries(1, $1)' USING schema_name;
    EXECUTE 'SELECT citydb_pkg.cleanup_appearances(1, $1)' USING schema_name;
    EXECUTE 'SELECT citydb_pkg.cleanup_citymodels($1)' USING schema_name;
END IF;

RETURN deleted_id;

EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.delete_cityobject (id: %): %', co_id, SQLERRM;
END; 
$BODY$
LANGUAGE plpgsql VOLATILE COST 100;

----------------------------------------------------------------
-- Function citydb_pkg.GET_ENVELOPE_CITYOBJECT_orig 
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_cityobject_orig(
	co_id integer,
	objclass_id integer DEFAULT 0,
	set_envelope integer DEFAULT 0,
	schema_name character varying DEFAULT 'citydb'::character varying)
  RETURNS geometry AS
$BODY$
DECLARE
	class_id INTEGER = 0;
	envelope GEOMETRY;
	db_srid INTEGER;
BEGIN
-- fetching class_id if it is NULL
IF objclass_id IS NULL OR objclass_id = 0 THEN
    EXECUTE format('SELECT objectclass_id FROM %I.cityobject WHERE id = %L', schema_name, co_id) INTO class_id;
ELSE
    class_id := objclass_id;
END IF;
CASE
	WHEN class_id = 4 THEN envelope := citydb_pkg.get_envelope_land_use(co_id, set_envelope, schema_name);
	WHEN class_id = 5 THEN envelope := citydb_pkg.get_envelope_generic_cityobj(co_id, set_envelope, schema_name);
	WHEN class_id = 7 THEN envelope := citydb_pkg.get_envelope_solitary_veg_obj(co_id, set_envelope, schema_name);
	WHEN class_id = 8 THEN envelope := citydb_pkg.get_envelope_plant_cover(co_id, set_envelope, schema_name);
	WHEN class_id = 9 THEN envelope := citydb_pkg.get_envelope_waterbody(co_id, set_envelope, schema_name);
	WHEN class_id = 11 OR
		 class_id = 12 OR
		 class_id = 13 THEN envelope := citydb_pkg.get_envelope_waterbnd_surface(co_id, set_envelope, schema_name);
	WHEN class_id = 14 THEN envelope := citydb_pkg.get_envelope_relief_feature(co_id, set_envelope, schema_name);
	WHEN class_id = 16 OR
		 class_id = 17 OR
		 class_id = 18 OR
		 class_id = 19 THEN envelope := citydb_pkg.get_envelope_relief_component(co_id, class_id, set_envelope, schema_name);
	WHEN class_id = 21 THEN envelope := citydb_pkg.get_envelope_city_furniture(co_id, set_envelope, schema_name);
	WHEN class_id = 23 THEN envelope := citydb_pkg.get_envelope_cityobjectgroup(co_id, set_envelope, 1, schema_name);
	WHEN class_id = 25 OR
		 class_id = 26 THEN envelope := citydb_pkg.get_envelope_building(co_id, set_envelope, schema_name);
	WHEN class_id = 27 OR
		 class_id = 28 THEN envelope := citydb_pkg.get_envelope_building_inst(co_id, set_envelope, schema_name);
	WHEN class_id = 30 OR
		 class_id = 31 OR
		 class_id = 32 OR
		 class_id = 33 OR
		 class_id = 34 OR
		 class_id = 35 OR
		 class_id = 36 OR
		 class_id = 60 OR
		 class_id = 61 THEN envelope := citydb_pkg.get_envelope_thematic_surface(co_id, set_envelope, schema_name);
	WHEN class_id = 38 OR
		 class_id = 39 THEN envelope := citydb_pkg.get_envelope_opening(co_id, set_envelope, schema_name);
	WHEN class_id = 40 THEN envelope := citydb_pkg.get_envelope_building_furn(co_id, set_envelope, schema_name);
	WHEN class_id = 41 THEN envelope := citydb_pkg.get_envelope_room(co_id, set_envelope, schema_name);
	WHEN class_id = 43 OR
		 class_id = 44 OR
		 class_id = 45 OR
		 class_id = 46 THEN envelope := citydb_pkg.get_envelope_trans_complex(co_id, set_envelope, schema_name);
	WHEN class_id = 47 OR
		 class_id = 48 THEN envelope := citydb_pkg.get_envelope_traffic_area(co_id, set_envelope, schema_name);
	WHEN class_id = 63 OR
		 class_id = 64 THEN envelope := citydb_pkg.get_envelope_bridge(co_id, set_envelope, schema_name);
	WHEN class_id = 65 OR
		 class_id = 66 THEN envelope := citydb_pkg.get_envelope_bridge_inst(co_id, set_envelope, schema_name);
	WHEN class_id = 68 OR
		 class_id = 69 OR
		 class_id = 70 OR
		 class_id = 71 OR
		 class_id = 72 OR
		 class_id = 73 OR
		 class_id = 74 OR
		 class_id = 75 OR
		 class_id = 76 THEN envelope := citydb_pkg.get_envelope_bridge_them_srf(co_id, set_envelope, schema_name);
	WHEN class_id = 78 OR
		 class_id = 79 THEN envelope := citydb_pkg.get_envelope_bridge_opening(co_id, set_envelope, schema_name);
	WHEN class_id = 80 THEN envelope := citydb_pkg.get_envelope_bridge_furniture(co_id, set_envelope, schema_name);
	WHEN class_id = 81 THEN envelope := citydb_pkg.get_envelope_bridge_room(co_id, set_envelope, schema_name);
	WHEN class_id = 82 THEN envelope := citydb_pkg.get_envelope_bridge_const_elem(co_id, set_envelope, schema_name);
	WHEN class_id = 84 OR
		 class_id = 85 THEN envelope := citydb_pkg.get_envelope_tunnel(co_id, set_envelope, schema_name);
	WHEN class_id = 86 OR
		 class_id = 87 THEN envelope := citydb_pkg.get_envelope_tunnel_inst(co_id, set_envelope, schema_name);
	WHEN class_id = 89 OR
		 class_id = 90 OR
		 class_id = 91 OR
		 class_id = 92 OR
		 class_id = 93 OR
		 class_id = 94 OR
		 class_id = 95 OR
		 class_id = 96 OR
		 class_id = 97 THEN envelope := citydb_pkg.get_envelope_tunnel_them_srf(co_id, set_envelope, schema_name);
	WHEN class_id = 99 OR
		 class_id = 100 THEN envelope := citydb_pkg.get_envelope_tunnel_opening(co_id, set_envelope, schema_name);
	WHEN class_id = 101 THEN envelope := citydb_pkg.get_envelope_tunnel_furniture(co_id, set_envelope, schema_name);
	WHEN class_id = 102 THEN envelope := citydb_pkg.get_envelope_tunnel_hspace(co_id, set_envelope, schema_name);
ELSE
	RAISE NOTICE 'Cannot get envelope of object with ID % and objectclass_id %.', co_id, class_id;
END CASE;

RETURN envelope;

EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_cityobject": %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql;


-- And now "over"write the old vanilla versions with the new one which includes a hook mechanismus for the ADEs.
----------------------------------------------------------------
-- Function citydb_pkg.DELETE_CITYOBJECT 
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.delete_cityobject(integer, integer, integer, text); --this is only if there is a leftover of the function with text instead of varchar type. The backup one is now coherently "varchar".
DROP FUNCTION IF EXISTS citydb_pkg.delete_cityobject(integer, integer, integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.delete_cityobject(
	co_id integer,
	delete_members integer DEFAULT 0,
	cleanup integer DEFAULT 0,
	schema_name varchar DEFAULT 'citydb'::varchar)
  RETURNS integer AS
$BODY$
DECLARE
	class_id INTEGER;
	class_info RECORD;
	deleted_id INTEGER;
BEGIN

EXECUTE format('SELECT objectclass_id FROM %I.cityobject WHERE id = %L', schema_name, co_id) INTO class_id;
-- class_id can be NULL if object has already been deleted

IF class_id IS NOT NULL THEN
	-- get the full info of the objectclass, including db_prefix etc.

	EXECUTE format('SELECT t.* FROM citydb_pkg.get_objectclass_info(%L, %L) AS t', class_id, schema_name) INTO class_info;
	-- This funtion returns class_info.db_prefix varchar, class_info.classname varchar, class_info.is_ade_class numeric(1,0)
	--RAISE NOTICE 'Class_info %', class_info;

	IF class_info.is_ade_class::integer = 1 THEN
	-- we are dealing with an ADE cityobject, so call the respective ADE delete_cityobject() function, which is identified by its db_prefix

		EXECUTE format('SELECT citydb_pkg.%I_delete_cityobject(%L, %L, %L, %L)', 
		 class_info.db_prefix, co_id, delete_members, cleanup, schema_name) INTO deleted_id;			

	ELSE -- i.e. is_ade_class::integer = 0
	-- we are dealing with a vanilla CityObject class, so use the "vanilla" approach.

		CASE
		  WHEN class_id = 4 THEN deleted_id := citydb_pkg.delete_land_use(co_id, schema_name);
		  WHEN class_id = 5 THEN deleted_id := citydb_pkg.delete_generic_cityobject(co_id, schema_name);
		  WHEN class_id = 7 THEN deleted_id := citydb_pkg.delete_solitary_veg_obj(co_id, schema_name);
		  WHEN class_id = 8 THEN deleted_id := citydb_pkg.delete_plant_cover(co_id, schema_name);
		  WHEN class_id = 9 THEN deleted_id := citydb_pkg.delete_waterbody(co_id, schema_name);
		  WHEN class_id = 11 OR 
			   class_id = 12 OR 
			   class_id = 13 THEN deleted_id := citydb_pkg.delete_waterbnd_surface(co_id, schema_name);
		  WHEN class_id = 14 THEN deleted_id := citydb_pkg.delete_relief_feature(co_id, schema_name);
		  WHEN class_id = 16 OR 
			   class_id = 17 OR 
			   class_id = 18 OR 
			   class_id = 19 THEN deleted_id := citydb_pkg.delete_relief_component(co_id, schema_name);
		  WHEN class_id = 21 THEN deleted_id := citydb_pkg.delete_city_furniture(co_id, schema_name);
		  WHEN class_id = 23 THEN deleted_id := citydb_pkg.delete_cityobjectgroup(co_id, delete_members, schema_name);
		  WHEN class_id = 25 OR 
			   class_id = 26 THEN deleted_id := citydb_pkg.delete_building(co_id, schema_name);
		  WHEN class_id = 27 OR 
			   class_id = 28 THEN deleted_id := citydb_pkg.delete_building_installation(co_id, schema_name);
		  WHEN class_id = 30 OR 
			   class_id = 31 OR 
			   class_id = 32 OR 
			   class_id = 33 OR 
			   class_id = 34 OR 
			   class_id = 35 OR 
			   class_id = 36 OR 
			   class_id = 60 OR 
			   class_id = 61 THEN deleted_id := citydb_pkg.delete_thematic_surface(co_id, schema_name);
		  WHEN class_id = 38 OR 
			   class_id = 39 THEN deleted_id := citydb_pkg.delete_opening(co_id, schema_name);
		  WHEN class_id = 40 THEN deleted_id := citydb_pkg.delete_building_furniture(co_id, schema_name);
		  WHEN class_id = 41 THEN deleted_id := citydb_pkg.delete_room(co_id, schema_name);
		  WHEN class_id = 43 OR 
			   class_id = 44 OR 
			   class_id = 45 OR 
			   class_id = 46 THEN deleted_id := citydb_pkg.delete_transport_complex(co_id, schema_name);
		  WHEN class_id = 47 OR 
			   class_id = 48 THEN deleted_id := citydb_pkg.delete_traffic_area(co_id, schema_name);
		  WHEN class_id = 63 OR 
			   class_id = 64 THEN deleted_id := citydb_pkg.delete_bridge(co_id, schema_name);
		  WHEN class_id = 65 OR 
			   class_id = 66 THEN deleted_id := citydb_pkg.delete_bridge_installation(co_id, schema_name);
		  WHEN class_id = 68 OR 
			   class_id = 69 OR 
			   class_id = 70 OR 
			   class_id = 71 OR 
			   class_id = 72 OR 
			   class_id = 73 OR 
			   class_id = 74 OR 
			   class_id = 75 OR 
			   class_id = 76 THEN deleted_id := citydb_pkg.delete_bridge_them_srf(co_id, schema_name);
		  WHEN class_id = 78 OR 
			   class_id = 79 THEN deleted_id := citydb_pkg.delete_bridge_opening(co_id, schema_name);		 
		  WHEN class_id = 80 THEN deleted_id := citydb_pkg.delete_bridge_furniture(co_id, schema_name);
		  WHEN class_id = 81 THEN deleted_id := citydb_pkg.delete_bridge_room(co_id, schema_name);
		  WHEN class_id = 82 THEN deleted_id := citydb_pkg.delete_bridge_constr_element(co_id, schema_name);
		  WHEN class_id = 84 OR 
			   class_id = 85 THEN deleted_id := citydb_pkg.delete_tunnel(co_id, schema_name);
		  WHEN class_id = 86 OR 
			   class_id = 87 THEN deleted_id := citydb_pkg.delete_tunnel_installation(co_id, schema_name);
		  WHEN class_id = 88 OR 
			   class_id = 89 OR 
			   class_id = 90 OR 
			   class_id = 91 OR 
			   class_id = 92 OR 
			   class_id = 93 OR 
			   class_id = 94 OR 
			   class_id = 95 OR 
			   class_id = 96 THEN deleted_id := citydb_pkg.delete_tunnel_them_srf(co_id, schema_name);
		  WHEN class_id = 99 OR 
			   class_id = 100 THEN deleted_id := citydb_pkg.delete_tunnel_opening(co_id, schema_name);
		  WHEN class_id = 101 THEN deleted_id := citydb_pkg.delete_tunnel_furniture(co_id, schema_name);
		  WHEN class_id = 102 THEN deleted_id := citydb_pkg.delete_tunnel_hollow_space(co_id, schema_name);
		ELSE
			RAISE NOTICE 'Cannot delete chosen cityobject with ID % and objectclass_id %.', co_id, class_id;
		END CASE;

	END IF;

	IF cleanup <> 0 THEN
	    EXECUTE 'SELECT citydb_pkg.cleanup_implicit_geometries(1, $1)' USING schema_name;
	    EXECUTE 'SELECT citydb_pkg.cleanup_appearances(1, $1)' USING schema_name;
	    EXECUTE 'SELECT citydb_pkg.cleanup_citymodels($1)' USING schema_name;
	END IF;

	RAISE NOTICE 'Deleted CityObject (%, class_id %) with id: %',class_info.classname, class_id, co_id;

	RETURN deleted_id;

ELSE
	-- do nothing, the object may have been deleted already
	-- RAISE NOTICE 'CityObject not found';
	RETURN NULL;
END IF;

EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.delete_cityobject (id: %): %', co_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;


----------------------------------------------------------------
-- Function citydb_pkg.GET_ENVELOPE_CITYOBJECT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.get_envelope_cityobject(integer, integer, integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_cityobject(
	co_id integer,
	objclass_id integer DEFAULT 0,
	set_envelope integer DEFAULT 0,
	schema_name varchar DEFAULT 'citydb'::varchar)
  RETURNS geometry AS
$BODY$
DECLARE
	class_id INTEGER = 0;
	class_info RECORD;
	envelope GEOMETRY;
	db_srid INTEGER;
BEGIN
-- get class_id if it is NULL or zero
IF objclass_id IS NULL OR objclass_id = 0 THEN
    EXECUTE format('SELECT objectclass_id FROM %I.cityobject WHERE id = %L', schema_name, co_id) INTO class_id;
ELSE
    class_id:=objclass_id;
END IF;
-- now I am sure that class id <> 0 AND IS NOT NULL

EXECUTE format('SELECT t.* FROM citydb_pkg.get_objectclass_info(%L, %L) AS t', class_id, schema_name) INTO class_info;
-- This funtion returns class_info.db_prefix varchar, class_info.classname varchar, class_info.is_ade_class numeric(1,0)
--RAISE NOTICE 'Class_info %'), class_info;

IF class_info.is_ade_class::integer=1 THEN
-- we are dealing with an ADE cityobject, so call the respective ADE get_envelope_cityobject() function, which is identified by its db_prefix

	EXECUTE format('SELECT citydb_pkg.%I_get_envelope_cityobject(%L, %L, %L, %L)', class_info.db_prefix, co_id, objclass_id, set_envelope, schema_name) INTO envelope;			

ELSE -- i.e. is_ade_class::integer=0 
	-- we are dealing with a vanilla CityObject class, so use the "vanilla" approach.
	CASE
		WHEN class_id = 4 THEN envelope := citydb_pkg.get_envelope_land_use(co_id, set_envelope, schema_name);
		WHEN class_id = 5 THEN envelope := citydb_pkg.get_envelope_generic_cityobj(co_id, set_envelope, schema_name);
		WHEN class_id = 7 THEN envelope := citydb_pkg.get_envelope_solitary_veg_obj(co_id, set_envelope, schema_name);
		WHEN class_id = 8 THEN envelope := citydb_pkg.get_envelope_plant_cover(co_id, set_envelope, schema_name);
		WHEN class_id = 9 THEN envelope := citydb_pkg.get_envelope_waterbody(co_id, set_envelope, schema_name);
		WHEN class_id = 11 OR
			 class_id = 12 OR
			 class_id = 13 THEN envelope := citydb_pkg.get_envelope_waterbnd_surface(co_id, set_envelope, schema_name);
		WHEN class_id = 14 THEN envelope := citydb_pkg.get_envelope_relief_feature(co_id, set_envelope, schema_name);
		WHEN class_id = 16 OR
			 class_id = 17 OR
			 class_id = 18 OR
			 class_id = 19 THEN envelope := citydb_pkg.get_envelope_relief_component(co_id, class_id, set_envelope, schema_name);
		WHEN class_id = 21 THEN envelope := citydb_pkg.get_envelope_city_furniture(co_id, set_envelope, schema_name);
		WHEN class_id = 23 THEN envelope := citydb_pkg.get_envelope_cityobjectgroup(co_id, set_envelope, 1, schema_name);
		WHEN class_id = 25 OR
			 class_id = 26 THEN envelope := citydb_pkg.get_envelope_building(co_id, set_envelope, schema_name);
		WHEN class_id = 27 OR
			 class_id = 28 THEN envelope := citydb_pkg.get_envelope_building_inst(co_id, set_envelope, schema_name);
		WHEN class_id = 30 OR
			 class_id = 31 OR
			 class_id = 32 OR
			 class_id = 33 OR
			 class_id = 34 OR
			 class_id = 35 OR
			 class_id = 36 OR
			 class_id = 60 OR
			 class_id = 61 THEN envelope := citydb_pkg.get_envelope_thematic_surface(co_id, set_envelope, schema_name);
		WHEN class_id = 38 OR
			 class_id = 39 THEN envelope := citydb_pkg.get_envelope_opening(co_id, set_envelope, schema_name);
		WHEN class_id = 40 THEN envelope := citydb_pkg.get_envelope_building_furn(co_id, set_envelope, schema_name);
		WHEN class_id = 41 THEN envelope := citydb_pkg.get_envelope_room(co_id, set_envelope, schema_name);
		WHEN class_id = 43 OR
			 class_id = 44 OR
			 class_id = 45 OR
			 class_id = 46 THEN envelope := citydb_pkg.get_envelope_trans_complex(co_id, set_envelope, schema_name);
		WHEN class_id = 47 OR
			 class_id = 48 THEN envelope := citydb_pkg.get_envelope_traffic_area(co_id, set_envelope, schema_name);
		WHEN class_id = 63 OR
			 class_id = 64 THEN envelope := citydb_pkg.get_envelope_bridge(co_id, set_envelope, schema_name);
		WHEN class_id = 65 OR
			 class_id = 66 THEN envelope := citydb_pkg.get_envelope_bridge_inst(co_id, set_envelope, schema_name);
		WHEN class_id = 68 OR
			 class_id = 69 OR
			 class_id = 70 OR
			 class_id = 71 OR
			 class_id = 72 OR
			 class_id = 73 OR
			 class_id = 74 OR
			 class_id = 75 OR
			 class_id = 76 THEN envelope := citydb_pkg.get_envelope_bridge_them_srf(co_id, set_envelope, schema_name);
		WHEN class_id = 78 OR
			 class_id = 79 THEN envelope := citydb_pkg.get_envelope_bridge_opening(co_id, set_envelope, schema_name);
		WHEN class_id = 80 THEN envelope := citydb_pkg.get_envelope_bridge_furniture(co_id, set_envelope, schema_name);
		WHEN class_id = 81 THEN envelope := citydb_pkg.get_envelope_bridge_room(co_id, set_envelope, schema_name);
		WHEN class_id = 82 THEN envelope := citydb_pkg.get_envelope_bridge_const_elem(co_id, set_envelope, schema_name);
		WHEN class_id = 84 OR
			 class_id = 85 THEN envelope := citydb_pkg.get_envelope_tunnel(co_id, set_envelope, schema_name);
		WHEN class_id = 86 OR
			 class_id = 87 THEN envelope := citydb_pkg.get_envelope_tunnel_inst(co_id, set_envelope, schema_name);
		WHEN class_id = 89 OR
			 class_id = 90 OR
			 class_id = 91 OR
			 class_id = 92 OR
			 class_id = 93 OR
			 class_id = 94 OR
			 class_id = 95 OR
			 class_id = 96 OR
			 class_id = 97 THEN envelope := citydb_pkg.get_envelope_tunnel_them_srf(co_id, set_envelope, schema_name);
		WHEN class_id = 99 OR
			 class_id = 100 THEN envelope := citydb_pkg.get_envelope_tunnel_opening(co_id, set_envelope, schema_name);
		WHEN class_id = 101 THEN envelope := citydb_pkg.get_envelope_tunnel_furniture(co_id, set_envelope, schema_name);
		WHEN class_id = 102 THEN envelope := citydb_pkg.get_envelope_tunnel_hspace(co_id, set_envelope, schema_name);
	ELSE
		RAISE NOTICE 'Cannot get envelope of object with ID % and objectclass_id %.', co_id, class_id;
		RETURN NULL;
	END CASE;
END IF;

RAISE NOTICE 'Computed envelope of CityObject (%, class_id %) with id: %', class_info.classname, class_id, co_id;
RETURN envelope;

EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.get_envelope_cityobject (id: %): %', co_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function DROP_ADE_OBJECTCLASSES
----------------------------------------------------------------
DROP FUNCTION IF EXISTS  citydb_pkg.drop_ade_objectclasses(varchar, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.drop_ade_objectclasses(
	db_prefix varchar,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS varchar AS $$
DECLARE
	class_id integer;
BEGIN
IF db_prefix IS NOT NULL THEN
	--first, all FK in table objectclass are deleted (columns baseclass_id and superclass_id)
	FOR class_id IN EXECUTE format('SELECT DISTINCT o.id FROM %I.ade a, %I.schema_to_objectclass so, %I.objectclass o, %I.schema s WHERE so.schema_id = s.id AND o.id = so.objectclass_id AND s.ade_id = a.id AND a.db_prefix=%L ORDER BY o.id', schema_name, schema_name, schema_name, schema_name, db_prefix) LOOP
		IF class_id IS NOT NULL THEN 
			--RAISE NOTICE 'class id: %',class_id;
			EXECUTE format('UPDATE %I.objectclass SET baseclass_id=NULL, superclass_id=NULL WHERE id=%L', schema_name, class_id);
		END IF;
	END LOOP;
	--then, delete the objectclass
	FOR class_id IN EXECUTE format('SELECT DISTINCT o.id FROM %I.ade a, %I.schema_to_objectclass so, %I.objectclass o, %I.schema s WHERE so.schema_id = s.id AND o.id = so.objectclass_id AND s.ade_id = a.id AND a.db_prefix=%L ORDER BY o.id', schema_name, schema_name, schema_name, schema_name, db_prefix) LOOP
		IF class_id IS NOT NULL THEN 
			--RAISE NOTICE 'class id: %',class_id;
			EXECUTE format('DELETE FROM %I.objectclass WHERE id=%L', schema_name, class_id);
		END IF;
	END LOOP;
	RAISE NOTICE 'Records in table %.objectclass depending associated with db_prefix "%" deleted', schema_name, db_prefix;	
	RETURN db_prefix;
ELSE
	RAISE NOTICE 'citydb_pkg.drop_ade_objectclasses: db_prefix is NULL, nothing to do';
	RETURN NULL;
END IF;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.drop_ade_objectclasses (db_prefix: %) in "%", %', db_prefix, schema_name, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.drop_ade_objectclasses(varchar,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DROP_ADE_TABLES
----------------------------------------------------------------
DROP FUNCTION IF EXISTS  citydb_pkg.drop_ade_tables(varchar, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.drop_ade_tables(
	db_prefix varchar,
	schema_name varchar DEFAULT 'citydb'::varchar)
RETURNS varchar AS $$
DECLARE
	db_prefix_length varchar;
	test integer;
	rec RECORD;
BEGIN
IF db_prefix IS NOT NULL THEN
	db_prefix_length=char_length(db_prefix);
	-- Check whether there are any prefixed tables to drop at all!
	EXECUTE format('SELECT 1 FROM information_schema.tables WHERE table_type=''BASE TABLE'' AND table_schema=%L AND substring(table_name, 1, %L::integer)=%L LIMIT 1',schema_name, db_prefix_length, db_prefix) INTO test;
	IF test IS NOT NULL AND test=1 THEN
		--RAISE INFO 'Removing all tables with db_prefix "%" in schema "%"',  db_prefix, schema_name;		
		FOR rec IN EXECUTE format('SELECT table_schema, table_name FROM information_schema.tables WHERE table_type=''BASE TABLE'' AND table_schema=%L AND substring(table_name, 1, %L::integer)=%L',schema_name,  
			 db_prefix_length, db_prefix) LOOP
			--RAISE INFO 'Dropping table %.%',rec.table_schema, rec.table_name;
			EXECUTE format('DROP TABLE IF EXISTS %I.%I CASCADE',rec.table_schema, rec.table_name);
		END LOOP;
		RETURN db_prefix;
	ELSE
		RAISE INFO '-- No tables found'; 
		RETURN NULL;
	END IF;
ELSE
	RAISE NOTICE 'citydb_pkg.drop_ade_tables: db_prefix is NULL, nothing to do';
	RETURN NULL;
END IF;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.drop_ade_tables (db_prefix: %) in "%", %', db_prefix, schema_name, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.drop_ade_tables(varchar,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DROP_ADE_FUNCTIONS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS  citydb_pkg.drop_ade_functions(varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.drop_ade_functions(
	db_prefix varchar)
RETURNS varchar AS $$
DECLARE
	db_prefix_length varchar;
	test integer;
	rec RECORD;
BEGIN
IF db_prefix IS NOT NULL THEN
	db_prefix_length=char_length(db_prefix);
	-- Check whether there are any prefixed functions to drop at all!
	EXECUTE format('SELECT 1 FROM information_schema.routines WHERE routine_type=''FUNCTION'' AND routine_schema=''citydb_pkg'' AND substring(routine_name, 1, %L::integer)=%L LIMIT 1', db_prefix_length, db_prefix) INTO test;
	IF test IS NOT NULL AND test=1 THEN
		--RAISE INFO 'Removing all functions with db_prefix "%" in schema citydb_pkg',  db_prefix;	
		FOR rec IN EXECUTE format('SELECT proname || ''('' || oidvectortypes(proargtypes) || '')'' AS function_name
		FROM pg_proc INNER JOIN pg_namespace ns ON (pg_proc.pronamespace = ns.oid)
		WHERE ns.nspname = ''citydb_pkg'' AND substring(proname, 1, %L)=%L ORDER BY proname', db_prefix_length, db_prefix) LOOP
			--RAISE NOTICE 'Dropping FUNCTION citydb_pkg.%',rec.function_name;
			EXECUTE 'DROP FUNCTION IF EXISTS citydb_pkg.' || rec.function_name || ' CASCADE'; 
		END LOOP;
		RETURN db_prefix;
	ELSE
		RAISE INFO '-- No functions found';
		RETURN NULL;		
	END IF;
ELSE
	RAISE NOTICE 'citydb_pkg.adrop_ade_functions: db_prefix is NULL, nothing to do';
	RETURN NULL;
END IF;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.drop_ade_functions (db_prefix: %) in "%", %', db_prefix, schema_name, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.drop_ade_functions(varchar,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DROP_ADE_SCHEMA
----------------------------------------------------------------
-- This is a very basic implementation which needs to be improved.
-- So far, it simply picks the db_prefix of the selected ADE and deletes
-- all entries with the same db_prefix in the schema table and all tables
-- and functions with the same db_prefix.
-- Entries in tables schema_referencing and schema_to_objectclass are deleted
-- automatically on cascade.
-- a more appropriate check on dependencies needs to be implemented.
DROP FUNCTION IF EXISTS  citydb_pkg.drop_ade(integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.drop_ade(
	ade_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	db_prefix varchar;
	deleted_id integer;
BEGIN
-- get more info about the ADE schema
EXECUTE format('SELECT db_prefix FROM %I.ade WHERE id=%L', schema_name, ade_id) INTO db_prefix;
IF db_prefix IS NOT NULL THEN
	RAISE NOTICE 'Picked up db_prefix: %',db_prefix;
	-- drops all objectclasses in table objectclass
	EXECUTE 'SELECT citydb_pkg.drop_ade_objectclasses($1,$2)' USING db_prefix, schema_name;	
	-- drops all tables
	EXECUTE 'SELECT citydb_pkg.drop_ade_tables($1,$2)' USING db_prefix, schema_name;
	-- drops all functions
	EXECUTE 'SELECT citydb_pkg.drop_ade_functions($1)' USING db_prefix;
	-- deletes entry in ade table
	EXECUTE format('DELETE FROM %I.ade WHERE id=%L RETURNING id', schema_name, ade_id) INTO deleted_id;
	-- delete entries in schema table (carried out automatically ON DELETE CASCADE)
	-- delete entries in schema_referencing and schema_to_objectclass (carried out automatically ON DELETE CASCADE)
	RETURN deleted_id;
ELSE
	RAISE NOTICE 'citydb_pkg.drop_ade: no db_prefix found for ADE (id: %)', ade_id;
	RETURN NULL;
END IF;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.drop_ade (id: %) in "%", %', ade_id, schema_name, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.drop_ade(varchar,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function CHANGE_ADE_COLUMN_SRID
----------------------------------------------------------------
--DROP FUNCTION IF EXISTS citydb_pkg.change_ade_column_srid(varchar,varchar,varchar,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.change_ade_column_srid(
  table_name varchar,
  geom_column varchar,
  geom_type varchar,
  schema_name varchar DEFAULT 'citydb'::varchar
)
  RETURNS void AS $$
DECLARE
  db_srid integer;
BEGIN
-- get the Srid already defined in the table database_srs
EXECUTE format('SELECT srid FROM %I.database_srs LIMIT 1',schema_name) INTO db_srid; 
-- RAISE INFO 'Found SRID % for schema %', db_srid, schema_name;
-- RAISE INFO 'Setting SRID for %.%', table_name, geom_column;
EXECUTE format('ALTER TABLE %I.%I ALTER COLUMN %I TYPE geometry(%I,%L) USING ST_SetSrid(%I,%L)',
			 schema_name, 
			 table_name, 
			 geom_column, 
			 geom_type, 
			 db_srid, 
			 geom_column,
			 db_srid); 
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.change_ade_column_srid(%, %, %, %): %', table_name, geom_column, geom_type,  schema_name, SQLERRM;
END;
$$ LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.change_ade_column_srid(varchar,varchar,varchar,varchar) OWNER TO postgres;


-- CREATES backup versions of the objectclass_id_to_table_name function
-- This is nothing else than a copy and paste of the functions from the vanilla 3DCityDB 3.3.1.
----------------------------------------------------------------
-- Function citydb_pkg.OBJECTCLASS_ID_TO_TABLE_NAME_orig 
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_pkg.objectclass_id_to_table_name_orig(
	class_id integer
)
  RETURNS text AS
$BODY$
DECLARE
	table_name TEXT := '';
BEGIN
  CASE 
    WHEN class_id = 4 THEN table_name := 'land_use';
    WHEN class_id = 5 THEN table_name := 'generic_cityobject';
    WHEN class_id = 7 THEN table_name := 'solitary_vegetat_object';
    WHEN class_id = 8 THEN table_name := 'plant_cover';
    WHEN class_id = 9 THEN table_name := 'waterbody';
    WHEN class_id = 11 OR 
         class_id = 12 OR 
         class_id = 13 THEN table_name := 'waterboundary_surface';
    WHEN class_id = 14 THEN table_name := 'relief_feature';
    WHEN class_id = 16 OR 
         class_id = 17 OR 
         class_id = 18 OR 
         class_id = 19 THEN table_name := 'relief_component';
    WHEN class_id = 21 THEN table_name := 'city_furniture';
    WHEN class_id = 23 THEN table_name := 'cityobjectgroup';
    WHEN class_id = 25 OR 
         class_id = 26 THEN table_name := 'building';
    WHEN class_id = 27 OR 
         class_id = 28 THEN table_name := 'building_installation';
    WHEN class_id = 30 OR 
         class_id = 31 OR 
         class_id = 32 OR 
         class_id = 33 OR 
         class_id = 34 OR 
         class_id = 35 OR
         class_id = 36 OR
         class_id = 60 OR
         class_id = 61 THEN table_name := 'thematic_surface';
    WHEN class_id = 38 OR 
         class_id = 39 THEN table_name := 'opening';
    WHEN class_id = 40 THEN table_name := 'building_furniture';
    WHEN class_id = 41 THEN table_name := 'room';
    WHEN class_id = 43 OR 
         class_id = 44 OR 
         class_id = 45 OR 
         class_id = 46 THEN table_name := 'transportation_complex';
    WHEN class_id = 47 OR 
         class_id = 48 THEN table_name := 'traffic_area';
    WHEN class_id = 57 THEN table_name := 'citymodel';
    WHEN class_id = 63 OR
         class_id = 64 THEN table_name := 'bridge';
    WHEN class_id = 65 OR
         class_id = 66 THEN table_name := 'bridge_installation';
    WHEN class_id = 68 OR 
         class_id = 69 OR 
         class_id = 70 OR 
         class_id = 71 OR 
         class_id = 72 OR
         class_id = 73 OR
         class_id = 74 OR
         class_id = 75 OR
         class_id = 76 THEN table_name := 'bridge_thematic_surface';
    WHEN class_id = 78 OR 
         class_id = 79 THEN table_name := 'bridge_opening';		 
    WHEN class_id = 80 THEN table_name := 'bridge_furniture';
    WHEN class_id = 81 THEN table_name := 'bridge_room';
    WHEN class_id = 82 THEN table_name := 'bridge_constr_element';
    WHEN class_id = 84 OR
         class_id = 85 THEN table_name := 'tunnel';
    WHEN class_id = 86 OR
         class_id = 87 THEN table_name := 'tunnel_installation';
    WHEN class_id = 88 OR 
         class_id = 89 OR 
         class_id = 90 OR 
         class_id = 91 OR 
         class_id = 92 OR
         class_id = 93 OR
         class_id = 94 OR
         class_id = 95 OR
         class_id = 96 THEN table_name := 'tunnel_thematic_surface';
    WHEN class_id = 99 OR 
         class_id = 100 THEN table_name := 'tunnel_opening';		 
    WHEN class_id = 101 THEN table_name := 'tunnel_furniture';
    WHEN class_id = 102 THEN table_name := 'tunnel_hollow_space';
  ELSE
    RAISE NOTICE 'Table name unknown.';
  END CASE;
  
  RETURN table_name;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
-- ALTER FUNCTION citydb_pkg.objectclass_id_to_table_name(integer) OWNER TO postgres;

----------------------------------------------------------------
-- Function citydb_pkg.OBJECTCLASS_ID_TO_TABLE_NAME
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.objectclass_id_to_table_name(integer); -- drops leftover, just in case.
DROP FUNCTION IF EXISTS citydb_pkg.objectclass_id_to_table_name(integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.objectclass_id_to_table_name(
	class_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS varchar AS
$BODY$
DECLARE
	table_name varchar;
BEGIN
IF class_id IS NOT NULL THEN
	EXECUTE format('SELECT tablename FROM %I.objectclass WHERE id=%L', schema_name, db_prefix) INTO table_name;
	IF table_name IS NOT NULL THEN
		RETURN table_name;
	ELSE
		RAISE NOTICE 'Table name unknown';
		RETURN NULL;
	END IF;
ELSE
	RAISE NOTICE 'objectclass_id_to_table_name: Class_id is NULL';
	RETURN NULL;
END IF;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.objectclass_id_to_table_name(%) in schema %, %', class_id, table_name, SQLERRM;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function CLEANUP_SCHEMA_orig
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.cleanup_schema(text);
DROP FUNCTION IF EXISTS citydb_pkg.cleanup_schema_orig(varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.cleanup_schema_orig(
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS void AS
$BODY$
BEGIN
-- clear tables
EXECUTE format('TRUNCATE TABLE %I.cityobject CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.tex_image CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.grid_coverage CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.address CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.citymodel CASCADE', schema_name);

-- restart sequences
EXECUTE format('ALTER SEQUENCE %I.address_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.appearance_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.citymodel_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.cityobject_genericatt_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.cityobject_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.external_ref_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.grid_coverage_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.implicit_geometry_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.surface_data_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.surface_geometry_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.tex_image_seq RESTART', schema_name);

EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.cleanup_schema: %', SQLERRM;
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function CLEANUP_SCHEMA
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.cleanup_schema(varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.cleanup_schema(
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS void AS
$BODY$
DECLARE
	test varchar = NULL;
	db_prefix varchar;	
BEGIN
-- First check whether there are ADE-related tables (by db_prefix)
-- If so, then first truncate the ADE-tables, and only then proceed
-- with the vanilla tables
EXECUTE format('SELECT db_prefix FROM %I.ade LIMIT 1',schema_name) INTO test;
IF test IS NOT NULL THEN
	-- there is at least an ADE
	FOR db_prefix IN EXECUTE format('SELECT db_prefix FROM %I.ade', schema_name) LOOP
		--RAISE NOTICE '---------- Found db_prefix: "%" in %',db_prefix, schema_name;
		EXECUTE format('SELECT citydb_pkg.%I_cleanup_schema(%L)',db_prefix, schema_name);
	END LOOP;
	RAISE NOTICE '--- Completed data cleanup of ADE with db_prefix: "%" in %',db_prefix, schema_name;
ELSE
-- do nothing
END IF;

-- Now proceed with the vanilla tables.
-- clear vanilla tables
EXECUTE format('TRUNCATE TABLE %I.cityobject CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.tex_image CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.grid_coverage CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.address CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.citymodel CASCADE', schema_name);

--restart vanilla sequences
EXECUTE format('ALTER SEQUENCE %I.address_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.appearance_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.citymodel_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.cityobject_genericatt_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.cityobject_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.external_ref_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.grid_coverage_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.implicit_geometry_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.surface_data_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.surface_geometry_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.tex_image_seq RESTART', schema_name);

EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.cleanup_schema: %', SQLERRM;
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INTERN_DELETE_CITYOBJECT_orig
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.intern_delete_cityobject(integer, text);
DROP FUNCTION IF EXISTS citydb_pkg.intern_delete_cityobject_orig(integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.intern_delete_cityobject_orig(
	co_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id INTEGER;
BEGIN
--// PRE DELETE CITY OBJECT //--
-- delete reference to city model
EXECUTE format('DELETE FROM %I.cityobject_member WHERE cityobject_id = %L', schema_name, co_id);
-- delete reference to city object group
EXECUTE format('DELETE FROM %I.group_to_cityobject WHERE cityobject_id = %L', schema_name, co_id);
-- delete reference to generalization
EXECUTE format('DELETE FROM %I.generalization WHERE generalizes_to_id = %L', schema_name, co_id);
EXECUTE format('DELETE FROM %I.generalization WHERE cityobject_id = %L', schema_name, co_id);
-- delete external references of city object
EXECUTE format('DELETE FROM %I.external_reference WHERE cityobject_id = %L', schema_name, co_id);
-- delete generic attributes of city object
EXECUTE format('DELETE FROM %I.cityobject_genericattrib WHERE cityobject_id = %L', schema_name, co_id);
EXECUTE format('UPDATE %I.cityobjectgroup SET parent_cityobject_id=null WHERE parent_cityobject_id = %L', schema_name, co_id);
-- delete local appearances of city object 
EXECUTE format('SELECT citydb_pkg.delete_appearance(id, 0, %L) FROM %I.appearance WHERE cityobject_id = %L', schema_name, schema_name, co_id);
--// DELETE CITY OBJECT //--
EXECUTE format('DELETE FROM %I.cityobject WHERE id = %L RETURNING id', schema_name, co_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
WHEN OTHERS THEN RAISE NOTICE 'intern_delete_cityobject (id: %): %', co_id, SQLERRM;
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE COST 100;
--ALTER FUNCTION citydb_pkg.intern_delete_cityobject_orig(integer, varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function INTERN_DELETE_CITYOBJECT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.intern_delete_cityobject(integer, text);
DROP FUNCTION IF EXISTS citydb_pkg.intern_delete_cityobject(integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.intern_delete_cityobject(
	co_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	test varchar = NULL;
	db_prefix varchar;
	deleted_id INTEGER;
BEGIN
--// START ADE PRE DELETE CITYOBJECT //--
-- First check whether there are ADEs (by db_prefix)
-- If so, then first run the ADE-related intern_delete_cityobject(),
-- and then continue with the vanilla intern_delete_cityobject().
EXECUTE format('SELECT db_prefix FROM %I.ade LIMIT 1',schema_name) INTO test;
IF test IS NOT NULL THEN
	-- there is at least an ADE
	FOR db_prefix IN EXECUTE format('SELECT db_prefix FROM %I.ade', schema_name) LOOP
		--RAISE NOTICE '---------- Found db_prefix: "%" in %',db_prefix, schema_name;
		EXECUTE format('SELECT citydb_pkg.%I_intern_delete_cityobject(%L,%L)',db_prefix, co_id, schema_name);
	END LOOP;
ELSE
-- do nothing
END IF;
--// END ADE PRE DELETE ADE CITYOBJECT //--

--// VANILLA PRE DELETE CITY OBJECT //--
-- delete reference to city model
EXECUTE format('DELETE FROM %I.cityobject_member WHERE cityobject_id = %L', schema_name, co_id);
-- delete reference to city object group
EXECUTE format('DELETE FROM %I.group_to_cityobject WHERE cityobject_id = %L', schema_name, co_id);
-- delete reference to generalization
EXECUTE format('DELETE FROM %I.generalization WHERE generalizes_to_id = %L', schema_name, co_id);
EXECUTE format('DELETE FROM %I.generalization WHERE cityobject_id = %L', schema_name, co_id);
-- delete external references of city object
EXECUTE format('DELETE FROM %I.external_reference WHERE cityobject_id = %L', schema_name, co_id);
-- delete generic attributes of city object
EXECUTE format('DELETE FROM %I.cityobject_genericattrib WHERE cityobject_id = %L', schema_name, co_id);
EXECUTE format('UPDATE %I.cityobjectgroup SET parent_cityobject_id=null WHERE parent_cityobject_id = %L', schema_name, co_id);
-- delete local appearances of city object 
EXECUTE format('SELECT citydb_pkg.delete_appearance(id, 0, %L) FROM %I.appearance WHERE cityobject_id = %L', schema_name, schema_name, co_id);
--// DELETE CITY OBJECT //--
EXECUTE format('DELETE FROM %I.cityobject WHERE id = %L RETURNING id', schema_name, co_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8a_intern_delete_cityobject (id: %): %', co_id, SQLERRM;
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE COST 100;
--ALTER FUNCTION citydb_pkg.intern_delete_cityobject_orig(integer, varchar) OWNER TO postgres;


----------------------------------------------------------------
-- Function citydb_pkg.OBJECTCLASS_CLASSNAME_TO_ID
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.objectclass_classname_to_id(varchar, varchar, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.objectclass_classname_to_id(
	class_name varchar,
	db_prefix varchar,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	class_id varchar;
BEGIN
IF class_name IS NOT NULL THEN
	IF db_prefix IS NULL THEN
		-- we are looking for a vanilla objectclass
		EXECUTE format('SELECT o.id FROM %I.objectclass o WHERE o.classname=%L', schema_name, class_name) INTO class_id;
	ELSE
		-- we are looking for an ADE objectclass
		EXECUTE format('SELECT o.id FROM %I.ade a, %I.schema s, %I.schema_to_objectclass so, %I.objectclass o WHERE a.id = s.ade_id AND s.id = so.schema_id AND so.objectclass_id = o.id AND a.db_prefix=%L AND o.classname=%L LIMIT 1',
		schema_name, schema_name, schema_name, schema_name, db_prefix, class_name) INTO class_id;
	END IF;
	IF class_id IS NOT NULL THEN
		RETURN class_id;
	ELSE
		RAISE EXCEPTION 'citydb_pkg.objectclass_classname_to_id: class_id is NULL for db_prefix "%" and classname "%"', db_prefix, class_name;
	END IF;
ELSE
	RAISE EXCEPTION 'citydb_pkg.objectclass_classname_to_id: class_name is NULL for db_prefix "%" and classname "%"',db_prefix, class_name;
END IF;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.objectclass_classname_to_id (db_prefix "%", classname "%"): %)', db_prefix, class_name, SQLERRM;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION citydb_pkg.objectclass_classname_to_id(varchar, varchar, varchar) OWNER TO postgres;

-- ***********************************************************************
-- ***********************************************************************

DO
$$
BEGIN
RAISE NOTICE '

********************************

Metadata module table data installation complete!

********************************

';
END
$$;
SELECT 'Metadata module table data installed correctly!'::varchar AS installation_result;


-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************













