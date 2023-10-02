using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class Sys
{
    private static Sys n_instance;

    public static Sys inst
    {
        get
        {
            if (n_instance == null)
            {
                n_instance = new Sys();
            }

            return n_instance;
           
        }
    }



    internal HashSet<renderObj> holder = new HashSet<renderObj>();

    public void ADD(renderObj o)
    {
        
        remove(o);
        holder.Add(o);

    }

    public void remove(renderObj o)
    {
        
        
        holder.Remove(o);

    }





}


[ExecuteInEditMode]
public class Command_Buffer_Manager : MonoBehaviour
{
    private CommandBuffer CmdBfr;
    private Dictionary<Camera, CommandBuffer> BufferManager = new Dictionary<Camera, CommandBuffer>();

    private void Cleanup()
    {
        foreach(var cam in BufferManager)
        {
            if(cam.Key)
                cam.Key.RemoveCommandBuffer(CameraEvent.BeforeLighting, cam.Value);
        }
        BufferManager.Clear();
    }

    public void OnDisable()
    {
        Cleanup();
    }

    public void OnEnable()
    {
        Cleanup();
    }

    public void OnWillRenderObject()
    {
        var render = gameObject.activeInHierarchy && enabled;
        if(!render)
        {
            Cleanup();
            return;
        }

        var cam = Camera.current;
        if(!cam)
            return;

        if(BufferManager.ContainsKey(cam))
            return;

        CmdBfr = new CommandBuffer();
        CmdBfr.name = "globnu";
        BufferManager[cam] = CmdBfr;

         int id = Shader.PropertyToID("Slay");
        CmdBfr.GetTemporaryRT(id,-1,-1,24,FilterMode.Bilinear);
        CmdBfr.SetRenderTarget(id);
        CmdBfr.ClearRenderTarget(true,true,Color.black);


        foreach (renderObj o in Sys.inst.holder)
        {
            Renderer r = o.GetComponent<Renderer>();
            Material m = o.here;

            if (r && m )
            {
                CmdBfr.DrawRenderer(r,m);
            }


        }
        CmdBfr.SetGlobalTexture("_Glower",id);
        cam.AddCommandBuffer(CameraEvent.BeforeLighting,CmdBfr);



    }
}
