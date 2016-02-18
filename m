From: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC v3 05/15] iommu/arm-smmu: implement
	alloc/free_reserved_iova_domain
Date: Thu, 18 Feb 2016 16:22:28 +0100
Message-ID: <56C5E1B4.20905@linaro.org>
References: <1455264797-2334-1-git-send-email-eric.auger@linaro.org>
	<1455264797-2334-6-git-send-email-eric.auger@linaro.org>
	<56C5A65D.5010401@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <56C5A65D.5010401-5wv7dgnIgG8@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>, eric.auger-qxv4g6HH51o@public.gmane.org, alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Thomas.Lendacky-5C7GfCeVMHo@public.gmane.org, brijesh.singh-5C7GfCeVMHo@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Manish.Jaggi-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, p.fedin-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, pranav.sawargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sherry.hurwitz-5C7GfCeVMHo@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Robin,
On 02/18/2016 12:09 PM, Robin Murphy wrote:
> Hi Eric,
> 
> On 12/02/16 08:13, Eric Auger wrote:
>> Implement alloc/free_reserved_iova_domain for arm-smmu. we use
>> the iova allocator (iova.c). The iova_domain is attached to the
>> arm_smmu_domain struct. A mutex is introduced to protect it.
> 
> The IOMMU API currently leaves IOVA management entirely up to the caller
I agree

> - VFIO is already managing its own IOVA space, so what warrants this
> being pushed all the way down to the IOMMU driver?
In practice, with upstreamed code, VFIO uses IOVA = GPA provided by the
user-space (corresponding to RAM regions) and does not allocate IOVA
itself. The IOVA is passed through the VFIO_IOMMU_MAP_DMA ioctl.

With that series we propose that the user-space provides a pool of
unused IOVA that can be used to map Host physical addresses (MSI frame
address). So effectively someone needs to use an iova allocator to
allocate within that window. This can be vfio or the iommu driver. But
in both cases this is a new capability introduced in either component.

