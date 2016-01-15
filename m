From: Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH V12 3/7] dma: add Qualcomm Technologies HIDMA management
 driver
Date: Fri, 15 Jan 2016 17:28:46 +0000
Message-ID: <56992C4E.6010606@arm.com>
References: <1452523550-8920-1-git-send-email-okaya@codeaurora.org> <1452523550-8920-4-git-send-email-okaya@codeaurora.org> <20160115145629.GI3262@leverpostej> <56990CD4.6020405@arm.com> <569912F3.9040507@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <569912F3.9040507-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sinan Kaya <okaya-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agross-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Vikram Sethi <vikrams-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

On 15/01/16 15:40, Sinan Kaya wrote:
> On 1/15/2016 10:14 AM, Marc Zyngier wrote:
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
> I always make an analogy of HIDMA channel driver to a PCI endpoint device driver (8139too for example)
> running on the guest machine.
> 
> Both HIDMA and PCI uses device pass-through approach.
> 
> I don't have an infrastructure for host and guest to communicate as I don't need to.
> A HIDMA channel is assigned to a guest machine after an unbind from the host machine. 
> 
> Guest machine uses HIDMA channel driver to offload DMA operations. The guest machine owns the
> HW registers for the channel. It doesn't need to trap to host for register read/writes etc.
> 
> All guest machine pages used are assumed to be pinned similar to VFIO PCI. 
> The reason is performance. The IOMMU takes care of the address translation for me.
> 
>>
>>>
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
>>
>> Well, this looks so far like a code dumping exercise. I'd very much
>> appreciate a HIDMA101 crash course:
> 
> Sure, I'm ready to answer any questions. This is really a VFIO platform course. Not
> a HIDMA driver course. The approach is not different if you assign a platfom 
> SATA (AHCI) or SDHC driver to a guest machine.

I happen to have an idea of how VFIO works...

> 
> The summary is that:
> - IOMMU takes care of the mappings via VFIO driver.
> - Guest machine owns the HW. No hypervisor interaction.

Then it might be worth mentioning all of this

> 
>>
>> - How do host and guest communicate?
> They don't.
> 
>> - How is the integration performed in the hypervisor?
> Hypervisor has a bunch of channel resources. For each guest machine, the channel gets
> unbound from the hypervisor. Channels get bind to each VFIO platform device and then
> control is given to the guest machine.

And what does the hypervisor do with those in the meantime? Above, you
say "Guest machine owns the HW". So what is that hypervisor code used
for? Is that your reset driver?

You may want to drop the "hypervisor" designation, BTW, because this has
no real connection to virtualisation.

> 
> Once the guest machine is shutdown, VFIO driver still owns the channel device. It can
> assign the device to another guest machine.
> 
>> - Does the HYP side requires any context switch (and how is that done)?
> No communication is needed.
> 
>> - What makes it safe?
> No communication is needed.
> 
>>
>> Without any of this information (and pointer to the code to back it up),
>> I'm very reluctant to take any of this.
> 
> Please let me know what exactly is not clear. 
> 
> You don't write a virtualization driver for 8139too driver. The driver works whether it is running in the 
> guest machine or the hypervisor. 

Exactly. No hypervisor code needed whatsoever. So please get rid of this
hypervisor nonsense! ;-)

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
