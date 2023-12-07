public type User readonly & record {|
    readonly string id;
    string email;
    string password;
|};