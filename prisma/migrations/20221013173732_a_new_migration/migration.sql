/*
  Warnings:

  - You are about to drop the column `ticketId` on the `Passanger` table. All the data in the column will be lost.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Passanger" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "lastname" TEXT NOT NULL,
    "age" INTEGER NOT NULL,
    "gender" TEXT NOT NULL
);
INSERT INTO "new_Passanger" ("age", "gender", "id", "lastname", "name") SELECT "age", "gender", "id", "lastname", "name" FROM "Passanger";
DROP TABLE "Passanger";
ALTER TABLE "new_Passanger" RENAME TO "Passanger";
CREATE TABLE "new_Ticket" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "passangerId" INTEGER,
    "bookId" INTEGER NOT NULL,
    "userId" INTEGER,
    CONSTRAINT "Ticket_bookId_fkey" FOREIGN KEY ("bookId") REFERENCES "Book" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Ticket_passangerId_fkey" FOREIGN KEY ("passangerId") REFERENCES "Passanger" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Ticket_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);
INSERT INTO "new_Ticket" ("bookId", "id", "userId") SELECT "bookId", "id", "userId" FROM "Ticket";
DROP TABLE "Ticket";
ALTER TABLE "new_Ticket" RENAME TO "Ticket";
CREATE UNIQUE INDEX "Ticket_passangerId_key" ON "Ticket"("passangerId");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
