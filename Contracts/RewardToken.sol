pragma solidity ^0.8.4;
//Importing required contracts
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/591c12d22de283a297e2b551175ccc914c938391/contracts/token/ERC20/ERC20.sol";
// This is a simple smartcontract for Reward tokens. 
//Start of contract
contract RewardToken is ERC20 {
    //Initialising the constructor.
    constructor(string memory _name, string memory _symbol)
    ERC20(_name,_symbol)
    {
        // Empty constructor.
    }
    //Start of function
    function mint(address _user, uint256 _amount) public {
        _mint(_user, _amount);
        }//End of function
    
}// End of contract
/* 
        |------------         |-----------------|           |--------------
        |                     |                 |           |
        |                     |                 |           |   
        |                     |                 |           |
        |                     |                 |           |
        |------------         |                 |           |---------------
        |                     |                 |           |           
        |                     |                 |           |               
        |                     |                 |           |           
        |                     |                 |           | 
        |-------------        |-----------------|           |


*/