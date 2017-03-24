From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v3 18/19] KVM: arm64: ITS: Device table save/restore
Date: Fri, 24 Mar 2017 11:38:35 +0100
Message-ID: <728905ad-61a2-f510-b04f-5af178dfaade@redhat.com>
References: <1488800074-21991-1-git-send-email-eric.auger@redhat.com>
 <1488800074-21991-19-git-send-email-eric.auger@redhat.com>
 <2c4841df-f7b3-ee03-16d3-7e32c9cbd936@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1B5040B3E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Mar 2017 06:36:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h8vEZGDHJIK0 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Mar 2017 06:36:51 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 497A340284
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Mar 2017 06:36:51 -0400 (EDT)
In-Reply-To: <2c4841df-f7b3-ee03-16d3-7e32c9cbd936@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,

On 22/03/2017 15:39, Andre Przywara wrote:
> Hi,
> 
> On 06/03/17 11:34, Eric Auger wrote:
>> This patch flushes the device table entries into guest RAM.
>> Both flat table and 2 stage tables are supported.  DeviceId
>> indexing is used.
>>
>> For each device listed in the device table, we also flush
>> the translation table using the vgic_its_flush/restore_itt
>> routines.
>>
>> On restore, devices are re-allocated and their itte are
>> re-built.
> 
> Some minor things below.
> In general I had quite some trouble to understand what's going on here,
> though I convinced myself that this is correct. So could you add a bit
> more comments here? For instance to explain that we have to explicitly
> handle the L1 table on restore, but not on flush.

On flush vgic_its_check_id does the 2 stage handling and computes the
entry address from the devid:

		if (!vgic_its_check_id(its, baser,
				       dev->device_id, &eaddr))

Then you simply flush the entry at that address

