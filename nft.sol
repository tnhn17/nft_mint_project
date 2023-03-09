// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721, Ownable {

    using Strings for uint256;
    uint256 public constant MAX_TOKENS = 10000;     // tüm token miktarı
    uint256 private constant TOKENS_RESERVED = 5;   // rezerve tokenler
    uint256 public price = 80000000000000000;       // token ücreti
    uint256 public constant MAX_MINT_PER_TX = 10;   // zorunluluk

    bool public isSaleActive;
    uint256 public totalSupply;
    mapping(address => uint256) private mintedPerWallet;

    string public baseUri;
    string public baseExtension = ".json";
