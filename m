From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v7 21/24] KVM: arm64: vgic-its: Device table save/restore
Date: Sun, 7 May 2017 19:22:37 +0200
Message-ID: <1890ba30-6621-dc48-5a28-c558d6f6819e@redhat.com>
References: <1494084283-12723-1-git-send-email-eric.auger@redhat.com>
 <1494084283-12723-22-git-send-email-eric.auger@redhat.com>
 <87zieoiyjy.fsf@on-the-bus.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA6E540969
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 May 2017 13:19:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zQr294hVabUo for <kvmarm@lists.cs.columbia.edu>;
 Sun,  7 May 2017 13:19:31 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C584C4095A
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 May 2017 13:19:31 -0400 (EDT)
In-Reply-To: <87zieoiyjy.fsf@on-the-bus.cambridge.arm.com>
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

Hi Marc,
On 07/05/2017 15:30, Marc Zyngier wrote:
> On Sat, May 06 2017 at  4:24:40 pm BST, Eric Auger <eric.auger@redhat.com> wrote:
>> This patch saves the device table entries into guest RAM.
>> Both flat table and 2 stage tables are supported. DeviceId
>> indexing is used.
>>
>> For each device listed in the device table, we also save
>> the translation table using the vgic_its_save/restore_itt
>> routines. Those functions will be implemented in a subsequent
>> patch.
>>
>> On restore, devices are re-allocated and their itt are
>> re-built.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>> v5 -> v6:
>> - accomodate vgic_its_alloc_device change of proto
>> - define bit fields for L1 entries
>> - s/handle_l1_entry/handle_l1_dte
>> - s/ite_esz/dte_esz in handle_l1_dte
>> - check BASER valid bit
>> - s/nb_eventid_bits/num_eventid_bits
>> - new convention for returned values
>> - itt functions implemented in subsequent patch
>>
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
>>  virt/kvm/arm/vgic/vgic-its.c | 194 +++++++++++++++++++++++++++++++++++++++++--
>>  virt/kvm/arm/vgic/vgic.h     |  10 +++
>>  2 files changed, 199 insertions(+), 5 deletions(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index 90afc83..3dea626 100644
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
>> @@ -1735,7 +1736,8 @@ int vgic_its_attr_regs_access(struct kvm_device *dev,
>>  	return ret;
>>  }
>>  
>> -u32 compute_next_devid_offset(struct list_head *h, struct its_device *dev)
>> +static u32 compute_next_devid_offset(struct list_head *h,
>> +				     struct its_device *dev)
>>  {
>>  	struct its_device *next;
>>  	u32 next_offset;
>> @@ -1789,8 +1791,8 @@ typedef int (*entry_fn_t)(struct vgic_its *its, u32 id, void *entry,
>>   * Return: < 0 on error, 0 if last element was identified, 1 otherwise
>>   * (the last element may not be found on second level tables)
>>   */
>> -int scan_its_table(struct vgic_its *its, gpa_t base, int size, int esz,
>> -		   int start_id, entry_fn_t fn, void *opaque)
>> +static int scan_its_table(struct vgic_its *its, gpa_t base, int size, int esz,
>> +			  int start_id, entry_fn_t fn, void *opaque)
>>  {
>>  	void *entry = kzalloc(esz, GFP_KERNEL);
>>  	struct kvm *kvm = its->dev->kvm;
>> @@ -1825,13 +1827,171 @@ int scan_its_table(struct vgic_its *its, gpa_t base, int size, int esz,
>>  	return ret;
>>  }
>>  
>> +static int vgic_its_save_itt(struct vgic_its *its, struct its_device *device)
>> +{
>> +	return -ENXIO;
>> +}
>> +
>> +static int vgic_its_restore_itt(struct vgic_its *its, struct its_device *dev)
>> +{
>> +	return -ENXIO;
>> +}
>> +
>> +/**
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
>> +	u32 next_offset;
>> +
>> +	itt_addr_field = dev->itt_addr >> 8;
>> +	next_offset = compute_next_devid_offset(&its->device_list, dev);
>> +	val = (1ULL << KVM_ITS_DTE_VALID_SHIFT |
>> +	       ((u64)next_offset << KVM_ITS_DTE_NEXT_SHIFT) |
>> +	       (itt_addr_field << KVM_ITS_DTE_ITTADDR_SHIFT) |
>> +		(dev->num_eventid_bits - 1));
>> +	val = cpu_to_le64(val);
>> +	return kvm_write_guest(kvm, ptr, &val, dte_esz);
>> +}
>> +
>> +/**
>> + * vgic_its_restore_dte - restore a device table entry
>> + *
>> + * @its: its handle
>> + * @id: device id the DTE corresponds to
>> + * @ptr: kernel VA where the 8 byte DTE is located
>> + * @opaque: unused
>> + *
>> + * Return: < 0 on error, 0 if the dte is the last one, id offset to the
>> + * next dte otherwise
>> + */
>> +static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
>> +				void *ptr, void *opaque)
>> +{
>> +	struct its_device *dev;
>> +	gpa_t itt_addr;
>> +	u8 num_eventid_bits;
>> +	u64 entry = *(u64 *)ptr;
>> +	bool valid;
>> +	u32 offset;
>> +	int ret;
>> +
>> +	entry = le64_to_cpu(entry);
>> +
>> +	valid = entry >> KVM_ITS_DTE_VALID_SHIFT;
>> +	num_eventid_bits = (entry & KVM_ITS_DTE_SIZE_MASK) + 1;
>> +	itt_addr = ((entry & KVM_ITS_DTE_ITTADDR_MASK)
>> +			>> KVM_ITS_DTE_ITTADDR_SHIFT) << 8;
>> +
>> +	if (!valid)
>> +		return 1;
>> +
>> +	/* dte entry is valid */
>> +	offset = (entry & KVM_ITS_DTE_NEXT_MASK) >> KVM_ITS_DTE_NEXT_SHIFT;
>> +
>> +	dev = vgic_its_alloc_device(its, id, itt_addr, num_eventid_bits);
>> +	if (IS_ERR(dev))
>> +		return PTR_ERR(dev);
>> +
>> +	ret = vgic_its_restore_itt(its, dev);
>> +	if (ret)
>> +		return ret;
> 
> Shouldn't we free the device entry if the restore as failed?
This is not totally obvious to me. the device creation is the result of
MAPD. The ITT is populated by MAPI's. Besides vgic_its_destroy frees
everything so I don't think there is any leak eventually. But if you
prefer I will do it.

Thanks

Eric
> 
> Thanks,
> 
> 	M.
> 