In the first version of this series
(https://lkml.org/lkml/2016/1/26/371) I put this iova allocation in
vfio_iommu_type1. the vfio-pci driver then was using this vfio internal
API to overwrite the physical address written in the PCI device by the
MSI controller.

However I was advised by Alex to move things at a lower level
(http://www.spinics.net/lists/kvm/msg126809.html), IOMMU core or irq
remapping driver; also the MSI controller should directly program the
IOVA address in the PCI device.

On ARM, irq remapping is somehow abstracted in ITS driver. Also we need
that functionality in GICv2M so I eventually chose to put the
functionality in the IOMMU driver. Since iova.c is not compiled by
everyone and since that functionality is needed for a restricted set of
architectures, ARM/ARM64 & PowerPC I chose to implement this in arhc
specific code, for the time being in arm-smmu.c.

This allows the MSI controller to interact with the IOMMU API to bind
its MSI address. I think it may be feasible to have the MSI controller
interact with the vfio external user API but does it look better?

Assuming we can agree on the relevance of adding that functionality at
IOMMU API level, maybe we can create a separate .c file to share code
between arm-smmu and arm-smmu-v3.c? or even I could dare to add this
into the iommu generic part. What is your opinion?

 All I see here is
> abstract code with no hardware-specific details that'll have to be
> copy-pasted into other IOMMU drivers (e.g. SMMUv3), which strongly
> suggests it's the wrong place to do it.
> 
> As I understand the problem, VFIO has a generic "configure an IOMMU to
> point at an MSI doorbell" step to do in the process of attaching a
> device, which hasn't needed implementing yet due to VT-d's
> IOMMU_CAP_I_AM_ALSO_ACTUALLY_THE_MSI_CONTROLLER_IN_DISGUISE flag, which
> most of us have managed to misinterpret so far.

Maybe I misunderstood the above comment but I would say this is the
contrary: ie up to now, VFIO did not need to care about that issue since
MSI addresses were not mapped in the IOMMU on x86. Now they need to be
so we need to extend an existing API, would it be VFIO external user API
or IOMMU API. But please correct if I misunderstood you.

Also I found it more practical to have a all-in-one API doing both the
iova allocation and binding (dma_map_single like). the user of the API
does not have to care about the iommu page size.

Thanks for your time and looking forward to reading from you!

Best Regards

Eric

 AFAICS all the IOMMU
> driver should need to know about this is an iommu_map() call (which will
> want a slight extension[1] to make things behave properly). We should be
> fixing the abstraction to be less x86-centric, not hacking up all the
> ARM drivers to emulate x86 hardware behaviour in software.
> 
> Robin.
> 
> [1]:http://article.gmane.org/gmane.linux.kernel.cross-arch/30833
> 
>> Signed-off-by: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>
>> ---
>> v2 -> v3:
>> - select IOMMU_IOVA when ARM_SMMU or ARM_SMMU_V3 is set
>>
>> v1 -> v2:
>> - formerly implemented in vfio_iommu_type1
>> ---
>>   drivers/iommu/Kconfig    |  2 ++
>>   drivers/iommu/arm-smmu.c | 87
>> +++++++++++++++++++++++++++++++++++++++---------
>>   2 files changed, 74 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
>> index a1e75cb..1106528 100644
>> --- a/drivers/iommu/Kconfig
>> +++ b/drivers/iommu/Kconfig
>> @@ -289,6 +289,7 @@ config ARM_SMMU
>>       bool "ARM Ltd. System MMU (SMMU) Support"
>>       depends on (ARM64 || ARM) && MMU
>>       select IOMMU_API
>> +    select IOMMU_IOVA
>>       select IOMMU_IO_PGTABLE_LPAE
>>       select ARM_DMA_USE_IOMMU if ARM
>>       help
>> @@ -302,6 +303,7 @@ config ARM_SMMU_V3
>>       bool "ARM Ltd. System MMU Version 3 (SMMUv3) Support"
>>       depends on ARM64 && PCI
>>       select IOMMU_API
>> +    select IOMMU_IOVA
>>       select IOMMU_IO_PGTABLE_LPAE
>>       select GENERIC_MSI_IRQ_DOMAIN
>>       help
>> diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
>> index c8b7e71..f42341d 100644
>> --- a/drivers/iommu/arm-smmu.c
>> +++ b/drivers/iommu/arm-smmu.c
>> @@ -42,6 +42,7 @@
>>   #include <linux/platform_device.h>
>>   #include <linux/slab.h>
>>   #include <linux/spinlock.h>
>> +#include <linux/iova.h>
>>
>>   #include <linux/amba/bus.h>
>>
>> @@ -347,6 +348,9 @@ struct arm_smmu_domain {
>>       enum arm_smmu_domain_stage    stage;
>>       struct mutex            init_mutex; /* Protects smmu pointer */
>>       struct iommu_domain        domain;
>> +    struct iova_domain        *reserved_iova_domain;
>> +    /* protects reserved domain manipulation */
>> +    struct mutex            reserved_mutex;
>>   };
>>
>>   static struct iommu_ops arm_smmu_ops;
>> @@ -975,6 +979,7 @@ static struct iommu_domain
>> *arm_smmu_domain_alloc(unsigned type)
>>           return NULL;
>>
>>       mutex_init(&smmu_domain->init_mutex);
>> +    mutex_init(&smmu_domain->reserved_mutex);
>>       spin_lock_init(&smmu_domain->pgtbl_lock);
>>
>>       return &smmu_domain->domain;
>> @@ -1446,22 +1451,74 @@ out_unlock:
>>       return ret;
>>   }
>>
>> +static int arm_smmu_alloc_reserved_iova_domain(struct iommu_domain
>> *domain,
>> +                           dma_addr_t iova, size_t size,
>> +                           unsigned long order)
>> +{
>> +    unsigned long granule, mask;
>> +    struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
>> +    int ret = 0;
>> +
>> +    granule = 1UL << order;
>> +    mask = granule - 1;
>> +    if (iova & mask || (!size) || (size & mask))
>> +        return -EINVAL;
>> +
>> +    if (smmu_domain->reserved_iova_domain)
>> +        return -EEXIST;
>> +
>> +    mutex_lock(&smmu_domain->reserved_mutex);
>> +
>> +    smmu_domain->reserved_iova_domain =
>> +        kzalloc(sizeof(struct iova_domain), GFP_KERNEL);
>> +    if (!smmu_domain->reserved_iova_domain) {
>> +        ret = -ENOMEM;
>> +        goto unlock;
>> +    }
>> +
>> +    init_iova_domain(smmu_domain->reserved_iova_domain,
>> +             granule, iova >> order, (iova + size - 1) >> order);
>> +
>> +unlock:
>> +    mutex_unlock(&smmu_domain->reserved_mutex);
>> +    return ret;
>> +}
>> +
>> +static void arm_smmu_free_reserved_iova_domain(struct iommu_domain
>> *domain)
>> +{
>> +    struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
>> +    struct iova_domain *iovad = smmu_domain->reserved_iova_domain;
>> +
>> +    if (!iovad)
>> +        return;
>> +
>> +    mutex_lock(&smmu_domain->reserved_mutex);
>> +
>> +    put_iova_domain(iovad);
>> +    kfree(iovad);
>> +
>> +    mutex_unlock(&smmu_domain->reserved_mutex);
>> +}
>> +
>>   static struct iommu_ops arm_smmu_ops = {
>> -    .capable        = arm_smmu_capable,
>> -    .domain_alloc        = arm_smmu_domain_alloc,
>> -    .domain_free        = arm_smmu_domain_free,
>> -    .attach_dev        = arm_smmu_attach_dev,
>> -    .detach_dev        = arm_smmu_detach_dev,
>> -    .map            = arm_smmu_map,
>> -    .unmap            = arm_smmu_unmap,
>> -    .map_sg            = default_iommu_map_sg,
>> -    .iova_to_phys        = arm_smmu_iova_to_phys,
>> -    .add_device        = arm_smmu_add_device,
>> -    .remove_device        = arm_smmu_remove_device,
>> -    .device_group        = arm_smmu_device_group,
>> -    .domain_get_attr    = arm_smmu_domain_get_attr,
>> -    .domain_set_attr    = arm_smmu_domain_set_attr,
>> -    .pgsize_bitmap        = -1UL, /* Restricted during device attach */
>> +    .capable            = arm_smmu_capable,
>> +    .domain_alloc            = arm_smmu_domain_alloc,
>> +    .domain_free            = arm_smmu_domain_free,
>> +    .attach_dev            = arm_smmu_attach_dev,
>> +    .detach_dev            = arm_smmu_detach_dev,
>> +    .map                = arm_smmu_map,
>> +    .unmap                = arm_smmu_unmap,
>> +    .map_sg                = default_iommu_map_sg,
>> +    .iova_to_phys            = arm_smmu_iova_to_phys,
>> +    .add_device            = arm_smmu_add_device,
>> +    .remove_device            = arm_smmu_remove_device,
>> +    .device_group            = arm_smmu_device_group,
>> +    .domain_get_attr        = arm_smmu_domain_get_attr,
>> +    .domain_set_attr        = arm_smmu_domain_set_attr,
>> +    .alloc_reserved_iova_domain    =
>> arm_smmu_alloc_reserved_iova_domain,
>> +    .free_reserved_iova_domain    = arm_smmu_free_reserved_iova_domain,
>> +    /* Page size bitmap, restricted during device attach */
>> +    .pgsize_bitmap            = -1UL,
>>   };
>>
>>   static void arm_smmu_device_reset(struct arm_smmu_device *smmu)
>>
> 
