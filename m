From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2 01/15] KVM: arm/arm64: VGIC: don't track used LRs in
 the distributor
Date: Mon, 24 Aug 2015 17:33:19 +0100
Message-ID: <55DB474F.7010202@arm.com>
References: <1436538111-4294-1-git-send-email-andre.przywara@arm.com>
 <1436538111-4294-2-git-send-email-andre.przywara@arm.com>
 <55CB0B80.5040508@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <55CB0B80.5040508@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>
Cc: marc.zyngier@arm.com, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

On 12/08/15 10:01, Eric Auger wrote:
....
>> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
>> index bc40137..394622c 100644
>> --- a/virt/kvm/arm/vgic.c
>> +++ b/virt/kvm/arm/vgic.c
>> @@ -79,7 +79,6 @@
>>  #include "vgic.h"
>>  
>>  static void vgic_retire_disabled_irqs(struct kvm_vcpu *vcpu);
>> -static void vgic_retire_lr(int lr_nr, int irq, struct kvm_vcpu *vcpu);
>>  static struct vgic_lr vgic_get_lr(const struct kvm_vcpu *vcpu, int lr);
>>  static void vgic_set_lr(struct kvm_vcpu *vcpu, int lr, struct vgic_lr lr_desc);
>>  
>> @@ -647,6 +646,17 @@ bool vgic_handle_cfg_reg(u32 *reg, struct kvm_exit_mmio *mmio,
>>  	return false;
>>  }
>>  
>> +static void vgic_sync_lr_elrsr(struct kvm_vcpu *vcpu, int lr,
>> +			       struct vgic_lr vlr)
>> +{
>> +	vgic_ops->sync_lr_elrsr(vcpu, lr, vlr);
>> +}
> why not renaming this into vgic_set_elrsr. This would be homogeneous
> with other virtual interface control register setters?

But that would involve renaming the vgic_ops members as well to be
consistent, right? As there is no change in the behaviour, a naming
change sounds unmotivated to me. And _set_ wouldn't be exact, as this
function deals only with only one bit at a time and allows to clear it
as well.

>> +
>> +static inline u64 vgic_get_elrsr(struct kvm_vcpu *vcpu)
>> +{
>> +	return vgic_ops->get_elrsr(vcpu);
>> +}
> If I am not wrong, each time you manipulate the elrsr you handle the
> bitmap. why not directly returning an unsigned long * then (elrsr_ptr)?

Because the pointer needs to point somewhere, and that storage is
currently located on the caller's stack. Directly returning a pointer
would require the caller to provide some memory for the u64, which does
not save you so much in terms on LOC:

-	u64 elrsr = vgic_get_elrsr(vcpu);
-	unsigned long *elrsr_ptr = u64_to_bitmask(&elrsr);
+	u64 elrsr;
+	unsigned long *elrsr_ptr = vgic_get_elrsr_bm(vcpu, &elrsr);

Also we need u64_to_bitmask() in one case when converting the EISR
value, so we cannot get lost of that function.

