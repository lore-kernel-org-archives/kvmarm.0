From: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 0/4] vfio: type1: support for ARM SMMUS with
	VFIO_IOMMU_TYPE1
Date: Fri, 06 Mar 2015 13:41:03 +0100
Message-ID: <54F9A05F.3080603@linaro.org>
References: <1425485274-5709-1-git-send-email-b.reynal@virtualopensystems.com>	<1425491104.5200.268.camel@redhat.com>	<54F893C3.6020006@linaro.org>	<1425589915.5200.336.camel@redhat.com>	<54F96D96.8040207@linaro.org>	<20150306104148.GC22377@arm.com>
	<CAN9JPjHWcXuzkByJY1gnbvi28nZX8RBbZXDA2t-VeK6v8OrSRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <CAN9JPjHWcXuzkByJY1gnbvi28nZX8RBbZXDA2t-VeK6v8OrSRg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Baptiste Reynal <b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: "tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org" <tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org" <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi All,

On 03/06/2015 12:27 PM, Baptiste Reynal wrote:
> Hi everyone,
> 
> Indeed, the NOEXEC flag is needed for our tests and VFIO should work
> without it for some other devices (including xgmac). I think it is
> reasonable to drop this patch serie for now.
> 
> Still we have the IOMMU_CACHE issue. To answer Will, the SMMU page
> tables are installed at stage-2. Currently, the dma-coherent flag is
> not preserved to the guest, that may be the issue (As we don't have it
> in the host in our case). "[RFC PATCH v3 0/3] vfio: platform: return
> device properties for a platform device"
> (http://lists.celinuxforum.org/pipermail/iommu/2014-December/011425.html)
> may be a solution to figure out if the device is coherent or not.
> 
> 
> On Fri, Mar 6, 2015 at 11:41 AM, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org> wrote:
>> Hi Eric,
>>
>> On Fri, Mar 06, 2015 at 09:04:22AM +0000, Eric Auger wrote:
>>> Yes to me "vfio: type1: support for ARM SMMUS with VFIO_IOMMU_TYPE1" is
>>> not a direct dependency of vfio-platform driver although I understand
>>> Baptiste needs it to test with PL330 device. On my side I can test
>>> vfio-platform driver without it, assigning the Midway Calxeda xgmac.
>>
>> Realistically, I don't expect anybody using device passthrough for
>> practical applications to be using a PL330. Your xgmac example is far
>> more compelling.
>>
>>> Also if I am not wrong the title of the series now does not really
>>> reflect anymore what the series aims at. since "[PATCH v3 2/6] vfio:
>>> type1: support for ARM SMMUs"  withdrawal, the series now "only" aims at
>>> supporting the VFIO_DMA_MAP_FLAG_NOEXEC flag.
>>>
>>> However with this issue of IOMMU_CACHE always set along with arm-smmu,
>>> there is a need for an adaptation of either vfio_iommu_type1 or arm-smmu
>>> since the integrated pieces are not functional.
>>
>> Well, I'm still trying to understand exactly what is happening in your case:
>>
>>   - Is the xgmac coherent or not? Does it have a "dma-coherent" property?
Yes it has the dma-coherent property
>>   - Are you installing the SMMU page tables at stage-1 or stage-2?
stage2
>>   - If it *is* coherent, then we should use IOMMU_CACHE mappings for the
>>     DMA buffers and ensure that the guest knows it is coherent (by
>>     preserving the "dma-coherent" flag).
indeed that's the point then.
>>   - If it is *not* coherent, then the behaviour of IOMMU_CACHE depends
>>     on the stage of translation:
>>
>>     * Stage-1: we will make the transactions cacheable, and you'll need
>>       to tell the guest that the device is actually cache coherent
>>     * Stage-2: IOMMU_CACHE won't actually have any effect, so everything
>>       should work as non-coherent.
>>
>> In other words, I think you're probably just telling the guest the wrong
>> thing.
>>
>>> On top of the dma-coherent property of the *master*, should not we also
>>> query the cache-coherent property of the interconnect downstream to the
>>> smmu?
>>
>> I don't think so... "dma-coherent" should only be set on a master if the
>> interconnect is properly configured. It's supposed to be a "If you DMA now,
>> it will snoop the CPU caches" flag as opposed to "If you write a random
>> selection of MMIO registers in the SoC, then this device will be coherent".
OK
>>
>>> How can we progress quickly on this topic? is it acceptable to return
>>> false on arm_smmu_capable(IOMMU_CAP_CACHE_COHERENCY) as a quick hack?
>>
>> No; pretending that a device is not coherent when it actually is can lead
>> to corruption of DMA buffers due to unnecessary cache invalidation.
>>
>>> As a longer term solution, would it make sense to add a user flag at VFIO
>>> user API level to turn the IOMMU_CACHE on?
>>
>> I think userspace certainly needs a way to figure out if a device is
>> coherent or not, otherwise it can't generate the correct device-tree
>> properties for something like a KVM guest but the IOMMU_* setting should
>> remain in the kernel IMO. Similarly for things like MSI pages, which would
>> need to be mapped as device memory on ARM -- that should be exposed as a
>> higher level "please map my MSI page here" ioctl as opposed to requiring
>> userspace to supply the correct memory attributes.

Many thanks for the explanations.

Best Regards

Eric
>>
>> Will
