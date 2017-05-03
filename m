From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 20/22] KVM: arm64: vgic-its: Device table save/restore
Date: Wed, 3 May 2017 16:07:45 +0200
Message-ID: <9f446caa-d62c-1a01-b916-9531a8034989@redhat.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-21-git-send-email-eric.auger@redhat.com>
 <20170430205540.GC1499@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170430205540.GC1499@lvm>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: peter.maydell@linaro.org, drjones@redhat.com, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, marc.zyngier@arm.com, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, Vijaya.Kumar@cavium.com, vijayak@caviumnetworks.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,
On 30/04/2017 22:55, Christoffer Dall wrote:
> On Fri, Apr 14, 2017 at 12:15:32PM +0200, Eric Auger wrote:
>> This patch saves the device table entries into guest RAM.
>> Both flat table and 2 stage tables are supported. DeviceId
>> indexing is used.
>>
>> For each device listed in the device table, we also save
>> the translation table using the vgic_its_save/restore_itt
>> routines.
>>
>> On restore, devices are re-allocated and their ite are
>> re-built.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>> v4 -> v5:
>> - sort the device list by deviceid on device table save
>> - use defines for shifts and masks
>> - use abi->dte_esz
>> - clatify entry sizes for L1 and L2 tables
>>
>> v3 -> v4:
>> - use the new proto for its_alloc_device
>> - compute_next_devid_offset, vgic_its_flush/restore_itt
>>   become static in this patch
>> - change in the DTE entry format with the introduction of the
>>   valid bit and next field width decrease; ittaddr encoded
>>   on its full range
>> - fix handle_l1_entry entry handling
>> - correct vgic_its_table_restore error handling
>>
>> v2 -> v3:
>> - fix itt_addr bitmask in vgic_its_restore_dte
>> - addition of return 0 in vgic_its_restore_ite moved to
>>   the ITE related patch
>>
>> v1 -> v2:
>> - use 8 byte format for DTE and ITE
>> - support 2 stage format
>> - remove kvm parameter
>> - ITT flush/restore moved in a separate patch
>> - use deviceid indexing
>> ---
>>  virt/kvm/arm/vgic/vgic-its.c | 183 +++++++++++++++++++++++++++++++++++++++++--
>>  virt/kvm/arm/vgic/vgic.h     |   7 ++
>>  2 files changed, 185 insertions(+), 5 deletions(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index b02fc3f..86dfc6c 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -1682,7 +1682,8 @@ int vgic_its_attr_regs_access(struct kvm_device *dev,
>>  	return ret;
>>  }
>>  
>> -u32 compute_next_devid_offset(struct list_head *h, struct its_device *dev)
>> +static u32 compute_next_devid_offset(struct list_head *h,
>> +				     struct its_device *dev)
>>  {
>>  	struct list_head *e = &dev->dev_list;
>>  	struct its_device *next;
>> @@ -1858,7 +1859,7 @@ static int vgic_its_ite_cmp(void *priv, struct list_head *a,
>>  		return 1;
>>  }
>>  
>> -int vgic_its_save_itt(struct vgic_its *its, struct its_device *device)
>> +static int vgic_its_save_itt(struct vgic_its *its, struct its_device *device)
>>  {
>>  	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
>>  	gpa_t base = device->itt_addr;
>> @@ -1877,7 +1878,7 @@ int vgic_its_save_itt(struct vgic_its *its, struct its_device *device)
>>  	return 0;
>>  }
>>  
>> -int vgic_its_restore_itt(struct vgic_its *its, struct its_device *dev)
>> +static int vgic_its_restore_itt(struct vgic_its *its, struct its_device *dev)
>>  {
>>  	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
>>  	gpa_t base = dev->itt_addr;
>> @@ -1895,12 +1896,161 @@ int vgic_its_restore_itt(struct vgic_its *its, struct its_device *dev)
>>  }
>>  
>>  /**
>> + * vgic_its_save_dte - Save a device table entry at a given GPA
>> + *
>> + * @its: ITS handle
>> + * @dev: ITS device
>> + * @ptr: GPA
>> + */
>> +static int vgic_its_save_dte(struct vgic_its *its, struct its_device *dev,
>> +			     gpa_t ptr, int dte_esz)
>> +{
>> +	struct kvm *kvm = its->dev->kvm;
>> +	u64 val, itt_addr_field;
>> +	int ret;
>> +	u32 next_offset;
>> +
>> +	itt_addr_field = dev->itt_addr >> 8;
>> +	next_offset = compute_next_devid_offset(&its->device_list, dev);
>> +	val = (1ULL << KVM_ITS_DTE_VALID_SHIFT |
>> +	       ((u64)next_offset << KVM_ITS_DTE_NEXT_SHIFT) |
> 
> I think this implies that the next field in your ABI points to the next
> offset, regardless of whether or not this is in a a level 2 or lavel 1
> table.  See more comments on this below (I reviewed this patch from the
> bottom up).
Not sure I understand your comment.

Doc says:
 - next: equals to 0 if this entry is the last one; otherwise it
   corresponds to the deviceid offset to the next DTE, capped by
   2^14 -1.

This is independent on 1 or 2 levels as we sort the devices by
deviceid's and compute the delta between those id.
> 
> I have a feeling this wasn't tested with 2 level device tables.  Could
> that be true?
No this was tested with 1 & and 2 levels (I hacked the guest to force 2
levels). 1 test hole I have though is all my dte's currently belong to
the same 2d level page, ie. my deviceid are not scattered enough.
> 
>> +	       (itt_addr_field << KVM_ITS_DTE_ITTADDR_SHIFT) |
>> +		(dev->nb_eventid_bits - 1));
>> +	val = cpu_to_le64(val);
>> +	ret = kvm_write_guest(kvm, ptr, &val, dte_esz);
>> +	return ret;
>> +}
>> +
>> +/**
>> + * vgic_its_restore_dte - restore a device table entry
>> + *
>> + * @its: its handle
>> + * @id: device id the DTE corresponds to
>> + * @ptr: kernel VA where the 8 byte DTE is located
>> + * @opaque: unused
>> + * @next: offset to the next valid device id
>> + *
>> + * Return: < 0 on error, 0 otherwise
>> + */
>> +static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
>> +				void *ptr, void *opaque, u32 *next)
>> +{
>> +	struct its_device *dev;
>> +	gpa_t itt_addr;
>> +	u8 nb_eventid_bits;
>> +	u64 entry = *(u64 *)ptr;
>> +	bool valid;
>> +	int ret;
>> +
>> +	entry = le64_to_cpu(entry);
>> +
>> +	valid = entry >> KVM_ITS_DTE_VALID_SHIFT;
>> +	nb_eventid_bits = (entry & KVM_ITS_DTE_SIZE_MASK) + 1;
>> +	itt_addr = ((entry & KVM_ITS_DTE_ITTADDR_MASK)
>> +			>> KVM_ITS_DTE_ITTADDR_SHIFT) << 8;
>> +	*next = 1;
>> +
>> +	if (!valid)
>> +		return 0;
>> +
>> +	/* dte entry is valid */
>> +	*next = (entry & KVM_ITS_DTE_NEXT_MASK) >> KVM_ITS_DTE_NEXT_SHIFT;
>> +
>> +	ret = vgic_its_alloc_device(its, &dev, id,
>> +				    itt_addr, nb_eventid_bits);
>> +	if (ret)
>> +		return ret;
>> +	ret = vgic_its_restore_itt(its, dev);
>> +
>> +	return ret;
>> +}
>> +
>> +static int vgic_its_device_cmp(void *priv, struct list_head *a,
>> +			       struct list_head *b)
>> +{
>> +	struct its_device *deva = container_of(a, struct its_device, dev_list);
>> +	struct its_device *devb = container_of(b, struct its_device, dev_list);
>> +
>> +	if (deva->device_id < devb->device_id)
>> +		return -1;
>> +	else
>> +		return 1;
>> +}
>> +
>> +/**
>>   * vgic_its_save_device_tables - Save the device table and all ITT
>>   * into guest RAM
>> + *
>> + * L1/L2 handling is hidden by vgic_its_check_id() helper which directly
>> + * returns the GPA of the device entry
>>   */
>>  static int vgic_its_save_device_tables(struct vgic_its *its)
>>  {
>> -	return -ENXIO;
>> +	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
>> +	struct its_device *dev;
>> +	int dte_esz = abi->dte_esz;
>> +	u64 baser;
>> +
>> +	baser = its->baser_device_table;
>> +
>> +	list_sort(NULL, &its->device_list, vgic_its_device_cmp);
>> +
>> +	list_for_each_entry(dev, &its->device_list, dev_list) {
>> +		int ret;
>> +		gpa_t eaddr;
>> +
>> +		if (!vgic_its_check_id(its, baser,
>> +				       dev->device_id, &eaddr))
>> +			return -EINVAL;
>> +
>> +		ret = vgic_its_save_itt(its, dev);
>> +		if (ret)
>> +			return ret;
>> +
>> +		ret = vgic_its_save_dte(its, dev, eaddr, dte_esz);
>> +		if (ret)
>> +			return ret;
>> +	}
>> +	return 0;
>> +}
>> +
>> +/**
>> + * handle_l1_entry - callback used for L1 entries (2 stage case)
>> + *
>> + * @its: its handle
>> + * @id: id
> 
> IIUC, this is actually the index of the entry in the L1 table.  I think
> this should be clarified.
yep
> 
>> + * @addr: kernel VA
>> + * @opaque: unused
>> + * @next_offset: offset to the next L1 entry: 0 if the last element
>> + * was found, 1 otherwise
>> + */
>> +static int handle_l1_entry(struct vgic_its *its, u32 id, void *addr,
>> +			   void *opaque, u32 *next_offset)
> 
> nit: shouldn't this be called handle_l1_device_table_entry ?
renamed into handle_l1_dte
> 
>> +{
>> +	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
>> +	int l2_start_id = id * (SZ_64K / GITS_LVL1_ENTRY_SIZE);
> 
> Hmmm, is this not actually supposed to be (SZ_64K / abi->dte_esz) ?
no because 1st level entries have a fixed size of GITS_LVL1_ENTRY_SIZE bytes
> 
>> +	u64 entry = *(u64 *)addr;
>> +	int ret, ite_esz = abi->ite_esz;
> 
> Should this be ite_esz or dte_esz?

you're correct. dte_esz should be used.
> 
>> +	gpa_t gpa;
> 
> nit: put declarations with initialization on separate lines.
OK
> 
>> +
>> +	entry = le64_to_cpu(entry);
>> +	*next_offset = 1;
> 
> I think you could attach a comment here saying that level 1 tables have
> to be scanned entirely.
added. note we exit as soon as the last element is found when scanning
l2 tables.
> 
> But this also reminds me.  Does that mean that the next field in the DTE
> in your documented ABI format points to the next DTE within that level-2
> table, or does it point across to different level-2 tables?  I think
> this needs to be clarified in the ABI unless I'm missing something.
see above comment on next_index semantic. In the doc I talk about
deviceid offset and not of table index.

> 
>> +
>> +	if (!(entry & BIT_ULL(63)))
>> +		return 0;
>> +
>> +	gpa = entry & GENMASK_ULL(51, 16);
> 
> Can you define the bit fields for the level-1 entries as well please?
yep
> 
>> +
>> +	ret = lookup_table(its, gpa, SZ_64K, ite_esz,
>> +			   l2_start_id, vgic_its_restore_dte, NULL);
>> +
>> +	if (ret == 1) {
>> +		/* last entry was found in this L2 table */
> 
> maybe you should define these return codes for you table scan function,
> and you wouldn't have to have a separate comment and it would be
> generally easier to follow the code.
I revisited the error values according to your suggestion and this looks
simpler to me now.
> 
>> +		*next_offset = 0;
>> +		ret = 0;
>> +	}
>> +
>> +	return ret;
>>  }
>>  
>>  /**
>> @@ -1909,7 +2059,30 @@ static int vgic_its_save_device_tables(struct vgic_its *its)
>>   */
>>  static int vgic_its_restore_device_tables(struct vgic_its *its)
>>  {
>> -	return -ENXIO;
>> +	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
>> +	u64 baser = its->baser_device_table;
>> +	int l1_esz, ret, l1_tbl_size = GITS_BASER_NR_PAGES(baser) * SZ_64K;
> 
> nit: put this initialization on a separate line.
done
> 
>> +	gpa_t l1_gpa;
>> +
>> +	l1_gpa = BASER_ADDRESS(baser);
>> +	if (!l1_gpa)
>> +		return 0;
> 
> I think you meant to check the valid bit here.
yes
> 
>> +
>> +	if (baser & GITS_BASER_INDIRECT) {
>> +		l1_esz = 8;
>> +		ret = lookup_table(its, l1_gpa, l1_tbl_size, l1_esz, 0,
>> +				   handle_l1_entry, NULL);
>> +	} else {
>> +		l1_esz = abi->dte_esz;
>> +		ret = lookup_table(its, l1_gpa, l1_tbl_size, l1_esz, 0,
>> +				   vgic_its_restore_dte, NULL);
>> +	}
>> +
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	/* if last element was not found we have an issue here */
> 
> same comment as other patch
> 
>> +	return ret ? 0 : -EINVAL;
revisited

Thanks

Eric
>>  }
>>  
>>  static int vgic_its_save_cte(struct vgic_its *its,
>> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
>> index ce57fbd..9bc52ef 100644
>> --- a/virt/kvm/arm/vgic/vgic.h
>> +++ b/virt/kvm/arm/vgic/vgic.h
>> @@ -85,6 +85,13 @@
>>  #define KVM_ITS_ITE_PINTID_SHIFT	16
>>  #define KVM_ITS_ITE_PINTID_MASK		GENMASK_ULL(47, 16)
>>  #define KVM_ITS_ITE_ICID_MASK		GENMASK_ULL(15, 0)
>> +#define KVM_ITS_DTE_VALID_SHIFT		63
>> +#define KVM_ITS_DTE_VALID_MASK		BIT_ULL(63)
>> +#define KVM_ITS_DTE_NEXT_SHIFT		49
>> +#define KVM_ITS_DTE_NEXT_MASK		GENMASK_ULL(62, 49)
>> +#define KVM_ITS_DTE_ITTADDR_SHIFT	5
>> +#define KVM_ITS_DTE_ITTADDR_MASK	GENMASK_ULL(48, 5)
>> +#define KVM_ITS_DTE_SIZE_MASK		GENMASK_ULL(4, 0)
>>  
>>  static inline bool irq_is_pending(struct vgic_irq *irq)
>>  {
>> -- 
>> 2.5.5
>>
> Thanks,
> -Christoffer
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
