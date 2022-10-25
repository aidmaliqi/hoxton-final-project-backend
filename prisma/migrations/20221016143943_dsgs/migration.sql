/*
  Warnings:

  - Made the column `userId` on table `Book` required. This step will fail if there are existing NULL values in that column.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Book" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "people" INTEGER NOT NULL,
    "flightId" INTEGER NOT NULL,
    "ticketId" INTEGER,
    "userId" INTEGER NOT NULL,
    CONSTRAINT "Book_flightId_fkey" FOREIGN KEY ("flightId") REFERENCES "Flight" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Book_ticketId_fkey" FOREIGN KEY ("ticketId") REFERENCES "Ticket" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Book_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_Book" ("flightId", "id", "people", "ticketId", "userId") SELECT "flightId", "id", "people", "ticketId", "userId" FROM "Book";
DROP TABLE "Book";
ALTER TABLE "new_Book" RENAME TO "Book";
CREATE UNIQUE INDEX "Book_ticketId_key" ON "Book"("ticketId");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
