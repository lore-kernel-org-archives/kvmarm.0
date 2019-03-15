From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: Question: KVM: Failed to bind vfio with PCI-e / SMMU on Juno-r2
Date: Fri, 15 Mar 2019 12:54:10 +0000
Message-ID: <0e58d46a-a076-e7b6-9b14-6bbefa2ef404@arm.com>
References: <20190311064248.GC13422@leoy-ThinkPad-X240s>
 <f6f56743-677c-61ff-1746-1c86eab054a4@redhat.com>
 <20190311093958.GF13422@leoy-ThinkPad-X240s>
 <762d54fb-b146-e591-d544-676cb5606837@redhat.com>
 <20190311143501.GH13422@leoy-ThinkPad-X240s>
 <20190313080048.GI13422@leoy-ThinkPad-X240s>
 <35c22d0c-7da5-4e68-effb-05c8571d8b63@redhat.com>
 <e98d267e-db97-8680-62e4-f0788c00cea8@redhat.com>
 <20190315093748.GA20568@leoy-ThinkPad-X240s>
 <adde331f-1be9-2f0c-435a-bd906e0f253f@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4087D4A415
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Mar 2019 08:54:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nxbEDeweTEJn for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Mar 2019 08:54:18 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F0554A382
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Mar 2019 08:54:18 -0400 (EDT)
In-Reply-To: <adde331f-1be9-2f0c-435a-bd906e0f253f@redhat.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>, Leo Yan <leo.yan@linaro.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Leo,

Sorry for the delay - I'm on holiday this week, but since I've made the 
mistake of glancing at my inbox I should probably save you from wasting 
any more time...

On 2019-03-15 11:03 am, Auger Eric wrote:
> Hi Leo,
> 
> + Jean-Philippe
> 
> On 3/15/19 10:37 AM, Leo Yan wrote:
>> Hi Eric, Robin,
>>
>> On Wed, Mar 13, 2019 at 11:24:25AM +0100, Auger Eric wrote:
>>
>> [...]
>>
>>>> If the NIC supports MSIs they logically are used. This can be easily
>>>> checked on host by issuing "cat /proc/interrupts | grep vfio". Can you
>>>> check whether the guest received any interrupt? I remember that Robin
>>>> said in the past that on Juno, the MSI doorbell was in the PCI host
>>>> bridge window and possibly transactions towards the doorbell could not
>>>> reach it since considered as peer to peer.
>>>
>>> I found back Robin's explanation. It was not related to MSI IOVA being
>>> within the PCI host bridge window but RAM GPA colliding with host PCI
>>> config space?
>>>
>>> "MSI doorbells integral to PCIe root complexes (and thus untranslatable)
>>> typically have a programmable address, so could be anywhere. In the more
>>> general category of "special hardware addresses", QEMU's default ARM
>>> guest memory map puts RAM starting at 0x40000000; on the ARM Juno
>>> platform, that happens to be where PCI config space starts; as Juno's
>>> PCIe doesn't support ACS, peer-to-peer or anything clever, if you assign
>>> the PCI bus to a guest (all of it, given the lack of ACS), the root
>>> complex just sees the guest's attempts to DMA to "memory" as the device
>>> attempting to access config space and aborts them."
>>
>> Below is some following investigation at my side:
>>
>> Firstly, must admit that I don't understand well for up paragraph; so
>> based on the description I am wandering if can use INTx mode and if
>> it's lucky to avoid this hardware pitfall.
> 
> The problem above is that during the assignment process, the virtualizer
> maps the whole guest RAM though the IOMMU (+ the MSI doorbell on ARM) to
> allow the device, programmed in GPA to access the whole guest RAM.
> Unfortunately if the device emits a DMA request with 0x40000000 IOVA
> address, this IOVA is interpreted by the Juno RC as a transaction
> towards the PCIe config space. So this DMA request will not go beyond
> the RC, will never reach the IOMMU and will never reach the guest RAM.
> So globally the device is not able to reach part of the guest RAM.
> That's how I interpret the above statement. Then I don't know the
> details of the collision, I don't have access to this HW. I don't know
> either if this problem still exists on the r2 HW.

