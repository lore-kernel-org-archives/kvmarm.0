From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH V12 3/7] dma: add Qualcomm Technologies HIDMA management
 driver
Date: Mon, 18 Jan 2016 09:06:15 +0000
Message-ID: <569CAB07.8020200@arm.com>
References: <1452523550-8920-1-git-send-email-okaya@codeaurora.org>
 <1452523550-8920-4-git-send-email-okaya@codeaurora.org>
 <20160115145629.GI3262@leverpostej> <56990C40.4050407@codeaurora.org>
 <20160115152257.GK3262@leverpostej> <56992987.5080603@codeaurora.org>
 <56992D16.6070800@arm.com> <56997718.70707@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5E79412A6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2016 04:01:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lQPZ88P-gkqG for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jan 2016 04:01:56 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 924F1412A2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2016 04:01:56 -0500 (EST)
In-Reply-To: <56997718.70707@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Sinan Kaya <okaya@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org, arnd@arndb.de, vinod.koul@intel.com, jcm@redhat.com, timur@codeaurora.org, linux-kernel@vger.kernel.org, agross@codeaurora.org, dmaengine@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-msm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 15/01/16 22:47, Sinan Kaya wrote:
> On 1/15/2016 12:32 PM, Marc Zyngier wrote:
>>>> Do you have a link to that? Seeing it would help to ease my concerns.
>>>>
>>>> The QEMU driver has not been posted yet. As far as I know, it just discovers the memory
>>>> resources on the platform object and creates mappings for the guest machine only. 
>>>>
>>>> Shanker Donthineni and Vikram Sethi will post the QEMU patch later.
>> Then may I suggest you both synchronize your submissions? I'd really
>> like to hear from the QEMU maintainers that they are satisfied with that
>> side of the story as well.
> 
> The HIDMA QEMU driver is also based on VFIO platform driver in QEMU. It is not a new concept
> or new framework. All tried and tested solutions. 
> 
> The driver below is already using this feature. HIDMA is no exception. 
> I have verified functionality of HIDMA linux driver with HIDMA QEMU driver already.

That you have tested what you propose is the minimum you can do.

> https://lxr.missinglinkelectronics.com/qemu/hw/arm/sysbus-fdt.c#L67
> https://lxr.missinglinkelectronics.com/qemu/hw/vfio/calxeda-xgmac.c#L18
> https://lxr.missinglinkelectronics.com/qemu/include/hw/vfio/vfio-calxeda-xgmac.h 

None of which warrants that what you're doing is the right thing. Since
nobody has seen your QEMU code, I'm not going to take any bet.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
