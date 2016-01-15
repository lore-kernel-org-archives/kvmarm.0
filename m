From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH V12 3/7] dma: add Qualcomm Technologies HIDMA management
 driver
Date: Fri, 15 Jan 2016 17:47:52 -0500
Message-ID: <56997718.70707@codeaurora.org>
References: <1452523550-8920-1-git-send-email-okaya@codeaurora.org>
 <1452523550-8920-4-git-send-email-okaya@codeaurora.org>
 <20160115145629.GI3262@leverpostej> <56990C40.4050407@codeaurora.org>
 <20160115152257.GK3262@leverpostej> <56992987.5080603@codeaurora.org>
 <56992D16.6070800@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3B4749A13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 17:43:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aaVHXy4fIDsu for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2016 17:43:41 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 985E349857
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 17:43:40 -0500 (EST)
In-Reply-To: <56992D16.6070800@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org, arnd@arndb.de, vinod.koul@intel.com, jcm@redhat.com, timur@codeaurora.org, linux-kernel@vger.kernel.org, agross@codeaurora.org, dmaengine@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-msm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 1/15/2016 12:32 PM, Marc Zyngier wrote:
>>> Do you have a link to that? Seeing it would help to ease my concerns.
>> > 
>> > The QEMU driver has not been posted yet. As far as I know, it just discovers the memory
>> > resources on the platform object and creates mappings for the guest machine only. 
>> > 
>> > Shanker Donthineni and Vikram Sethi will post the QEMU patch later.
> Then may I suggest you both synchronize your submissions? I'd really
> like to hear from the QEMU maintainers that they are satisfied with that
> side of the story as well.

The HIDMA QEMU driver is also based on VFIO platform driver in QEMU. It is not a new concept
or new framework. All tried and tested solutions. 

The driver below is already using this feature. HIDMA is no exception. 
I have verified functionality of HIDMA linux driver with HIDMA QEMU driver already.

https://lxr.missinglinkelectronics.com/qemu/hw/arm/sysbus-fdt.c#L67
https://lxr.missinglinkelectronics.com/qemu/hw/vfio/calxeda-xgmac.c#L18
https://lxr.missinglinkelectronics.com/qemu/include/hw/vfio/vfio-calxeda-xgmac.h 



-- 
Sinan Kaya
Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
