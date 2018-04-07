pragma solidity^0.4.0;
import "./NewToken.sol";
contract Banknew
{
    
    //Register contract Details
    uint eth=0.01 ether;
    struct bank_Details
    {
        string name;
        uint bal;
        uint time;
        uint loan_interst;
        uint fixed_deposit_interst;
        uint account_deposit_interst;
        uint token_count;
        uint borrow_amount;
        uint lend_amount;
    }
    
    mapping(address => bank_Details) public bank_d1;
    address[] public reg_user;
    //loan user using token
    struct loan_get_token
    {
        address bank_address;
        uint256 amount;
        uint256 lend_for_tokens;
        uint time;
        uint bal_ln;
        uint installment;
        uint256 tokens;
        uint year;
        address token_address;
        
    }
    mapping (address=>mapping(uint256=>loan_get_token))public tk_get;
    mapping(address=>uint256)public tk_get_count;
    struct loan_pro_tk
    {
        address bank_address;
        uint256 amount;
        uint time;
        uint256 tokens;
    }
    mapping (address=>mapping(uint256=>loan_pro_tk))public tk_pro;
    mapping(address=>uint256)public tk_pro_count;
    //Loan_Details contract Details
    struct loan_get
    {
        address bank_address;
        uint amount;
        uint count;
        uint last_setl_time;
        uint time;
        uint months;
        uint bal_ln;
        uint installment;
        uint id;
    }
    
    mapping (address => mapping(uint256 => loan_get)) public ln_get;
    mapping(address => uint256) public ln_get_count;
    
    struct loan_pro
    {
        address bank_address;
        uint256 amount;
        uint time;
        uint months;
    }
    
    mapping (address => mapping(uint256 => loan_pro)) public ln_pro;
    mapping(address => uint256)public ln_pro_count;

    
    //Fixed_Deposit contract Details
    struct Bank_Client
    {
        address bank_address;
        address user_address;
        uint256 amount;
        uint256 start_time;
        uint256 end_time;
        uint256 year;
        bool check;
    }

    mapping(address => mapping(address => Bank_Client)) public bank_client_Details;

    //Bank can stores the users details
    mapping(address => mapping(uint256 => address)) public bank_owner_clients;
    mapping(address => uint256) public bank_client_count;

    //User can stores the deposited bank details
    mapping(address => mapping(uint256 => address)) public my_acc_details;
    mapping(address => uint256) public my_acc_count;


    //Bank act as a Client (dep,withdraw,trans) contract Details
    struct Bank_Client_Ac
    {
        address bank_address;
        address user_address;
        uint256 amount;
    }
    
     mapping(address => mapping(address => Bank_Client_Ac)) public bank_client_ac_Details;

    //Bank can stores the users details
    mapping(address => mapping(uint256 => address)) public bank_owner_clients_ac;
    mapping(address => uint256) public bank_client_ac_count;

    //User can stores the deposited bank details
    mapping(address => mapping(uint256 => address)) public my_ac_details;
    mapping(address => uint256) public my_ac_count;




    //Register contract functions
    function register(string name, uint loan_interst, uint fixed_deposit, uint acc_dep_int) public payable returns(string)
    {
        if(bank_d1[msg.sender].time == 0)
        {
            bank_d1[msg.sender].name = name;
            bank_d1[msg.sender].loan_interst = loan_interst;
            bank_d1[msg.sender].fixed_deposit_interst = fixed_deposit;
            bank_d1[msg.sender].account_deposit_interst = acc_dep_int;
            bank_d1[msg.sender].bal = msg.value;
            bank_d1[msg.sender].time = now;
        
            reg_user.push(msg.sender);
            return "Successfully Registered";
        }
        else
        {
            return "Account Alreay Exist";
        }
    }
  
    function show_registers() public view returns(address[])
    {
        return reg_user;
    }

    
    function show_bank_detail(uint index,uint intr_type)public view returns(string bank_name,address tem_add,uint intr)
    {
        tem_add = reg_user[index];
        bank_name = bank_d1[tem_add].name;
        if(intr_type == 0)
        {
            intr = bank_d1[tem_add].loan_interst;
        }
        if(intr_type == 1)
        {
            intr = bank_d1[tem_add].fixed_deposit_interst;
        }
        if(intr_type == 2)
        {
            intr = bank_d1[tem_add].account_deposit_interst;
        }
    }


    //Bank Contract Basic functions
    modifier ch_register()
    {
        require(bank_d1[msg.sender].time != 0);
        _;
    }
   
    function deposit()  public payable ch_register
    {
        require(msg.value > 0);
        bank_d1[msg.sender].bal += msg.value;
    }
   
    function withdraw(uint256 amount) ch_register public
    {
        require(bank_d1[msg.sender].bal > amount);
        bank_d1[msg.sender].bal -= amount;
        msg.sender.transfer(amount);
    }
   
    function transfer(address to,uint256 amount) ch_register public
    {  
        require(bank_d1[msg.sender].bal > amount);
        bank_d1[to].bal += amount;
        bank_d1[msg.sender].bal -= amount; //amount transfered to other persion bank address
        //to.transfer(amount);
    }
    
    function GetBalance() ch_register public constant returns (uint256)
    {
        return bank_d1[msg.sender].bal;
    }

    function fetchBalance(address _banker) public constant returns (uint256)
    {
        return bank_d1[_banker].bal;
    }

    function isRegistered(address _bank) public constant returns (bool) {
      return bank_d1[_bank].time > 0;
    }




    //Loan_Details contract functions
    
    function req_loan(address bank_address,uint256 amt,uint8 year) public //payable
    {
        require(bank_d1[msg.sender].time!=0);
        require(bank_d1[bank_address].time!=0);
        require(bank_address!=msg.sender);
        
        require (bank_d1[bank_address].bal > amt );
            
        bank_d1[msg.sender].bal += amt;
        //msg.sender.transfer(amt);
        bank_d1[bank_address].bal -= amt;
        
        bank_d1[msg.sender].borrow_amount += amt;
        bank_d1[bank_address].lend_amount += amt;
        
        ln_get[msg.sender][ln_get_count[msg.sender]].bank_address = bank_address;
        ln_get[msg.sender][ln_get_count[msg.sender]].amount = amt;
        ln_get[msg.sender][ln_get_count[msg.sender]].months = year*12;
        ln_get[msg.sender][ln_get_count[msg.sender]].time = now;
        ln_get[msg.sender][ln_get_count[msg.sender]].last_setl_time = now;
        ln_get[msg.sender][ln_get_count[msg.sender]].installment = (amt) / (year*12);
        ln_get[msg.sender][ln_get_count[msg.sender]].bal_ln = amt;
        ln_get[msg.sender][ln_get_count[msg.sender]].id = ln_get_count[msg.sender];
        
        ln_pro[bank_address][ln_pro_count[bank_address]].bank_address = msg.sender;
        ln_pro[bank_address][ln_pro_count[bank_address]].amount = amt;
        ln_pro[bank_address][ln_pro_count[bank_address]].months = year*12;
        ln_pro[bank_address][ln_pro_count[bank_address]].time = now;
        
        ln_pro_count[bank_address]++;
        ln_get_count[msg.sender]++;
    }
    
    function settlement(uint ln_id) public
    {
        uint temp_count = ln_get[msg.sender][ln_id].count;
        uint temp_month = ln_get[msg.sender][ln_id].months;
        uint temp_bal_ln = ln_get[msg.sender][ln_id].bal_ln;
        uint temp_ins = ln_get[msg.sender][ln_id].installment;
        //uint temp_last = ln_get[msg.sender][ln_id].last_setl_time + 1 minutes; //30 days;
        address temp_bank_address = ln_get[msg.sender][ln_id].bank_address;
        
        require(temp_count < temp_month);
        //require(temp_last <= now);
        
        uint intr = bank_d1[temp_bank_address].loan_interst;
        uint amont = ( temp_bal_ln * (intr/100) ) /100;
        
        require(amont + temp_ins <= bank_d1[msg.sender].bal);
        
        bank_d1[msg.sender].bal -= amont + temp_ins;
        bank_d1[temp_bank_address].bal += amont + temp_ins;

        bank_d1[msg.sender].borrow_amount -= temp_ins;
        bank_d1[temp_bank_address].lend_amount -= temp_ins;
        
        //ln_get[msg.sender][ln_id].last_setl_time = temp_last ;//30 days;
        ln_get[msg.sender][ln_id].bal_ln -= temp_ins;
        ln_get[msg.sender][ln_id].count++;
    }




    //Fixed_Deposit contract functions
    
    function Fixed_Deposit(address bank_addr, uint256 year) public payable
    {
        require(bank_d1[bank_addr].time != 0);
        
        require( bank_client_Details[bank_addr][msg.sender].check == false );
        require(bank_addr != msg.sender);
        bank_client_Details[bank_addr][msg.sender].bank_address = bank_addr;
        bank_client_Details[bank_addr][msg.sender].user_address = msg.sender;
        bank_owner_clients[bank_addr][ bank_client_count[bank_addr] ] = msg.sender;
        bank_client_count[bank_addr]++;

        my_acc_details[msg.sender][ my_acc_count [msg.sender] ] = bank_addr;
        my_acc_count[msg.sender]++;
        
        bank_d1[bank_addr].bal += msg.value;
        
        bank_client_Details[bank_addr][msg.sender].amount = msg.value;
        bank_client_Details[bank_addr][msg.sender].start_time = now;
        bank_client_Details[bank_addr][msg.sender].end_time =now + 2 minutes;//now + (year *1 years);
        bank_client_Details[bank_addr][msg.sender].year = year;
        bank_client_Details[bank_addr][msg.sender].check = true;
        
    }

    
    function fixed_amount_get(address bank_addr) public
    {
        require( bank_client_Details[bank_addr][msg.sender].check == true );
        
        uint256 temp_amount;
        uint256 temp_interest;
        uint256 temp_int_amt;
        uint256 temp_end_time;
        uint256 temp_year;
        
        temp_year = bank_client_Details[bank_addr][msg.sender].year;
        temp_amount = bank_client_Details[bank_addr][msg.sender].amount;
        temp_interest = bank_d1[bank_addr].fixed_deposit_interst;
        temp_end_time = bank_client_Details[bank_addr][msg.sender].end_time;
        
        if ( now >= temp_end_time )
        {
            temp_int_amt = temp_amount + ( (temp_amount * temp_year * (temp_interest/100)) / 100 );
            
            require(temp_int_amt <= bank_d1[bank_addr].bal);
            
            bank_d1[bank_addr].bal -= temp_int_amt;
            msg.sender.transfer( temp_int_amt );
            
            bank_client_Details[bank_addr][msg.sender].check = false;
        }
        
        else
        {
            temp_int_amt = temp_amount - (temp_amount / 100) ;
            
            require(temp_int_amt <= bank_d1[bank_addr].bal);
            
            bank_d1[bank_addr].bal -= temp_int_amt;
            msg.sender.transfer( temp_int_amt );
            
            bank_client_Details[bank_addr][msg.sender].check = false;
        }
    }        
       
    
    
    function amount_settlement(address user_address) public
    {
        
        uint256 temp_amount;
        uint256 temp_interest;
        uint256 temp_int_amt;
        uint256 temp_end_time;
        uint256 temp_year;
        
        
        require( bank_client_Details[msg.sender][user_address].check == true );
        
        temp_end_time = bank_client_Details[msg.sender][user_address].end_time;
        require ( now >= temp_end_time );
        
        temp_year = bank_client_Details[msg.sender][user_address].year;
        temp_amount = bank_client_Details[msg.sender][user_address].amount;
        temp_interest = bank_d1[msg.sender].fixed_deposit_interst;
        
        temp_int_amt = temp_amount + ( (temp_amount * temp_year * (temp_interest / 100)) / 100 );
        
        require(temp_int_amt <= bank_d1[msg.sender].bal);
        
        bank_d1[msg.sender].bal -= temp_int_amt;
        user_address.transfer( temp_int_amt );
        
        bank_client_Details[msg.sender][user_address].check = false;
    
    }

    
    
    
    
    //Bank act as a Client (dep,withdraw,trans) contract functions

   
    function register_client(address bank_addr) public
    {
        require(bank_addr != msg.sender);
        bank_client_ac_Details[bank_addr][msg.sender].bank_address = bank_addr;
        bank_client_ac_Details[bank_addr][msg.sender].user_address = msg.sender;
        bank_owner_clients_ac[bank_addr][ bank_client_ac_count[bank_addr] ] = msg.sender;
        bank_client_ac_count[bank_addr]++;

        my_ac_details[msg.sender][ my_ac_count[msg.sender] ] = bank_addr;
        my_ac_count[msg.sender]++;
    }

    function deposit_client(address bank_addr) public payable
    {
        
        if(bank_client_ac_Details[bank_addr][msg.sender].user_address != msg.sender)
        {
            register_client(bank_addr);
        }
        
        bank_client_ac_Details [bank_addr] [msg.sender].amount += msg.value;
        bank_d1 [bank_addr].bal += msg.value;
        
    }
    
    function withdraw_client(address bank_addr, uint256 amount) public
    {
        require(bank_d1 [bank_addr].bal >= amount);
        
        //require(bank_client_Details [bank_addr] [msg.sender].user_address != msg.sender);
        //bank_d1[msg.sender].bal += amount;
        bank_client_ac_Details [bank_addr] [msg.sender].amount -= amount;
        bank_d1 [bank_addr].bal -= amount;
        msg.sender.transfer(amount);
    }
    
    function transfer_client(address bank_addr, address to, uint256 amount) public
    {
        require(bank_d1 [bank_addr].bal >= amount);
         
        //require(bank_client_Details [bank_addr] [msg.sender].user_address != msg.sender);
        //bank_d1[msg.sender].bal += amount;
        bank_client_ac_Details [bank_addr] [msg.sender].amount -= amount;
        bank_d1[bank_addr].bal -=amount;
        bank_d1[to].bal += amount;
        //to.transfer(amount);
    }
    
    
    function give_interest() public
    {
        address temp_bank_address;
        uint256 temp_amount;
        uint256 temp_interest;
        uint256 temp_int_amt;
        
        for(uint256 i=0;i<bank_client_ac_count[msg.sender];i++)
        {
            temp_bank_address = bank_owner_clients_ac[msg.sender][i];
            temp_amount = bank_client_ac_Details[msg.sender][temp_bank_address].amount;
            temp_interest = bank_d1[msg.sender].account_deposit_interst;
            
            temp_int_amt=( temp_amount * (temp_interest/100) )/100;
            
            require(temp_int_amt <= bank_d1[msg.sender].bal);
            
            bank_client_ac_Details[msg.sender][temp_bank_address].amount += temp_int_amt;
        }
    }
    //Getting loan using token as colletral
    
      function loan_req_token(address token_address,address bank_address,uint8 year,uint256 tokens)public
    {   uint256 amt = (eth * tokens);
        bank_d1[bank_address].bal-=amt;
        NewToken(token_address).transferFrom(msg.sender,bank_address,tokens);
        bank_d1[msg.sender].bal+=amt;
        tk_get[msg.sender][tk_get_count[msg.sender]].year=year;
        tk_get[msg.sender][tk_get_count[msg.sender]].bank_address = bank_address;
        tk_get[msg.sender][tk_get_count[msg.sender]].amount = amt;
        tk_get[msg.sender][tk_get_count[msg.sender]].time=now;
        tk_get[msg.sender][tk_get_count[msg.sender]].tokens=tokens;
        tk_get[msg.sender][tk_get_count[msg.sender]].installment=(amt)/(year*12);
        tk_get[msg.sender][tk_get_count[msg.sender]].bal_ln = amt;
        tk_get[msg.sender][tk_get_count[msg.sender]].token_address=token_address;
        bank_d1[msg.sender].token_count=tokens;
        tk_pro[bank_address][tk_pro_count[bank_address]].bank_address = msg.sender;
        tk_pro[bank_address][tk_pro_count[bank_address]].amount = amt;
        tk_pro[bank_address][tk_pro_count[bank_address]].tokens=tokens;
        tk_pro[bank_address][tk_pro_count[bank_address]].time=now;
        tk_pro_count[bank_address]++;
        tk_get_count[msg.sender]++;
    }
    function balanceOftoken(address token) public view returns(uint)
    {   
        return NewToken(token).balanceOf(msg.sender);
    }
  
    
}