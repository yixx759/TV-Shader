using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

[ExecuteInEditMode]
public class renderObj : MonoBehaviour
{

    public Material here;

    private void OnEnable()
    {
        Sys.inst.ADD(this);
    }

    private void Start()
    {
        Sys.inst.ADD(this);
    }

    private void OnDisable()
    {
        Sys.inst.remove(this);
    }
}
