/* Schema for MolPro Project SQLite DB */

PRAGMA foreign_keys=ON;
BEGIN TRANSACTION;
	CREATE TABLE project(
		prefix 		VARCHAR(26) NOT NULL,
		serial 		CHAR(7) NOT NULL DEFAULT ( SUBSTR('0000000' || ABS(RANDOM() % 9999999), -7) ),
		parent_prefix 	VARCHAR(26) DEFAULT NULL,
		parent_serial 	CHAR(7) DEFAULT NULL,
		started 	INT NOT NULL DEFAULT CURRENT_TIMESTAMP,
		ended 		INT,
		client_id 	INT,
		description 	VARCHAR(255),
		hidden 		INT NOT NULL DEFAULT 1,
		hide_client 	INT NOT NULL DEFAULT 1,
		hide_dates	INT NOT NULL DEFAULT 1,
		PRIMARY KEY (prefix, serial),
		CONSTRAINT parentpj_fk FOREIGN KEY (parent_prefix, parent_serial) REFERENCES project(prefix, serial) ON DELETE SET NULL,
		CHECK(
			LENGTH(serial == 7)		-- Serial length is 7 chars exactly
		)
	);

	CREATE TABLE sibling_project (
		prefix1 	VARCHAR(26) NOT NULL,
		serial1 	INT NOT NULL,
		prefix2 	VARCHAR(26) NOT NULL,
		serial2 	INT NOT NULL,
		UNIQUE(prefix1, serial1, prefix2, serial2),
		CONSTRAINT project1_fk FOREIGN KEY (prefix1, serial1) REFERENCES project(prefix, serial) ON DELETE CASCADE,
		CONSTRAINT project2_fk FOREIGN KEY (prefix2, serial2) REFERENCES project(prefix, serial) ON DELETE CASCADE
	);

	CREATE TABLE cost (
		pj_prefix 	VARCHAR(26) NOT NULL,
		pj_serial 	INT NOT NULL,
		citem_id 	INT NOT NULL,
		quantity 	REAL NOT NULL,
		UNIQUE(pj_prefix, pj_serial, citem_id),
		CONSTRAINT cproject_fk FOREIGN KEY (pj_prefix, pj_serial) REFERENCES project(prefix, serial) ON DELETE CASCADE,
		CONSTRAINT citem_fk FOREIGN KEY (citem_id) REFERENCES cost_item(citem_id)
	);
	
	CREATE TABLE cost_item (
		citem_id 	INT NOT NULL,
		name 		VARCHAR(255) NOT NULL,
		unit_cost 	REAL NOT NULL,
		unit_size 	REAL NOT NULL,
		unit_size_units TEXT NOT NULL,
		PRIMARY KEY (citem_id)
	);
COMMIT;
