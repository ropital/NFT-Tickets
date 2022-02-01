pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./Base64.sol";

contract RopiNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private currentId;
    bool public saleIsActive = false;
    uint256 public totalTickets = 10;
    uint256 public availableTickets = 10;

    mapping(address => uint256[]) public holderTokenIDs;

    constructor() ERC721("RopiNFT", "RNFT") {
        currentId.increment();
    }

    function mint() public {
        require(availableTickets > 0, "Not enough tickets");

        string[3] memory svg;
        svg[
            0
        ] = '<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><text y="50">';
        svg[1] = Strings.toString(currentId.current());
        svg[2] = "</text></svg>";

        string memory image = string(abi.encodePacked(svg[0], svg[1], svg[2]));
        string memory encodedImage = Base64.encode(bytes(image));

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{ "name": "NFTix #',
                        Strings.toString(currentId.current()),
                        '", "description": "A NFT-powered ticketing system", ',
                        '"traits": [{ "trait_type": "Checked In", "value": "false" }, { "trait_type": "Purchased", "value": "true" }], ',
                        '"image": "data:image/svg+xml;base64,',
                        encodedImage,
                        '" }'
                    )
                )
            )
        );

        string memory tokenURI = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        _safeMint(msg.sender, currentId.current());
        _setTokenURI(currentId.current(), tokenURI);

        currentId.increment();
        availableTickets = availableTickets - 1;
    }

    function availableTicketsCount() public view returns (uint256) {
        return availableTickets;
    }

    function totalTicketsCount() public view returns (uint256) {
        return totalTickets;
    }

    function openSale() external {
        saleIsActive = true;
    }

    function closeSale() external {
        saleIsActive = false;
    }
}
