using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;

public class SaveAndLoad : MonoBehaviour {
    PlayerAction playerAction;


    private void Start() {
        playerAction = FindObjectOfType<PlayerAction>();
    }
   
	
	
    public void SaveGame() {
        BinaryFormatter bf = new BinaryFormatter();
        FileStream file = File.Open(Application.persistentDataPath + "gameInfo.dat", FileMode.Create);
        PlayerData playerDataToSave = new PlayerData();

        playerDataToSave.cash = playerAction.GetAvailableCash();
        playerDataToSave.oilNumber = playerAction.GetOilNumber();
        playerDataToSave.goldNumber = playerAction.GetGoldNumber();

        bf.Serialize(file, playerDataToSave);
        file.Close();

    }

    public void LoadGame() {
        BinaryFormatter bf = new BinaryFormatter();

        if (!File.Exists(Application.persistentDataPath + "gameInfo.dat"))
        {
            throw new Exception("Fichier du jeu innexistant");
        }

        FileStream file = File.Open(Application.persistentDataPath + "gameInfo.dat", FileMode.Open);
        PlayerData playerDataToLoad = (PlayerData)bf.Deserialize(file);
        file.Close();

        playerAction.SetAvailableCash(playerDataToLoad.cash);
        playerAction.SetGoldNumber(playerDataToLoad.goldNumber);
        playerAction.SetOilNumber(playerDataToLoad.oilNumber);
    }

    [Serializable]
    class PlayerData
    {
        public float cash;
        public int oilNumber;
        public int goldNumber;
    }
}
