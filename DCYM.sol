pragma solidity >= 0.5.0 < 0.9.0;

struct UserDetails{
    string name;
    string password;
    bool isuser;
}
struct Transaction{
    uint tid;
    int amount;
    string note;
    string time;
}
struct Contact{
    uint cid;
    string id;
    string name;
    int balance;
}

contract DCYM{
    mapping (string => UserDetails) private users;
    mapping (string => mapping (string=>Transaction[])) private trans;
    mapping (string => mapping (string=>bool)) private iscont; 
    mapping (string => Contact[]) private contact;
    uint Tid;
    uint Cid;
    function addUser(string calldata uname,string calldata uid, string calldata upassword) public returns(bool){
        UserDetails memory ud=users[uid];
        if(ud.isuser==true){
            return false;
        }else{
            ud.name=uname;
            ud.password=upassword;
            ud.isuser=true;
        }
        users[uid]=ud;
        return true;
    }
    function login(string calldata password,string calldata id) public view  returns(bool,string memory){
        UserDetails memory nud = users[id];
        if(keccak256(bytes(nud.password)) == keccak256(bytes(password))){
            if(nud.isuser==true){
                return (true,nud.name);
            }else{
                return (false,"no name");
            }
        }else{
            return (false,"no name");
        }
    }
    function addContact(string calldata _newContact,string calldata _name,string calldata id)  public returns(bool) {
        require(!iscont[id][_newContact],"Contact already Exist");
        Contact[] storage cnt = contact[id];
        Contact memory cd;
        if(users[_newContact].isuser){
            cd.name=users[_newContact].name;
        }else{
            cd.name=_name;
        }
        cd.id=_newContact;
        cd.balance=0;
        cd.cid=Cid;
        cnt.push(cd);
        iscont[id][_newContact]= true;
        Cid++;
        return true;
    }
    function getContact(string calldata id) public view returns(Contact[] memory){
        require(users[id].isuser,"this is not user");
        return contact[id];
    }
    function getTrans(string calldata id,string calldata cnt) public view returns(Transaction[] memory,Transaction[] memory){
        require(iscont[id][cnt],"first add in contact...");
        return (trans[id][cnt],trans[cnt][id]);
    }
    function addTrans(string calldata id,string calldata cnt,int _amount,string calldata _note,string calldata _time) public returns(Transaction memory){
        require(iscont[id][cnt],"first add in contact...");
        Transaction memory tra;
        tra.tid = Tid;
        tra.amount = _amount;
        tra.note=_note;
        tra.time=_time;
        trans[id][cnt].push(tra);
        Tid++;
        return tra;
    }
    function deleteTrans(string calldata id,string calldata cnt, uint _tid) public returns(bool){
        require(iscont[id][cnt],"first add in contact...");
        Transaction[] storage tra = trans[id][cnt];
        for(uint i=0;i<tra.length;i++){
            if(tra[i].tid ==_tid){
                tra[i].note="";
                tra[i].amount=0;
                return true;
            }
        } 
        return false;
    }
    function editTrans(string calldata id,string calldata cnt, uint _tid,string calldata _note,int _amount) public returns(bool){
        require(iscont[id][cnt],"first add in contact...");
        require(_amount != 0,"invalid amount");
        Transaction[] storage tra = trans[id][cnt];
        for(uint i=0;i<tra.length;i++){
            if(tra[i].tid ==_tid){
                tra[i].note=_note;
                tra[i].amount=_amount;
                return true;
            }
        } 
        return false;
    }
}
