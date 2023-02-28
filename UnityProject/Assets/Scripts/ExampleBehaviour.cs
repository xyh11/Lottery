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
                Debug.Log("星期一");
                break;
            case 2:
                Debug.Log("星期二");
                break; 
            case 3:
                Debug.Log("星期三");
                break;  
            case 4:
                Debug.Log("星期四");
                break;  
            case 5:
                Debug.Log("星期五");
                break; 
            case 6:
                Debug.Log("星期六");
                break; 
            case 7:
                Debug.Log("星期日");
                break;
            default:
                Debug.Log("没有这个");
                break;
        }
    }
}