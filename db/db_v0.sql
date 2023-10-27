CREATE TABLE "tube" (
	"code"	INTEGER,
	"id"	TEXT NOT NULL DEFAULT "",
	"label"	TEXT NOT NULL DEFAULT "",
	"url"	TEXT NOT NULL DEFAULT "",
	"template"	TEXT NOT NULL DEFAULT "",
	PRIMARY KEY("code" AUTOINCREMENT)
);

CREATE TABLE "serial" (
	"code"	INTEGER,
	"id"	TEXT NOT NULL DEFAULT "",
	"label"	TEXT NOT NULL DEFAULT "",
	"url"	TEXT NOT NULL DEFAULT "",
	"comment"	TEXT NOT NULL DEFAULT "",
	PRIMARY KEY("code" AUTOINCREMENT)
);

CREATE TABLE "serial_tube" (
	"tube_code"	INTEGER NOT NULL DEFAULT 0,
	"serial_code"	INTEGER NOT NULL DEFAULT 0,
	"url"	TEXT NOT NULL DEFAULT "",
	"comment"	TEXT NOT NULL DEFAULT ""
);

CREATE TABLE "season" (
	"code"	INTEGER,
	"id"	TEXT NOT NULL DEFAULT "",
	"serial_code"	INTEGER,
	"order_in_serial"	INTEGER,
	"label"	TEXT NOT NULL DEFAULT "",
	"url"	TEXT NOT NULL DEFAULT "",
	"record_date"	TEXT NOT NULL DEFAULT "",
	"comment"	TEXT NOT NULL DEFAULT "",
	PRIMARY KEY("code" AUTOINCREMENT)
);

CREATE TABLE "video" (
	"code"	INTEGER,
	"id"	TEXT NOT NULL DEFAULT "",
	"label"	TEXT NOT NULL DEFAULT "",
	"season_code"	INTEGER NOT NULL DEFAULT 0,
	"order_in_season"	INTEGER NOT NULL DEFAULT 0,
	"record_date"	TEXT NOT NULL DEFAULT "",
	"url"	TEXT NOT NULL DEFAULT "",
	"comment"	TEXT NOT NULL DEFAULT "",
	PRIMARY KEY("code" AUTOINCREMENT)
);

CREATE TABLE "video_tube" (
	"tube_code"	INTEGER NOT NULL DEFAULT 0,
	"video_code"	INTEGER NOT NULL DEFAULT 0,
	"publish_date"	TEXT NOT NULL DEFAULT "",
	"url"	TEXT NOT NULL DEFAULT "",
	"comment"	TEXT NOT NULL DEFAULT ""
);

CREATE INDEX "tube_by_label" ON "tube" (
	"label",
	"code"
);

CREATE INDEX "serial_by_label" ON "serial" (
	"label",
	"code"
);

CREATE INDEX "season_by_serial_label" ON "season" (
	"serial_code",
	"label",
	"code"
);

CREATE INDEX "season_by_serial_order" ON "season" (
	"serial_code",
	"order_in_serial",
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

CREATE INDEX "video_by_season_label" ON "video" (
	"season_code",
	"label",
	"code"
);

CREATE INDEX "video_by_season_order" ON "video" (
	"season_code",
	"order_in_season",
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
