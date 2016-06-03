From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v4 09/12] KVM: arm64: sync LPI configuration and pending
 tables
Date: Fri, 3 Jun 2016 15:17:21 +0100
Message-ID: <66b1f4d4-a958-b870-451d-5c2475e2c236@arm.com>
References: <1458958450-19662-1-git-send-email-andre.przywara@arm.com>
 <1458958450-19662-10-git-send-email-andre.przywara@arm.com>
 <570511FA.7010906@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0381041267
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jun 2016 10:12:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3W4HovsBEWnK for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Jun 2016 10:12:38 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 646A240C9A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jun 2016 10:12:37 -0400 (EDT)
In-Reply-To: <570511FA.7010906@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Salut Eric,

just some rationale below on why I didn't address all of your comments.

On 06/04/16 14:41, Eric Auger wrote:
> Hi Andre,
> On 03/26/2016 03:14 AM, Andre Przywara wrote:
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
>>  include/kvm/vgic/vgic.h      |   2 +
>>  virt/kvm/arm/vgic/its-emul.c | 135 +++++++++++++++++++++++++++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic.h     |   1 +
>>  3 files changed, 138 insertions(+)
>>
>> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
>> index ecf3260..ea98133 100644
>> --- a/include/kvm/vgic/vgic.h
>> +++ b/include/kvm/vgic/vgic.h
>> @@ -121,6 +121,8 @@ struct vgic_its {
>>  	int			cwriter;
>>  	struct list_head	device_list;
>>  	struct list_head	collection_list;
>> +	/* memory used for buffering guest's memory */
>> +	void			*buffer_page;
>>  };
>>  
>>  struct vgic_dist {
>> diff --git a/virt/kvm/arm/vgic/its-emul.c b/virt/kvm/arm/vgic/its-emul.c
>> index 1188e9a..d82ba9b 100644
>> --- a/virt/kvm/arm/vgic/its-emul.c
>> +++ b/virt/kvm/arm/vgic/its-emul.c
>> @@ -78,8 +78,130 @@ static struct its_itte *find_itte_by_lpi(struct kvm *kvm, int lpi)
>>  	return NULL;
>>  }
>>  
>> +#define LPI_PROP_ENABLE_BIT(p)	((p) & LPI_PROP_ENABLED)
>> +#define LPI_PROP_PRIORITY(p)	((p) & 0xfc)
>> +
>> +/* stores the priority and enable bit for a given LPI */
>> +static void update_lpi_config(struct kvm *kvm, struct its_itte *itte, u8 prop)
>> +{
>> +	spin_lock(&itte->irq.irq_lock);
>> +	itte->irq.priority = LPI_PROP_PRIORITY(prop);
>> +	itte->irq.enabled = LPI_PROP_ENABLE_BIT(prop);
>> +
> would put a comment saying that vgic_queue_irq is unlocking since it
> looks weird.
>> +	vgic_queue_irq(kvm, &itte->irq);
>> +}
>> +
>> +#define GIC_LPI_OFFSET 8192
>> +
>> +/* We scan the table in chunks the size of the smallest page size */
>> +#define CHUNK_SIZE 4096U
>> +
>>  #define BASER_BASE_ADDRESS(x) ((x) & 0xfffffffff000ULL)
>>  
>> +static int nr_idbits_propbase(u64 propbaser)
>> +{
>> +	int nr_idbits = (1U << (propbaser & 0x1f)) + 1;
>> +
>> +	return max(nr_idbits, INTERRUPT_ID_BITS_ITS);
> don't get this.
> don't you want to take the min of INTERRUPT_ID_BITS_ITS  (16) and
> propbaser & 0x1f +1.
> 
> Spec says IDbits should not exceed GICD_TYPER.IDbit ==
> INTERRUPT_ID_BITS_ITS - 1 = 15.
> 
> and in case the purpose of the function is to return the size of the
> table, which is not obvious given its name ;-), we should return 1U <<
> min(), no?

Oh dear, indeed that code was totally boll^Wnonsense. Thanks for
pointing this out!

