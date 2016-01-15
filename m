From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH V12 3/7] dma: add Qualcomm Technologies HIDMA management
 driver
Date: Fri, 15 Jan 2016 11:01:11 -0500
Message-ID: <569917C7.9000804@codeaurora.org>
References: <1452523550-8920-1-git-send-email-okaya@codeaurora.org>
 <1452523550-8920-4-git-send-email-okaya@codeaurora.org>
 <20160115145629.GI3262@leverpostej> <56990CD4.6020405@arm.com>
 <20160115153656.GM3262@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EA7649A25
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 10:57:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fGhMu3yNDnuX for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2016 10:57:02 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DAFB849A1B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 10:57:01 -0500 (EST)
In-Reply-To: <20160115153656.GM3262@leverpostej>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org, arnd@arndb.de, vinod.koul@intel.com, jcm@redhat.com, timur@codeaurora.org, linux-kernel@vger.kernel.org, agross@codeaurora.org, dmaengine@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-msm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 1/15/2016 10:36 AM, Mark Rutland wrote:
> On Fri, Jan 15, 2016 at 03:14:28PM +0000, Marc Zyngier wrote:
>> On 15/01/16 14:56, Mark Rutland wrote:
>>> Hi,
>>>
>>> [adding KVM people, given this is meant for virtualization]
>>>
>>> On Mon, Jan 11, 2016 at 09:45:43AM -0500, Sinan Kaya wrote:
>>>> The Qualcomm Technologies HIDMA device has been designed to support
>>>> virtualization technology. The driver has been divided into two to follow
>>>> the hardware design.
>>>>
>>>> 1. HIDMA Management driver
>>>> 2. HIDMA Channel driver
>>>>
>>>> Each HIDMA HW consists of multiple channels. These channels share some set
>>>> of common parameters. These parameters are initialized by the management
>>>> driver during power up. Same management driver is used for monitoring the
>>>> execution of the channels. Management driver can change the performance
>>>> behavior dynamically such as bandwidth allocation and prioritization.
>>>>
>>>> The management driver is executed in hypervisor context and is the main
>>>> management entity for all channels provided by the device.
>>>
>>> You mention repeatedly that this is designed for virtualization, but
>>> looking at the series as it stands today I can't see how this operates
>>> from the host side.
>>
>> Nor the guest's, TBH. How do host and guest communicate, what is the
>> infrastructure, how is it meant to be used? A lot of questions, and no
>> answer whatsoever in this series.
> 
> I think the guest's PoV is fairly simple and understood. The DMA channel
> is pased in as with any passthrough of any other platform device.
> 
> No communication with the host is necessary -- an isolated channel is
> usable.
> 

Correct, I'm behind on emails. I'm following you. 

> The larger concern is isolation, given the lack of IOMMU, or anything
> obvious w.r.t. pinning of pages.
> 
I assume the presence of an IOMMU if used in the guest machine. I wonder
if I can place a check and make the driver fail if IOMMU driver is not present.

Any ideas?

>>> This doesn't seem to tie into KVM or VFIO, and as far as I can tell
>>> there's no mechanism for associating channels with a particular virtual
>>> address space (i.e. no configuration of an external or internal IOMMU),
>>> nor pinning of guest pages to allow for DMA to occur safely.
>>>
>>> Given that, I'm at a loss as to how this would be used in a hypervisor
>>> context. What am I missing?
>>>
>>> Are there additional patches, or do you have some userspace that works
>>> with this in some limited configuration?

I forgot to mention that these are the only kernel patches. A userspace application
is being built as we speak by another team.

The userspace application will use sysfs to communicate to the management driver. 
The management driver knows how to change runtime characteristics like priority and
weight.



>>
>> Well, this looks so far like a code dumping exercise. I'd very much
>> appreciate a HIDMA101 crash course:
>>
>> - How do host and guest communicate?
>> - How is the integration performed in the hypervisor?
>> - Does the HYP side requires any context switch (and how is that done)?
> 
> I don't believe this requires any context-switch -- it's the same as
> assigning any other platform device other than additional proeprties
> being controlled in the managament interface.

Agreed.

> 
>> - What makes it safe?
> 
> I'm concerned with how this is safe, and with the userspace interface.
> e.g. if the user wants to up the QoS for a VM, how to they find the
> right channel in sysfs  to alter?

The HW supports changing the QoS values on the flight. In order to locate the
object, I'm exporting a 

I tried to address your concern on v10 last series. Here is brief summary.

Each channel device has a sysfs entry named chid.
What:		/sys/devices/platform/hidma-*/chid
+		/sys/devices/platform/QCOM8061:*/chid


Each management object has one priority and weight file per channel.
+What:		/sys/devices/platform/hidma-mgmt*/chanops/chan*/priority
+		/sys/devices/platform/QCOM8060:*/chanops/chan*/priority

Suppose you want to change the priority of a channel you assigned to guess,
the userspace application goes and reads the chid value of the channel.

Then goes to chanops/chan<chid>/ directory and can change priority and weight 
parameters here.

Here is how the directory looks like. QCOM8060:00 is a management object.
QCOM8061:0x are the channel objects.

/sys/devices/platform/QCOM8060:00# ls
QCOM8061:00
QCOM8061:01
QCOM8061:02
QCOM8061:03
QCOM8061:04
QCOM8061:05
chanops
<other common attributes>




> 
>> Without any of this information (and pointer to the code to back it up),
>> I'm very reluctant to take any of this.
> 
> Likewise.
> 
> Thanks,
> Mark.
> 


-- 
Sinan Kaya
Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
