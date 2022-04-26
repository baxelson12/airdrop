// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @author no-op.eth
/// @title Airdrop
contract Airdrop is ERC1155, Ownable {
  /** Name of collection */
  string public constant name = "One Fine Airdrop";
  /** Symbol of collection */
  string public constant symbol = "OFA";
  /** URI for the contract metadata */
  string public contractURI;

  /** Token URIs where i == tokenId */
  string[] private uris_;
  /** # of tokens */
  uint256 private supply_ = 0;

  constructor() ERC1155("") {}

  /// @notice Sets the token URI
  /// @param _val The new URI
  function setTokenURI(uint256 _id, string memory _val) external onlyOwner {
    require(_id < uris_.length, "Out of bounds.");
    uris_[_id] = _val;
  }

  /// @notice Sets the contract metadata URI
  /// @param _val The new URI
  function setContractURI(string memory _val) external onlyOwner {
    contractURI = _val;
  }

  /// @notice Returns a given token's URI
  /// @param _id Token ID
  function uri(uint256 _id) public view override returns (string memory) {
    return uris_[_id];
  } 

  /// @notice Creates a new token to be airdropped.
  /// @param _uri The token URI
  function createToken(string memory _uri) external onlyOwner {
    uris_.push(_uri);
    supply_++;
  }

  /// @notice Airdrops given artwork id to list of receivers
  /// @param _receivers The wallet addresses to send to
  /// @param _ids The NFT IDs to send.
  /// @param _quantities The amount of NFTs to send
  /// @param _datas 0x0000
  /// @dev Array indexes correspond to the wallet index in receivers
  function airdrop(
    address[] calldata _receivers,
    uint256[] calldata _ids,
    uint256[] calldata _quantities,
    bytes[] calldata _datas
  ) external onlyOwner {
    uint256 _len = _receivers.length;
    require(_len == _quantities.length, "Quantities should have equal length to receivers.");
    require(_len == _ids.length, "IDs should have equal length to receivers");
    require(_len == _datas.length, "Datas should have equal length to receivers");

    for (uint256 i = 0; i < _len; i++) {
      _mint(_receivers[i], _ids[i], _quantities[i], _datas[i]);
    }
  }

  /// @notice Recover any lost funds
  function withdraw() external onlyOwner {
    payable(msg.sender).transfer(address(this).balance);
  }
}