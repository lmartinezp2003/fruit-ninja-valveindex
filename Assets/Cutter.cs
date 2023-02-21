using System.Collections;
using UnityEngine;


[RequireComponent(typeof(Rigidbody))]
public class Cutter : MonoBehaviour
{   
    public Material capMaterial;

    void OnCollisionEnter(Collision collision) 
    {
        Debug.Log("aaaaaa");
        GameObject victim = collision.collider.gameObject;

        GameObject[] pieces = BLINDED_AM_ME.MeshCut.Cut(victim, transform.position, transform.right, capMaterial);

        if (!pieces[1].GetComponent<Rigidbody>())
        {
            pieces[1].AddComponent<Rigidbody>();
            MeshCollider temp = pieces[1].AddComponent<MeshCollider>();
            temp.convex = true;
    	}

    }

}
