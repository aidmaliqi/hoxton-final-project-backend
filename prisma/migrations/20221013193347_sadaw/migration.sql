-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Book" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "people" INTEGER NOT NULL,
    "flightId" INTEGER,
    "ticketId" INTEGER,
    CONSTRAINT "Book_flightId_fkey" FOREIGN KEY ("flightId") REFERENCES "Flight" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Book_ticketId_fkey" FOREIGN KEY ("ticketId") REFERENCES "Ticket" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);
INSERT INTO "new_Book" ("flightId", "id", "people", "ticketId") SELECT "flightId", "id", "people", "ticketId" FROM "Book";
DROP TABLE "Book";
ALTER TABLE "new_Book" RENAME TO "Book";
CREATE UNIQUE INDEX "Book_ticketId_key" ON "Book"("ticketId");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
