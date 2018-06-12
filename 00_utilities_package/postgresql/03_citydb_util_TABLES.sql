-- 3D City Database Utilities Package
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
-- ****************** 03_citydb_util_TABLES.sql **************************
--
--
-- ***********************************************************************
-- ***********************************************************************

----------------------------------------------------------------
-- Table LU_RELATIVE_TO_TERRAIN
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_relative_to_terrain CASCADE;
CREATE TABLE         citydb.lu_relative_to_terrain (
id varchar PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_relative_to_terrain OWNER TO postgres;

CREATE INDEX lu_relter_name_inx ON citydb.lu_relative_to_terrain USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_RELATIVE_TO_WATER
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_relative_to_water CASCADE;
CREATE TABLE         citydb.lu_relative_to_water (
id varchar PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_relative_to_water OWNER TO postgres;

CREATE INDEX lu_relwat_name_inx ON citydb.lu_relative_to_water USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_GENERICATTRIB_DATA_TYPE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_genericattrib_data_type CASCADE;
CREATE TABLE         citydb.lu_genericattrib_data_type (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_genericattrib_data_type OWNER TO postgres;

CREATE INDEX lu_genatt_name_inx ON citydb.lu_genericattrib_data_type USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_APPEARANCE_TEXT_MIME_TYPE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_appearance_text_mime_type CASCADE;
CREATE TABLE         citydb.lu_appearance_text_mime_type (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_appearance_text_mime_type OWNER TO postgres;

CREATE INDEX lu_app_name_inx ON citydb.lu_appearance_text_mime_type USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_BRIDGE_CLASS
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_bridge_class CASCADE;
CREATE TABLE         citydb.lu_bridge_class (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_bridge_class OWNER TO postgres;

CREATE INDEX lu_bridge_class_name_inx ON citydb.lu_bridge_class USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_BRIDGE_FUNCTION_USAGE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_bridge_function_usage CASCADE;
CREATE TABLE         citydb.lu_bridge_function_usage (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_bridge_function_usage OWNER TO postgres;

CREATE INDEX lu_bridge_funct_name_inx ON citydb.lu_bridge_function_usage USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_BUILDING_CLASS
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_building_class CASCADE;
CREATE TABLE         citydb.lu_building_class (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_bridge_function_usage OWNER TO postgres;

CREATE INDEX lu_bdg_class_name_inx ON citydb.lu_building_class USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_BUILDING_FUNCTION_USAGE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_building_function_usage CASCADE;
CREATE TABLE         citydb.lu_building_function_usage (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_building_function_usage OWNER TO postgres;

CREATE INDEX lu_bdg_funct_name_inx ON citydb.lu_building_function_usage USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_BUILDING_ROOF_TYPE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_building_roof_type CASCADE;
CREATE TABLE         citydb.lu_building_roof_type (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_building_roof_type OWNER TO postgres;

CREATE INDEX lu_bdg_roof_type_name_inx ON citydb.lu_building_roof_type USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_ROOM_CLASS
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_room_class CASCADE;
CREATE TABLE         citydb.lu_room_class (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_room_class OWNER TO postgres;

CREATE INDEX lu_room_class_name_inx ON citydb.lu_room_class USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_ROOM_FUNCTION_USAGE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_room_function_usage CASCADE;
CREATE TABLE         citydb.lu_room_function_usage (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_room_function_usage OWNER TO postgres;

CREATE INDEX lu_room_funct_name_inx ON citydb.lu_room_function_usage USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_BUILDING_FURNITURE_CLASS
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_building_furniture_class CASCADE;
CREATE TABLE         citydb.lu_building_furniture_class (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_building_furniture_function_usage OWNER TO postgres;

CREATE INDEX lu_bdg_fur_class_name_inx ON citydb.lu_building_furniture_class USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_BUILDING_FURNITURE_FUNCTION_USAGE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_building_furniture_function_usage CASCADE;
CREATE TABLE         citydb.lu_building_furniture_function_usage (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_building_furniture_function_usage OWNER TO postgres;

CREATE INDEX lu_bdg_fur_funct_name_inx ON citydb.lu_building_furniture_function_usage USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_BUILDING_INSTALLATION_CLASS
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_building_installation_class CASCADE;
CREATE TABLE         citydb.lu_building_installation_class (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_building_installation_class OWNER TO postgres;

CREATE INDEX lu_bdg_inst_class_name_inx ON citydb.lu_building_installation_class USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_BUILDING_INSTALLATION_FUNCTION_USAGE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_building_installation_function_usage CASCADE;
CREATE TABLE         citydb.lu_building_installation_function_usage (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_building_installation_function_usage OWNER TO postgres;

CREATE INDEX lu_bdg_inst_funct_name_inx ON citydb.lu_building_installation_function_usage USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_INT_BUILDING_INSTALLATION_CLASS
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_int_building_installation_class CASCADE;
CREATE TABLE         citydb.lu_int_building_installation_class (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_int_building_installation_class OWNER TO postgres;

CREATE INDEX lu_int_bdg_inst_class_name_inx ON citydb.lu_int_building_installation_class USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_INT_BUILDING_INSTALLATION_FUNCTION_USAGE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_int_building_installation_function_usage CASCADE;
CREATE TABLE         citydb.lu_int_building_installation_function_usage (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_int_building_installation_function_usage OWNER TO postgres;

CREATE INDEX lu_int_bdg_inst_funct_name_inx ON citydb.lu_int_building_installation_function_usage USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_CITY_FURNITURE_CLASS
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_city_furniture_class CASCADE;
CREATE TABLE         citydb.lu_city_furniture_class (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_city_furniture_class OWNER TO postgres;

CREATE INDEX lu_cty_fur_class_name_inx ON citydb.lu_city_furniture_class USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_CITY_FURNITURE_FUNCTION_USAGE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_city_furniture_function_usage CASCADE;
CREATE TABLE         citydb.lu_city_furniture_function_usage (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_city_furniture_function_usage OWNER TO postgres;

CREATE INDEX lu_cty_fur_inst_funct_name_inx ON citydb.lu_city_furniture_function_usage USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_CITYOBJECTGROUP_CLASS
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_cityobjectgroup_class CASCADE;
CREATE TABLE         citydb.lu_cityobjectgroup_class (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_cityobjectgroup_class OWNER TO postgres;

CREATE INDEX lu_ctyobjgrp_class_name_inx ON citydb.lu_cityobjectgroup_class USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_CITYOBJECTGROUP_FUNCTION_USAGE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_cityobjectgroup_function_usage CASCADE;
CREATE TABLE         citydb.lu_cityobjectgroup_function_usage (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_cityobjectgroup_function_usage OWNER TO postgres;

CREATE INDEX lu_ctyobjgrp_funct_name_inx ON citydb.lu_cityobjectgroup_function_usage USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_CORE_GEOM_MIME_TYPE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_core_geom_mime_type CASCADE;
CREATE TABLE         citydb.lu_core_geom_mime_type (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_core_geom_mime_type OWNER TO postgres;

CREATE INDEX lu_core_name_inx ON citydb.lu_core_geom_mime_type USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_LANDUSE_CLASS
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_landuse_class CASCADE;
CREATE TABLE         citydb.lu_landuse_class (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_int_building_installation_class OWNER TO postgres;

CREATE INDEX lu_luse_class_name_inx ON citydb.lu_landuse_class USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_LANDUSE_FUNCTION_USAGE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_landuse_function_usage CASCADE;
CREATE TABLE         citydb.lu_landuse_function_usage (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_int_building_installation_function_usage OWNER TO postgres;

CREATE INDEX lu_luse_funct_name_inx ON citydb.lu_landuse_function_usage USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_TRANSPORTATION_COMPLEX_CLASS
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_transportation_complex_class CASCADE;
CREATE TABLE         citydb.lu_transportation_complex_class (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_transportation_complex_class OWNER TO postgres;

CREATE INDEX lu_trcplex_class_name_inx ON citydb.lu_transportation_complex_class USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_TRANSPORTATION_COMPLEX_FUNCTION_USAGE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_transportation_complex_function_usage CASCADE;
CREATE TABLE         citydb.lu_transportation_complex_function_usage (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_transportation_complex_function_usage OWNER TO postgres;

CREATE INDEX lu_trcplex_funct_name_inx ON citydb.lu_transportation_complex_function_usage USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_AUX_FRAFFIC_AREA_FUNCTION
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_aux_traffic_area_function CASCADE;
CREATE TABLE         citydb.lu_aux_traffic_area_function (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_aux_traffic_area_function OWNER TO postgres;

CREATE INDEX lu_aux_traf_funct_name_inx ON citydb.lu_aux_traffic_area_function USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_AUX_TRAFFIC_AREA_SURF_MATERIAL
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_aux_traffic_area_surf_material CASCADE;
CREATE TABLE         citydb.lu_aux_traffic_area_surf_material (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_aux_traffic_area_surf_material OWNER TO postgres;

CREATE INDEX lu_aux_traf_surf_name_inx ON citydb.lu_aux_traffic_area_surf_material USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_TRAFIC_AREA_FUNCTION
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_traffic_area_function CASCADE;
CREATE TABLE         citydb.lu_traffic_area_function (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_traffic_area_function OWNER TO postgres;

CREATE INDEX lu_tra_area_funct_name_inx ON citydb.lu_traffic_area_function USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_TRAFIC_AREA_USAGE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_traffic_area_usage CASCADE;
CREATE TABLE         citydb.lu_traffic_area_usage (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_traffic_area_usage OWNER TO postgres;

CREATE INDEX lu_tra_area_usage_name_inx ON citydb.lu_traffic_area_usage USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_TRAFFIC_AREA_SURF_MATERIAL
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_traffic_area_surf_material CASCADE;
CREATE TABLE         citydb.lu_traffic_area_surf_material (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_traffic_area_surf_material OWNER TO postgres;

CREATE INDEX lu_traf_surf_name_inx ON citydb.lu_traffic_area_surf_material USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_TUNNEL_CLASS
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_tunnel_class CASCADE;
CREATE TABLE         citydb.lu_tunnel_class (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_tunnel_function_usage OWNER TO postgres;

CREATE INDEX lu_tun_class_name_inx ON citydb.lu_tunnel_class USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_TUNNEL_FUNCTION_USAGE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_tunnel_function_usage CASCADE;
CREATE TABLE         citydb.lu_tunnel_function_usage (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_tunnel_function_usage OWNER TO postgres;

CREATE INDEX lu_tun_funct_name_inx ON citydb.lu_tunnel_function_usage USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_PLANT_COVER_CLASS
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_plant_cover_class CASCADE;
CREATE TABLE         citydb.lu_plant_cover_class (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_plant_cover_class OWNER TO postgres;

CREATE INDEX lu_plcov_class_name_inx ON citydb.lu_plant_cover_class USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_PLANT_COVER_FUNCTION_USAGE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_plant_cover_function_usage CASCADE;
CREATE TABLE         citydb.lu_plant_cover_function_usage (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_plant_cover_function_usage OWNER TO postgres;

CREATE INDEX lu_plcov_funct_name_inx ON citydb.lu_plant_cover_function_usage USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_SOL_VEGETATIONOBJECT_CLASS_FUNCTION_USAGE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_sol_vegetationobject_class_function_usage CASCADE;
CREATE TABLE         citydb.lu_sol_vegetationobject_class_function_usage (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_sol_vegetationobject_class_function_usage OWNER TO postgres;

CREATE INDEX lu_sol_vegobj_class_name_inx ON citydb.lu_sol_vegetationobject_class_function_usage USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_SOL_VEGETATIONOBJECT_SPECIES
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_sol_vegetationobject_species CASCADE;
CREATE TABLE         citydb.lu_sol_vegetationobject_species (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_sol_vegetationobject_species OWNER TO postgres;

CREATE INDEX lu_sol_vegobj_species_name_inx ON citydb.lu_sol_vegetationobject_species USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_WATERBODY_CLASS
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_waterbody_class CASCADE;
CREATE TABLE         citydb.lu_waterbody_class (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_waterbody_class OWNER TO postgres;

CREATE INDEX lu_watbdy_class_name_inx ON citydb.lu_waterbody_class USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_WATERBODY_FUNCTION_USAGE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_waterbody_function_usage CASCADE;
CREATE TABLE         citydb.lu_waterbody_function_usage (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_waterbody_function_usage OWNER TO postgres;

CREATE INDEX lu_watbdy_funct_name_inx ON citydb.lu_waterbody_function_usage USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_WATER_SURF_WATER_LEVEL
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.lu_water_surf_water_level CASCADE;
CREATE TABLE         citydb.lu_water_surf_water_level (
id integer PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.lu_water_surf_water_level OWNER TO postgres;

CREATE INDEX lu_watlev_class_name_inx ON citydb.lu_water_surf_water_level USING btree (name, name_codespace);

DO
$$
BEGIN
RAISE NOTICE '

********************************

Utilities Package tables installation complete!

********************************

';
END
$$;
SELECT 'Utilities Package tables installation complete!'::varchar AS installation_result;

-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************

