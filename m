From: Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH V12 3/7] dma: add Qualcomm Technologies HIDMA management
 driver
Date: Fri, 15 Jan 2016 17:32:06 +0000
Message-ID: <56992D16.6070800@arm.com>
References: <1452523550-8920-1-git-send-email-okaya@codeaurora.org> <1452523550-8920-4-git-send-email-okaya@codeaurora.org> <20160115145629.GI3262@leverpostej> <56990C40.4050407@codeaurora.org> <20160115152257.GK3262@leverpostej> <56992987.5080603@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56992987.5080603-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sinan Kaya <okaya-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agross-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Vikram Sethi <vikrams-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 15/01/16 17:16, Sinan Kaya wrote:
>>>> This doesn't seem to tie into KVM or VFIO, and as far as I can tell
>>>> there's no mechanism for associating channels with a particular virtual
>>>> address space (i.e. no configuration of an external or internal IOMMU),
>>>> nor pinning of guest pages to allow for DMA to occur safely.
>>>
>>> I'm using VFIO platform driver for this purpose. VFIO platform driver is 
>>> capable of assigning any platform device to a guest machine with this driver. 
>>
>> Typically VFIO-platform also comes with a corresponding reset driver.
>> You don't need one?
> 
> The HIDMA channel driver resets the channel before using it. That's why, I never
> bothered with writing a reset driver on the hypervisor.
> 
>>
>>> You just unbind the HIDMA channel driver from the hypervisor and bind to vfio
>>> driver using the very same approach you'd use with PCIe. 
>>>
>>> Of course, this all assumes the presence of an IOMMU driver on the system. VFIO
>>> driver uses the IOMMU driver to create the mappings. 
>>
>> No IOMMU was described in the DT binding. It sounds like you'd need an
>> optional (not present in the guest) iommus property per-channel
> 
> You are right. I missed that part. I'll update the device-tree binding documentation.
> 
>>
>>> The mechanism used here is not different from VFIO PCI from user perspective.
>>>
>>>>
>>>> Given that, I'm at a loss as to how this would be used in a hypervisor
>>>> context. What am I missing?
>>>>
>>>> Are there additional patches, or do you have some userspace that works
>>>> with this in some limited configuration?
>>>
>>> No, these are the only patches. We have one patch for the QEMU but from kernel
>>> perspective this is it. 
>>
>> Do you have a link to that? Seeing it would help to ease my concerns.
> 
> The QEMU driver has not been posted yet. As far as I know, it just discovers the memory
> resources on the platform object and creates mappings for the guest machine only. 
> 
> Shanker Donthineni and Vikram Sethi will post the QEMU patch later.

Then may I suggest you both synchronize your submissions? I'd really
like to hear from the QEMU maintainers that they are satisfied with that
side of the story as well.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
