From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC v3 18/21] vfio-pci: Add a new VFIO_REGION_TYPE_NESTED region
 type
Date: Tue, 15 Jan 2019 22:56:51 +0100
Message-ID: <1ec95b07-4485-da37-9a72-92a3cd146da0@redhat.com>
References: <20190108102633.17482-1-eric.auger@redhat.com>
 <20190108102633.17482-19-eric.auger@redhat.com>
 <20190111165838.06a22ab8@x1.home>
 <497dad10-8832-3f2c-3ff8-fbcdd4c41ae4@redhat.com>
 <20190114160422.6e320df9@x1.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190114160422.6e320df9@x1.home>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alex Williamson <alex.williamson@redhat.com>
Cc: eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, jacob.jun.pan@linux.intel.com, yi.l.liu@linux.intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com, robin.murphy@arm.com, kevin.tian@intel.com, ashok.raj@intel.com, marc.zyngier@arm.com, christoffer.dall@arm.com, peter.maydell@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Alex,

On 1/15/19 12:04 AM, Alex Williamson wrote:
> On Mon, 14 Jan 2019 21:48:06 +0100
> Auger Eric <eric.auger@redhat.com> wrote:
> 
>> Hi Alex,
>>
>> On 1/12/19 12:58 AM, Alex Williamson wrote:
>>> On Tue,  8 Jan 2019 11:26:30 +0100
>>> Eric Auger <eric.auger@redhat.com> wrote:
>>>   
>>>> This patch adds a new 64kB region aiming to report nested mode
>>>> translation faults.
>>>>
>>>> The region contains a header with the size of the queue,
>>>> the producer and consumer indices and then the actual
>>>> fault queue data. The producer is updated by the kernel while
>>>> the consumer is updated by the userspace.
>>>>
>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>>
>>>> ---
>>>> ---
>>>>  drivers/vfio/pci/vfio_pci.c         | 102 +++++++++++++++++++++++++++-
>>>>  drivers/vfio/pci/vfio_pci_private.h |   2 +
>>>>  include/uapi/linux/vfio.h           |  15 ++++
>>>>  3 files changed, 118 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
>>>> index ff60bd1ea587..2ba181ab2edd 100644
>>>> --- a/drivers/vfio/pci/vfio_pci.c
>>>> +++ b/drivers/vfio/pci/vfio_pci.c
>>>> @@ -56,6 +56,11 @@ module_param(disable_idle_d3, bool, S_IRUGO | S_IWUSR);
>>>>  MODULE_PARM_DESC(disable_idle_d3,
>>>>  		 "Disable using the PCI D3 low power state for idle, unused devices");
>>>>  
>>>> +#define VFIO_FAULT_REGION_SIZE 0x10000  
>>>
>>> Why 64K?  
>> For the region to be mmappable with 64kB page size.
> 
> Isn't hard coding 64K just as bad as hard coding 4K?  The kernel knows
> what PAGE_SIZE is after all.  Is there some target number of queue
> entries here that we could round up to a multiple of PAGE_SIZE?
Spec says the queue size has max 2^n events with n <= 19. n is
implementation dependent. In practice the driver uses 2^8 entries, each
entry being 32 bytes so the event queue is 8kB. So depending on the size
of the entry we are going to choose here we may need a queue counting
around the same number of entries.

