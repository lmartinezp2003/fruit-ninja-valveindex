using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Valve.VR;

public class Fruit : MonoBehaviour
{

    // Update is called once per frame
    void Update()
    {
        if (transform.position.y < -10f)
            Destroy(this.gameObject);
    }
}
