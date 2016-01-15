From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH V12 3/7] dma: add Qualcomm Technologies HIDMA management
 driver
Date: Fri, 15 Jan 2016 12:44:08 -0500
Message-ID: <56992FE8.4000606@codeaurora.org>
References: <1452523550-8920-1-git-send-email-okaya@codeaurora.org>
 <1452523550-8920-4-git-send-email-okaya@codeaurora.org>
 <20160115145629.GI3262@leverpostej> <56990CD4.6020405@arm.com>
 <569912F3.9040507@codeaurora.org> <56992C4E.6010606@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56992C4E.6010606@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: dmaengine@vger.kernel.org, timur@codeaurora.org, devicetree@vger.kernel.org, cov@codeaurora.org, vinod.koul@intel.com, jcm@redhat.com, agross@codeaurora.org, arnd@arndb.de, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, Vikram Sethi <vikrams@codeaurora.org>, shankerd@codeaurora.org
List-Id: kvmarm@lists.cs.columbia.edu

>>
>> Sure, I'm ready to answer any questions. This is really a VFIO platform course. Not
>> a HIDMA driver course. The approach is not different if you assign a platfom 
>> SATA (AHCI) or SDHC driver to a guest machine.
> 
> I happen to have an idea of how VFIO works...
> 

OK. Good to know that we are speaking the same language.

>>
>> The summary is that:
>> - IOMMU takes care of the mappings via VFIO driver.
>> - Guest machine owns the HW. No hypervisor interaction.
> 
> Then it might be worth mentioning all of this
> 

Sure thing. I'm trying to locate where the right place would be.
I'll target commit message and source code for now.

>>
>>>
>>> - How do host and guest communicate?
>> They don't.
>>
>>> - How is the integration performed in the hypervisor?
>> Hypervisor has a bunch of channel resources. For each guest machine, the channel gets
>> unbound from the hypervisor. Channels get bind to each VFIO platform device and then
>> control is given to the guest machine.
> 
> And what does the hypervisor do with those in the meantime? Above, you
> say "Guest machine owns the HW". 

The guest machine owns the channel HW which runs independent of the management HW.

> So what is that hypervisor code used
> for? Is that your reset driver?

The HIDMA "management" driver which runs at the hypervisor owns the management HW. 
Management driver serves two purposes.

1. Common bus parameter configuration (could be called reset driver).
2. Fine tuning the HW resources.

Multiple HIDMA channels share common HW resources. The management driver is able to change 
the priority (high/low) and weight (round-robin priority) of each HIDMA channel on the flight. 

The system administrator will use a userspace application to allocate HW resources to each channel via
the management driver.

The management driver does some common configuration too for these parameters. 
The management interface also has to be enabled before any channel can be enabled.

- max-write-burst-bytes: Maximum write burst in bytes that HIDMA can 
  occupy the bus for in a single transaction. A memcpy requested is 
  fragmented to multiples of this amount. This parameter is used while
  writing into destination memory. Setting this value incorrectly can
  starve other peripherals in the system.
- max-read-burst-bytes: Maximum read burst in bytes that HIDMA can
  occupy the bus for in a single transaction. A memcpy request is
  fragmented to multiples of this amount. This parameter is used while
  reading the source memory. Setting this value incorrectly can starve
  other peripherals in the system.
- max-write-transactions: This value is how many times a write burst is 
  applied back to back while writing to the destination before yielding 
  the bus.
- max-read-transactions: This value is how many times a read burst is
  applied back to back while reading the source before a yielding the bus.
- channel-reset-timeout-cycles: Channel reset timeout in cycles for this SOC.
  Once a reset is applied to the HW, HW starts a timer for reset operation
  to confirm. If reset is not completed within this time, HW reports reset
  failure. 

> 
> You may want to drop the "hypervisor" designation, BTW, because this has
> no real connection to virtualisation.
> 

Would you use host/guest relationship?

>>
>> Once the guest machine is shutdown, VFIO driver still owns the channel device. It can
>> assign the device to another guest machine.
>>
>>> - Does the HYP side requires any context switch (and how is that done)?
>> No communication is needed.
>>
>>> - What makes it safe?
>> No communication is needed.
>>
>>>
>>> Without any of this information (and pointer to the code to back it up),
>>> I'm very reluctant to take any of this.
>>
>> Please let me know what exactly is not clear. 
>>
>> You don't write a virtualization driver for 8139too driver. The driver works whether it is running in the 
>> guest machine or the hypervisor. 
> 
> Exactly. No hypervisor code needed whatsoever. So please get rid of this
> hypervisor nonsense! ;-)
> 

I need the management driver for administrative purposes and common initialization. 
I like the split SW design as it follows the HW design too.

> Thanks,
> 
> 	M.
> 


-- 
Sinan Kaya
Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
