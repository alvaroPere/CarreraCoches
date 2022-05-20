pragma solidity ^0.8.7;

import "./principal.sol";
import "./erc721.sol";

contract CocheToken is CarreraCoches, ERC721 {

    mapping (uint => address) confirmarTransferencia;
    
    function balanceOf(address _owner) public override view returns (uint256 _balance) {
        return numeroCochesPersona[_owner];
    }

    function ownerOf(uint256 _tokenId) public override view returns (address _owner) {
        return cocheDePropietario[_tokenId];
    }

    function _transfer(address _from, address _to, uint256 _tokenId) private {
        numeroCochesPersona[_to]++;
        numeroCochesPersona[_from]--;
        cocheDePropietario[_tokenId] == _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function transfer(address _to, uint256 _tokenId) public override onlyOwnerOf(_tokenId) {
        _transfer(msg.sender, _to, _tokenId);
    }

    function approve(address _to, uint256 _tokenId) public override onlyOwnerOf(_tokenId) {
        confirmarTransferencia[_tokenId] = _to;
        emit Approval(msg.sender, _to, _tokenId);
    }

    function takeOwnership(uint256 _tokenId) public override {
        require(confirmarTransferencia[_tokenId] == msg.sender);
        address propietario = ownerOf(_tokenId);
        _transfer(propietario, msg.sender, _tokenId);
    }

}