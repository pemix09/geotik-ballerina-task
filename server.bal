import ballerina/http;
import geotik_task.userModule;

//simple dependency inversion
var userRepo = new userModule:UserRepo();
var userService = new userModule:UserService(userRepo);
var authService = new userModule:AuthService(userRepo);

service / on new http:Listener(9090) {
    resource function get users() returns userModule:User[] {
        return userService.getAllUsers();
    }

    resource function get users/[string id]() returns userModule:User? {
        return userService.getById(id);
    }

    resource function post users(@http:Payload userModule:User user) returns http:Ok|http:InternalServerError {
        userService.addUser(user);

        http:Ok ok = {body: "User created successfully"};
        return ok;
    }

    resource function post users/resetPassword(@http:Payload userModule:ResetPasswordRequest req) returns http:Accepted|http:BadRequest {
        var ret = userService.resetPassword(req.email);

        if (ret is error) {
            return http:BAD_REQUEST;
        }

        return http:ACCEPTED;
    }

    resource function post auth/login(@http:Payload userModule:LoginRequest req) returns http:Ok|http:Unauthorized {
        var ret = authService.login(req.email, req.password);

        if (ret is error) {
            return http:UNAUTHORIZED;
        }

        return http:OK;
    }
}
