using System.Collections;
using UnityEngine;


[RequireComponent(typeof(Rigidbody))]
public class SlowCutter : MonoBehaviour
{   
    public Material capMaterial;

    public Vector3 direct;

    public double SwordVelocity;

    Vector3 prevPosition;

    public AudioSource audioSource;

    void OnCollisionEnter(Collision collision) 
    {
        Vector3 direct = transform.position - prevPosition;
        prevPosition = transform.position;
        SwordVelocity = direct.magnitude/Time.deltaTime;

        if (SwordVelocity<=40 & SwordVelocity>=3)
        {
            GameObject victim = collision.collider.gameObject;

            GameObject[] pieces = BLINDED_AM_ME.MeshCut.Cut(victim, transform.position, transform.right, capMaterial);

            if (!pieces[1].GetComponent<Rigidbody>())
            {
                pieces[1].AddComponent<Rigidbody>();
                MeshCollider temp = pieces[1].AddComponent<MeshCollider>();
                temp.convex = true;
                audioSource.Play();
    	    }
        }

    }

}
