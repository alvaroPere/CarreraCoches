pragma solidity ^0.8.7;

import "./principal.sol";

contract LevelCoches is CarreraCoches {

    modifier nivelAlcanzado(uint _nivel, uint _coche) {
        require(listaCoches[_coche].nivel >= _nivel);
        _;
    }

    function cambiarCoche(uint _coche, string memory _newModelo, string memory _newMarca) external nivelAlcanzado(10, _coche) {
        require(msg.sender==cocheDePropietario[_coche]);
        listaCoches[_coche].modelo = _newModelo;
        listaCoches[_coche].marca = _newMarca;
    }

}