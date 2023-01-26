pragma solidity ^0.5.0;

// Importing required contracts.
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

//Initialising the contract.
// The contract is iniatialised as a OWnable contract to inherit and grant the basic authorization control functions which simplifies the implementation of "user permissions".
contract StakingToken is ERC20, Ownable {
    // Inheriting the properties of SafeERC20 withing the contract
    using SafeMath for uint256;
    // Creating a golbal variable to hold the information about the stakeholders.
    address[] internal stakeholders;
    // Mapping stakes with respect to each stakeholder.
    mapping(address => uint256) internal stakes;
    // Mapping rewards for each stakeholder and their rewards.
    mapping(address => uint256) internal rewards;
    // Initialising a constructor for the staking Token
    //Start of the constructor.
    constructor(address _owner, uint256 _supply) public{ 
        // _owner holds the address of the constructor and _supply holds the value of number of tokens to be minted.  
        _mint(_owner, _supply);

    }// End of Constructor.
    // Start of the function createStake.
    // _stake holds the value of stake to be created. 
    function createStake(uint256 _stake) public
    {
        _burn(msg.sender, _stake);
        // If the staked amount in the users amount is equal to zero, then the user will be added using addStakeholder function.
        //addStakeholder takes the address of the user as an argument using msg.sender. 
        if(stakes[msg.sender] == 0) addStakeholder(msg.sender);
        // If the user already has his funds staked then the below code is executed to further add the stakes.
        stakes[msg.sender] = stakes[msg.sender].add(_stake);
    }// End of function createStake

    //Start of function removeStake
    // _stake holds the value of stake to be removed. 
    function removeStake(uint256 _stake) public
    {
        //The below LOC amends the cureent balance of the staked amount by substracting the staked amount from the given address from stakes[msg.sender].
        stakes[msg.sender] = stakes[msg.sender].sub(_stake);
        // If the stake is zero, we remove the stakeholder using the address passed in as an argument using msg.sender.
        if(stakes[msg.sender] == 0) removeStakeholder(msg.sender);
        _mint(msg.sender, _stake);
    }// End of removeStake function.
    //Start of function stakeOf.
    // This function is used to keep track of the stakeholders and their investments.
    // This function takes in the value of stakeholder to find the staked amount of the user. 
    function stakeOf(address _stakeholder) public view returns(uint256)
    {
        // The function returns the amount staked with respect to stakeholders. 
        return stakes[_stakeholder];
    }// End of function stakeOf.
    // Start of function totalStakes. 
    //This function is used to find the aggregated stakes from all the stakeholders.
    function totalStakes() public view returns(uint256)
    {   //Initialising the variable totalStakes as a 0
        uint256 _totalStakes = 0;
        //Start of for loop
        //Initialising a for loop to count the sum of the staked amount
        for (uint256 s = 0; s < stakeholders.length; s += 1){
            _totalStakes = _totalStakes.add(stakes[stakeholders[s]]);
        }// End of for loop
        return _totalStakes;
    }// End of totalStakes().
    // Start of function isStakeholder
    // This function is used to check/know if the user is a stakeholder. 
    function isStakeholder(address _address) public view returns(bool, uint256)
    {// Start if for loop to iterate through the list of stakeholder addresses. 
        for (uint256 s = 0; s < stakeholders.length; s += 1){
            // Start iof if clause. 
            // IF clause is used to check if the address is present in the list of the stakeholders which returns true of present. 
            if (_address == stakeholders[s]) return (true, s);
        }// End of for loop
        return (false, 0);
    } // End of isStakeholder function. 
    //Start of function addStakeholder. 
    // The use of this function  is to add anew stakeholder. 
    function addStakeholder(address _stakeholder) public {
        // Checking if the address is existing in the list of the stakeholders. 
        (bool _isStakeholder, ) = isStakeholder(_stakeholder);
        // Adding the new address as a new stakeholder if user is not present in the list using push function. 
        if(!_isStakeholder) stakeholders.push(_stakeholder);
    }// End of addStakeholder function.
     //Start iof function removeStakeholder. 
     // This function is used to remove the stakeholder/user.
    function removeStakeholder(address _stakeholder) public {
        //Checking if the stakeholder is present
        (bool _isStakeholder, uint256 s) = isStakeholder(_stakeholder);
        //Start of if clause. 
        if(_isStakeholder){
            //Checking if the stakeholder is present and removing from the list using pop()
            stakeholders[s] = stakeholders[stakeholders.length - 1];
            stakeholders.pop();
        } //End of if clause
    }//End of removeStakeholder.
    //Start of rewardOf function. 
    // This function is used by the user to check his rewards. 
    // The _stakeholder holds the address of the stakeholder to check his balance. 
    function rewardOf(address _stakeholder) public view returns(uint256)
    {// Return the rewards accumulated by the _stakeholder. 
        return rewards[_stakeholder];
    }// End of function rewardOf(). 
    // Start of totalRewards
    // This function is used to find the sum of the rewards with respect to all users/stakeholders. 
    //This functuins returns aggregated rewards from all the users.  
    function totalRewards() public view returns(uint256)
    {   //Initialised totalRewards as 0.
        uint256 _totalRewards = 0;
        //Start of iterative loop. 
        for (uint256 s = 0; s < stakeholders.length; s += 1){
            //Adding the rewards for every rewards in the stakeholders list. 
            _totalRewards = _totalRewards.add(rewards[stakeholders[s]]);
        }//End of for loop
        return _totalRewards;
    }//End of function totalRewards. 
    //Start of function calculateReward
    //This function is used to calculate the reward for each user. 
    //The _stakeholder holds the value of the stakeholder's/users address. 
    function calculateReward(address _stakeholder) public view returns(uint256)
    {
        return stakes[_stakeholder] / 100;
    } //End of calculateReward function. 
    //Start of function distributeRewards.
    //This function is used to distribute the rewards to all the users/stakeholders which can only be accessed by Owner. 

    function distributeRewards() public onlyOwner {
        //Start of for loop
        for (uint256 s = 0; s < stakeholders.length; s += 1){
            //Assigning each user to a stakehilder address in a loop. 
            address stakeholder = stakeholders[s];
            //Calculating reward for each user/stakeholder. 
            uint256 reward = calculateReward(stakeholder);
            //Adding reward to the stakeholders address. 
            rewards[stakeholder] = rewards[stakeholder].add(reward);
        }//End of for loop.
    }//End of distributeRewards function. 
    //Start of function withdrawReward
    //This function is used by stakeholders to unstake/withdraw the rewards
    function withdrawReward() public
    {
        //Assigning reward to user using rewards[address of user]. 
        uint256 reward = rewards[msg.sender];
        //Assigning rewards[address of user] as 0 to avoid iterative payments in future. 
        rewards[msg.sender] = 0;
        //transfering the tokens as rewards. 
        _mint(msg.sender, reward);
    }// End of function withdrawReward.
}// Contract End

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
