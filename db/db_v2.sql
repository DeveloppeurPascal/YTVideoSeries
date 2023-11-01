ALTER TABLE "video" add "serial_code" INTEGER NOT NULL DEFAULT 0;
	
CREATE INDEX "video_by_serial_season_label" ON "video" (
	"serial_code",
	"season_code",
	"label",
	"code"
);

CREATE INDEX "video_by_serial_season_order" ON "video" (
	"serial_code",
	"season_code",
	"order_in_season",
	"code"
);

CREATE INDEX "video_by_serial_label" ON "video" (
	"serial_code",
	"label",
	"code"
);
