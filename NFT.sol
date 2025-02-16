// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721URIStorage {
    constructor() ERC721("pookie homelander", "Oi Omelander") {
        owner = msg.sender;
    }

    uint public TokenCount;
    address owner;
    uint public maximumtoken = 100;
    uint public mintFee = 0.002 ether;
    mapping(uint => address) public tokenowner;
    mapping(address => uint) public tokensperuser;

    modifier Onlyowner() {
        require(msg.sender == owner, "Not accessible");
        _;
    }

    function GiveownerAccess(address newowner) external Onlyowner {
        owner = newowner;
    }

    function setMintPrice(uint256 newPrice) external Onlyowner {
        mintFee = newPrice;
    }

    function MintNFT(
        address _to,
        string calldata uriId
    ) external payable returns (uint _newtoken) {
        require(TokenCount < maximumtoken);
        require(msg.value == mintFee);
        TokenCount += 1;
        _safeMint(_to, TokenCount);
        _setTokenURI(_newtoken, uriId);
        tokenowner[_newtoken] = msg.sender;
        tokensperuser[_to] += 1;

        (bool success, ) = payable(owner).call{value: msg.value}("");
        require(success, "Payment to owner failed");
        return TokenCount;
    }
}
