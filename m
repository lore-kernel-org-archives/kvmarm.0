From: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v6 2/5] vfio: allow the user to register reserved iova
	range for MSI mapping
Date: Fri, 8 Apr 2016 18:57:04 +0200
Message-ID: <5707E2E0.2010304@linaro.org>
References: <1459758611-2972-1-git-send-email-eric.auger@linaro.org>
	<1459758611-2972-3-git-send-email-eric.auger@linaro.org>
	<20160406160709.1d208b45@t450s.home> <57066401.7060406@linaro.org>
	<20160407122931.1ba3c01c@t450s.home> <5707D2B1.8080802@linaro.org>
	<20160408104139.210cb1f1@t450s.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20160408104139.210cb1f1-1yVPhWWZRC1BDLzU/O5InQ@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: julien.grall-5wv7dgnIgG8@public.gmane.org, eric.auger-qxv4g6HH51o@public.gmane.org, jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, p.fedin-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Manish.Jaggi-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, pranav.sawargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Alex,
On 04/08/2016 06:41 PM, Alex Williamson wrote:
> On Fri, 8 Apr 2016 17:48:01 +0200
> Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> 
> Hi Eric,
> 
>> Hi Alex,
>> On 04/07/2016 08:29 PM, Alex Williamson wrote:
>>> On Thu, 7 Apr 2016 15:43:29 +0200
>>> Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>>>   
>>>> Hi Alex,
>>>> On 04/07/2016 12:07 AM, Alex Williamson wrote:  
>>>>> On Mon,  4 Apr 2016 08:30:08 +0000
>>>>> Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>>>>>     
>>>>>> The user is allowed to [un]register a reserved IOVA range by using the
>>>>>> DMA MAP API and setting the new flag: VFIO_DMA_MAP_FLAG_MSI_RESERVED_IOVA.
>>>>>> It provides the base address and the size. This region is stored in the
>>>>>> vfio_dma rb tree. At that point the iova range is not mapped to any target
>>>>>> address yet. The host kernel will use those iova when needed, typically
>>>>>> when the VFIO-PCI device allocates its MSIs.
>>>>>>
>>>>>> This patch also handles the destruction of the reserved binding RB-tree and
>>>>>> domain's iova_domains.
>>>>>>
>>>>>> Signed-off-by: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>>>>> Signed-off-by: Bharat Bhushan <Bharat.Bhushan-KZfg59tc24xl57MIdRCFDg@public.gmane.org>
>>>>>>
>>>>>> ---
>>>>>> v3 -> v4:
>>>>>> - use iommu_alloc/free_reserved_iova_domain exported by dma-reserved-iommu
>>>>>> - protect vfio_register_reserved_iova_range implementation with
>>>>>>   CONFIG_IOMMU_DMA_RESERVED
>>>>>> - handle unregistration by user-space and on vfio_iommu_type1 release
>>>>>>
>>>>>> v1 -> v2:
>>>>>> - set returned value according to alloc_reserved_iova_domain result
>>>>>> - free the iova domains in case any error occurs
>>>>>>
>>>>>> RFC v1 -> v1:
>>>>>> - takes into account Alex comments, based on
>>>>>>   [RFC PATCH 1/6] vfio: Add interface for add/del reserved iova region:
>>>>>> - use the existing dma map/unmap ioctl interface with a flag to register
>>>>>>   a reserved IOVA range. A single reserved iova region is allowed.
>>>>>>
>>>>>> Conflicts:
>>>>>> 	drivers/vfio/vfio_iommu_type1.c
>>>>>> ---
>>>>>>  drivers/vfio/vfio_iommu_type1.c | 141 +++++++++++++++++++++++++++++++++++++++-
>>>>>>  include/uapi/linux/vfio.h       |  12 +++-
>>>>>>  2 files changed, 150 insertions(+), 3 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>>>>> index c9ddbde..4497b20 100644
>>>>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>>>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>>>>> @@ -36,6 +36,7 @@
>>>>>>  #include <linux/uaccess.h>
>>>>>>  #include <linux/vfio.h>
>>>>>>  #include <linux/workqueue.h>
>>>>>> +#include <linux/dma-reserved-iommu.h>
>>>>>>  
>>>>>>  #define DRIVER_VERSION  "0.2"
>>>>>>  #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>"
>>>>>> @@ -403,10 +404,22 @@ static void vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma)
>>>>>>  	vfio_lock_acct(-unlocked);
>>>>>>  }
>>>>>>  
>>>>>> +static void vfio_unmap_reserved(struct vfio_iommu *iommu)
>>>>>> +{
>>>>>> +#ifdef CONFIG_IOMMU_DMA_RESERVED
>>>>>> +	struct vfio_domain *d;
>>>>>> +
>>>>>> +	list_for_each_entry(d, &iommu->domain_list, next)
>>>>>> +		iommu_unmap_reserved(d->domain);
>>>>>> +#endif
>>>>>> +}
>>>>>> +
>>>>>>  static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>>>>>>  {
>>>>>>  	if (likely(dma->type != VFIO_IOVA_RESERVED))
>>>>>>  		vfio_unmap_unpin(iommu, dma);
>>>>>> +	else
>>>>>> +		vfio_unmap_reserved(iommu);
>>>>>>  	vfio_unlink_dma(iommu, dma);
>>>>>>  	kfree(dma);
>>>>>>  }    
>>>>>
>>>>> This makes me nervous, apparently we can add reserved mappings
>>>>> individually, but we have absolutely no granularity on remove, so if we
>>>>> remove one, we've removed them all even though we still have them
>>>>> linked in our rb tree.  I see later that only one reserved region is
>>>>> allowed, but that seems very short sighted, especially to impose that
>>>>> on the user level API.    
>>>> On kernel-size the reserved region is currently backed by a unique
>>>> iova_domain. Do you mean you would like me to handle a list of
>>>> iova_domains instead of using a single "cookie"?  
>>>
>>> TBH, I'm not really sure how this works with a single iova domain.  If
>>> we have multiple irq chips and each gets mapped by a separate page in
>>> the iova space, then is it really sufficient to do a lookup from the
>>> irq_data to the msi_desc to the device to the domain in order to get
>>> reserved iova to map that msi doorbell?  Don't we need an iova from the
>>> pool mapping the specific irqchip associated with our device?  The IOMMU
>>> domain might span any number of irq chips, how can we assume there's
>>> one only reserved iova space?  Maybe I'm not understanding how the code
>>> works.  
>>
>> On vfio_iommu_type1 we currently compute the reserved iova needs for
>> each domain and we take the max. Each domain then is assigned a reserved
>> iova domain of this max size.
>>
>> So let's say domain1 has the largest needs (say 2 doorbells)
>> domain 1: iova domain size = 2
>> dev A --> doorbell 1
>> dev B -> doorbell 1
>> dev C -> doorbell 2
>> 2 iova pages are used
>>
>> domain 2: iova domain size = 2
>> dev D -> doorbell 1
>> 1 iova page is used.
>>
>> Do you see something wrong here?
> 
> Can we really know the maximum reserved iova space for a domain?  It
> seems like this depends on the current composition of the domain, so it
> could change as devices are added to the domain.  Or perhaps the
> maximum is based on a maximally configured domain, but even then the
> system itself may be expandable so it might need to account for an
> architectural maximum.  A user like QEMU would likely have an easier
> time dealing with an absolute maximum than a current maximum.  Maybe a
> single range would be sufficient under those conditions.

yes definitively if the domain evolves we may need to extend the
reserved iova domain. Also dealing with an arbitary absolute maximum is
much easier to integrate on (QEMU) user side.

> 
>>> Conceptually, this is a generic IOMMU API extension to include reserved
>>> ioor va space, MSI mappings are a consumer of that reserved iova pool but
>>> I don't think we can say they will necessarily be the only consumer.
>>> So building into the interface that there's only one is like making a
>>> fixed length array to hold a string, it works for the initial
>>> implementation, but it's not a robust solution.  
>>
>> I see. On the other hand the code is quite specific to MSI binding
>> problematic today (rb-tree indexed on PA, locking, ...). argh, storm in
>> a teacup...
> 
> For the vfio api, the interface is already specific to MSI, so that
> seems reasonable.  I'd still rather expose somehow to the user that
> only a single reserved MSI region is supported, even if that's all the
> implementation can handle, just so we have the option to expand that in
> the future.  The iommu api is internal, so we can expand it as we go, i
> just want to be sure to raise the issue even if we think the
> restrictions are sufficient for now.  Thanks,

OK I agree. I Will change the doc/code accordingly.

Best Regards

Eric
> 
> Alex
> 
