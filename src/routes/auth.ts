import Elysia, { t } from 'elysia';
import bcrypt from 'bcryptjs';
import { ctx } from '../db';

const app = new Elysia({ name: 'Service.Auth' })
    .use(ctx)
    .post(
        '/register',
        async ({ set, body, db, cookie }) => {
            const { email, firstName, lastName, password } = body;

            // Check if user already exists
            const existingUser = await db.user.findUnique({ where: { email } });
            if (existingUser) {
                set.status = 409; // Conflict
                return { error: 'User with this email already exists.' };
            }
            // Hash the password
            const passwordHash = await bcrypt.hash(password, 10);

            // Create the new user in the database
            try {
                const user = await db.user.create({
                    data: {
                        email,
                        firstName,
                        lastName,
                        passwordHash,
                    },
                });

                set.status = 201;
                cookie.sessionToken.set({
                    value: 'your-secret-token-here',
                    httpOnly: true,
                    path: '/',
                    expires: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
                    sameSite: 'strict',
                });
                const { passwordHash: _, ...userResponse } = user;
                return {
                    message: 'User registered successfully',
                    user: userResponse,
                };
            } catch (e) {
                console.error(e);
                set.status = 500;
                return { error: 'Could not create user.' };
            }
        },
        {
            body: t.Object({
                email: t.String({ format: 'email' }),
                firstName: t.String(),
                lastName: t.String(),
                password: t.String({ minLength: 8 }),
            }),
        }
    )
    .post(
        '/login',
        async ({ body, db, cookie, set }) => {
            const { email, password } = body;

            // Find the user by email
            const user = await db.user.findUnique({ where: { email } });
            if (!user) {
                set.status = 401; // Unauthorized
                return { error: 'Invalid email or password.' };
            }

            // Compare the provided password with the stored hash
            const isPasswordValid = await bcrypt.compare(
                password,
                user.passwordHash
            );
            if (!isPasswordValid) {
                set.status = 401; // Unauthorized
                return { error: 'Invalid email or password.' };
            }

            // Create a session for the user
            const sessionToken = crypto.randomUUID();
            const expires = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000); // Session expires in 7 days

            await db.session.create({
                data: {
                    userId: user.id,
                    sessionToken,
                    expires,
                },
            });

            // Set the session token in an HTTP-only cookie
            cookie.sessionToken.set({
                value: sessionToken,
                httpOnly: true,
                path: '/',
                expires: expires,
                sameSite: 'strict',
            });

            return { message: 'Logged in successfully' };
        },
        {
            body: t.Object({
                email: t.String({ format: 'email' }),
                password: t.String({ minLength: 8 }),
            }),
        }
    )
    .post('/logout', async ({ db, cookie, set }) => {
        const sessionToken = cookie.sessionToken.value;

        if (sessionToken) {
            // Delete the session from the database
            try {
                await db.session.delete({
                    where: { sessionToken },
                });
            } catch (error) {
                // It's possible the session doesn't exist, which is fine.
                console.log(
                    'Session to delete not found, proceeding with logout.'
                );
            }
        }

        // Remove the cookie from the client
        cookie.sessionToken.remove();

        return { message: 'Logged out successfully' };
    });

export default app;