>  
>>>> +#define VFIO_FAULT_QUEUE_SIZE	\
>>>> +	((VFIO_FAULT_REGION_SIZE - sizeof(struct vfio_fault_region_header)) / \
>>>> +	sizeof(struct iommu_fault))
>>>> +
>>>>  static inline bool vfio_vga_disabled(void)
>>>>  {
>>>>  #ifdef CONFIG_VFIO_PCI_VGA
>>>> @@ -1226,6 +1231,100 @@ static const struct vfio_device_ops vfio_pci_ops = {
>>>>  static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev);
>>>>  static void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck);
>>>>  
>>>> +static size_t
>>>> +vfio_pci_dma_fault_rw(struct vfio_pci_device *vdev, char __user *buf,
>>>> +		      size_t count, loff_t *ppos, bool iswrite)
>>>> +{
>>>> +	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
>>>> +	void *base = vdev->region[i].data;
>>>> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
>>>> +
>>>> +	if (pos >= vdev->region[i].size)
>>>> +		return -EINVAL;
>>>> +
>>>> +	count = min(count, (size_t)(vdev->region[i].size - pos));
>>>> +
>>>> +	if (copy_to_user(buf, base + pos, count))
>>>> +		return -EFAULT;
>>>> +
>>>> +	*ppos += count;
>>>> +
>>>> +	return count;
>>>> +}
>>>> +
>>>> +static int vfio_pci_dma_fault_mmap(struct vfio_pci_device *vdev,
>>>> +				   struct vfio_pci_region *region,
>>>> +				   struct vm_area_struct *vma)
>>>> +{
>>>> +	u64 phys_len, req_len, pgoff, req_start;
>>>> +	unsigned long long addr;
>>>> +	unsigned int index;
>>>> +
>>>> +	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
>>>> +
>>>> +	if (vma->vm_end < vma->vm_start)
>>>> +		return -EINVAL;
>>>> +	if ((vma->vm_flags & VM_SHARED) == 0)
>>>> +		return -EINVAL;
>>>> +
>>>> +	phys_len = VFIO_FAULT_REGION_SIZE;
>>>> +
>>>> +	req_len = vma->vm_end - vma->vm_start;
>>>> +	pgoff = vma->vm_pgoff &
>>>> +		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
>>>> +	req_start = pgoff << PAGE_SHIFT;
>>>> +
>>>> +	if (req_start + req_len > phys_len)
>>>> +		return -EINVAL;
>>>> +
>>>> +	addr = virt_to_phys(vdev->fault_region);
>>>> +	vma->vm_private_data = vdev;
>>>> +	vma->vm_pgoff = (addr >> PAGE_SHIFT) + pgoff;
>>>> +
>>>> +	return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
>>>> +			       req_len, vma->vm_page_prot);
>>>> +}
>>>> +
>>>> +void vfio_pci_dma_fault_release(struct vfio_pci_device *vdev,
>>>> +				struct vfio_pci_region *region)
>>>> +{
>>>> +}
>>>> +
>>>> +static const struct vfio_pci_regops vfio_pci_dma_fault_regops = {
>>>> +	.rw		= vfio_pci_dma_fault_rw,
>>>> +	.mmap		= vfio_pci_dma_fault_mmap,
>>>> +	.release	= vfio_pci_dma_fault_release,
>>>> +};
>>>> +
>>>> +static int vfio_pci_init_dma_fault_region(struct vfio_pci_device *vdev)
>>>> +{
>>>> +	u32 flags = VFIO_REGION_INFO_FLAG_READ | VFIO_REGION_INFO_FLAG_WRITE |
>>>> +		    VFIO_REGION_INFO_FLAG_MMAP;
>>>> +	int ret;
>>>> +
>>>> +	spin_lock_init(&vdev->fault_queue_lock);
>>>> +
>>>> +	vdev->fault_region = kmalloc(VFIO_FAULT_REGION_SIZE, GFP_KERNEL);
>>>> +	if (!vdev->fault_region)
>>>> +		return -ENOMEM;
>>>> +
>>>> +	ret = vfio_pci_register_dev_region(vdev,
>>>> +		VFIO_REGION_TYPE_NESTED,
>>>> +		VFIO_REGION_SUBTYPE_NESTED_FAULT_REGION,
>>>> +		&vfio_pci_dma_fault_regops, VFIO_FAULT_REGION_SIZE,
>>>> +		flags, vdev->fault_region);
>>>> +	if (ret) {
>>>> +		kfree(vdev->fault_region);
>>>> +		return ret;
>>>> +	}
>>>> +
>>>> +	vdev->fault_region->header.prod = 0;
>>>> +	vdev->fault_region->header.cons = 0;
>>>> +	vdev->fault_region->header.reserved = 0;  
>>>
>>> Use kzalloc above or else we're leaking kernel memory to userspace
>>> anyway.  
>> sure
>>>   
>>>> +	vdev->fault_region->header.size = VFIO_FAULT_QUEUE_SIZE;
>>>> +	return 0;
>>>> +}
>>>> +
>>>>  static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>>>  {
>>>>  	struct vfio_pci_device *vdev;
>>>> @@ -1300,7 +1399,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>>>  		pci_set_power_state(pdev, PCI_D3hot);
>>>>  	}
>>>>  
>>>> -	return ret;
>>>> +	return vfio_pci_init_dma_fault_region(vdev);  
>>>
>>> Missing lots of cleanup should this fail.  Why is this done on probe
>>> anyway?  This looks like something we'd do from vfio_pci_enable() and
>>> therefore our release callback would free fault_region rather than what
>>> we have below.  
>> OK. That's fine to put in the vfio_pci_enable().
>>>   
>>>>  }
>>>>  
>>>>  static void vfio_pci_remove(struct pci_dev *pdev)
>>>> @@ -1315,6 +1414,7 @@ static void vfio_pci_remove(struct pci_dev *pdev)
>>>>  
>>>>  	vfio_iommu_group_put(pdev->dev.iommu_group, &pdev->dev);
>>>>  	kfree(vdev->region);
>>>> +	kfree(vdev->fault_region);
>>>>  	mutex_destroy(&vdev->ioeventfds_lock);
>>>>  	kfree(vdev);
>>>>  
>>>> diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
>>>> index 8c0009f00818..38b5d1764a26 100644
>>>> --- a/drivers/vfio/pci/vfio_pci_private.h
>>>> +++ b/drivers/vfio/pci/vfio_pci_private.h
>>>> @@ -120,6 +120,8 @@ struct vfio_pci_device {
>>>>  	int			ioeventfds_nr;
>>>>  	struct eventfd_ctx	*err_trigger;
>>>>  	struct eventfd_ctx	*req_trigger;
>>>> +	spinlock_t              fault_queue_lock;
>>>> +	struct vfio_fault_region *fault_region;
>>>>  	struct list_head	dummy_resources_list;
>>>>  	struct mutex		ioeventfds_lock;
>>>>  	struct list_head	ioeventfds_list;
>>>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>>>> index 352e795a93c8..b78c2c62af6d 100644
>>>> --- a/include/uapi/linux/vfio.h
>>>> +++ b/include/uapi/linux/vfio.h
>>>> @@ -307,6 +307,9 @@ struct vfio_region_info_cap_type {
>>>>  #define VFIO_REGION_TYPE_GFX                    (1)
>>>>  #define VFIO_REGION_SUBTYPE_GFX_EDID            (1)
>>>>  
>>>> +#define VFIO_REGION_TYPE_NESTED			(2)
>>>> +#define VFIO_REGION_SUBTYPE_NESTED_FAULT_REGION	(1)
>>>> +
>>>>  /**
>>>>   * struct vfio_region_gfx_edid - EDID region layout.
>>>>   *
>>>> @@ -697,6 +700,18 @@ struct vfio_device_ioeventfd {
>>>>  
>>>>  #define VFIO_DEVICE_IOEVENTFD		_IO(VFIO_TYPE, VFIO_BASE + 16)
>>>>  
>>>> +struct vfio_fault_region_header {
>>>> +	__u32	size;		/* Read-Only */
>>>> +	__u32	prod;		/* Read-Only */  
>>>
>>> We can't really enforce read-only if it's mmap'd.  
>> Do we really need to? Assuming the kernel always uses
>> VFIO_FAULT_QUEUE_SIZE to check prod and cons indice - which is not the
>> case at the moment by the way :-( -s, the queue cannot
>> be overflown .
>>
>> The header also can be checked each time the kernel fills any event in
>> the queue
>> (vfio_pci_iommu_dev_fault_handler). If inconsistent the kernel may stop
>> using the queue. If the user-space mangles with those RO fields, this
>> will break error reporting on the guest but the problem should be
>> confined here?
> 
> I guess this is a matter of whether the performance benefit is worth
> the hardening and I can imagine that it could be, but we do need that
> hardening and well defined behavior to the user.  If we put it into a
> single page then we need to define if a user write to the producer index
> resets the index or if it's just a shadow of internal state and will be
> restored on the next update. 
I had in mind the kernel would leave the prod value by the userspace.
Obviously the error reporting would be broken then.
 Does a user write to the size register
> change the size of the queue or is it ignored?
it would be ignored and restored on the subsquent kernel push
  Is there an event that
> will restore it?  Maybe the size should be exposed as a part of a
> region info capability like we've done for some of the new nvlink
> regions.
> 
>>> I worry about synchronization here too, perhaps there should be a ring offset such
>>> that the ring can be in a separate page from the header and then sparse
>>> mmap support can ensure that the user access is restricted.  
>>
>> I was assuming a single writer and single reader lock-free circular
>> buffer here. My understanding was it was safe to consider concurrent
>> read and write. What I am missing anyway is atomic counter operations to
>> guarantee the indices are updated after the push/pop action as explained in
>> https://www.kernel.org/doc/Documentation/circular-buffers.txt. I am not
>> comfortable about how to enforce this on user side though.
> 
> It doesn't seem enforceable to the user without slowing down the
> interface, either via ioctl or non-mmap.  I think it's fine to have
> acquire and release semantics, we just need to define them and have
> safe, predictable behavior when the user does something wrong (and
> expect them to do something wrong, intentionally or not).
Agreed. I am not comfortable either with the existing proto despite it
works in my case.
> 
>> In case I split the header and the actual buffer into 2 different
>> possible 64kB pages, the first one will be very scarcely used.
> 
> Yes, it's wasteful, a shared page would be preferred, but it's also
> only a page.
agreed
> 
>>> wonder if there are other transports that make sense here, this almost
>>> feels like a vhost sort of thing.  Thanks,  
>> Using something more sophisticated may be useful for PRI where answers
>> need to be provided. For the case of unrecoverable faults, I wonder
>> whether it is worth the pain exposing a fault region compared to the
>> original IOCTL approach introduced in
>> [RFC v2 18/20] vfio: VFIO_IOMMU_GET_FAULT_EVENTS
>> https://lkml.org/lkml/2018/9/18/1094
> 
> Not sure I understand the pain aspect, if we don't support mmap on a
> region then we can fill a user read from a region just as easily as we
> can fill a buffer passed via ioctl.  Thanks,
My impression was the previous VFIO_IOMMU_GET_FAULT_EVENTS ioctl based
approach filling the user provided buffer with available events was
rather simple compared to the region implementation (my own filling). We
could use the kfifo utilities without needing to define a region layout.

Thanks

Eric
> 
> Alex
> 
