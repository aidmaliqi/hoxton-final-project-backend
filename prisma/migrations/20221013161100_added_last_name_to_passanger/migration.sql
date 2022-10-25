/*
  Warnings:

  - Added the required column `lastname` to the `Passanger` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Passanger" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "lastname" TEXT NOT NULL,
    "age" INTEGER NOT NULL,
    "gender" TEXT NOT NULL,
    "ticketId" INTEGER,
    CONSTRAINT "Passanger_ticketId_fkey" FOREIGN KEY ("ticketId") REFERENCES "Ticket" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);
INSERT INTO "new_Passanger" ("age", "gender", "id", "name", "ticketId") SELECT "age", "gender", "id", "name", "ticketId" FROM "Passanger";
DROP TABLE "Passanger";
ALTER TABLE "new_Passanger" RENAME TO "Passanger";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
