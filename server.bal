import ballerina/http;

type User readonly & record {|
    readonly string id;
    string email;
    string password;
|};

type ResetPasswordRequest readonly & record {|
    string email;
|};

type LoginRequest readonly & record {|
    string email;
    string password;
|};

table<User> key(id) users = table [
    {id: "1", email: "klejno.przemyslaw@gmail.com", password: "123456"},
    {id: "2", email: "jon@doe.com", password: "0987654321"},
    {id: "3", email: "alice@grace.com", password: "qwerty"}
];

service / on new http:Listener(9090) {
    resource function get users() returns User[] {
        return users.toArray();
    }

    resource function get users/[string id]() returns User? {
        return users[id];
    }

    resource function post users(User user) returns http:Ok|http:InternalServerError {
        users.add(user);

        http:Ok ok = {body: "User created successfully"};
        return ok;
    }

    resource function post users/resetPassword(ResetPasswordRequest req) returns http:Accepted|http:BadRequest {
        var filteredUsers = users.filter(user => user.email == req.email);

        if (filteredUsers.length() == 0) {
            return http:BAD_REQUEST;
        }

        return http:ACCEPTED;
    }

    resource function post auth/login(LoginRequest req) returns http:Ok|http:Unauthorized {
        var filteredUsers = users.filter(user => user.email == req.email && user.password == req.password);

        if (filteredUsers.length() == 0) {
            return http:UNAUTHORIZED;
        }

        return http:OK;
    }
}
