import { Elysia, t } from "elysia";
import { getData, postData } from "./routes/items";

const app = new Elysia()
    .get("/", () => getData)
    .post("/", ({ body }) => postData(body), {
        body: t.Object({
            firstName: t.String(),
            lastName: t.String()
        })
    })
    .listen(8080);

console.log(
  `🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`
);
