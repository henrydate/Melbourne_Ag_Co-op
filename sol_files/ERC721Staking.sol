pragma solidity ^0.5.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

//The Contract is built to be compatible with ERC721 and ERC20 Tokens
// The contract ERC20Staking avoids the most common problem of reentrancy and can pause the functionality is remediation is pending.
// The contract is iniatialised aas a OWnable contract to inherit and grant the basic authorization control functions which simplifies the implementation of "user permissions".
contract ERC721Staking is Ownable, ReentrancyGaurd, Pausable {
    // Inheriting the properties of SafeERC20 withing the contract
    using SafeERC20 for IERC20;
    // ERC20 token which will be redistributed to owners as a dividen
    IERC20 public immutable rewardToken;
    // ERC721 Token which will be used to buy the property.
    IERC721 public immutable coinCollection;
    //Declaring a constant which holds the number of seconds in a hour
    uint256 constant SECONDS_PER_HOUR = 3600;
    //Creating a Struct which holds the buy/staking details of the users
    struct Staker {
        //Creating a variable which stores the array of TokenId's staked by the users.
        unit256[] stakedTokenIds;
        // Creating the variable which shows the number of Tokens which are not claimed by the user
        uint256 unclaimedRewards;
        // Creating a variable which holds the timestamp of last update of the rewards
        uint256 timeOfLastUpdate;
    }// End of Struct
    // Creating a variable to hold the number of tokens accured per hour.
    uint256 private rewardsPerHour = 100000;
    // Mapping buyers/stakers to theie buying/staking info.
    mapping(address => Staker) public stakers;
    // Mapping Token ID to staker Address
    mapping(uint256=> address) public stakerAddress;
    // Creating a variable which holds the Array of stakers/buyers address
    address[] public stakersArray;
    // Cfreating a constructor to initialise ERC20 and ERC721 Interfaces. 
    constructor(IERC721 _coinCollection, IERC20 _rewardToken){
        //parameter _coinCollection holds the address iof the ERC721 collection
        coinCollection = _coinCollection;
        // parameter _rewardToken holds the address of ERC20 Reward Tokens
        rewardToken = _rewardToken;
    }// End of constructor
    // Creating a function to stake/buy ERC721 Tokens
    // Parameter _tokenIDs holds the information of the array of Token IDs to stake
    // Clause whenNotPaused helps the modifier throw when the contract is paused by calling pause function
    function stake(uint256[] calldata _tokenIds) external whenNotPaused {
        // Using storage to hold the data between the function calls.
        Staker storage staker = stakers[msg.sender];
        // Writing a if-else statement to stake.
        if (staker.stakedTokenIds.length > 0) {
            // Updating the rewards and returning a message to sender if the number of stakedTokenIDs are morethan 0
            updateRewards(msg.sender);
        } // End of if statement
        else {
            // Sending a message to staker of the length of staked TokenIds are less then 0 and updating the timestamp of the block
            stakersArray.push(msg.sender);
            staker.timeOfLastUpdate = block.timestamp;
        }// End of Else block
        // Creating a variable which holds the length of number of TokenIds
        uint256 len = _tokenIds.length;
        //Using a iterative for loop
        for (uint256 i; i < len; ++i) {
            // passing in a require condition(For better Error Handeling)
            require(
                // If the user isnt the owner of token, a "Can't stake tokens you don't own!" message is sent to the user.
                //If the user is the owner of the Token the information the condition is fuilfilled and moves on to next step.
                coinCollection.ownerOf(_tokenIds[i]) == msg.sender,
                "Can't stake tokens you don't own!"
            );// End of require statement
            // If theuser is the  owner of the Token, the token will be transferred from users address to the DAO address for the purpose of staking. 
            coinCollection.transferFrom(msg.sender, address(this), _tokenIds[i]);
            // appending _tokenIds[i] to a dynamic storage array at the end
            staker.stakedTokenIds.push(_tokenIds[i]);
            stakerAddress[_tokenIds[i]] = msg.sender;
        }// End of for loop
    } // Function End

    // Start of Withdraw Function
    // The function withdraw is used to sell or withdraw the funds from the project
    //The functioin uses the inherent data from the _tokenIds and the clause nonReentrant avoids withdrawing multiple times by allowing user to use this function call only once  per address. 
    function withdraw(uint256[] calldata _tokenIds) external nonReentrant {
        // Using storage to hold the data between the function calls.
        Staker storage staker = stakers[msg.sender];
        // Adding a require statement to check if the number of tokens owned by user are greater than 0.
        // if not a error message stating that "You have no tokens staked" is displayed to the user.
        require(
            staker.stakedTokenIds.length > 0,
            "You have no tokens staked"
        );// End of require 
        //Updating the user rewards by passing in the user address.
        updateRewards(msg.sender);
        // Creating a variable lenToWithdraw which holds the length of the array _tokenIds
        uint256 lenToWithdraw = _tokenIds.length;
        // Initialising a for loop
        for (uint256 i; i < lenToWithdraw; ++i) {
            //Verifying that the tokens are stakednusing a require statement
            require(stakerAddress[_tokenIds[i]] == msg.sender);
            // Creating a variable to hold the number of tokens staked.
            uint256 lenStakedTokens = staker.stakedTokenIds.length;
            // Initialising a for loop
            for (uint256 j; j < lenStakedTokens; ++j) {
                // Initialising a if loop which checks if staker.stakedTokenIds[j] is in the array of _tokenIds
                if (staker.stakedTokenIds[j] == _tokenIds[i]) {
                    // If the abopve condition is satisfied the below statements are executed which are is used when the last element of the array is to be removed in any dynamic array.
                    staker.stakedTokenIds[staker.stakedTokenIds.length - 1] = staker.stakedTokenIds[j];
                    staker.stakedTokenIds.pop();
                    break;
                }// End of if loop
            }//End of for loop
            // Deleting the user address of token from the array of tokenIds
            delete stakerAddress[_tokenIds[i]];
            // Transfering the unstaked tokens to  the user's address
            coinCollection.transferFrom(address(this), msg.sender, _tokenIds[i]);
        }// End of for loop
        //Initialising a if statement to check if the numberof staked tokens are equal to 0
        if (staker.stakedTokenIds.length == 0) {
            // Initialising a for loop once the above condition is satisfied
            for (uint256 i; i < stakersArray.length; ++i) {
                // Initialising a if loop to check if the stakersArray[i] is equal to msg.sender
                if (stakersArray[i] == msg.sender) {
                    // If the above condition is satisfied the below statements are executed which are used when the last element of the array is to be removed in any dynamic array.
                    stakersArray[i] = stakersArray[stakersArray.length - 1];
                    stakersArray.pop();
                    break;
                }// End of if loop
            }// End of for loop
        }// End of if loop
    }// End of Withdraw function

    // Start of function claimRewards
    // Function claimRewards is used to claim the accured ERC20 tokens
    function claimRewards() external {
        // Using storage to hold the data between the function calls.
        Staker storage staker = stakers[msg.sender];
        // Creating a  variable rewards  which is a combination of calculating unclaimed rewards and calculate rewards function
        uint256 rewards = calculateRewards(msg.sender) + staker.unclaimedRewards;
        // Using a require function to check if the rewards is greater than 0
        // If the reward is equal to 0, a error message is thrown stating that "You have no rewards to claim".
        require(rewards > 0, "You have no rewards to claim");
        // Updating the timeOfLastUpdate varaible.
        staker.timeOfLastUpdate = block.timestamp;
        // Setting the unclaimedRewards to 0 as user claimed his rewards. 
        staker.unclaimedRewards = 0;
        // Transfering the rewards to the users address. 
        rewardsToken.safeTransfer(msg.sender, rewards);

    }// End of function claimRewards
    // Start of function setRewardsPerHour
    // This function is used to set the reward tokens accrued per hour
    function setRewardsPerHour(uint256 _newValue) public onlyOwner {
        // _newValue holds the new value of the rewards per hour
        address[] memory _stakers = stakersArray;
        //Creating a len variable to store the length of _stakers
        uint256 len = _stakers.length;
        // Initialising a for loop
        for (uint256 i; i < len; ++i) {
            // Updating the rewards for the stakers
            updateRewards(_stakers[i]);
        }// End of for loop
        // Assigning _newValue to rewardsPerHour to update it with the current reward. 
        rewardsPerHour = _newValue;
    }// End of function
    // Start of function userStakeInfo
    // This function is used to provide info the the user about the Tokens staked and the available rewards.
    function userStakeInfo(address _user) public view returns (uint256[] memory _stakedTokenIds, uint256 _availableRewards)
    {
        // The parameter _stakedTokenIds holds the array of TokenIds staked by the user.
        // _availableRewards holds the value of rewards available with respect to the number of tokens staked.
        return (stakers[_user].stakedTokenIds, availableRewards(_user));
    } // End of function






    


}