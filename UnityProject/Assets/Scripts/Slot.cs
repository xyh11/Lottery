////using System.Collections;
////using System.Collections.Generic;
//using UnityEngine;
//using UnityEngine.UI;

//public class Slot : MonoBehaviour
//{
//    public Animator anim;
//    public Text num_1;
//    public Text num_2;
//    public Text num_3;
//    //public Button btn;
//    public float loopTime = 4f;
//    private bool isTrue;

//    public bool IsTrue
//    {
//        get { return isTrue; }
//        set { isTrue = false; }
//    }

//    private float myTime;

//    public float MyTime
//    {
//        get { return myTime; }
//        set { myTime = 0f; }
//    }

//    //public float updateInterval = 1.0f;//定时刷新
//    //private float timePassed = 0.0f;

//    //void Start()
//    //{
//    //    //num_1.text = Random.Range(0, 33).ToString();
//    //    num_2.text = Random.Range(0, 33).ToString();
//    //    num_3.text = Random.Range(0, 33).ToString();
//    //}

//    //void Update()
//    //{
//    //    timePassed += Time.deltaTime;
//    //    myTime += Time.deltaTime;

//    //    if (isTrue == true && timePassed>= updateInterval)
//    //    {
//    //        num_1.text = Random.Range(0, 33).ToString();
//    //        num_2.text = Random.Range(0, 33).ToString();
//    //        num_3.text = Random.Range(0, 33).ToString();

//    //        //重置定时器
//    //        timePassed = 0.0f;
//    //    }
//    //}

//    //public void isStart()
//    //{
//    //    anim.SetBool("isStart",true);

//    //}
//    public void isLoop()
//    {
//        isTrue = true;
//        anim.SetBool("isStart", false);
//        anim.SetBool("isLoop", true);
//        myTime = 0f;
//    }
//    public void isStop()
//    {
//        if (myTime >= loopTime) {
//            anim.SetBool("isStop", true);
//            anim.SetBool("isLoop", false);
//            myTime = 0f;
//            isTrue = false;
//        }
//    }
//    public void isIdle()
//    {
//        anim.SetBool("isStop", false);

//    }
 
//}
