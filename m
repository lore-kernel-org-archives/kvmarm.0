From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 16/22] KVM: arm64: vgic-its: Add infrastructure for
 table lookup
Date: Thu, 27 Apr 2017 21:24:57 +0200
Message-ID: <58f99f7e-15ea-221d-e7ec-911f64148644@redhat.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-17-git-send-email-eric.auger@redhat.com>
 <20170427180641.GT50776@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170427180641.GT50776@lvm>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: eric.auger.pro@gmail.com, marc.zyngier@arm.com, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 27/04/2017 20:06, Christoffer Dall wrote:
> On Fri, Apr 14, 2017 at 12:15:28PM +0200, Eric Auger wrote:
>> Add a generic lookup_table() helper whose role consists in
>> scanning a contiguous table located in guest RAM and applying
>> a callback on each entry. Entries can be handled as linked lists
>> since the callback may return an offset to the next entry and
>> also tell that an entry is the last one.
>>
>> Helper functions also are added to compute the device/event ID
>> offset to the next DTE/ITE.
>>
>> compute_next_devid_offset, compute_next_eventid_offset and
>> lookup_table will become static in subsequent patches
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>> v4 -> v5:
>> - use kvm_read_guest
>>
>> v3 -> v4:
>> - remove static to avoid compilation warning
>> - correct size computation in looup_table()
>> - defines now encode the number of bits used for devid and eventid offsets
>> - use BIT() - 1 to encode the max offets
>> ---
>>  virt/kvm/arm/vgic/vgic-its.c | 93 ++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 93 insertions(+)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index 56c5123..c22b35d 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -195,6 +195,8 @@ static struct its_ite *find_ite(struct vgic_its *its, u32 device_id,
>>  
>>  #define VITS_TYPER_IDBITS 16
>>  #define VITS_TYPER_DEVBITS 16
>> +#define VITS_DTE_MAX_DEVID_OFFSET	(BIT(14) - 1)
>> +#define VITS_ITE_MAX_EVENTID_OFFSET	(BIT(16) - 1)
>>  
>>  /*
>>   * Finds and returns a collection in the ITS collection table.
>> @@ -1674,6 +1676,97 @@ int vgic_its_attr_regs_access(struct kvm_device *dev,
>>  	return ret;
>>  }
>>  
>> +u32 compute_next_devid_offset(struct list_head *h, struct its_device *dev)
>> +{
>> +	struct list_head *e = &dev->dev_list;
>> +	struct its_device *next;
>> +	u32 next_offset;
>> +
>> +	if (e->next == h)
>> +		return 0;
>> +	next = list_entry(e->next, struct its_device, dev_list);
>> +	next_offset = next->device_id - dev->device_id;
>> +
>> +	return min_t(u32, next_offset, VITS_DTE_MAX_DEVID_OFFSET);
>> +}
>> +
>> +u32 compute_next_eventid_offset(struct list_head *h, struct its_ite *ite)
>> +{
>> +	struct list_head *e = &ite->ite_list;
>> +	struct its_ite *next;
>> +	u32 next_offset;
>> +
>> +	if (e->next == h)
>> +		return 0;
>> +	next = list_entry(e->next, struct its_ite, ite_list);
>> +	next_offset = next->event_id - ite->event_id;
>> +
>> +	return min_t(u32, next_offset, VITS_ITE_MAX_EVENTID_OFFSET);
>> +}
>> +
>> +/**
>> + * entry_fn_t - Callback called on a table entry restore path
>> + * @its: its handle
>> + * @id: id of the entry
>> + * @entry: pointer to the entry
>> + * @opaque: pointer to an opaque data
>> + * @next_offset: minimal ID offset to the next entry. 0 if this
>> + * entry is the last one, 1 if the entry is invalid, >= 1 if an
>> + * entry's next_offset field was truly decoded
>> + *
>> + * Return: < 0 on error, 0 otherwise
>> + */
>> +typedef int (*entry_fn_t)(struct vgic_its *its, u32 id, void *entry,
>> +			  void *opaque, u32 *next_offset);
>> +
>> +/**
>> + * lookup_table - scan a contiguous table in guest RAM and applies a function
>> + * to each entry
>> + *
>> + * @its: its handle
>> + * @base: base gpa of the table
>> + * @size: size of the table in bytes
>> + * @esz: entry size in bytes
>> + * @start_id: first entry's ID
> 
> I'm a little confused.  Why is this not 0?
Because this is meant to be called on a second-level table as well
(device table). In that case the start ID != 0.
> 
>> + * @fn: function to apply on each entry
>> + *
>> + * Return: < 0 on error, 1 if last element identified, 0 otherwise
> 
> How can you scan the entire table and not find the last element?
This happens on 2d level tables. The last element might be in another 2d
level table.
> 
>> + */
>> +int lookup_table(struct vgic_its *its, gpa_t base, int size, int esz,
>> +		 int start_id, entry_fn_t fn, void *opaque)
> 
> Is this really a lookup?  I think this should be called
> 'scan_its_table'.
ok no strong opinion here.
> 
>> +{
>> +	void *entry = kzalloc(esz, GFP_KERNEL);
>> +	struct kvm *kvm = its->dev->kvm;
>> +	unsigned long len = size;
>> +	u32 id = start_id;
> 
> why are ids u32 and not just an unsigned long?
will change that.
> 
>> +	gpa_t gpa = base;
>> +	int ret;
>> +
>> +	while (len > 0) {
>> +		u32 next_offset;
>> +		size_t byte_offset;
>> +
>> +		ret = kvm_read_guest(kvm, gpa, entry, esz);
>> +		if (ret)
>> +			goto out;
>> +
>> +		ret = fn(its, id, entry, opaque, &next_offset);
>> +		if (ret < 0 || (!ret && !next_offset))
>> +			goto out;
>> +
>> +		byte_offset = next_offset * esz;
>> +		id += next_offset;
>> +		gpa += byte_offset;
>> +		len -= byte_offset;
>> +	}
>> +	kfree(entry);
>> +	return 0;
>> +
> 
> here you can just set 'ret = 0;'
> 
>> +out:
>> +	kfree(entry);
>> +	return (ret < 0 ? ret : 1);
> 
> and then here you can do 'return (ret <= 0 ? ret : 1)'
> but I actually think it's nicer to just write:
> 
> 	if (ret <= 0)
> 		return ret;
> 	return 1;
OK

thanks

Eric
> 
>> +}
>> +
>>  /**
>>   * vgic_its_save_device_tables - Save the device table and all ITT
>>   * into guest RAM
>> -- 
>> 2.5.5
>>
> 
> Thanks,
> -Christoffer
> 
