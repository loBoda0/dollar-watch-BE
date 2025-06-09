import { Elysia, t } from 'elysia';
import authRoutes from './routes/auth';
import { postTransaction } from './routes/transactions';

const app = new Elysia()
    .use(authRoutes)
    .derive(async ({ db, cookie, set }) => {
        const sessionToken = cookie.sessionToken.value;
        if (!sessionToken) {
            set.status = 401;
            return {
                user: null,
                error: 'Unauthorized: No session token provided.',
            };
        }

        // Find the session in the database
        const session = await db.session.findUnique({
            where: { sessionToken },
            include: { user: true },
        });

        if (!session || session.expires < new Date()) {
            cookie.sessionToken.remove();
            set.status = 401;
            return {
                user: null,
                error: 'Unauthorized: Invalid or expired session.',
            };
        }

        const { passwordHash, ...user } = session.user;
        return { user };
    })
    .post('/', ({ user, error, query: { wee }, body: { text } }) => {
        if (!user) {
            return error || 'Unauthorized';
        } else {
            console.log(user)
            return postTransaction(text, wee);
        }
    }, {
        body: t.Object({
            text: t.Any()
        })
    })
    .listen(8080);

console.log(
    `🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`
);