>> +}
>> +
>> +/*
>> + * Scan the whole LPI configuration table and put the LPI configuration
>> + * data in our own data structures. This relies on the LPI being
>> + * mapped before.
>> + */
>> +static bool its_update_lpis_configuration(struct kvm *kvm, u64 prop_base_reg)
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
>> +	propbase = BASER_BASE_ADDRESS(prop_base_reg);
>> +	tsize = nr_idbits_propbase(prop_base_reg);
>> +
>> +	while (tsize > 0) {
>> +		int chunksize = min(tsize, CHUNK_SIZE);
>> +
>> +		ret = kvm_read_guest(kvm, propbase, prop, chunksize);
>> +		if (ret)
>> +			return false;
>> +
>> +		spin_lock(&dist->its.lock);
> as we start holding several locks maybe worth to comment somewhere about
> order lock: its lock > vcpu lock > irq lock
>> +		/*
>> +		 * Updating the status for all allocated LPIs. We catch
>> +		 * those LPIs that get disabled. We really don't care
>> +		 * about unmapped LPIs, as they need to be updated
>> +		 * later manually anyway once they get mapped.
>> +		 */
>> +		for_each_lpi(device, itte, kvm) {
>> +			if (itte->lpi < lpi || itte->lpi >= lpi + chunksize)
>> +				continue;
>> +
>> +			update_lpi_config(kvm, itte, prop[itte->lpi - lpi]);
>> +		}
>> +		spin_unlock(&dist->its.lock);
>> +		tsize -= chunksize;
>> +		lpi += chunksize;
>> +		propbase += chunksize;
>> +	}
>> +
>> +	return true;
>> +}
>> +
>> +/*
>> + * Scan the whole LPI pending table and sync the pending bit in there
>> + * with our own data structures. This relies on the LPI being
>> + * mapped before.
>> + */
>> +static bool its_sync_lpi_pending_table(struct kvm_vcpu *vcpu, u64 base_addr_reg)
>> +{
>> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>> +	unsigned long *pendmask = dist->its.buffer_page;
>> +	u32 nr_lpis = 1U << INTERRUPT_ID_BITS_ITS;
> shouldn't we use value computed as in nr_idbits_propbase instead?

In contrast to the PROPBASER there is not size information in PENDBASER,
also we can't use those bits from PROPBASER instead.
So I use the only other information we have about the number of LPIs,
which is what we report in TYPER as well.

>> +	gpa_t pendbase;
>> +	int lpi = 0;
>> +	struct its_itte *itte;
>> +	struct its_device *device;
>> +	int ret;
>> +	int lpi_bit, nr_bits;
>> +
>> +	pendbase = BASER_BASE_ADDRESS(base_addr_reg);
>> +
> I understand we should start reading at pendbase + 1KB. (4.8.5 pending
> tables)

Which stems from the fact that LPI numbers start at 8192, so the first
LPI would naturally start at 1KB. I use non-normalized LPI numbers
below, so that would be covered. Or did I miss something?

Cheers,
Andre.

> Eric
>> +	while (nr_lpis > 0) {
>> +		nr_bits = min(nr_lpis, CHUNK_SIZE * 8);
>> +
>> +		ret = kvm_read_guest(vcpu->kvm, pendbase, pendmask,
>> +				     nr_bits / 8);
>> +		if (ret)
>> +			return false;
>> +
>> +		spin_lock(&dist->its.lock);
>> +		for_each_lpi(device, itte, vcpu->kvm) {
>> +			lpi_bit = itte->lpi - lpi;
>> +			if (lpi_bit < 0 || lpi_bit >= nr_bits)
>> +				continue;
>> +
>> +			if (!test_bit(lpi_bit, pendmask))
>> +				continue;
>> +
>> +			spin_lock(&itte->irq.irq_lock);
>> +			itte->irq.pending = true;
>> +			vgic_queue_irq(vcpu->kvm, &itte->irq);
>> +		}
>> +		spin_unlock(&dist->its.lock);
>> +		nr_lpis -= nr_bits;
>> +		lpi += nr_bits;
>> +		pendbase += nr_bits / 8;
>> +	}
>> +
>> +	return true;
>> +}
>> +
>>  static int vgic_mmio_read_its_ctlr(struct kvm_vcpu *vcpu,
>>  				   struct kvm_io_device *this,
>>  				   gpa_t addr, int len, void *val)
>> @@ -357,6 +479,14 @@ struct vgic_register_region its_registers[] = {
>>  /* This is called on setting the LPI enable bit in the redistributor. */
>>  void vgic_enable_lpis(struct kvm_vcpu *vcpu)
>>  {
>> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>> +	u64 prop_base_reg, pend_base_reg;
>> +
>> +	pend_base_reg = dist->pendbaser[vcpu->vcpu_id];
>> +	prop_base_reg = dist->propbaser;
>> +
>> +	its_update_lpis_configuration(vcpu->kvm, prop_base_reg);
>> +	its_sync_lpi_pending_table(vcpu, pend_base_reg);
>>  }
>>  
>>  int vits_init(struct kvm *kvm)
>> @@ -371,6 +501,10 @@ int vits_init(struct kvm *kvm)
>>  	if (!dist->pendbaser)
>>  		return -ENOMEM;
>>  
>> +	its->buffer_page = kmalloc(CHUNK_SIZE, GFP_KERNEL);
>> +	if (!its->buffer_page)
>> +		return -ENOMEM;
>> +
>>  	spin_lock_init(&its->lock);
>>  
>>  	INIT_LIST_HEAD(&its->device_list);
>> @@ -430,6 +564,7 @@ void vits_destroy(struct kvm *kvm)
>>  		kfree(container_of(cur, struct its_collection, coll_list));
>>  	}
>>  
>> +	kfree(its->buffer_page);
>>  	kfree(dist->pendbaser);
>>  
>>  	its->enabled = false;
>> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
>> index 160c511..a7218b0 100644
>> --- a/virt/kvm/arm/vgic/vgic.h
>> +++ b/virt/kvm/arm/vgic/vgic.h
>> @@ -23,6 +23,7 @@
>>  #define IS_VGIC_ADDR_UNDEF(_x)  ((_x) == VGIC_ADDR_UNDEF)
>>  
>>  #define INTERRUPT_ID_BITS_SPIS	10
>> +#define INTERRUPT_ID_BITS_ITS	16
>>  
>>  struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
>>  			      u32 intid);
>>
> 
