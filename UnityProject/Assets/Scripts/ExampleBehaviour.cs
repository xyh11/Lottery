using UnityEngine;
using System.Collections;

public class ExampleBehaviour : MonoBehaviour
{
    int day = 5;

    void Start()
    {
        switch (day)
        {
            case 1:
                Debug.Log("����һ");
                break;
            case 2:
                Debug.Log("���ڶ�");
                break; 
            case 3:
                Debug.Log("������");
                break;  
            case 4:
                Debug.Log("������");
                break;  
            case 5:
                Debug.Log("������");
                break; 
            case 6:
                Debug.Log("������");
                break; 
            case 7:
                Debug.Log("������");
                break;
            default:
                Debug.Log("û�����");
                break;
        }
    }
}