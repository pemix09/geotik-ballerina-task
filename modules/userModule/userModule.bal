final table<User> key(id) users = table [
        {id: "1", email: "klejno.przemyslaw@gmail.com", password: "123456"},
        {id: "2", email: "jon@doe.com", password: "0987654321"},
        {id: "3", email: "alice@grace.com", password: "qwerty"}
    ];

public class UserRepo {

    public function getAllUsers() returns User[] {
        return users.toArray();
    }

    public function getById(string id) returns User? {
        return users[id];
    }

    public function addUser(User user) {
        users.add(user);
    }

    public function getByEmail(string email) returns User? {
        var foundUsers = users.filter(user => user.email == email).toArray();

        if (foundUsers.length() > 0) {
            return foundUsers[0];
        }

        return null;
    }
}

public class UserService {
    final UserRepo userRepo;

    public function init(UserRepo userRepo) {
        self.userRepo = new UserRepo();
    }
    public function getAllUsers() returns User[] {
        return self.userRepo.getAllUsers();
    }

    public function getById(string id) returns User? {
        return self.userRepo.getById(id);
    }

    public function addUser(User user) {
        self.userRepo.addUser(user);
    }

    public function resetPassword(string email) returns error? {
        var user = self.userRepo.getByEmail(email);

        if (user == null) {
            return error("User not found");
        }
    }
}

public class AuthService {
    final UserRepo userRepo;

    public function init(UserRepo userRepo) {
        self.userRepo = new UserRepo();
    }

    public function login(string email, string password) returns error? {
        var user = self.userRepo.getByEmail(email);

        if (user == null) {
            return error("Invalid email");
        }

        if (user.password != password) {
            return error("Invalid password");
        }
    }
}
