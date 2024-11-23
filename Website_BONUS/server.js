const express = require("express");
const app = express();
const session = require('express-session');
app.set("view engine", "ejs");
app.use(express.urlencoded({ extended: false }));
app.use(session({
    secret: "secret",
    resave: false,
    saveUninitialized: false
}));

app.use(express.static('public'));

const flash = require("express-flash");

const pool = require("./databaseConfig");
app.use(flash());
app.get("/users/register", (req, res) => {
    res.render("register");

});

app.post("/users/backtodashboard", (req, res) => {
    console.log("Returning to dashboard");
    res.render("dashboard");
})

app.get("/users/dashboard", async (req, res) => {
    try {
       
        const query = `SELECT table_name, column_name, data_type
                       FROM information_schema.columns
                       WHERE table_schema = 'public'
                       ORDER BY table_name, column_name;`;
        const result = await pool.query(query);
        

        res.render("dashboard", { rows: result.rows });
    } catch (error) {
        console.error("Error fetching schema data:", error);
        req.flash('error', "Failed to fetch schema data.");
        res.redirect("/");
    }
});


app.post("/users/login", (req, res) => {
    console.log("Enter the login");
    let {LoginEmail, password} = req.body;
    console.log(LoginEmail)
    pool.query(
        `select * from UserAuthentication where email = $1`, [LoginEmail], (err, results) => {
            if(err)
                throw err;

            if(results.rows.length > -1){
                const  userName= results.rows[0];
                const useid = results.rows[1];
                const email = results.rows[2];
                console.log(email);
                res.render("dashboard", { userName, useid, LoginEmail });


            }
            else    res.redirect("/users/login");




        }
    )
})





app.post("/users/register", (req, res) => {

    let { firstname, lastname, gender, phonenumber, age, username, email, password } = req.body;
    let errors = [];

    console.log(errors);

    if (errors.length > 0) {
        res.render("register", { errors });

    } else {

        pool.query(
            `select * from UserAuthentication where email = $1`, [email], (err, results) => {
                if (err) {
                    throw err;
                }
                console.log(results.rows);
                let userid = Math.floor(Math.random() * 1000000).toString().padStart(6, '0');
                console.log(userid);
                pool.query(`Insert into UserAuthentication values($1, $2, $3, $4)`, [username, userid, email, password], (err, results) => {
                    if (err) {
                        throw err
                    }
       
                })

                pool.query(`Insert into UserProfile values ($1, $2, $3, $4, $5, $6)`, [userid, firstname, lastname, gender, phonenumber, age], (err2, results2) => {
                    if(err2){
                        throw err2;
                    }
                })            

                req.flash('success', "Registeration Done.")
                res.redirect("/users/login");             



            }
        )






    }




});

app.get("/users/dashboard", (req, res) => {
    res.render("dashboard", { user: "yashwanth" });

});

app.get("/users/login", (req, res) => {
    res.render("login");

});

app.get("/", (req, res) => {
    res.render("login");

});

app.post("/query", async (req, res) => {
    const { sqlQuery } = req.body;
    console.log(sqlQuery);

    try {
        const result = await pool.query(sqlQuery);
        res.render("queryResult", { title: sqlQuery, rows: result.rows });
    } catch (error) {
        console.error("Error executing SQL query:", error);
        req.flash('error', "Error executing SQL query.");
        res.redirect("/dashboard");
    }
});


app.listen(3000, () => {
    console.log("Localhost: 3000 Running");
});
