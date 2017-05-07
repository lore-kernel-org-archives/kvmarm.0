From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v7 22/24] KVM: arm64: vgic-its: ITT save and restore
Date: Sun, 7 May 2017 19:24:04 +0200
Message-ID: <d76ca195-0867-5693-fc66-355d90888c7f@redhat.com>
References: <1494084283-12723-1-git-send-email-eric.auger@redhat.com>
 <1494084283-12723-23-git-send-email-eric.auger@redhat.com>
 <87shkgiy5m.fsf@on-the-bus.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14F3E40962
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 May 2017 13:21:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u4rAfUX+COhy for <kvmarm@lists.cs.columbia.edu>;
 Sun,  7 May 2017 13:20:59 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E7EF04095A
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 May 2017 13:20:58 -0400 (EDT)
In-Reply-To: <87shkgiy5m.fsf@on-the-bus.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, vijayak@caviumnetworks.com, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, Vijaya.Kumar@cavium.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu



On 07/05/2017 15:39, Marc Zyngier wrote:
> On Sat, May 06 2017 at  4:24:41 pm BST, Eric Auger <eric.auger@redhat.com> wrote:
>> Implement routines to save and restore device ITT and their
>> interrupt table entries (ITE).
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Reviewed-by: Christoffer Dall <cdall@linaro.org>
>>
>> ---
>> v6 -> v7:
>> - added Christoffer's R-b
>>
>> v5 -> v6:
>> - accomodate vgic_its_alloc_ite change of proto
>> - check LPI ID on restore, check eventid offset
>> - initializations on separate line
>> - coming after device save/restore
>> - add_lpi does config and pending bit sync
>>
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
>>  virt/kvm/arm/vgic/vgic-its.c | 116 +++++++++++++++++++++++++++++++++++++++++--
>>  virt/kvm/arm/vgic/vgic.h     |   4 ++
>>  2 files changed, 117 insertions(+), 3 deletions(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index 3dea626..adb3d9e 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -1750,7 +1750,7 @@ static u32 compute_next_devid_offset(struct list_head *h,
>>  	return min_t(u32, next_offset, VITS_DTE_MAX_DEVID_OFFSET);
>>  }
>>  
>> -u32 compute_next_eventid_offset(struct list_head *h, struct its_ite *ite)
>> +static u32 compute_next_eventid_offset(struct list_head *h, struct its_ite *ite)
>>  {
>>  	struct its_ite *next;
>>  	u32 next_offset;
>> @@ -1827,14 +1827,124 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, int esz,
>>  	return ret;
>>  }
>>  
>> +/**
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
>> + */
>> +static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
>> +				void *ptr, void *opaque)
>> +{
>> +	struct its_device *dev = (struct its_device *)opaque;
>> +	struct its_collection *collection;
>> +	struct kvm *kvm = its->dev->kvm;
>> +	struct kvm_vcpu *vcpu = NULL;
>> +	u64 val;
>> +	u64 *p = (u64 *)ptr;
>> +	struct vgic_irq *irq;
>> +	u32 coll_id, lpi_id;
>> +	struct its_ite *ite;
>> +	u32 offset;
>> +
>> +	val = *p;
>> +
>> +	val = le64_to_cpu(val);
>> +
>> +	coll_id = val & KVM_ITS_ITE_ICID_MASK;
>> +	lpi_id = (val & KVM_ITS_ITE_PINTID_MASK) >> KVM_ITS_ITE_PINTID_SHIFT;
>> +
>> +	if (!lpi_id)
>> +		return 1; /* invalid entry, no choice but to scan next entry */
>> +
>> +	if (lpi_id < VGIC_MIN_LPI)
>> +		return -EINVAL;
>> +
>> +	offset = val >> KVM_ITS_ITE_NEXT_SHIFT;
>> +	if (event_id + offset >= BIT_ULL(dev->num_eventid_bits))
>> +		return -EINVAL;
>> +
>> +	collection = find_collection(its, coll_id);
>> +	if (!collection)
>> +		return -EINVAL;
>> +
>> +	ite = vgic_its_alloc_ite(dev, collection, lpi_id, event_id);
>> +	if (IS_ERR(ite))
>> +		return PTR_ERR(ite);
>> +
>> +	if (its_is_collection_mapped(collection))
>> +		vcpu = kvm_get_vcpu(kvm, collection->target_addr);
>> +
>> +	irq = vgic_add_lpi(kvm, lpi_id, vcpu);
>> +	if (IS_ERR(irq))
>> +		return PTR_ERR(irq);
> 
> Same remark as the previous patch: the its_ite structure should be freed
> on failure. Otherwise, I suspect we end0up leaking memory.
also freed in vgic_its_destroy.

Thanks

Eric
> 
> Thanks,
> 
> 	M.
> 
