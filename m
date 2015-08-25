From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2 12/15] KVM: arm64: sync LPI configuration and pending
 tables
Date: Tue, 25 Aug 2015 16:27:12 +0100
Message-ID: <55DC8950.3050306@arm.com>
References: <1436538111-4294-1-git-send-email-andre.przywara@arm.com>
 <1436538111-4294-13-git-send-email-andre.przywara@arm.com>
 <55CDD7CB.9020103@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <55CDD7CB.9020103@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Pavel Fedin <p.fedin@samsung.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

On 14/08/15 12:58, Eric Auger wrote:
> On 07/10/2015 04:21 PM, Andre Przywara wrote:
>> The LPI configuration and pending tables of the GICv3 LPIs are held
>> in tables in (guest) memory. To achieve reasonable performance, we
>> cache this data in our own data structures, so we need to sync those
>> two views from time to time. This behaviour is well described in the
>> GICv3 spec and is also exercised by hardware, so the sync points are
>> well known.
>>
>> Provide functions that read the guest memory and store the
>> information from the configuration and pending tables in the kernel.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
> would help to have change log between v1 -> v2 (valid for the whole series)
>>  include/kvm/arm_vgic.h  |   2 +
>>  virt/kvm/arm/its-emul.c | 124 ++++++++++++++++++++++++++++++++++++++++++++++++
>>  virt/kvm/arm/its-emul.h |   3 ++
>>  3 files changed, 129 insertions(+)
>>
>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> index 2a67a10..323c33a 100644
>> --- a/include/kvm/arm_vgic.h
>> +++ b/include/kvm/arm_vgic.h
>> @@ -167,6 +167,8 @@ struct vgic_its {
>>  	int			cwriter;
>>  	struct list_head	device_list;
>>  	struct list_head	collection_list;
>> +	/* memory used for buffering guest's memory */
>> +	void			*buffer_page;
>>  };
>>  
>>  struct vgic_dist {
>> diff --git a/virt/kvm/arm/its-emul.c b/virt/kvm/arm/its-emul.c
>> index b9c40d7..05245cb 100644
>> --- a/virt/kvm/arm/its-emul.c
>> +++ b/virt/kvm/arm/its-emul.c
>> @@ -50,6 +50,7 @@ struct its_itte {
>>  	struct its_collection *collection;
>>  	u32 lpi;
>>  	u32 event_id;
>> +	u8 priority;
>>  	bool enabled;
>>  	unsigned long *pending;
>>  };
>> @@ -70,8 +71,124 @@ static struct its_itte *find_itte_by_lpi(struct kvm *kvm, int lpi)
>>  	return NULL;
>>  }
>>  
>> +#define LPI_PROP_ENABLE_BIT(p)	((p) & LPI_PROP_ENABLED)
>> +#define LPI_PROP_PRIORITY(p)	((p) & 0xfc)
>> +
>> +/* stores the priority and enable bit for a given LPI */
>> +static void update_lpi_config(struct kvm *kvm, struct its_itte *itte, u8 prop)
>> +{
>> +	itte->priority = LPI_PROP_PRIORITY(prop);
>> +	itte->enabled  = LPI_PROP_ENABLE_BIT(prop);
>> +}
>> +
>> +#define GIC_LPI_OFFSET 8192
>> +
>> +/* We scan the table in chunks the size of the smallest page size */
> 4kB chunks?

Marc was complaining about this wording, I think. The rationale was that
"4K" is already in the code and thus does not need to be repeated in the
comment, whereas the comment should explain the meaning of the value.

>> +#define CHUNK_SIZE 4096U
>> +
>>  #define BASER_BASE_ADDRESS(x) ((x) & 0xfffffffff000ULL)
>>  
>> +static int nr_idbits_propbase(u64 propbaser)
>> +{
>> +	int nr_idbits = (1U << (propbaser & 0x1f)) + 1;
>> +
>> +	return max(nr_idbits, INTERRUPT_ID_BITS_ITS);
>> +}
>> +
>> +/*
>> + * Scan the whole LPI configuration table and put the LPI configuration
>> + * data in our own data structures. This relies on the LPI being
>> + * mapped before.
>> + */
>> +static bool its_update_lpis_configuration(struct kvm *kvm)
>> +{
>> +	struct vgic_dist *dist = &kvm->arch.vgic;
>> +	u8 *prop = dist->its.buffer_page;
>> +	u32 tsize;
>> +	gpa_t propbase;
>> +	int lpi = GIC_LPI_OFFSET;
>> +	struct its_itte *itte;
>> +	struct its_device *device;
>> +	int ret;
>> +
>> +	propbase = BASER_BASE_ADDRESS(dist->propbaser);
>> +	tsize = nr_idbits_propbase(dist->propbaser);
>> +
>> +	while (tsize > 0) {
>> +		int chunksize = min(tsize, CHUNK_SIZE);
>> +
>> +		ret = kvm_read_guest(kvm, propbase, prop, chunksize);
> I think you still have the spin_lock issue  since if my understanding is
> correct this is called from
> vgic_handle_mmio_access/vcall_range_handler/gic_enable_lpis
> where vgic_handle_mmio_access. Or does it take another path?

Well, it's (also) called on handling the INVALL command, but you are
right that on that enable path the dist lock is held. I reckon that this
init part isn't racy so that shouldn't be a problem (famous last words ;-).
Let me see whether I can find a way to just drop the lock around the
while loop.

Cheers,
Andre.

> 
> Shouldn't we create a new kvm_io_device to avoid holding the dist lock?
> 
> Eric
