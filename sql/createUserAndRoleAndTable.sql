-- Add user and role
CREATE USER AIM_USER IDENTIFIED BY "AiMAcce55";
GRANT CREATE SESSION TO AIM_USER;
CREATE ROLE AIM_USER_ROLE;
GRANT AIM_USER_ROLE TO AIM_USER;
GRANT CONNECT TO AIM_USER;
ALTER USER AIM_USER DEFAULT ROLE ALL;

-- Add table, primary key, and index
CREATE TABLE VBMSUI.CONTENTION_EVENT_LATEST (
    ActionName VARCHAR(4000),
    ActionResultName VARCHAR(4000),
    ActorUserId VARCHAR(4000),
    ActorApplicationId VARCHAR(4000),
    ActorStation VARCHAR(4000),
    AutomationIndicator NUMBER(1),
    BenefitClaimTypeCode VARCHAR(4000),
    ClaimId NUMBER(19),
    ContentionClassificationName VARCHAR(4000),
    ContentionId NUMBER(19),
    ContentionStatusTypeCode VARCHAR(4000),
    ContentionTypeCode VARCHAR(4000),
    CurrentLifecycleStatus VARCHAR(4000),
    DateAdded DATE,
    Details VARCHAR(4000),
    DiagnosticTypeCode VARCHAR(4000),
    EventTime TIMESTAMP,
    JournalStatusTypeCode VARCHAR(4000),
    VeteranParticipantId NUMBER(19),
    CONSTRAINT pk_contention_id PRIMARY KEY(ContentionId));
CREATE INDEX VBMSUI.CONTENTION_EVENT_LATEST_CLAIMID_IDX ON VBMSUI.CONTENTION_EVENT_LATEST (ClaimId);

-- Grant all table privledges to role.
GRANT SELECT, UPDATE, DELETE, INSERT ON VBMSUI.CONTENTION_EVENT_LATEST TO AIM_USER_ROLE;


--Remove user, role, and table
DROP USER AIM_USER CASCADE;
DROP ROLE AIM_USER_ROLE;
DROP TABLE VBMSUI.CONTENTION_EVENT_LATEST;