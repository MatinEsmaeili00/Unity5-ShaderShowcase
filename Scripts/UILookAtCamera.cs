using System.Collections;
using System.Collections.Generic;



#if UNITY_EDITOR
using UnityEditor;
using UnityEngine;
#endif



[ExecuteAlways]
public class UILookAtCamera : MonoBehaviour
{
    public GameObject cameraToLook;

    void Update()
    {
        Vector3 dirToCamera;

        if (Application.isPlaying && cameraToLook != null)
        {
            dirToCamera = cameraToLook.transform.position - transform.position;
        }
#if UNITY_EDITOR
        else if (!Application.isPlaying)
        {
            Camera sceneCam = SceneView.lastActiveSceneView?.camera;
            if (sceneCam == null) return;
            dirToCamera = sceneCam.transform.position - transform.position;
        }
        else return;
#endif
        


        // Make Y+ point to the camera, but lock twist around the Z axis
        Vector3 targetUp = dirToCamera.normalized;
        Vector3 targetForward = Vector3.Cross(Vector3.right, targetUp); // Avoid rolling

        if (targetForward == Vector3.zero)
            targetForward = Vector3.forward;

        transform.rotation = Quaternion.LookRotation(targetForward, targetUp);
    }
}