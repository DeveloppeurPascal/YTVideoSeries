CREATE TABLE "tube" (
	"code"	INTEGER,
	"id"	TEXT NOT NULL,
	"label"	TEXT NOT NULL,
	"url"	TEXT NOT NULL,
	PRIMARY KEY("code" AUTOINCREMENT)
);

CREATE TABLE "serial" (
	"code"	INTEGER,
	"id"	TEXT NOT NULL,
	"label"	TEXT NOT NULL,
	"url"	TEXT NOT NULL,
	"comment"	TEXT NOT NULL,
	PRIMARY KEY("code" AUTOINCREMENT)
);

CREATE TABLE "serial_tube" (
	"tube_code"	INTEGER NOT NULL,
	"serial_code"	INTEGER NOT NULL,
	"url"	TEXT NOT NULL,
	"comment"	TEXT NOT NULL
);

CREATE TABLE "video" (
	"code"	INTEGER,
	"id"	TEXT NOT NULL,
	"label"	TEXT NOT NULL,
	"serial_code"	INTEGER NOT NULL,
	"order_in_serial"	INTEGER NOT NULL,
	"record_date"	TEXT NOT NULL,
	"url"	TEXT NOT NULL,
	"comment"	TEXT NOT NULL,
	PRIMARY KEY("code" AUTOINCREMENT)
);

CREATE TABLE "video_tube" (
	"tube_code"	INTEGER NOT NULL,
	"video_code"	INTEGER NOT NULL,
	"publish_date"	TEXT NOT NULL,
	"url"	TEXT NOT NULL,
	"comment"	TEXT NOT NULL
);

CREATE INDEX "tube_by_label" ON "tube" (
	"label",
	"code"
);

CREATE INDEX "serial_by_label" ON "serial" (
	"label",
	"code"
);

CREATE INDEX "link_serial_tube" ON "serial_tube" (
	"serial_code",
	"tube_code"
);

CREATE INDEX "link_tube_serial" ON "serial_tube" (
	"tube_code",
	"serial_code"
);

CREATE INDEX "video_by_label" ON "video" (
	"label",
	"code"
);

CREATE INDEX "video_by_serial_label" ON "video" (
	"serial_code",
	"label",
	"code"
);

CREATE INDEX "video_by_serial_order" ON "video" (
	"serial_code",
	"order_in_serial",
	"code"
);

CREATE INDEX "link_video_tube" ON "video_tube" (
	"video_code",
	"tube_code"
);

CREATE INDEX "link_tube_video" ON "video_tube" (
	"tube_code",
	"video_code"
);
