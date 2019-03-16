pragma solidity >=0.4.24; 

import "../openzeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol";
import "../openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";
import "../openzeppelin-solidity/contracts/ownership/Ownable.sol"; 

contract DogToken is ERC721BasicToken, Ownable {

    struct Dog
    {
        address owner;
        string name;
        uint Id;
        string breed;
        uint age;
        uint weight;
    }

    string public name;
    string public ticker;
    uint incrementId;

    mapping(address => bool) breeder;
    address[] public breederList;

    Dog[] public DogList;


    constructor() public { 
        ticker = "DOG"; 
        name = "DogToken";
        owner = msg.sender;  
        incrementId = 1
        ;
    }

    function RegisterBreeder(address addr) public {
        require(msg.sender == owner);
        require(breeder[addr] == false);
        
        breeder[addr] = true;
        breederList.push(addr);
    }

    function declareAnimal(address Owner, string Name, string Breed, uint Age, uint Weight) public {
        Dog memory Dogo;
        Dogo.owner = Owner;
        Dogo.name = Name;
        Dogo.breed = Breed;
        Dogo.age = Age;
        Dogo.weight = Weight;
        Dogo.Id = incrementId;

        incrementId ++;
        DogList.push(Dogo);
        //emit Transfer(msg.sender, msg.sender, Dogo.Id);
    }

    function findIndexDog(uint IdDog) private returns (uint){
 
        for(uint j = 0; j<DogList.length; j++)
        {
            if(DogList[j].Id == IdDog){
                return j;
            }
        }
        return 0;
    }

    function deadAnimal(uint deadDogId) public {
        uint index = findIndexDog(deadDogId);
        if (index == 0){
            require (DogList[index].owner == msg.sender);
            for (uint i = index; i<DogList.length-1; i++){
                DogList[i] = DogList[i+1];
            }
            delete DogList[DogList.length-1];
            DogList.length--;

        }
        else{
            //emit Transfer(msg.sender,msg.sender, deadDogId);
        }
    }

    function compareStrings (string memory a, string memory b) public view returns (bool) {
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }


    function breedAnimal(uint IdDog1, uint IdDog2, string namePuppy, uint weightPuppy) public{

        uint Index1 = findIndexDog(IdDog1);
        uint Index2 = findIndexDog(IdDog2);
        
        string breed1 = DogList[Index1].breed;
        string breed2 = DogList[Index2].breed;
        string memory breedPuppy = " ";

        if(compareStrings(breed1, breed2) == true){
            breedPuppy = breed1;
        } else {
            breedPuppy = "Bastard";
        }
        
        declareAnimal(msg.sender, namePuppy, breedPuppy, 0, weightPuppy);
    }
}