>> +
>>  /**
>>   * vgic_unqueue_irqs - move pending/active IRQs from LRs to the distributor
>>   * @vgic_cpu: Pointer to the vgic_cpu struct holding the LRs
>> @@ -658,9 +668,11 @@ bool vgic_handle_cfg_reg(u32 *reg, struct kvm_exit_mmio *mmio,
>>  void vgic_unqueue_irqs(struct kvm_vcpu *vcpu)
>>  {
>>  	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>> +	u64 elrsr = vgic_get_elrsr(vcpu);
>> +	unsigned long *elrsr_ptr = u64_to_bitmask(&elrsr);
>>  	int i;
>>  
>> -	for_each_set_bit(i, vgic_cpu->lr_used, vgic_cpu->nr_lr) {
>> +	for_each_clear_bit(i, elrsr_ptr, vgic_cpu->nr_lr) {
>>  		struct vgic_lr lr = vgic_get_lr(vcpu, i);
>>  
>>  		/*
>> @@ -703,7 +715,7 @@ void vgic_unqueue_irqs(struct kvm_vcpu *vcpu)
>>  		 * Mark the LR as free for other use.
>>  		 */
>>  		BUG_ON(lr.state & LR_STATE_MASK);
>> -		vgic_retire_lr(i, lr.irq, vcpu);
>> +		vgic_sync_lr_elrsr(vcpu, i, lr);
>>  		vgic_irq_clear_queued(vcpu, lr.irq);
>>  
>>  		/* Finally update the VGIC state. */
>> @@ -1011,17 +1023,6 @@ static void vgic_set_lr(struct kvm_vcpu *vcpu, int lr,
>>  	vgic_ops->set_lr(vcpu, lr, vlr);
>>  }
>>  
>> -static void vgic_sync_lr_elrsr(struct kvm_vcpu *vcpu, int lr,
>> -			       struct vgic_lr vlr)
>> -{
>> -	vgic_ops->sync_lr_elrsr(vcpu, lr, vlr);
>> -}
>> -
>> -static inline u64 vgic_get_elrsr(struct kvm_vcpu *vcpu)
>> -{
>> -	return vgic_ops->get_elrsr(vcpu);
>> -}
>> -
>>  static inline u64 vgic_get_eisr(struct kvm_vcpu *vcpu)
>>  {
>>  	return vgic_ops->get_eisr(vcpu);
>> @@ -1062,18 +1063,6 @@ static inline void vgic_enable(struct kvm_vcpu *vcpu)
>>  	vgic_ops->enable(vcpu);
>>  }
>>  
>> -static void vgic_retire_lr(int lr_nr, int irq, struct kvm_vcpu *vcpu)
>> -{
>> -	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>> -	struct vgic_lr vlr = vgic_get_lr(vcpu, lr_nr);
>> -
>> -	vlr.state = 0;
>> -	vgic_set_lr(vcpu, lr_nr, vlr);
>> -	clear_bit(lr_nr, vgic_cpu->lr_used);
>> -	vgic_cpu->vgic_irq_lr_map[irq] = LR_EMPTY;
>> -	vgic_sync_lr_elrsr(vcpu, lr_nr, vlr);
>> -}
>> -
>>  /*
>>   * An interrupt may have been disabled after being made pending on the
>>   * CPU interface (the classic case is a timer running while we're
>> @@ -1085,23 +1074,32 @@ static void vgic_retire_lr(int lr_nr, int irq, struct kvm_vcpu *vcpu)
>>   */
>>  static void vgic_retire_disabled_irqs(struct kvm_vcpu *vcpu)
>>  {
>> -	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>> +	u64 elrsr = vgic_get_elrsr(vcpu);
>> +	unsigned long *elrsr_ptr = u64_to_bitmask(&elrsr);
> if you agree with above modif I would simply rename elrsr_ptr into elrsr.
>>  	int lr;
>> +	struct vgic_lr vlr;
> why moving this declaration here. I think this can remain in the block.

Possibly. Don't remember the reason of this move, I think it was due to
some other changes I later removed. I will revert it.

>>  
>> -	for_each_set_bit(lr, vgic_cpu->lr_used, vgic->nr_lr) {
>> -		struct vgic_lr vlr = vgic_get_lr(vcpu, lr);
>> +	for_each_clear_bit(lr, elrsr_ptr, vgic->nr_lr) {
>> +		vlr = vgic_get_lr(vcpu, lr);
>>  
>>  		if (!vgic_irq_is_enabled(vcpu, vlr.irq)) {
>> -			vgic_retire_lr(lr, vlr.irq, vcpu);
>> -			if (vgic_irq_is_queued(vcpu, vlr.irq))
>> -				vgic_irq_clear_queued(vcpu, vlr.irq);
>> +			vlr.state = 0;
>> +			vgic_set_lr(vcpu, lr, vlr);
>> +			vgic_sync_lr_elrsr(vcpu, lr, vlr);
> vgic_set_elrsr?
> 
> the "if (vgic_irq_is_queued(vcpu, vlr.irq))" check disappeared. This
> change might be introduced separately.

OK, this is an admittedly independent optimization to avoid the needless
check for "clear only set bits". I didn't find it useful to spin a
separate patch for this, so just fixed this while reworking this code
anyway.

>> +			vgic_irq_clear_queued(vcpu, vlr.irq);
>>  		}
>>  	}
>>  }
>>  
>>  static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
>> -				 int lr_nr, struct vgic_lr vlr)
> I don't think this change of proto is compatible with Marc's "KVM:
> arm/arm64: vgic: Allow HW interrupts to be queued to a guest".
> I think we need to keep former signature.

