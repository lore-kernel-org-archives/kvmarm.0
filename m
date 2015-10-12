From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 12/16] KVM: arm64: handle pending bit for LPIs in ITS
 emulation
Date: Mon, 12 Oct 2015 15:17:52 +0100
Message-ID: <561BC110.9090403@arm.com>
References: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
 <1444229726-31559-13-git-send-email-andre.przywara@arm.com>
 <016d01d104c1$47a41570$d6ec4050$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A14541022
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Oct 2015 10:14:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dFhEDZDL3h7h for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Oct 2015 10:14:47 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 156F640FB3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Oct 2015 10:14:46 -0400 (EDT)
In-Reply-To: <016d01d104c1$47a41570$d6ec4050$@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Pavel,

On 12/10/15 08:40, Pavel Fedin wrote:
>  Hello!
> 
>> -----Original Message-----
>> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On Behalf Of Andre Przywara
>> Sent: Wednesday, October 07, 2015 5:55 PM
>> To: marc.zyngier@arm.com; christoffer.dall@linaro.org
>> Cc: eric.auger@linaro.org; p.fedin@samsung.com; kvmarm@lists.cs.columbia.edu; linux-arm-
>> kernel@lists.infradead.org; kvm@vger.kernel.org
>> Subject: [PATCH v3 12/16] KVM: arm64: handle pending bit for LPIs in ITS emulation
>>
>> As the actual LPI number in a guest can be quite high, but is mostly
>> assigned using a very sparse allocation scheme, bitmaps and arrays
>> for storing the virtual interrupt status are a waste of memory.
>> We use our equivalent of the "Interrupt Translation Table Entry"
>> (ITTE) to hold this extra status information for a virtual LPI.
>> As the normal VGIC code cannot use its fancy bitmaps to manage
>> pending interrupts, we provide a hook in the VGIC code to let the
>> ITS emulation handle the list register queueing itself.
>> LPIs are located in a separate number range (>=8192), so
>> distinguishing them is easy. With LPIs being only edge-triggered, we
>> get away with a less complex IRQ handling.
>> We extend the number of bits for storing the IRQ number in our
>> LR struct to 16 to cover the LPI numbers we support as well.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>> Changelog v2..v3:
>> - extend LR data structure to hold 16-bit wide IRQ IDs
>> - only clear pending bit if IRQ could be queued
>> - adapt __kvm_vgic_sync_hwstate() to upstream changes
>>
>>  include/kvm/arm_vgic.h      |  4 +-
>>  virt/kvm/arm/its-emul.c     | 75 ++++++++++++++++++++++++++++++++++++
>>  virt/kvm/arm/its-emul.h     |  3 ++
>>  virt/kvm/arm/vgic-v3-emul.c |  2 +
>>  virt/kvm/arm/vgic.c         | 93 +++++++++++++++++++++++++++++++--------------
>>  5 files changed, 148 insertions(+), 29 deletions(-)
>>
>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> index c3eb414..035911f 100644
>> --- a/include/kvm/arm_vgic.h
>> +++ b/include/kvm/arm_vgic.h
>> @@ -95,7 +95,7 @@ enum vgic_type {
>>  #define LR_HW			(1 << 3)
>>
>>  struct vgic_lr {
>> -	unsigned irq:10;
>> +	unsigned irq:16;
>>  	union {
>>  		unsigned hwirq:10;
>>  		unsigned source:3;
>> @@ -147,6 +147,8 @@ struct vgic_vm_ops {
>>  	int	(*init_model)(struct kvm *);
>>  	void	(*destroy_model)(struct kvm *);
>>  	int	(*map_resources)(struct kvm *, const struct vgic_params *);
>> +	bool	(*queue_lpis)(struct kvm_vcpu *);
>> +	void	(*unqueue_lpi)(struct kvm_vcpu *, int irq);
>>  };
>>
>>  struct vgic_io_device {
>> diff --git a/virt/kvm/arm/its-emul.c b/virt/kvm/arm/its-emul.c
>> index bab8033..8349970 100644
>> --- a/virt/kvm/arm/its-emul.c
>> +++ b/virt/kvm/arm/its-emul.c
>> @@ -59,8 +59,27 @@ struct its_itte {
>>  	struct its_collection *collection;
>>  	u32 lpi;
>>  	u32 event_id;
>> +	bool enabled;
>> +	unsigned long *pending;
>>  };
>>
>> +/* To be used as an iterator this macro misses the enclosing parentheses */
>> +#define for_each_lpi(dev, itte, kvm) \
>> +	list_for_each_entry(dev, &(kvm)->arch.vgic.its.device_list, dev_list) \
>> +		list_for_each_entry(itte, &(dev)->itt, itte_list)
>> +
>> +static struct its_itte *find_itte_by_lpi(struct kvm *kvm, int lpi)
>> +{
>> +	struct its_device *device;
>> +	struct its_itte *itte;
>> +
>> +	for_each_lpi(device, itte, kvm) {
>> +		if (itte->lpi == lpi)
>> +			return itte;
>> +	}
>> +	return NULL;
>> +}
>> +
>>  #define BASER_BASE_ADDRESS(x) ((x) & 0xfffffffff000ULL)
>>
>>  /* The distributor lock is held by the VGIC MMIO handler. */
>> @@ -154,9 +173,65 @@ static bool handle_mmio_gits_idregs(struct kvm_vcpu *vcpu,
>>  	return false;
>>  }
>>
>> +/*
>> + * Find all enabled and pending LPIs and queue them into the list
>> + * registers.
>> + * The dist lock is held by the caller.
>> + */
>> +bool vits_queue_lpis(struct kvm_vcpu *vcpu)
>> +{
>> +	struct vgic_its *its = &vcpu->kvm->arch.vgic.its;
>> +	struct its_device *device;
>> +	struct its_itte *itte;
>> +	bool ret = true;
>> +
>> +	if (!vgic_has_its(vcpu->kvm))
>> +		return true;
>> +	if (!its->enabled || !vcpu->kvm->arch.vgic.lpis_enabled)
>> +		return true;
>> +
>> +	spin_lock(&its->lock);
>> +	for_each_lpi(device, itte, vcpu->kvm) {
>> +		if (!itte->enabled || !test_bit(vcpu->vcpu_id, itte->pending))
>> +			continue;
>> +
>> +		if (!itte->collection)
>> +			continue;
>> +
>> +		if (itte->collection->target_addr != vcpu->vcpu_id)
>> +			continue;
>> +
>> +
>> +		if (vgic_queue_irq(vcpu, 0, itte->lpi))
>> +			__clear_bit(vcpu->vcpu_id, itte->pending);
>> +		else
>> +			ret = false;
> 
>  Shouldn't we also have 'break' here? If vgic_queue_irq() returns false, this means we have no more
> LRs to use, therefore it makes no sense to keep iterating.

I consider this too much optimization at this point.
vgic_queue_irq() just tells about the success for this interrupt, I'd
rather not make assumptions about other IRQs (we could piggy-back those,
for instance).
Even if not, I'd prefer to not break abstraction here.

Cheers,
Andre.