On restore, you need to scan the level1 and level2 tables for valid entries.
> 
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
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
>>  virt/kvm/arm/vgic/vgic-its.c | 144 ++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 142 insertions(+), 2 deletions(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index a216849..27ebabd 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -1849,12 +1849,137 @@ static int vgic_its_restore_itt(struct vgic_its *its,
>>  }
>>  
>>  /**
>> + * vgic_its_flush_dte - Flush a device table entry at a given GPA
>> + *
>> + * @its: ITS handle
>> + * @dev: ITS device
>> + * @ptr: GPA
>> + */
>> +static int vgic_its_flush_dte(struct vgic_its *its,
>> +			      struct its_device *dev, gpa_t ptr)
>> +{
>> +	struct kvm *kvm = its->dev->kvm;
>> +	u64 val, itt_addr_field;
>> +	int ret;
>> +	u32 next_offset;
>> +
>> +	itt_addr_field = dev->itt_addr >> 8;
>> +	next_offset = compute_next_devid_offset(&its->device_list, dev);
>> +	val = (((u64)next_offset << 45) | (itt_addr_field << 5) |
> 
> So this gives you 19 bits for next_offset, but the value of
> VITS_DTE_MAX_DEVID_OFFSET suggests 20 bits. It should become more
> obvious what's happening here if use "BITS(x) - 1" at the definition as
> suggested before.
Yes this should be 19 bits
> 
> Also you limit itt_addr here to 40 bits, where the actual limit seems to
> be 44 bits (52 - 8). Is that limited by KVM somewhere else?

Those 40 bits match [47:8] of the itt_addr. I limited to 48 since I
found a comment saying
/*
 * We only implement 48 bits of PA at the moment, although the ITS
 * supports more. Let's be restrictive here.
 */


On the other hand there is
#define its_cmd_get_ittaddr(cmd) its_cmd_mask_field(cmd, 2,  8, 44)
To me this is wrong. I would have expected its_cmd_mask_field(cmd, 2,
8, 47) instead as the other *_ADDRESS()

If confirmed I will send a fix.



> Even if it is, I think we should make sure that itt_addr_field doesn't
> spill over into next_offset.
> 
>> +		(dev->nb_eventid_bits - 1));
> 
> Mmmh, here nb_eventid_bits seems to be the real bit number again. Puzzled.
corrected
> 
>> +	val = cpu_to_le64(val);
>> +	ret = kvm_write_guest(kvm, ptr, &val, 8);
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
>> +	size_t size;
>> +	u64 val, *p = (u64 *)ptr;
>> +	int ret;
>> +
>> +	val = *p;
>> +	val = le64_to_cpu(val);
>> +
>> +	size = val & GENMASK_ULL(4, 0);
>> +	itt_addr = (val & GENMASK_ULL(44, 5)) >> 5;
>> +	*next = 1;
>> +
>> +	if (!itt_addr)
>> +		return 0;
>> +
>> +	/* dte entry is valid */
>> +	*next = (val & GENMASK_ULL(63, 45)) >> 45;
> 
> No need for GENMASK, just shift by 45.
yes
> 
>> +
>> +	ret = vgic_its_alloc_device(its, &dev, id,
>> +				    itt_addr, size);
>> +	if (ret)
>> +		return ret;
>> +	ret = vgic_its_restore_itt(its, dev);
>> +
>> +	return ret;
>> +}
>> +
>> +/**
>>   * vgic_its_flush_device_tables - flush the device table and all ITT
>>   * into guest RAM
>>   */
>>  static int vgic_its_flush_device_tables(struct vgic_its *its)
>>  {
>> -	return -ENXIO;
>> +	struct its_device *dev;
>> +	u64 baser;
>> +
>> +	baser = its->baser_device_table;
>> +
>> +	list_for_each_entry(dev, &its->device_list, dev_list) {
>> +		int ret;
>> +		gpa_t eaddr;
>> +
>> +		if (!vgic_its_check_id(its, baser,
>> +				       dev->device_id, &eaddr))
>> +			return -EINVAL;
>> +
>> +		ret = vgic_its_flush_itt(its, dev);
>> +		if (ret)
>> +			return ret;
>> +
>> +		ret = vgic_its_flush_dte(its, dev, eaddr);
>> +		if (ret)
>> +			return ret;
>> +		}
> 
> whitespace ?
OK
> 
>> +	return 0;
>> +}
>> +
>> +/**
>> + * handle_l1_entry - callback used for L1 entries (2 stage case)
>> + *
>> + * @its: its handle
>> + * @id: id
>> + * @addr: kernel VA
>> + * @opaque: unused
>> + * @next_offset: offset to the next L1 entry: 0 if the last element
>> + * was found, 1 otherwise
>> + */
>> +static int handle_l1_entry(struct vgic_its *its, u32 id, void *addr,
>> +			   void *opaque, u32 *next_offset)
>> +{
>> +	u64 *pe = addr;
>> +	gpa_t gpa;
>> +	int l2_start_id = id * (SZ_64K / 8);
> 
> I think we can use GITS_LVL1_ENTRY_SIZE here, which I suppose is what
> the 8 stands for.
yes
> 
>> +	int ret;
>> +
>> +	*pe = le64_to_cpu(*pe);
> 
> Is it correct to _update_ the entry here? I think that breaks BE, right?
> Beside I believe the ITS is not supposed to tinker with the L1 table
> entries, isn't it?
> 
> So should it be instead:
> 	u64 pe = *(u64 *)addr;
> 	
> 	pe = le64_to_cpu(pe);
> 
> instead?
> And what "pe" stand for anyway? Maybe "entry" instead?
correct. I fixed that.
> 
>> +	*next_offset = 1;
>> +
>> +	if (!(*pe & BIT_ULL(63)))
>> +		return 0;
>> +
>> +	gpa = *pe & GENMASK_ULL(51, 16);
>> +
>> +	ret = lookup_table(its, gpa, SZ_64K, 8,
>> +			    l2_start_id, vgic_its_restore_dte, NULL);
>> +
>> +	if (ret == 1) {
>> +		/* last entry was found in this L2 table */
>> +		*next_offset = 0;
>> +		ret = 0;
>> +	}
>> +
>> +	return ret;
>>  }
>>  
>>  /**
>> @@ -1863,7 +1988,22 @@ static int vgic_its_flush_device_tables(struct vgic_its *its)
>>   */
>>  static int vgic_its_restore_device_tables(struct vgic_its *its)
>>  {
>> -	return -ENXIO;
>> +	u64 baser = its->baser_device_table;
>> +	int l1_tbl_size = GITS_BASER_NR_PAGES(baser) * SZ_64K;
>> +	int l1_esz = GITS_BASER_ENTRY_SIZE(baser);
>> +	gpa_t l1_gpa;
>> +
>> +	l1_gpa = BASER_ADDRESS(baser);
>> +	if (!l1_gpa)
>> +		return 0;
>> +
>> +	if (!(baser & GITS_BASER_INDIRECT))
>> +		return lookup_table(its, l1_gpa, l1_tbl_size, l1_esz,
>> +				    0, vgic_its_restore_dte, NULL);
>> +
>> +	/* two stage table */
>> +	return lookup_table(its, l1_gpa, l1_tbl_size, 8, 0,
>> +			    handle_l1_entry, NULL);
> 
> That usage of lookup_table with the callback is pretty neat!
thanks a lot for your time and the numerous bugs you found!

Cheers

Eric
> 
> Cheers,
> Andre.
> 
>>  }
>>  
>>  static int vgic_its_flush_cte(struct vgic_its *its,
>>
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
