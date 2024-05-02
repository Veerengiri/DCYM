pragma solidity >=0.7.0 <0.9.0;

contract SSIP2023 {
    address public admin = 0x9504d7994A79a769641016164e5689213158aEbd;
    struct User{
        string name;
        string email;
        string mobileNo;
        string date;
    }
    struct Officer{
        string name;
        string email;
        string mobileNo;
        string date;
    }
    struct Document{
        int256 DocId;
        string hash;
        string DocNumber;
        string Type;
        address Officer;
    }
    int256 private DocIdMain = 1;
    mapping(address => Officer) private officers;
    mapping(address => User) private users;
    mapping(string => Document ) private documents;
    mapping(address => Document[] ) private OfficerDoc;
    // string types[]= ;

    // ADMIN PORTAL
    modifier onlyAdmin() {
        require(admin==msg.sender,"Invalid Admin");
        _;
    }
    function assignOfficer(address ofcr,string memory name,string memory email, string memory date, string memory mobileNo) external onlyAdmin{
        require(bytes(officers[ofcr].name).length == 0, "Officer Already Exists");
        officers[ofcr]=Officer(name,email,mobileNo,date);
    }
    
    
    // OFFICER PORTAL
    modifier onlyRegisteredOfficer() {
        require(bytes(officers[msg.sender].name).length != 0, "Invalid Officer");
        _;
    }
    function addDocument(string memory hash,string memory DocNumber,string memory Type) external onlyRegisteredOfficer {
        require(bytes(documents[DocNumber].hash).length == 0, "Document Already Exists");
        documents[DocNumber]=Document( DocIdMain,hash,DocNumber,Type,msg.sender );
        OfficerDoc[msg.sender].push(Document( DocIdMain,hash,DocNumber,Type,msg.sender ));
        DocIdMain++;
    }
    function changeDocument(string memory DocNumber, string memory _hash ) external onlyRegisteredOfficer{
        require(documents[DocNumber].Officer==msg.sender,"UnOthorized Officer");
        documents[DocNumber].hash=_hash;
    }
    function getDocumentOfficer() view external onlyRegisteredOfficer returns (Document[] memory){
        return OfficerDoc[msg.sender];
    }
    function getOfficer() view external returns(bool) {
        if(bytes(officers[msg.sender].name).length > 0){
            return true;
        }else{
            return false;
        }
    }

    // USER PORTAL
    function VerifyDocument(string memory DocNumber) view external returns(string memory) {
        require(bytes(documents[DocNumber].hash).length > 0,"No Document Exists");
        return (documents[DocNumber].hash);
    }
    function addUser(string memory name,string memory mobileNo, string memory email,string memory date) external {
        require(bytes(users[msg.sender].email).length == 0,"User Already Registerd");
        users[msg.sender]=User(name,email,mobileNo,date);
    }
    function getUser() view external returns (User memory) {
        return users[msg.sender];
    }
    
}