I will need to rebase my series on top of the 4.3 pull request anyway,
so: yes, I will adapt to Marc's series.

>> +				 int lr_nr, int sgi_source_id)
>>  {
>> +	struct vgic_lr vlr;
>> +
>> +	vlr.state = 0;
>> +	vlr.irq = irq;
>> +	vlr.source = sgi_source_id;
>> +
>>  	if (vgic_irq_is_active(vcpu, irq)) {
>>  		vlr.state |= LR_STATE_ACTIVE;
>>  		kvm_debug("Set active, clear distributor: 0x%x\n", vlr.state);
>> @@ -1126,9 +1124,9 @@ static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
>>   */
>>  bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_source_id, int irq)
>>  {
>> -	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>>  	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>> -	struct vgic_lr vlr;
>> +	u64 elrsr = vgic_get_elrsr(vcpu);
>> +	unsigned long *elrsr_ptr = u64_to_bitmask(&elrsr);
>>  	int lr;
>>  
>>  	/* Sanitize the input... */
>> @@ -1138,42 +1136,20 @@ bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_source_id, int irq)
>>  
>>  	kvm_debug("Queue IRQ%d\n", irq);
>>  
>> -	lr = vgic_cpu->vgic_irq_lr_map[irq];
>> -
>> -	/* Do we have an active interrupt for the same CPUID? */
>> -	if (lr != LR_EMPTY) {
>> -		vlr = vgic_get_lr(vcpu, lr);
>> -		if (vlr.source == sgi_source_id) {
>> -			kvm_debug("LR%d piggyback for IRQ%d\n", lr, vlr.irq);
>> -			BUG_ON(!test_bit(lr, vgic_cpu->lr_used));
>> -			vgic_queue_irq_to_lr(vcpu, irq, lr, vlr);
>> -			return true;
>> -		}
>> -	}
>> +	lr = find_first_bit(elrsr_ptr, vgic->nr_lr);
>>  
>> -	/* Try to use another LR for this interrupt */
>> -	lr = find_first_zero_bit((unsigned long *)vgic_cpu->lr_used,
>> -			       vgic->nr_lr);
>>  	if (lr >= vgic->nr_lr)
>>  		return false;
>>  
>>  	kvm_debug("LR%d allocated for IRQ%d %x\n", lr, irq, sgi_source_id);
>> -	vgic_cpu->vgic_irq_lr_map[irq] = lr;
>> -	set_bit(lr, vgic_cpu->lr_used);
>>  
>> -	vlr.irq = irq;
>> -	vlr.source = sgi_source_id;
>> -	vlr.state = 0;
>> -	vgic_queue_irq_to_lr(vcpu, irq, lr, vlr);
>> +	vgic_queue_irq_to_lr(vcpu, irq, lr, sgi_source_id);
>>  
>>  	return true;
>>  }
>>  
>>  static bool vgic_queue_hwirq(struct kvm_vcpu *vcpu, int irq)
>>  {
>> -	if (!vgic_can_sample_irq(vcpu, irq))
>> -		return true; /* level interrupt, already queued */
>> -
> I think that change needs to be introduced in a separate patch as the
> other one mentioned above and justified since it affects the state machine.

But this change is dependent on this patch: it will not work without
this patch and this patch will not work without that change.
So the idea is that on returning from the guest we now harvest all
_used_ LRs by copying their state back into the distributor. The
previous behaviour was to just check _unused_ LRs for completed IRQs.
So now all IRQs need to be re-inserted into the LRs before the next
guest run, that's why we have to remove the test which skipped this for
IRQs where the code knew that they were still in the LRs.
Does that make sense?

Cheers,
Andre.
