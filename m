From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v2 3/6] vfio: platform: reset: calxedaxgmac: add reset
 function registration
Date: Thu, 22 Oct 2015 14:29:02 +0200
Message-ID: <5628D68E.5020009@linaro.org>
References: <1445506922-6005-1-git-send-email-eric.auger@linaro.org>
 <4810974.apRDTjc3oB@wuerfel> <5628CE82.7090105@linaro.org>
 <43557523.izmYB5ybOS@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 413DC41022
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Oct 2015 08:26:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LQg3KKZptde5 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Oct 2015 08:26:27 -0400 (EDT)
Received: from mail-wi0-f170.google.com (mail-wi0-f170.google.com
 [209.85.212.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5210940FAB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Oct 2015 08:26:26 -0400 (EDT)
Received: by wicfx6 with SMTP id fx6so133281051wic.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Oct 2015 05:29:04 -0700 (PDT)
In-Reply-To: <43557523.izmYB5ybOS@wuerfel>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Arnd Bergmann <arnd@arndb.de>
Cc: kvm@vger.kernel.org, patches@linaro.org, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, eric.auger@st.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 10/22/2015 02:09 PM, Arnd Bergmann wrote:
> On Thursday 22 October 2015 13:54:42 Eric Auger wrote:
>> On 10/22/2015 12:13 PM, Arnd Bergmann wrote:
>>> On Thursday 22 October 2015 11:41:59 Eric Auger wrote:
>>>> This patch adds the reset function registration/unregistration.
>>>>
>>>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>>>
>>> Looks good, except one thing:
>>>> @@ -70,6 +69,8 @@ int vfio_platform_calxedaxgmac_reset(struct vfio_platform_device *vdev)
>>>>                      return -ENOMEM;
>>>>      }
>>>>  
>>>> +    pr_info("VFIO reset of %s\n", vdev->name);
>>>> +
>>>>      /* disable IRQ */
>>>>      writel(0, reg.ioaddr + XGMAC_DMA_INTR_ENA);
>>>>  
>>>
>>> This probably slipped in from debugging, please remove it.
>> Well actually this is not an oversight but some unappropriate tracing
>> attempt I am afraid. I wanted to add a trace useful for the end-user to
>> make sure the VFIO reset function was called. Do you forbid that or do
>> recommend to use another tracing mechanism/level? In the past I tried
>> dynamic tracing but with module loading mechanism I found it not that handy.
> 
> If you think it's useful to have in the long run, it should be a separate
> patch with a description what it's good for, rather than a side-effect of
> an unrelated patch. It just looked to me like it's something you do
> while debugging the reset code, rather than while using it.
> 
> Implementation-wise, you should use dev_info() instead of pr_info() where
> possible, and it probably makes sense to put this into the vfio_platform
> driver before calling the reset function, for consistency between the
> drivers.
OK thanks

Best Regards

Eric
> 
> 	Arnd
> 
