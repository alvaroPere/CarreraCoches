pragma solidity ^0.8.7;

import "./ownable.sol";

contract CarreraCoches is Ownable {

    struct Coche {
        address idPiloto; //address
        string modelo;
        string marca;
        string nombrePiloto;
        uint carrerasGanadas;
        uint carrerasTotales;
        uint tiempoEspera;
        uint32 nivel;
    }

    uint randNonce = 0; //para que no ejecutemos dos veces la misma función hash con los mismos parámetros de entrada    
    uint contador = 0;
    uint cooldown = 60 seconds;
    uint subirNivel = 1 ether;
    uint cambiarCocheV = 1 ether;

    Coche[] public listaCoches;

    event mostrarResultado(string ms, uint res);
    event confirmacionDepositoLleno(string ms);
    event comprobar(uint compr);
    event cochePropietario(string mo, string ma, uint32 niv, uint carrGan, uint carrTot);
    

    mapping (uint => address) public cocheDePropietario;
    mapping (address => uint) public numeroCochesPersona;

    //Solo se puede tener un coche por cuenta
    modifier restriccion() {
        require(numeroCochesPersona[msg.sender] < 1, "Solo se puede tener un coche por persona");
        _;
    }

    modifier onlyOwnerOf(uint _coche){
        require(msg.sender == cocheDePropietario[_coche]);
        _;
    }

    /*function borrarCoche(address _from) public {
        for(uint i = 0; i < listaCoches.length; i++){
            if(listaCoches[i].idPiloto == _from){
                listaCoches.pop();
            }
        }
    }*/

    function numAleatorio(uint _modulo) internal returns(uint) {
        randNonce++;
        return uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % _modulo;
    }

    //Añadir coche al array coches
    function anadirCoche(string memory _modelo, string memory _marca, string memory _nombrePiloto) public restriccion returns (uint) {
        listaCoches.push(Coche(msg.sender, _modelo, _marca, _nombrePiloto, 0, 0, uint32(block.timestamp + cooldown), 1));
        uint id = listaCoches.length;
        cocheDePropietario[id] = msg.sender;
        numeroCochesPersona[msg.sender]++;
        contador++;
        return contador - 1;
    }

    //Enfriamiento
    function _repostando(Coche storage _coche) internal {
        _coche.tiempoEspera = uint32(block.timestamp + cooldown);
    }

    //Esta listo
    function _depositoLleno(Coche storage _coche) internal view returns (bool) {
        return _coche.tiempoEspera <= block.timestamp;
    }

    function subirDeNivel(address _propietario) external payable returns(string memory) {
        require(msg.value==subirNivel);
        for(uint i = 0; i < listaCoches.length; i++){
            if(listaCoches[i].idPiloto == _propietario){
                listaCoches[i].nivel++;
                return "Ha subido de nivel";
            }
        }
    }

    function verCochePropietario(address _propietario) external {
        for(uint i = 0; i < listaCoches.length; i++){
            if(listaCoches[i].idPiloto==_propietario){
                emit cochePropietario(listaCoches[i].marca, listaCoches[i].modelo, listaCoches[i].nivel, listaCoches[i].carrerasGanadas, listaCoches[i].carrerasTotales);
            }
        }
    }

    //Puedes pagar 1 Eher para cambiar el modelo y la marca de tu coche
    function comprarCoche(address _address, string memory _newModelo, string memory _newMarca) external payable returns(string memory) {
        require(msg.sender==_address);
        require(msg.value==cambiarCocheV);
        for(uint i = 0; i < listaCoches.length; i++){
            if(listaCoches[i].idPiloto==msg.sender){
                listaCoches[i].modelo = _newModelo;
                listaCoches[i].marca = _newMarca;
            }
        }
    }

    //Mensaje de deposito vacio
    /*function _depositoVacio(Coche memory _car) public returns (string memory) {
        if(!_depositoLleno(_car)){
            return "Llenando el deposito";
        }
        

    }*/

    //A la hora de apostar, se debe hacer con Wei, para ver esa subida de precio con numeros altos
   function Apostar(uint dineroApostar) public payable returns(string memory) {
       

       if(listaCoches.length <= 1){
           emit confirmacionDepositoLleno("No hay coches suficientes para iniciar una carrera");
       }else{
            require(msg.value == dineroApostar);
            randNonce++;
            //Contra quien me enfrento
            uint256 rival = uint256(keccak256(abi.encodePacked(block.timestamp, listaCoches.length, randNonce))) % listaCoches.length;
            address addressRival = cocheDePropietario[rival];

            //Decidir quien gana
            randNonce++;
            uint numero = 100;
            uint256 ganador = uint256(keccak256(abi.encodePacked(block.timestamp, numero, randNonce))) % numero;

            for(uint i = 0; i < listaCoches.length; i++){
                
                //require(_depositoLleno(listaCoches[i]));
                if (msg.sender == listaCoches[i].idPiloto) {
                    listaCoches[i].carrerasTotales++;
                    listaCoches[rival].carrerasTotales++;
                    _repostando(listaCoches[i]);
                    if(listaCoches[rival].nivel < listaCoches[i].nivel){
                        if(ganador<=60){
                            balance();
                            listaCoches[i].carrerasGanadas++;
                            listaCoches[i].nivel++;
                            return "Has ganado";
                        }else{
                            //emit mostrarResultado("El coche ganador es: ", rival);
                            emit confirmacionDepositoLleno("El coche ganador es: ");
                            this.verCochePropietario(addressRival);
                            return "Has perdido";
                        }    
                    }else if(listaCoches[rival].nivel == listaCoches[i].nivel){
                        if(ganador<=50){
                            balance();
                            listaCoches[i].carrerasGanadas++;
                            listaCoches[i].nivel++;
                            return "Has ganado";
                        }else{
                            /*emit mostrarResultado("El coche ganador es: ", rival);*/
                            emit confirmacionDepositoLleno("El coche ganador es: ");
                            this.verCochePropietario(addressRival);
                            return "Has perdido";
                        } 
                    }else{
                        if(ganador<=40){
                            balance();
                            listaCoches[i].carrerasGanadas++;
                            listaCoches[i].nivel++;
                            return "Has ganado";
                        }else{
                            emit confirmacionDepositoLleno("El coche ganador es: ");
                            this.verCochePropietario(addressRival);
                            //emit cochePropietario(listaCoches[rival].marca, listaCoches[rival].modelo, listaCoches[rival].nivel, listaCoches[rival].carrerasGanadas, listaCoches[rival].carrerasTotales);
                            return "Has perdido";
                        } 
                    }    
                }
                
            } 
       }
   }

    //Devuelve el dinero en caso de que se gane
    function balance() private {
        payable (msg.sender).transfer(address(this).balance);
    }
}