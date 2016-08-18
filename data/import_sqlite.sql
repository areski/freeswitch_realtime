PRAGMA foreign_keys=OFF;

BEGIN TRANSACTION;

CREATE TABLE channels (
   uuid  VARCHAR(256),
   direction  VARCHAR(32),
   created  VARCHAR(128),
   created_epoch  INTEGER,
   name  VARCHAR(1024),
   state  VARCHAR(64),
   cid_name  VARCHAR(1024),
   cid_num  VARCHAR(256),
   ip_addr  VARCHAR(256),
   dest  VARCHAR(1024),
   application  VARCHAR(128),
   application_data  VARCHAR(4096),
   dialplan VARCHAR(128),
   context VARCHAR(128),
   read_codec  VARCHAR(128),
   read_rate  VARCHAR(32),
   read_bit_rate  VARCHAR(32),
   write_codec  VARCHAR(128),
   write_rate  VARCHAR(32),
   write_bit_rate  VARCHAR(32),
   secure VARCHAR(64),
   hostname VARCHAR(256),
   presence_id VARCHAR(4096),
   presence_data VARCHAR(4096),
   accountcode VARCHAR(256),
   callstate  VARCHAR(64),
   callee_name  VARCHAR(1024),
   callee_num  VARCHAR(256),
   callee_direction  VARCHAR(5),
   call_uuid  VARCHAR(256),
   sent_callee_name  VARCHAR(1024),
   sent_callee_num  VARCHAR(256),
   initial_cid_name  VARCHAR(1024),
   initial_cid_num  VARCHAR(256),
   initial_ip_addr  VARCHAR(256),
   initial_dest  VARCHAR(1024),
   initial_dialplan  VARCHAR(128),
   initial_context  VARCHAR(128)
, campaign_id INTEGER, used_gateway_id INTEGER, user_id INTEGER);

INSERT INTO "channels" VALUES('e5f6b9cd-393e-4751-857b-HVN5KprtdMMn','outbound','2016-08-03 17:16:15',1470237375,'sofia/external/0034650787234723','CS_CONSUME_MEDIA','','1234564678','','0034650787234723',NULL,NULL,'','default','PCMU','8000','64000','PCMU','8000','64000',NULL,'test-elixir-deploy','','','','EARLY','Outbound Call','0034650787234723',NULL,'e5f6b9cd-393e-4751-857b-15f571b56c6f','','','','1234564678','','0034650787234723','','default',1,2,3);
INSERT INTO "channels" VALUES('e5f6b9cd-393e-4751-857b-HVN5KprtdMMn','outbound','2016-08-03 17:16:15',1470237375,'sofia/external/003465078724444','CS_CONSUME_MEDIA','','1234564678','','003465078724444',NULL,NULL,'','default','PCMU','8000','64000','PCMU','8000','64000',NULL,'test-elixir-deploy','','','','EARLY','Outbound Call','003465078724444',NULL,'e5f6b9cd-393e-4751-857b-15f571b56c6f','','','','1234564678','','003465078724444','','default',2,2,3);
INSERT INTO "channels" VALUES('e5f6b9cd-393e-4751-857b-HVN5KprtdMMn','outbound','2016-08-03 17:16:15',1470237375,'sofia/external/0034650787200000','CS_CONSUME_MEDIA','','1234564678','','0034650787200000',NULL,NULL,'','default','PCMU','8000','64000','PCMU','8000','64000',NULL,'test-elixir-deploy','','','','EARLY','Outbound Call','0034650787200000',NULL,'e5f6b9cd-393e-4751-857b-15f571b56c6f','','','','1234564678','','0034650787200000','','default',2,5,3);
INSERT INTO "channels" VALUES('e5f6b9cd-393e-4751-857b-HVN5KprtdMMn','outbound','2016-08-03 17:16:15',1470237375,'sofia/external/003465078721111','CS_CONSUME_MEDIA','','1234564678','','003465078721111',NULL,NULL,'','default','PCMU','8000','64000','PCMU','8000','64000',NULL,'test-elixir-deploy','','','','EARLY','Outbound Call','003465078721111',NULL,'e5f6b9cd-393e-4751-857b-15f571b56c6f','','','','1234564678','','003465078721111','','default',1,5,3);
INSERT INTO "channels" VALUES('e5f6b9cd-393e-4751-857b-15f571b56c6f','outbound','2016-08-03 17:16:15',1470237375,'sofia/external/0034650784355','CS_CONSUME_MEDIA','','1234564678','','0034650784355',NULL,NULL,'','default','PCMU','8000','64000','PCMU','8000','64000',NULL,'test-elixir-deploy','','','','EARLY','Outbound Call','0034650784355',NULL,'e5f6b9cd-393e-4751-857b-15f571b56c6f','','','','1234564678','','0034650784355','','default',3,4,1);
INSERT INTO "channels" VALUES('e5f6b9cd-393e-4751-857b-HVN5KprtdMMn','outbound','2016-08-03 17:16:15',1470237375,'sofia/external/0034650787200011','CS_CONSUME_MEDIA','','1234564678','','0034650787200011',NULL,NULL,'','default','PCMU','8000','64000','PCMU','8000','64000',NULL,'test-elixir-deploy','','','','EARLY','Outbound Call','0034650787200011',NULL,'e5f6b9cd-393e-4751-857b-15f571b56c6f','','','','1234564678','','0034650787200011','','default',2,5,3);
INSERT INTO "channels" VALUES('e5f6b9cd-393e-4751-857b-HVN5KprtdMMn','outbound','2016-08-03 17:16:15',1470237375,'sofia/external/003465078721122','CS_CONSUME_MEDIA','','1234564678','','003465078721122',NULL,NULL,'','default','PCMU','8000','64000','PCMU','8000','64000',NULL,'test-elixir-deploy','','','','EARLY','Outbound Call','003465078721122',NULL,'e5f6b9cd-393e-4751-857b-15f571b56c6f','','','','1234564678','','003465078721122','','default',1,5,3);
INSERT INTO "channels" VALUES('e5f6b9cd-393e-4751-857b-15f571b56c6f','outbound','2016-08-03 17:16:15',1470237375,'sofia/external/0034650784388','CS_CONSUME_MEDIA','','1234564678','','0034650784388',NULL,NULL,'','default','PCMU','8000','64000','PCMU','8000','64000',NULL,'test-elixir-deploy','','','','EARLY','Outbound Call','0034650784388',NULL,'e5f6b9cd-393e-4751-857b-15f571b56c6f','','','','1234564678','','0034650784388','','default',3,4,1);

CREATE INDEX channels1 on channels(hostname);
CREATE INDEX chidx1 on channels (hostname);
CREATE INDEX uuindex on channels (uuid, hostname);
CREATE INDEX uuindex2 on channels (call_uuid);
CREATE INDEX channels_campaign_id on channels (campaign_id);
CREATE INDEX channels_used_gateway_id on channels (used_gateway_id);
CREATE INDEX channels_user_id on channels (user_id);

COMMIT;
