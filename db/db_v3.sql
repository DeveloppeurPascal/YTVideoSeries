ALTER TABLE "tube" add "tpl_label" TEXT NOT NULL DEFAULT "";
ALTER TABLE "tube" add "tpl_comment" TEXT NOT NULL DEFAULT "";
ALTER TABLE "tube" add "tpl_keyword" TEXT NOT NULL DEFAULT "";
update tube set tpl_comment=template;
ALTER TABLE "serial" add "keyword" TEXT NOT NULL DEFAULT "";
ALTER TABLE "serial_tube" add "keyword" TEXT NOT NULL DEFAULT "";
ALTER TABLE "season" add "keyword" TEXT NOT NULL DEFAULT "";
ALTER TABLE "season_tube" add "keyword" TEXT NOT NULL DEFAULT "";
ALTER TABLE "video" add "keyword" TEXT NOT NULL DEFAULT "";
ALTER TABLE "video_tube" add "keyword" TEXT NOT NULL DEFAULT "";