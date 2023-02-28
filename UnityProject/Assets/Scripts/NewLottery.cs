using UnityEngine;
using UnityEngine.UI;

public class NewLottery : MonoBehaviour
{
    public Button getBall;
    public Text redball_1;
    public Text redball_2;
    public Text redball_3;
    public Text redball_4;
    public Text redball_5;
    public Text redball_6;
    public Text blueball_1;

    //private float loopTime = 4.0f;
    private float timePassed = 0.0f;
    public float updateInterval = 1.0f;

    private bool isPaused = false;

    //��������
    private int[] redBall = new int[33];
    private int[] blueBall = new int[16];
    //��������ĸ���
    private int red = 6;
    //��������ĸ���
    private int blue = 1;


    private void Awake()
    {
        for (int loop = 1; loop < 34; loop++)
        {
            this.redBall[loop - 1] = loop;
            //Debug.Log("��ɫ��" + redBall[loop - 1]);
        }
        for (int loop = 1; loop < 17; loop++)
        {
            this.blueBall[loop - 1] = loop;
            //Debug.Log("��ɫ��" + blueBall[loop - 1]);
        }
    }
    void Start()
    {
        getBall.onClick.AddListener(TogglePause);

    }

    // Update is called once per frame
    void Update()
    {
        int[] redball = BubbleSort(GetRandomSequence(redBall, red));
        int[] blueball = GetRandomSequence(blueBall, blue);

        if (isPaused)
        {
            //Debug.LogError(isPaused);
            //int[] redList = BubbleSort(redball);
            Time.timeScale = 0; // ��Ϸ��ͣ
            //int[] blueList = GetRandomSequence(blueBall, blue);
            //redball_1.text = redList[0].ToString();
            //redball_2.text = redList[1].ToString();
            //redball_3.text = redList[2].ToString();
            //redball_4.text = redList[3].ToString();
            //redball_5.text = redList[4].ToString();
            //redball_6.text = redList[5].ToString();
        }
        else
        {
            //Debug.LogError(isPaused);
            Time.timeScale = 1; // ��Ϸ����
            timePassed += Time.deltaTime;
            if (timePassed >= updateInterval)
            {
                redball_1.text = redball[0].ToString();
                redball_2.text = redball[1].ToString();
                redball_3.text = redball[2].ToString();
                redball_4.text = redball[3].ToString();
                redball_5.text = redball[4].ToString();
                redball_6.text = redball[5].ToString();
                blueball_1.text = blueball[0].ToString();
                //���ö�ʱ��
                timePassed = 0.0f;
            }
        }

    }
    private void TogglePause()
    {
        // �л� isPaused ������ֵ
        isPaused = !isPaused;
        // ���� isPaused ������ֵ���ð�ť�ı�
        if (isPaused)
        {
            getBall.animator.Play("Disabled");
            getBall.GetComponentInChildren<Text>().text = "����";
        }
        else
        {
            getBall.animator.Play("Normal");
            getBall.GetComponentInChildren<Text>().text = "ͣ";
        }
    }

    int[] GetRandomSequence(int[] array, int count)
    {
        int[] output = new int[count];
        for (int i = array.Length - 1; i >= 0 && count > 0; i--)
        {
            if (Random.Range(0, i + 1) < count)//������ ʣ��ȡ������/������ʣ��ĳ���
            {
                output[count - 1] = array[i];//output�����һλ��ʼ��ǰ��
                count--;
            }
        }
        return output;
    }

    int[] BubbleSort(int[] array)
    {
        int temp = 0;
        for (int i = 0; i < array.Length - 1; i++)  //���ѭ��������������
        {
            for (int j = 0; j < array.Length - 1 - i; j++)  //�ڲ�ѭ������ÿһ��������ٴ�
            {
                if (array[j] > array[j + 1])
                {
                    temp = array[j];
                    array[j] = array[j + 1];
                    array[j + 1] = temp;
                }
            }
        }
        return array;
    }
}

