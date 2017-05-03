From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 19/22] KVM: arm64: vgic-its: ITT save and restore
Date: Wed, 3 May 2017 18:08:58 +0200
Message-ID: <8ccb9bec-0df6-732b-c0b3-3c2067c67bf0@redhat.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-20-git-send-email-eric.auger@redhat.com>
 <20170430201438.GB1499@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C43740A69
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 May 2017 12:06:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6EDw6UO+G69d for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 May 2017 12:06:01 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CA1F040296
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 May 2017 12:06:01 -0400 (EDT)
In-Reply-To: <20170430201438.GB1499@lvm>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, marc.zyngier@arm.com, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, Vijaya.Kumar@cavium.com, vijayak@caviumnetworks.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 30/04/2017 22:14, Christoffer Dall wrote:
> On Fri, Apr 14, 2017 at 12:15:31PM +0200, Eric Auger wrote:
>> Introduce routines to save and restore device ITT and their
>> interrupt table entries (ITE).
>>
>> The routines will be called on device table save and
>> restore. They will become static in subsequent patches.
> 
> Why this bottom-up approach?  Couldn't you start by having the patch
> that restores the device table and define the static functions that
> return an error there
done
, and then fill them in with subsequent patches
> (liek this one)?
> 
> That would have the added benefit of being able to tell how things are
> designed to be called.
> 
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>> v4 -> v5:
>> - ITE are now sorted by eventid on the flush
>> - rename *flush* into *save*
>> - use macros for shits and masks
>> - pass ite_esz to vgic_its_save_ite
>>
>> v3 -> v4:
>> - lookup_table and compute_next_eventid_offset become static in this
>>   patch
>> - remove static along with vgic_its_flush/restore_itt to avoid
>>   compilation warnings
>> - next field only computed with a shift (mask removed)
>> - handle the case where the last element has not been found
>>
>> v2 -> v3:
>> - add return 0 in vgic_its_restore_ite (was in subsequent patch)
>>
>> v2: creation
>> ---
>>  virt/kvm/arm/vgic/vgic-its.c | 128 ++++++++++++++++++++++++++++++++++++++++++-
>>  virt/kvm/arm/vgic/vgic.h     |   4 ++
>>  2 files changed, 129 insertions(+), 3 deletions(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index 35b2ca1..b02fc3f 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -23,6 +23,7 @@
>>  #include <linux/interrupt.h>
>>  #include <linux/list.h>
>>  #include <linux/uaccess.h>
>> +#include <linux/list_sort.h>
>>  
>>  #include <linux/irqchip/arm-gic-v3.h>
>>  
>> @@ -1695,7 +1696,7 @@ u32 compute_next_devid_offset(struct list_head *h, struct its_device *dev)
>>  	return min_t(u32, next_offset, VITS_DTE_MAX_DEVID_OFFSET);
>>  }
>>  
>> -u32 compute_next_eventid_offset(struct list_head *h, struct its_ite *ite)
>> +static u32 compute_next_eventid_offset(struct list_head *h, struct its_ite *ite)
>>  {
>>  	struct list_head *e = &ite->ite_list;
>>  	struct its_ite *next;
>> @@ -1737,8 +1738,8 @@ typedef int (*entry_fn_t)(struct vgic_its *its, u32 id, void *entry,
>>   *
>>   * Return: < 0 on error, 1 if last element identified, 0 otherwise
>>   */
>> -int lookup_table(struct vgic_its *its, gpa_t base, int size, int esz,
>> -		 int start_id, entry_fn_t fn, void *opaque)
>> +static int lookup_table(struct vgic_its *its, gpa_t base, int size, int esz,
>> +			int start_id, entry_fn_t fn, void *opaque)
>>  {
>>  	void *entry = kzalloc(esz, GFP_KERNEL);
>>  	struct kvm *kvm = its->dev->kvm;
>> @@ -1773,6 +1774,127 @@ int lookup_table(struct vgic_its *its, gpa_t base, int size, int esz,
>>  }
>>  
>>  /**
>> + * vgic_its_save_ite - Save an interrupt translation entry at @gpa
>> + */
>> +static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
>> +			      struct its_ite *ite, gpa_t gpa, int ite_esz)
>> +{
>> +	struct kvm *kvm = its->dev->kvm;
>> +	u32 next_offset;
>> +	u64 val;
>> +
>> +	next_offset = compute_next_eventid_offset(&dev->itt_head, ite);
>> +	val = ((u64)next_offset << KVM_ITS_ITE_NEXT_SHIFT) |
>> +	       ((u64)ite->lpi << KVM_ITS_ITE_PINTID_SHIFT) |
>> +		ite->collection->collection_id;
>> +	val = cpu_to_le64(val);
>> +	return kvm_write_guest(kvm, gpa, &val, ite_esz);
>> +}
>> +
>> +/**
>> + * vgic_its_restore_ite - restore an interrupt translation entry
>> + * @event_id: id used for indexing
>> + * @ptr: pointer to the ITE entry
>> + * @opaque: pointer to the its_device
>> + * @next: id offset to the next entry
>> + */
>> +static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
>> +				void *ptr, void *opaque, u32 *next)
>> +{
>> +	struct its_device *dev = (struct its_device *)opaque;
>> +	struct its_collection *collection;
>> +	struct kvm *kvm = its->dev->kvm;
>> +	u64 val, *p = (u64 *)ptr;
> 
> nit: initializations on separate line (and possible do that just above
> assigning val).
done
> 
>> +	struct vgic_irq *irq;
>> +	u32 coll_id, lpi_id;
>> +	struct its_ite *ite;
>> +	int ret;
>> +
>> +	val = *p;
>> +	*next = 1;
>> +
>> +	val = le64_to_cpu(val);
>> +
>> +	coll_id = val & KVM_ITS_ITE_ICID_MASK;
>> +	lpi_id = (val & KVM_ITS_ITE_PINTID_MASK) >> KVM_ITS_ITE_PINTID_SHIFT;
>> +
>> +	if (!lpi_id)
>> +		return 0;
> 
> are all non-zero LPI IDs valid?  Don't we have a wrapper that tests if
> the ID is valid?
no, lpi_id must be >= GIC_MIN_LPI=8192; added that check.
ABI Doc says lpi_id==0 is interpreted as invalid. Other values <
GIC_MIN_LPI cause an -EINVAL error
> 
> (looks like it's possible to add LPIs with the INTID range of SPIs, SGIs
> and PPIs here)

> 
>> +
>> +	*next = val >> KVM_ITS_ITE_NEXT_SHIFT;
> 
> Don't we need to validate this somehow since it will presumably be used
> to forward a pointer somehow by the caller?
checked against max number of eventids supported by the device
> 
>> +
>> +	collection = find_collection(its, coll_id);
>> +	if (!collection)
>> +		return -EINVAL;
>> +
>> +	ret = vgic_its_alloc_ite(dev, &ite, collection,
>> +				  lpi_id, event_id);
>> +	if (ret)
>> +		return ret;
>> +
>> +	irq = vgic_add_lpi(kvm, lpi_id);
>> +	if (IS_ERR(irq))
>> +		return PTR_ERR(irq);
>> +	ite->irq = irq;
>> +
>> +	/* restore the configuration of the LPI */
>> +	ret = update_lpi_config(kvm, irq, NULL);
>> +	if (ret)
>> +		return ret;
>> +
>> +	update_affinity_ite(kvm, ite);
>> +	return 0;
>> +}
>> +
>> +static int vgic_its_ite_cmp(void *priv, struct list_head *a,
>> +			    struct list_head *b)
>> +{
>> +	struct its_ite *itea = container_of(a, struct its_ite, ite_list);
>> +	struct its_ite *iteb = container_of(b, struct its_ite, ite_list);
>> +
>> +	if (itea->event_id < iteb->event_id)
>> +		return -1;
>> +	else
>> +		return 1;
>> +}
>> +
>> +int vgic_its_save_itt(struct vgic_its *its, struct its_device *device)
>> +{
>> +	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
>> +	gpa_t base = device->itt_addr;
>> +	struct its_ite *ite;
>> +	int ret, ite_esz = abi->ite_esz;
> 
> nit: initializations on separate line
OK
> 
>> +
>> +	list_sort(NULL, &device->itt_head, vgic_its_ite_cmp);
>> +
>> +	list_for_each_entry(ite, &device->itt_head, ite_list) {
>> +		gpa_t gpa = base + ite->event_id * ite_esz;
>> +
>> +		ret = vgic_its_save_ite(its, device, ite, gpa, ite_esz);
>> +		if (ret)
>> +			return ret;
>> +	}
>> +	return 0;
>> +}
>> +
>> +int vgic_its_restore_itt(struct vgic_its *its, struct its_device *dev)
>> +{
>> +	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
>> +	gpa_t base = dev->itt_addr;
>> +	int ret, ite_esz = abi->ite_esz;
>> +	size_t max_size = BIT_ULL(dev->nb_eventid_bits) * ite_esz;
> 
> nit: initializations on separate line
OK
> 
>> +
>> +	ret =  lookup_table(its, base, max_size, ite_esz, 0,
>> +			    vgic_its_restore_ite, dev);
> 
> nit: extra white space
> 
>> +
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	/* if the last element has not been found we are in trouble */
>> +	return ret ? 0 : -EINVAL;
> 
> hmm, these are values potentially created by the guest in guest RAM,
> right?  So do we really abort migration and return an error to userspace
> in this case?
So we discussed with Peter/dave we shouldn't abort() in qemu in case of
such error. The restore table IOCTL will return an error. Up to qemu to
print the error. Destination guest will not be functional though.

Thanks

Eric
> 
> Also, this comment doesn't really tell me what this situation is and how
> we handle things...
> 
>> +}
>> +
>> +/**
>>   * vgic_its_save_device_tables - Save the device table and all ITT
>>   * into guest RAM
>>   */
>> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
>> index 56e57c1..ce57fbd 100644
>> --- a/virt/kvm/arm/vgic/vgic.h
>> +++ b/virt/kvm/arm/vgic/vgic.h
>> @@ -81,6 +81,10 @@
>>  #define KVM_ITS_CTE_VALID_MASK		BIT_ULL(63)
>>  #define KVM_ITS_CTE_RDBASE_SHIFT	16
>>  #define KVM_ITS_CTE_ICID_MASK		GENMASK_ULL(15, 0)
>> +#define KVM_ITS_ITE_NEXT_SHIFT		48
>> +#define KVM_ITS_ITE_PINTID_SHIFT	16
>> +#define KVM_ITS_ITE_PINTID_MASK		GENMASK_ULL(47, 16)
>> +#define KVM_ITS_ITE_ICID_MASK		GENMASK_ULL(15, 0)
>>  
>>  static inline bool irq_is_pending(struct vgic_irq *irq)
>>  {
>> -- 
>> 2.5.5
>>
> 
> Thanks,
> -Christoffer
> 
