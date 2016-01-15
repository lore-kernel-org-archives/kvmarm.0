From: Sinan Kaya <okaya-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH V12 3/7] dma: add Qualcomm Technologies HIDMA management
 driver
Date: Fri, 15 Jan 2016 10:12:00 -0500
Message-ID: <56990C40.4050407@codeaurora.org>
References: <1452523550-8920-1-git-send-email-okaya@codeaurora.org>
 <1452523550-8920-4-git-send-email-okaya@codeaurora.org>
 <20160115145629.GI3262@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160115145629.GI3262@leverpostej>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agross-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Vikram Sethi <vikrams-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Mark,

On 1/15/2016 9:56 AM, Mark Rutland wrote:
> Hi,
> 
> [adding KVM people, given this is meant for virtualization]
> 
> On Mon, Jan 11, 2016 at 09:45:43AM -0500, Sinan Kaya wrote:
>> The Qualcomm Technologies HIDMA device has been designed to support
>> virtualization technology. The driver has been divided into two to follow
>> the hardware design.
>>
>> 1. HIDMA Management driver
>> 2. HIDMA Channel driver
>>
>> Each HIDMA HW consists of multiple channels. These channels share some set
>> of common parameters. These parameters are initialized by the management
>> driver during power up. Same management driver is used for monitoring the
>> execution of the channels. Management driver can change the performance
>> behavior dynamically such as bandwidth allocation and prioritization.
>>
>> The management driver is executed in hypervisor context and is the main
>> management entity for all channels provided by the device.
> 
> You mention repeatedly that this is designed for virtualization, but
> looking at the series as it stands today I can't see how this operates
> from the host side.
> 
> This doesn't seem to tie into KVM or VFIO, and as far as I can tell
> there's no mechanism for associating channels with a particular virtual
> address space (i.e. no configuration of an external or internal IOMMU),
> nor pinning of guest pages to allow for DMA to occur safely.

I'm using VFIO platform driver for this purpose. VFIO platform driver is 
capable of assigning any platform device to a guest machine with this driver. 

You just unbind the HIDMA channel driver from the hypervisor and bind to vfio
driver using the very same approach you'd use with PCIe. 

Of course, this all assumes the presence of an IOMMU driver on the system. VFIO
driver uses the IOMMU driver to create the mappings. 

The mechanism used here is not different from VFIO PCI from user perspective.

> 
> Given that, I'm at a loss as to how this would be used in a hypervisor
> context. What am I missing?
> 
> Are there additional patches, or do you have some userspace that works
> with this in some limited configuration?

No, these are the only patches. We have one patch for the QEMU but from kernel
perspective this is it. 

I just rely on the platform VFIO driver to do the work. 

> 
> Thanks,
> Mark.
> 

Sinan
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
