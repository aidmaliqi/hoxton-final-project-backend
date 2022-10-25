import express from "express";
import cors from "cors";
import bcrypt from "bcryptjs";
import { PrismaClient } from "@prisma/client";
import jwt from "jsonwebtoken";
import dotenv from "dotenv";
dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

const prisma = new PrismaClient();

const port = 3011;

const SecretCode = process.env.SecretCode!;

function getToken(id: number) {
  return jwt.sign({ id: id }, SecretCode, {
    expiresIn: "24h",
  });
}

async function getCurrentUser(token: string) {
  const data = jwt.verify(token, SecretCode);
  const user = await prisma.user.findUnique({
    //@ts-ignore
    where: { id: data.id },
    include: {  books: { include: { flight: true } },
    ticket: { include: { flight: true, passanger: true } }, },
  });
  return user;
}

app.post("/sign-in", async (req, res) => {
  const data = {
    email: req.body.email,
    password: req.body.password,
  };

  try {
    const user = await prisma.user.findUnique({
      where: { email: data.email },
      include: {
        books: { include: { flight: true } },
        ticket: { include: { flight: true, passanger: true } },
      },
    });

    if (user && bcrypt.compareSync(data.password, user.password)) {
      res.send({ user: user, token: getToken(user.id) });
    } else {
      res
        .status(404)
        .send({ error: "The email/password you entered is wrong!" });
    }
  } catch (error) {
    //@ts-ignore
    res.status(404).send({ error: error.message });
  }
});

app.post("/sign-up", async (req, res) => {
  const data = {
    name: req.body.name,
    email: req.body.email,
    password: bcrypt.hashSync(req.body.password),
    age: req.body.age,
  };

  try {
    const checkUser = await prisma.user.findUnique({
      where: { email: data.email },
    });
    if (checkUser) {
      res.status(400).send({ error: "This email alredy exists" });
    }

    const user = await prisma.user.create({
      data: {
        name: data.name,
        email: data.email,
        password: data.password,
        age: data.age,
      },
      include: {
        books: true,
        ticket: true,
      },
    });
    res.send({ user: user, token: getToken(user.id) });
  } catch (error) {
    //@ts-ignore
    res.status(404).send({ error: error.message });
  }
});

app.get("/validate", async (req, res) => {
  try {
    if (req.headers.authorization) {
      const user = await getCurrentUser(req.headers.authorization);
      //@ts-ignore
      res.send({ user: user, token: getToken(user.id) });
    }
  } catch (error) {
    //@ts-ignore
    res.status(400).send({ error: error.message });
  }
});
app.get("/user", async (req, res) => {
  try {
    //@ts-ignore
    const user = await getCurrentUser(req.headers.authorization);
    //@ts-ignore
    res.send(user);
  } catch (error) {
    //@ts-ignore
    res.status(400).send({ error: error.message });
  }
});

app.post("/all-flights", async (req, res) => {
  try {
    console.log(req.body);
    const flights = await prisma.flight.findMany({
      where: {
        departure: req.body.departure,
        destination: req.body.destination,
        departure_time: req.body.departure_time,
        class: req.body.class,
        seats: { gte: req.body.people },
      },
    });
    res.send(flights);
  } catch (error) {
    //@ts-ignore
    res.status(404).send({ error: error.message });
  }
});

app.get("/user", async (req, res) => {
  try {
    //@ts-ignore
    const user = await getCurrentUser(req.headers.authorization);

    res.send(user);
  } catch (error) {
    //@ts-ignore
    res.status(404).send({ error: error.message });
  }
});
app.get("/users", async (req, res) => {
  const users = await prisma.user.findMany();
  res.send(users);
});

app.patch("/flights/:id", async (req, res) => {
  try {
    //@ts-ignore
    const user1 = await getCurrentUser(req.headers.authorization);

    const books = await prisma.flight.update({
      where: { id: Number(req.params.id) },
      data: {
        books: {
          create: {
            people: req.body.people,
            user: { connect: { email: user1?.email } },
          },
        },
      },
    });

    res.send(books);
  } catch (error) {
    //@ts-ignore
    res.status(404).send({ error: error.message });
  }
});

app.patch("/tickets/:id", async (req, res) => {
  try {
    //@ts-ignore
    const user1 = await getCurrentUser(req.headers.authorization);
    const book1 = await prisma.book.findUnique({
      where: { id: Number(req.params.id) },
    });
    const tickets = await prisma.user.update({
      data: {
        ticket: {
          create: {
            book: {
              connect: { id: Number(req.params.id) },
            },
            passanger: {
              create: {
                age: req.body.age,
                name: req.body.name,
                lastname: req.body.lastname,
                gender: req.body.gender,
                nationality: req.body.nationality,
              },
            },
            flight: { connect: { id: book1?.flightId } },
          },
        },
      },
      where: {
        email: user1?.email,
      },
    });

    if (Number(book1?.people) >= 0) {
      const books = await prisma.user.update({
        where: {
          email: user1?.email,
        },
        data: {
          books: {
            update: {
              where: { id: Number(req.params.id) },
              data: {
                people: { decrement: 1 },
              },
            },
          },
        },
      });
    } else {
      const books = await prisma.book.delete({
        where: {
          id: Number(req.params.id),
        },
      });
    }
    res.send(tickets);
  } catch (error) {
    //@ts-ignore
    res.status(404).send({ error: error.message });
  }
});

app.listen(port, () => {
  console.log(`App running: http:/localhost:${port}`);
});
