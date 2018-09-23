pragma solidity ^0.4.24;

import "./SafeMath.sol";
import "./EIP20Interface.sol";


contract QcityToken is EIP20Interface {
    using SafeMath for uint256;
    uint256 constant private MAX_UINT256 = 2**256 - 1;
    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowed;

string public name;                 
    uint8 public decimals;          
    string public symbol;           

    constructor(
        string _name,
        string _sym,
        uint256 _initAmt,
        uint8 _decimal
    ) public {
        balances[msg.sender] = _initAmt;               
        totalSupply = _initAmt;                        
        name = _name;                                  
        decimals = _decimal;                           
        symbol = _sym;                               
    
        emit Transfer(address(0), msg.sender, totalSupply);        
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_to != 0x0);
        require(balances[msg.sender] >= _value);
        //balances[msg.sender] -= _value;
        balances[msg.sender] = balances[msg.sender].sub(_value);
        //balances[_to] += _value;
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value); 
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        uint256 allowance = allowed[_from][msg.sender];
        require(balances[_from] >= _value && allowance >= _value);
        //balances[_to] += _value;
        balances[_to] = balances[_to].add(_value);
        //balances[_from] -= _value;
        balances[_from] = balances[_from].sub(_value);
        if (allowance < MAX_UINT256) {
            //allowed[_from][msg.sender] -= _value;
            allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        }
        emit Transfer(_from, _to, _value); 
        return true;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value); 
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
}
