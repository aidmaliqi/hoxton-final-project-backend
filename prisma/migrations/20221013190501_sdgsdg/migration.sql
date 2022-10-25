/*
  Warnings:

  - Made the column `ticketId` on table `Passanger` required. This step will fail if there are existing NULL values in that column.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Passanger" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "lastname" TEXT NOT NULL,
    "age" INTEGER NOT NULL,
    "gender" TEXT NOT NULL,
    "nationality" TEXT,
    "ticketId" INTEGER NOT NULL,
    CONSTRAINT "Passanger_ticketId_fkey" FOREIGN KEY ("ticketId") REFERENCES "Ticket" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_Passanger" ("age", "gender", "id", "lastname", "name", "nationality", "ticketId") SELECT "age", "gender", "id", "lastname", "name", "nationality", "ticketId" FROM "Passanger";
DROP TABLE "Passanger";
ALTER TABLE "new_Passanger" RENAME TO "Passanger";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
