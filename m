From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 19/22] KVM: arm64: vgic-its: ITT save and restore
Date: Thu, 4 May 2017 09:40:35 +0200
Message-ID: <3d00df6f-3360-e9b3-7618-e3ec528ae36a@redhat.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-20-git-send-email-eric.auger@redhat.com>
 <20170430201438.GB1499@lvm> <8ccb9bec-0df6-732b-c0b3-3c2067c67bf0@redhat.com>
 <20170503163742.GA29506@cbox>
 <3af9ae62-1e20-e0f4-a2a9-db0a7a1b10ef@redhat.com>
 <20170504073110.GA5923@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170504073110.GA5923@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, eric.auger.pro@gmail.com, marc.zyngier@arm.com, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 04/05/2017 09:31, Christoffer Dall wrote:
> On Wed, May 03, 2017 at 11:55:34PM +0200, Auger Eric wrote:
>> Hi Christoffer,
>>
>> On 03/05/2017 18:37, Christoffer Dall wrote:
>>> On Wed, May 03, 2017 at 06:08:58PM +0200, Auger Eric wrote:
>>>> Hi Christoffer,
>>>>
>>>> On 30/04/2017 22:14, Christoffer Dall wrote:
>>>>> On Fri, Apr 14, 2017 at 12:15:31PM +0200, Eric Auger wrote:
>>>>>> Introduce routines to save and restore device ITT and their
>>>>>> interrupt table entries (ITE).
>>>>>>
>>>>>> The routines will be called on device table save and
>>>>>> restore. They will become static in subsequent patches.
>>>>>
>>>>> Why this bottom-up approach?  Couldn't you start by having the patch
>>>>> that restores the device table and define the static functions that
>>>>> return an error there
>>>> done
>>>> , and then fill them in with subsequent patches
>>>>> (liek this one)?
>>>>>
>>>>> That would have the added benefit of being able to tell how things are
>>>>> designed to be called.
>>>>>
>>>>>>
>>>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>>>>
>>>>>> ---
>>>>>> v4 -> v5:
>>>>>> - ITE are now sorted by eventid on the flush
>>>>>> - rename *flush* into *save*
>>>>>> - use macros for shits and masks
>>>>>> - pass ite_esz to vgic_its_save_ite
>>>>>>
>>>>>> v3 -> v4:
>>>>>> - lookup_table and compute_next_eventid_offset become static in this
>>>>>>   patch
>>>>>> - remove static along with vgic_its_flush/restore_itt to avoid
>>>>>>   compilation warnings
>>>>>> - next field only computed with a shift (mask removed)
>>>>>> - handle the case where the last element has not been found
>>>>>>
>>>>>> v2 -> v3:
>>>>>> - add return 0 in vgic_its_restore_ite (was in subsequent patch)
>>>>>>
>>>>>> v2: creation
>>>>>> ---
>>>>>>  virt/kvm/arm/vgic/vgic-its.c | 128 ++++++++++++++++++++++++++++++++++++++++++-
>>>>>>  virt/kvm/arm/vgic/vgic.h     |   4 ++
>>>>>>  2 files changed, 129 insertions(+), 3 deletions(-)
>>>>>>
>>>>>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>>>>>> index 35b2ca1..b02fc3f 100644
>>>>>> --- a/virt/kvm/arm/vgic/vgic-its.c
>>>>>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>>>>>> @@ -23,6 +23,7 @@
>>>>>>  #include <linux/interrupt.h>
>>>>>>  #include <linux/list.h>
>>>>>>  #include <linux/uaccess.h>
>>>>>> +#include <linux/list_sort.h>
>>>>>>  
>>>>>>  #include <linux/irqchip/arm-gic-v3.h>
>>>>>>  
>>>>>> @@ -1695,7 +1696,7 @@ u32 compute_next_devid_offset(struct list_head *h, struct its_device *dev)
>>>>>>  	return min_t(u32, next_offset, VITS_DTE_MAX_DEVID_OFFSET);
>>>>>>  }
>>>>>>  
>>>>>> -u32 compute_next_eventid_offset(struct list_head *h, struct its_ite *ite)
>>>>>> +static u32 compute_next_eventid_offset(struct list_head *h, struct its_ite *ite)
>>>>>>  {
>>>>>>  	struct list_head *e = &ite->ite_list;
>>>>>>  	struct its_ite *next;
>>>>>> @@ -1737,8 +1738,8 @@ typedef int (*entry_fn_t)(struct vgic_its *its, u32 id, void *entry,
>>>>>>   *
>>>>>>   * Return: < 0 on error, 1 if last element identified, 0 otherwise
>>>>>>   */
>>>>>> -int lookup_table(struct vgic_its *its, gpa_t base, int size, int esz,
>>>>>> -		 int start_id, entry_fn_t fn, void *opaque)
>>>>>> +static int lookup_table(struct vgic_its *its, gpa_t base, int size, int esz,
>>>>>> +			int start_id, entry_fn_t fn, void *opaque)
>>>>>>  {
>>>>>>  	void *entry = kzalloc(esz, GFP_KERNEL);
>>>>>>  	struct kvm *kvm = its->dev->kvm;
>>>>>> @@ -1773,6 +1774,127 @@ int lookup_table(struct vgic_its *its, gpa_t base, int size, int esz,
>>>>>>  }
>>>>>>  
>>>>>>  /**
>>>>>> + * vgic_its_save_ite - Save an interrupt translation entry at @gpa
>>>>>> + */
>>>>>> +static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
>>>>>> +			      struct its_ite *ite, gpa_t gpa, int ite_esz)
>>>>>> +{
>>>>>> +	struct kvm *kvm = its->dev->kvm;
>>>>>> +	u32 next_offset;
>>>>>> +	u64 val;
>>>>>> +
>>>>>> +	next_offset = compute_next_eventid_offset(&dev->itt_head, ite);
>>>>>> +	val = ((u64)next_offset << KVM_ITS_ITE_NEXT_SHIFT) |
>>>>>> +	       ((u64)ite->lpi << KVM_ITS_ITE_PINTID_SHIFT) |
>>>>>> +		ite->collection->collection_id;
>>>>>> +	val = cpu_to_le64(val);
>>>>>> +	return kvm_write_guest(kvm, gpa, &val, ite_esz);
>>>>>> +}
>>>>>> +
>>>>>> +/**
>>>>>> + * vgic_its_restore_ite - restore an interrupt translation entry
>>>>>> + * @event_id: id used for indexing
>>>>>> + * @ptr: pointer to the ITE entry
>>>>>> + * @opaque: pointer to the its_device
>>>>>> + * @next: id offset to the next entry
>>>>>> + */
>>>>>> +static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
>>>>>> +				void *ptr, void *opaque, u32 *next)
>>>>>> +{
>>>>>> +	struct its_device *dev = (struct its_device *)opaque;
>>>>>> +	struct its_collection *collection;
>>>>>> +	struct kvm *kvm = its->dev->kvm;
>>>>>> +	u64 val, *p = (u64 *)ptr;
>>>>>
>>>>> nit: initializations on separate line (and possible do that just above
>>>>> assigning val).
>>>> done
>>>>>
>>>>>> +	struct vgic_irq *irq;
>>>>>> +	u32 coll_id, lpi_id;
>>>>>> +	struct its_ite *ite;
>>>>>> +	int ret;
>>>>>> +
>>>>>> +	val = *p;
>>>>>> +	*next = 1;
>>>>>> +
>>>>>> +	val = le64_to_cpu(val);
>>>>>> +
>>>>>> +	coll_id = val & KVM_ITS_ITE_ICID_MASK;
>>>>>> +	lpi_id = (val & KVM_ITS_ITE_PINTID_MASK) >> KVM_ITS_ITE_PINTID_SHIFT;
>>>>>> +
>>>>>> +	if (!lpi_id)
>>>>>> +		return 0;
>>>>>
>>>>> are all non-zero LPI IDs valid?  Don't we have a wrapper that tests if
>>>>> the ID is valid?
>>>> no, lpi_id must be >= GIC_MIN_LPI=8192; added that check.
>>>> ABI Doc says lpi_id==0 is interpreted as invalid. Other values <
>>>> GIC_MIN_LPI cause an -EINVAL error
>>>>>
>>>>> (looks like it's possible to add LPIs with the INTID range of SPIs, SGIs
>>>>> and PPIs here)
>>>>
>>>>>
>>>>>> +
>>>>>> +	*next = val >> KVM_ITS_ITE_NEXT_SHIFT;
>>>>>
>>>>> Don't we need to validate this somehow since it will presumably be used
>>>>> to forward a pointer somehow by the caller?
>>>> checked against max number of eventids supported by the device
>>>>>
>>>>>> +
>>>>>> +	collection = find_collection(its, coll_id);
>>>>>> +	if (!collection)
>>>>>> +		return -EINVAL;
>>>>>> +
>>>>>> +	ret = vgic_its_alloc_ite(dev, &ite, collection,
>>>>>> +				  lpi_id, event_id);
>>>>>> +	if (ret)
>>>>>> +		return ret;
>>>>>> +
>>>>>> +	irq = vgic_add_lpi(kvm, lpi_id);
>>>>>> +	if (IS_ERR(irq))
>>>>>> +		return PTR_ERR(irq);
>>>>>> +	ite->irq = irq;
>>>>>> +
>>>>>> +	/* restore the configuration of the LPI */
>>>>>> +	ret = update_lpi_config(kvm, irq, NULL);
>>>>>> +	if (ret)
>>>>>> +		return ret;
>>>>>> +
>>>>>> +	update_affinity_ite(kvm, ite);
>>>>>> +	return 0;
>>>>>> +}
>>>>>> +
>>>>>> +static int vgic_its_ite_cmp(void *priv, struct list_head *a,
>>>>>> +			    struct list_head *b)
>>>>>> +{
>>>>>> +	struct its_ite *itea = container_of(a, struct its_ite, ite_list);
>>>>>> +	struct its_ite *iteb = container_of(b, struct its_ite, ite_list);
>>>>>> +
>>>>>> +	if (itea->event_id < iteb->event_id)
>>>>>> +		return -1;
>>>>>> +	else
>>>>>> +		return 1;
>>>>>> +}
>>>>>> +
>>>>>> +int vgic_its_save_itt(struct vgic_its *its, struct its_device *device)
>>>>>> +{
>>>>>> +	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
>>>>>> +	gpa_t base = device->itt_addr;
>>>>>> +	struct its_ite *ite;
>>>>>> +	int ret, ite_esz = abi->ite_esz;
>>>>>
>>>>> nit: initializations on separate line
>>>> OK
>>>>>
>>>>>> +
>>>>>> +	list_sort(NULL, &device->itt_head, vgic_its_ite_cmp);
>>>>>> +
>>>>>> +	list_for_each_entry(ite, &device->itt_head, ite_list) {
>>>>>> +		gpa_t gpa = base + ite->event_id * ite_esz;
>>>>>> +
>>>>>> +		ret = vgic_its_save_ite(its, device, ite, gpa, ite_esz);
>>>>>> +		if (ret)
>>>>>> +			return ret;
>>>>>> +	}
>>>>>> +	return 0;
>>>>>> +}
>>>>>> +
>>>>>> +int vgic_its_restore_itt(struct vgic_its *its, struct its_device *dev)
>>>>>> +{
>>>>>> +	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
>>>>>> +	gpa_t base = dev->itt_addr;
>>>>>> +	int ret, ite_esz = abi->ite_esz;
>>>>>> +	size_t max_size = BIT_ULL(dev->nb_eventid_bits) * ite_esz;
>>>>>
>>>>> nit: initializations on separate line
>>>> OK
>>>>>
>>>>>> +
>>>>>> +	ret =  lookup_table(its, base, max_size, ite_esz, 0,
>>>>>> +			    vgic_its_restore_ite, dev);
>>>>>
>>>>> nit: extra white space
>>>>>
>>>>>> +
>>>>>> +	if (ret < 0)
>>>>>> +		return ret;
>>>>>> +
>>>>>> +	/* if the last element has not been found we are in trouble */
>>>>>> +	return ret ? 0 : -EINVAL;
>>>>>
>>>>> hmm, these are values potentially created by the guest in guest RAM,
>>>>> right?  So do we really abort migration and return an error to userspace
>>>>> in this case?
>>>> So we discussed with Peter/dave we shouldn't abort() in qemu in case of
>>>> such error. The restore table IOCTL will return an error. Up to qemu to
>>>> print the error. Destination guest will not be functional though.
>>>>
>>>
>>> ok, I'm just wondering if userspace can make a qualified decision based
>>> on this error code.  EINVAL typically means that userspace provided
>>> something incorrect, which I suppose in a sense is true, but this should
>>> be the only case where we return EINVAL here.
>>   Userspace must be able to
>>> tell the cases apart where the guest programmed bogus into memory before
>>> migration started, in which case we should ignore-and-resume, and where
>>> QEMU errornously provide some bogus value where the machine state
>>> becomes unreliable and must be powered down.
>> guest does not feed much besides few registers the ITS table restore
>> depends on. In case we want a more subtle error management at userspace
>> level all the error codes need to be revisited I am afraid. My plan was
>> to be more rough at the beginning and ignore & resume if ITS table
>> restore fails.
>>
> 
> Do we require that the VM is quiesced the entire time between saving the
> ITS state to memory and copying all memory over the wire and capturing
> all register state?  If so, then an error to restore would be because of
> userspace doing something wrong and handling that accordingly is fine.

yes the ITS table save into RAM starts when we have a guarantee that all
the VCPUS are stopped (we take all locks). The restore happens before
the VM gets resumed. At least this is the QEMU integration as of today.

Thanks

Eric
> 
> However, if there is any situation where the guest can by accident
> write some incorrect value into RAM where the ITS data structures happen
> to be, and the VM is migrated afterwards with the potential result of
> just killing the VM, then that's unacceptable, because it's a gross
> deviation from how the hardware works, and the migration should be
> transparent to the VM.
> 
> Thanks,
> -Christoffer
> 
