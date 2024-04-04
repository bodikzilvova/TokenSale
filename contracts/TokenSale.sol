// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenSale is Ownable {
    IERC20 public token;
    uint256 public tokenPrice;
    uint256 public saleStartTime;
    uint256 public saleEndTime;
    uint256 public tokensSold;
    uint256 public maxTokensPerWallet;
    address payable public wallet;

    mapping(address => uint256) public purchasedTokens;

    event TokenPurchased(address indexed buyer, uint256 amount, uint256 value);

    constructor(
        address _token,
        uint256 _tokenPrice,
        uint256 _saleDuration,
        uint256 _maxTokensPerWallet,
        address payable _wallet
    ) Ownable(msg.sender) {
        token = IERC20(_token);
        tokenPrice = _tokenPrice;
        saleStartTime = block.timestamp;
        saleEndTime = saleStartTime + _saleDuration;
        maxTokensPerWallet = _maxTokensPerWallet;
        wallet = _wallet;
    }

    modifier saleOpen() {
        require(
            block.timestamp >= saleStartTime && block.timestamp <= saleEndTime,
            "Sale is not open"
        );
        _;
    }

    modifier saleNotEnded() {
        require(block.timestamp <= saleEndTime, "Sale has ended");
        _;
    }

    function buyTokens(uint256 _tokenAmount)
        external
        payable
        saleOpen
        saleNotEnded
    {
        require(_tokenAmount > 0, "Amount have to be more than 0");
        require(msg.value == _tokenAmount * tokenPrice, "Incorect ETH value");

        uint256 totalTokenPurchased = purchasedTokens[msg.sender] +
            _tokenAmount;
        require(
            totalTokenPurchased <= maxTokensPerWallet,
            "Exceeds max tokens per wallet"
        );

        uint256 tokensAvailable = token.balanceOf(address(this));
        require(
            tokensAvailable >= _tokenAmount,
            "Not enough tokens available for purchase"
        );

        token.transfer(msg.sender, _tokenAmount);
        purchasedTokens[msg.sender] = totalTokenPurchased;
        tokensSold = tokensSold + _tokenAmount;
        wallet.transfer(msg.value);

        emit TokenPurchased(msg.sender, _tokenAmount, msg.value);
    }

    function setTokenPrice(uint256 _newPrice) external onlyOwner {
        tokenPrice = _newPrice;
    }

    function withdrawTokens(uint256 _amount) external onlyOwner {
        uint256 tokensAvailable = token.balanceOf(address(this));
        require(
            tokensAvailable >= _amount,
            "Not enough tokens available for withdrawal"
        );
        token.transfer(owner(), _amount);
    }

    function withdrawETH() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
