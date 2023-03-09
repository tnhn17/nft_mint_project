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


    constructor () ERC721("NFT Name", "SYMBOL") {
        // base OPFS URI of the NFTs
        baseUri = "ipfs://xxxxxxxxxxxxxxxxxxxxxxxxxxxxx/";
        for (uint256 i= 1; i <= TOKENS_RESERVED; ++i) {   // ne kadar token rezerve edildi
            _safeMint(msg.sender, i);
        }
        totalSupply = TOKENS_RESERVED;
    }
    
        function mint(uint256 _numTokens) external payable {
        require(isSaleActive, "The sale is paused"); // isSaleActive False olursa satış durur fonksiyonu durdurur
        require(_numTokens <= MAX_MINT_PER_TX, "You can only mint a maximum of 10 NFTs per transaction");  // En fazla 10 tane üretilebilir 
        require(mintedPerWallet[msg.sender] + _numTokens <= 10, "You can only mint 10 per wallet."); // cüzdan başına 10 tane
        uint256 curTotalSupply = totalSupply;
        require(curTotalSupply + _numTokens <= MAX_TOKENS , "Exceeds 'MAX_TOKENS'"); 
        require(_numTokens * price <= msg.value, "Unsufficient funds you need more ETH!"); // Yetersiz ETH 


        for (uint256 i = 1; i <= _numTokens; ++i) {
            _safeMint(msg.sender, curTotalSupply + i);
        }
        mintedPerWallet[msg.sender] += _numTokens;
        totalSupply += _numTokens;
    }


        function flipSaleState() external onlyOwner{
        isSaleActive = !isSaleActive;  // Satışın durmasını sadece kontrat sahibi gerçekleştirebilir
    }

    function setBaseURI(string memory _baseUri) external onlyOwner { 
        baseUri = _baseUri;  // URI(kaynağı ve dosyaları benzersiz bir şekilde tanımlamamızı sağlar ve bu fonksiyon sayesinde değişimlerde bulunabiliriz)
    }

    function setPrice(uint256 _price) external onlyOwner {
        price = _price;  // fiyatı güncelleyebileceğimiz fonksiyon ( sadece kontrat sahibi)
}


}
