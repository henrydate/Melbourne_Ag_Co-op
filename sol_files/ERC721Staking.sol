pragma solidity ^0.5.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

//The Contract is built ti be cimpatible with ERC721 and ERC20 Tokens
// The contract ERC20Staking avoinds the most common problem of reentrancy and can pause the functionality is remediation is pending. 
contract ERC721Staking is Ownable, ReentrancyGaurd, Pausable {
    // Inheriting the properties of SafeERC20 withing the contract
    using SafeERC20 for IERC20;

    IERC20 public immutable rewardsToken

}