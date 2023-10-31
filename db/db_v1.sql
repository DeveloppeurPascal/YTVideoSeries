CREATE TABLE "season_tube" (
	"tube_code" INTEGER NOT NULL DEFAULT 0,
	"season_code" INTEGER NOT NULL DEFAULT 0,
	"url" TEXT NOT NULL DEFAULT "",
	"label" TEXT NOT NULL DEFAULT "",
	"comment" TEXT NOT NULL DEFAULT ""
);

ALTER TABLE "video_tube" add "label" TEXT NOT NULL DEFAULT "";
	
ALTER TABLE "video_tube" add "embed" TEXT NOT NULL DEFAULT "";

ALTER TABLE "serial_tube" add "label" TEXT NOT NULL DEFAULT "";

CREATE INDEX "link_season_tube" ON "season_tube" (
	"season_code",
	"tube_code"
);

CREATE INDEX "link_tube_season" ON "season_tube" (
	"tube_code",
	"season_code"
);
