import { Elysia } from 'elysia';
import { PrismaClient } from '@prisma/client';

export const ctx = new Elysia().decorate('db', new PrismaClient());
