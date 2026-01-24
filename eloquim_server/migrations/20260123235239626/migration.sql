BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "conversations" (
    "id" bigserial PRIMARY KEY,
    "type" text NOT NULL DEFAULT 'p2p'::text,
    "title" text,
    "participantIds" json NOT NULL,
    "startedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastMessageAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "chemistryScore" double precision,
    "status" text NOT NULL DEFAULT 'active'::text
);

-- Indexes

CREATE INDEX "conversations_last_message_idx" ON "conversations" USING btree ("lastMessageAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "emoji_mappings" (
    "id" bigserial PRIMARY KEY,
    "personaId" bigint NOT NULL,
    "emojiSequence" text NOT NULL,
    "canonicalText" text NOT NULL,
    "contextTags" json NOT NULL,
    "usageCount" bigint NOT NULL DEFAULT 0,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "emoji_mappings_persona_idx" ON "emoji_mappings" USING btree ("personaId", "emojiSequence");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "messages" (
    "id" bigserial PRIMARY KEY,
    "conversationId" bigint NOT NULL,
    "senderId" bigint NOT NULL,
    "emojiSequence" json NOT NULL,
    "rawIntent" text,
    "translatedText" text NOT NULL,
    "tone" text NOT NULL DEFAULT 'casual'::text,
    "personaUsed" text NOT NULL,
    "confidenceScore" double precision NOT NULL DEFAULT 0.0,
    "mediaGifUrl" text,
    "replyToMsgId" bigint,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deliveredAt" timestamp without time zone,
    "readAt" timestamp without time zone,
    "isEncrypted" boolean NOT NULL DEFAULT false
);

-- Indexes
CREATE INDEX "messages_conversation_idx" ON "messages" USING btree ("conversationId", "createdAt");
CREATE INDEX "messages_sender_idx" ON "messages" USING btree ("senderId", "createdAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "personas" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "creatorId" bigint,
    "isOfficial" boolean NOT NULL DEFAULT false,
    "description" text NOT NULL,
    "traitsJson" text NOT NULL,
    "communicationStyle" text NOT NULL,
    "packVersion" text NOT NULL DEFAULT '1.0'::text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "personas_official_idx" ON "personas" USING btree ("isOfficial");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "users" (
    "id" bigserial PRIMARY KEY,
    "username" text NOT NULL,
    "email" text,
    "gender" text,
    "age" bigint,
    "country" text,
    "personaId" bigint,
    "emojiSignature" text NOT NULL DEFAULT '✨🎵💫'::text,
    "hasDoneTutorial" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastSeen" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "isAnonymous" boolean NOT NULL DEFAULT true
);

-- Indexes
CREATE INDEX "users_last_seen_idx" ON "users" USING btree ("lastSeen");
CREATE INDEX "users_email_idx" ON "users" USING btree ("email");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "emoji_mappings"
    ADD CONSTRAINT "emoji_mappings_fk_0"
    FOREIGN KEY("personaId")
    REFERENCES "personas"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "messages"
    ADD CONSTRAINT "messages_fk_0"
    FOREIGN KEY("conversationId")
    REFERENCES "conversations"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "messages"
    ADD CONSTRAINT "messages_fk_1"
    FOREIGN KEY("senderId")
    REFERENCES "users"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "personas"
    ADD CONSTRAINT "personas_fk_0"
    FOREIGN KEY("creatorId")
    REFERENCES "users"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "users"
    ADD CONSTRAINT "users_fk_0"
    FOREIGN KEY("personaId")
    REFERENCES "personas"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR eloquim
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('eloquim', '20260123235239626', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260123235239626', "timestamp" = now();

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
