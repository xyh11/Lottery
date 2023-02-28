//using System.Collections;
//using System.Collections.Generic;
//using UnityEngine;
//using UnityEngine.UI;

//public class Lottery : MonoBehaviour
//{
//    public GameObject slotRed;
//    public GameObject slotBlue;
//    public GameObject gameItem;
//    public float updateInterval = 1.0f;//定时刷新
//    //private float timePassed = 0.0f;

//    public float loopTime = 4f;//loop动画持续时长
//    private bool isTrue = false;//是否检测
//    private float myTime = 0.0f;

//    //红球蓝球
//    private int[] redBall = new int[33];
//    private int[] blueBall = new int[16];
//    //红球随机的个数
//    private int red = 6;
//    //蓝球随机的个数
//    private int blue = 1;


//    private void Awake()
//    {
//        for (int loop = 1; loop < 34; loop++)
//        {
//            this.redBall[loop - 1] = loop;
//            //Debug.Log("红色：" + redBall[loop - 1]);
//        }
//        for (int loop = 1; loop < 17; loop++)
//        {
//            this.blueBall[loop - 1] = loop;
//            //Debug.Log("蓝色：" + blueBall[loop - 1]);
//        }
//    }
//    void Start()
//    {
//        //getBall.onClick.AddListener(OnStartButtonClick);//监听点击事件
//        for (int i = 0; i < 6; i++)
//        {
//            var instanceRed = GameObject.Instantiate(slotRed);
//            instanceRed.transform.SetParent(gameItem.transform);
//            instanceRed.name = "Slot_" + (i + 1);
//            instanceRed.transform.localScale = new Vector3(1, 1, 1);
//        }
//        var instanceBlue = GameObject.Instantiate(slotBlue);
//        instanceBlue.transform.SetParent(gameItem.transform);
//        instanceBlue.name = "Slot_7";
//        instanceBlue.transform.localScale = new Vector3(1, 1, 1);
//    }

//    // Update is called once per frame
//    void Update()
//    {

//    }

//    public void switchAnim(Animator anim)
//    {
//        while (isTrue)
//        {
//            //idle

//            //start
//            //loop
//            //stop
//        }
//    }

//    public void isLoop(Animator anim)
//    {
//        isTrue = true;
//        anim.SetBool("isStart", false);
//        anim.SetBool("isLoop", true);
//        myTime = 0f;
//    }
//    public void isStop(Animator anim)
//    {
//        if (myTime >= loopTime)
//        {
//            anim.SetBool("isStop", true);
//            anim.SetBool("isLoop", false);
//            myTime = 0f;
//            isTrue = false;
//        }
//    }
//    public void isIdle(Animator anim)
//    {
//        anim.SetBool("isStop", false);

//    }

//    //void OnStartButtonClick()
//    //{

//    //    int[] redList = BubbleSort(GetRandomSequence(this.redBall, this.red));
//    //    int[] blueList = GetRandomSequence(this.blueBall, this.blue);
//    //}

//    int[] GetRandomSequence(int[] array, int count)
//    {
//        int[] output = new int[count];
//        for (int i = array.Length - 1; i >= 0 && count > 0; i--)
//        {
//            if (Random.Range(0, i + 1) < count)//概率是 剩余取数长度/总数组剩余的长度
//            {
//                output[count - 1] = array[i];//output从最后一位开始往前存
//                count--;
//            }
//        }
//        return output;
//    }

//    int[] BubbleSort(int[] array)
//    {
//        int temp = 0;
//        for (int i = 0; i < array.Length - 1; i++)  //外层循环控制排序趟数
//        {
//            for (int j = 0; j < array.Length - 1 - i; j++)  //内层循环控制每一趟排序多少次
//            {
//                if (array[j] > array[j + 1])
//                {
//                    temp = array[j];
//                    array[j] = array[j + 1];
//                    array[j + 1] = temp;
//                }
//            }
//        }
//        return array;
//    }
//}

