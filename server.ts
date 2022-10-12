import express from "express"
import cors from "cors"
import bcrypt from "bcryptjs"
import {PrismaClient} from "@prisma/client"
import jwt  from "jsonwebtoken"
import dotenv from "dotenv"
dotenv.config()

const app = express()
app.use(cors())
app.use(express.json())

const prisma = new PrismaClient()

const port = 3010

app.listen(port, () => {
    console.log(`App running: http:/localhost:${port}`);
})