BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "token_logs" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "tokenCount" bigint NOT NULL,
    "estimatedCost" double precision NOT NULL,
    "apiCallType" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- ACTION ALTER TABLE
--
ALTER TABLE "users" ADD COLUMN "totalTokenCount" bigint NOT NULL DEFAULT 0;

--
-- MIGRATION VERSION FOR eloquim
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('eloquim', '20260126225156339', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260126225156339', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20251208110333922-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110333922-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260109031533194', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260109031533194', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251208110412389-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110412389-v3-0-0', "timestamp" = now();


COMMIT;
