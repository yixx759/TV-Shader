using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

public class Post : MonoBehaviour
{

    // [SerializeField] private float thresh;
    // [SerializeField] private float softthresh;
    [SerializeField, Range(1,8)] private int downsample;
    [SerializeField] private float deldown;
    [SerializeField] private float delup;
    
    [FormerlySerializedAs("a")] public Material DownSizer;
    // public Material b;
    // public Material c;
    // Start is called before the first frame update
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        // a.SetFloat("_Threshold",thresh );
        // a.SetFloat("_SoftThreshold",softthresh );
        DownSizer.SetFloat("del",deldown );
        DownSizer.SetFloat("del1",delup );
        DownSizer.SetTexture("_ogtex",source );


        RenderTexture[] l = new RenderTexture[downsample];
        
        int height = source.height / 2;
        int width = source.height /2;
        RenderTexture u = l[0] = RenderTexture.GetTemporary(width, height, 0, source.format);
        Graphics.Blit(source, u,DownSizer,0);
        RenderTexture coursource = u;

        int i = 1;
        for (; i < downsample; i++)
        {
            height /= 2;
            width /= 2;

            if (height <2)
            {
                break;
            }
            u =l[i]=  RenderTexture.GetTemporary(width, height, 0, source.format);
            
            
        
            
            Graphics.Blit(coursource, u,DownSizer,1);
            coursource =u ;
        }


      
        for (i -= 2; i >= 0; i--)
        {
            u = l[i];
            l[i] = null;
            Graphics.Blit(coursource,u,DownSizer,2);
            RenderTexture.ReleaseTemporary(coursource);
            coursource = u;
        
            
        
        }
         Graphics.Blit(coursource, destination,DownSizer,3);
         RenderTexture.ReleaseTemporary(coursource);
        
    }
}
