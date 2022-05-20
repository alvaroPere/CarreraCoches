pragma solidity ^0.8.7;

abstract contract ERC721 {
  event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
  event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);

  function balanceOf(address _owner) public virtual view returns (uint256 _balance);
  function ownerOf(uint256 _tokenId) public virtual view returns (address _owner);
  function transfer(address _to, uint256 _tokenId) public virtual;
  function approve(address _to, uint256 _tokenId) public virtual;
  function takeOwnership(uint256 _tokenId) public virtual;

    /*event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    function balanceOf(address _owner) external virtual view returns (uint256);
    function ownerOf(uint256 _tokenId) external virtual view returns (address);
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) external virtual payable;
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external virtual payable;
    function transferFrom(address _from, address _to, uint256 _tokenId) external virtual payable;
    function approve(address _approved, uint256 _tokenId) external virtual payable;
    function setApprovalForAll(address _operator, bool _approved) external virtual;
    function getApproved(uint256 _tokenId) external virtual view returns (address);
    function isApprovedForAll(address _owner, address _operator) external virtual view returns (bool);*/

}
