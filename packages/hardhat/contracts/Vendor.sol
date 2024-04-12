pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT


import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";


contract Vendor is Ownable {
  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address seller, uint256 amountOfTokens, uint256 amountOfETH);

  using SafeERC20 for IERC20;

  IERC20 public yourToken;
  uint public tokensPerEth = 100; 
  constructor(address tokenAddress) {
    yourToken = IERC20(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:
  function buyTokens() payable public {
    require(msg.value > 0, "You need to send some Ether");
    uint256 amountOfTokens = msg.value * tokensPerEth;
    IERC20(yourToken).safeTransfer(msg.sender, amountOfTokens);
    emit BuyTokens(msg.sender, msg.value, amountOfTokens);
  }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  function withdraw() public onlyOwner(){
     (bool success, ) = payable(owner()).call{value: address(this).balance}("");
      require(success, "Payment failed.");
  }

  // ToDo: create a sellTokens(uint256 _amount) function:
  function sellTokens(uint256 _amount) public {
    uint256 eth = _amount / tokensPerEth ;
    require(yourToken.balanceOf(msg.sender) >= _amount, "You do not have enough tokens");
    yourToken.safeTransferFrom(msg.sender, address(this), _amount);
    (bool success, ) = payable(msg.sender).call{value: eth}("");
    require(success, "Payment failed.");
    emit SellTokens(msg.sender, _amount, eth);
   
  }
}
