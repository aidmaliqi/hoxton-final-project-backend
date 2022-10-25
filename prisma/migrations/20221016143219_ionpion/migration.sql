/*
  Warnings:

  - You are about to drop the `_BookToUser` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropIndex
DROP INDEX "_BookToUser_B_index";

-- DropIndex
DROP INDEX "_BookToUser_AB_unique";

-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "_BookToUser";
PRAGMA foreign_keys=on;

-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Book" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "people" INTEGER NOT NULL,
    "flightId" INTEGER NOT NULL,
    "ticketId" INTEGER,
    "userId" INTEGER,
    CONSTRAINT "Book_flightId_fkey" FOREIGN KEY ("flightId") REFERENCES "Flight" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Book_ticketId_fkey" FOREIGN KEY ("ticketId") REFERENCES "Ticket" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Book_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);
INSERT INTO "new_Book" ("flightId", "id", "people", "ticketId") SELECT "flightId", "id", "people", "ticketId" FROM "Book";
DROP TABLE "Book";
ALTER TABLE "new_Book" RENAME TO "Book";
CREATE UNIQUE INDEX "Book_ticketId_key" ON "Book"("ticketId");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
