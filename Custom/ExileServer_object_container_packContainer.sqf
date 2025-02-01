/**
 * ExileServer_object_container_packContainer
 *
 * Exile Mod
 * exile.majormittens.co.uk
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 


fnc_handleVehicleDestroyed = {
    params ["_vehicle"];
  
    private _cargo = _vehicle getVariable ["R3F_LOG_objets_charges", []];
    if (count _cargo > 0) then {
        
        private _position = getPosATL _vehicle;

        
        {
            
            private _offset = [random 16 - 8, random 16 - 8, 0]; 
            private _cratePos = _position vectorAdd _offset;

            
            private _crateType = typeOf _x; 
            private _crate = createVehicle [_crateType, _cratePos, [], 0, "CAN_COLLIDE"];
            _crate setPosATL _cratePos; 

            
            clearItemCargoGlobal _crate;
            clearWeaponCargoGlobal _crate;
            clearMagazineCargoGlobal _crate;
            clearBackpackCargoGlobal _crate;

            
            private _itemCargo = getItemCargo _x;
            if (count (_itemCargo select 0) > 0) then {
                {
                    private _item = _x;
                    private _count = (_itemCargo select 1) select _forEachIndex;
                    if (_item != "" && _count > 0) then {
                        _crate addItemCargoGlobal [_item, _count];
                    };
                } forEach (_itemCargo select 0);
            };

            
            private _weaponCargo = getWeaponCargo _x;
            if (count (_weaponCargo select 0) > 0) then {
                {
                    private _weapon = _x;
                    private _count = (_weaponCargo select 1) select _forEachIndex;
                    if (_weapon != "" && _count > 0) then {
                        _crate addWeaponCargoGlobal [_weapon, _count];
                    };
                } forEach (_weaponCargo select 0);
            };

            
            private _magazineCargo = getMagazineCargo _x;
            if (count (_magazineCargo select 0) > 0) then {
                {
                    private _magazine = _x;
                    private _count = (_magazineCargo select 1) select _forEachIndex;
                    if (_magazine != "" && _count > 0) then {
                        _crate addMagazineCargoGlobal [_magazine, _count];
                    };
                } forEach (_magazineCargo select 0);
            };

            
            private _backpackCargo = getBackpackCargo _x;
            if (count (_backpackCargo select 0) > 0) then {
                {
                    private _backpack = _x;
                    private _count = (_backpackCargo select 1) select _forEachIndex;
                    if (_backpack != "" && _count > 0) then {
                        _crate addBackpackCargoGlobal [_backpack, _count];
                    };
                } forEach (_backpackCargo select 0);
            };
			
			
            private _money = _x getVariable ["ExileMoney", 0];
            if (_money > 0) then {
                _crate setVariable ["ExileMoney", _money, true];
            };
			
           
            systemChat format ["Ящик %1 выпал из уничтоженной техники.", _crateType];
        } forEach _cargo;

        
        _vehicle setVariable ["R3F_LOG_objets_charges", nil, true];
    };


    private["_object", "_objectpos", "_objectpos2", "_items", "_magazines", "_weapons", "_containers", "_popTabs", "_typeof", "_groundHolder", "_popTabsObject", "_filter", "_kitMagazine"];
    _object = _vehicle;
    _objectpos = getPosATL _object;
    
  
    if (typeOf _object == "Exile_Container_Safe") then {
        
        _objectpos2 = _objectpos;
    } else {
      
        private _offset = [random 16 - 8, random 16 - 8, 0];
        _objectpos2 = _objectpos vectorAdd _offset;
    };
    
    _items = _object call ExileServer_util_getItemCargo;
    _magazines = magazinesAmmoCargo _object;
    _weapons = weaponsItemsCargo _object;
    _containers =_object call ExileServer_util_getObjectContainerCargo;
    _popTabs = _object getVariable ["ExileMoney",0];
    _typeof = typeOf _object;
    deleteVehicle _object;
    _object call ExileServer_object_container_database_delete;
    
    
    _groundHolder = createVehicle ["Box_IND_Wps_F", _objectpos2, [], 0, "CAN_COLLIDE"];

    clearWeaponCargoGlobal 		_groundHolder;
    clearItemCargoGlobal 		_groundHolder;
    clearMagazineCargoGlobal 	_groundHolder;
    clearBackpackCargoGlobal 	_groundHolder;

    _groundHolder setPosATL _objectpos2;
    if (_popTabs > 0 ) then
    {
            
        _groundHolder setVariable ["ExileMoney", _popTabs, true];
    };
    _filter  = ("getText(_x >> 'staticObject') == _typeof" configClasses(configFile >> "CfgConstruction")) select 0;
    _kitMagazine = getText(_filter >> "kitMagazine");
    _groundHolder addItemCargoGlobal [_kitMagazine,1];
    [_groundHolder,_items] call ExileServer_util_fill_fillItems;
    [_groundHolder,_magazines] call ExileServer_util_fill_fillMagazines;
    [_groundHolder,_weapons] call ExileServer_util_fill_fillWeapons;
    [_groundHolder,_containers] call ExileServer_util_fill_fillContainers;
    true
};
call fnc_handleVehicleDestroyed;