The short answer is that if you want PCI passthrough to work on Juno, 
the guest memory map has to look like a Juno.

The PCIe root complex uses an internal lookup table to generate 
appropriate AXI attributes for outgoing PCIe transactions; unfortunately 
this has no notion of 'default' attributes, so addresses *must* match 
one of the programmed windows in order to be valid. From memory, EDK2 
sets up a 2GB window covering the lower DRAM bank, an 8GB window 
covering the upper DRAM bank, and a 1MB (or thereabouts) window covering 
the GICv2m region with Device attributes. Any PCIe transactions to 
addresses not within one of those windows will be aborted by the RC 
without ever going out to the AXI side where the SMMU lies (and I think 
anything matching the config space or I/O space windows or a region 
claimed by a BAR will be aborted even earlier as a peer-to-peer attempt 
regardless of the AXI Translation Table setup).

You could potentially modify the firmware to change the window 
configuration, but the alignment restrictions make it awkward. I've only 
ever tested passthrough on Juno using kvmtool, which IIRC already has 
guest RAM in an appropriate place (and is trivially easy to hack if not) 
- I don't remember if I ever actually tried guest MSI with that.

Robin.

>> But when I want to rollback to use INTx mode I found there have issue
>> for kvmtool to support INTx mode, so this is why I wrote the patch [1]
>> to fix the issue.  Alternatively, we also can set the NIC driver
>> module parameter 'sky2.disable_msi=1' thus can totally disable msi and
>> only use INTx mode.
>>
>> Anyway, finally I can get INTx mode enabled and I can see the
>> interrupt will be registered successfully on both host and guest:
>>
>> Host side:
>>
>>             CPU0       CPU1       CPU2       CPU3       CPU4       CPU5
>>   41:          0          0          0          0          0          0     GICv2  54 Level     arm-pmu
>>   42:          0          0          0          0          0          0     GICv2  58 Level     arm-pmu
>>   43:          0          0          0          0          0          0     GICv2  62 Level     arm-pmu
>>   45:        772          0          0          0          0          0     GICv2 171 Level     vfio-intx(0000:08:00.0)
>>
>> Guest side:
>>
>> # cat /proc/interrupts
>>             CPU0       CPU1       CPU2       CPU3       CPU4       CPU5
>>   12:          0          0          0          0          0          0     GIC-0  96 Level     eth1
>>
>> So you could see the host can receive the interrupts, but these
>> interrupts are mainly triggered before binding vfio-pci driver.  But
>> seems now after launch kvm I can see there have very small mount
>> interrupts are triggered in host and the guest kernel also can receive
>> the virtual interrupts, e.g. if use 'dhclient eth1' command in guest
>> OS, this command stalls for long time (> 1 minute) after return back,
>> I can see both the host OS and guest OS can receive 5~6 interrupts.
>> Based on this, I guess the flow for interrupts forwarding has been
>> enabled.  But seems the data packet will not really output and I use
>> wireshark to capture packets, but cannot find any packet output from
>> the NIC.
>>
>> I did another testing is to shrink the memory space/io/bus region to
>> less than 0x40000000, so this can avoid to put guest memory IPA into
>> 0x40000000.  But this doesn't work.
> 
> What is worth to try is to move the base address of the guest RAM. I
> think there were some recent works on this on kvmtool. Adding
> Jean-Philippe in the loop.
> 
> Thanks
> 
> Eric
>>
>> @Robin, could you help explain for the hardware issue and review my
>> methods are feasible on Juno board?  Thanks a lot for suggestions.
>>
>> I will dig more for the memory mapping and post at here.
>>
>> Thanks,
>> Leo Yan
>>
>> [1] https://lists.cs.columbia.edu/pipermail/kvmarm/2019-March/035055.html
>>
