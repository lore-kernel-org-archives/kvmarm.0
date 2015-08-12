From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v2 01/15] KVM: arm/arm64: VGIC: don't track used LRs in
 the distributor
Date: Wed, 12 Aug 2015 11:01:52 +0200
Message-ID: <55CB0B80.5040508@linaro.org>
References: <1436538111-4294-1-git-send-email-andre.przywara@arm.com> <1436538111-4294-2-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1436538111-4294-2-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, marc.zyngier@arm.com, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu
Cc: Pavel Fedin <p.fedin@samsung.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,
On 07/10/2015 04:21 PM, Andre Przywara wrote:
> Currently we track which IRQ has been mapped to which VGIC list
> register and also have to synchronize both. We used to do this
> to hold some extra state (for instance the active bit).
> It turns out that this extra state in the LRs is no longer needed and
> this extra tracking causes some pain later.
> Remove the tracking feature (lr_map and lr_used) and get rid of
> quite some code on the way.
> On a guest exit we pick up all still pending IRQs from the LRs and put
> them back in the distributor. We don't care about active-only IRQs,
> so we keep them in the LRs. They will be retired either by our
> vgic_process_maintenance() routine or by the GIC hardware in case of
> edge triggered interrupts.
> In places where we scan LRs we now use our shadow copy of the ELRSR
> register directly.
> This code change means we lose the "piggy-back" optimization, which
> would re-use an active-only LR to inject the pending state on top of
> it. Tracing with various workloads shows that this actually occurred
> very rarely, the ballpark figure is about once every 10,000 exits
> in a disk I/O heavy workload. Also the list registers don't seem to
> as scarce as assumed, with all 4 LRs on the popular implementations
> used less than once every 100,000 exits.
> 
> This has been briefly tested on Midway, Juno and the model (the latter
> both with GICv2 and GICv3 guests).
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/kvm/arm_vgic.h |   6 ---
>  virt/kvm/arm/vgic-v2.c |   1 +
>  virt/kvm/arm/vgic-v3.c |   1 +
>  virt/kvm/arm/vgic.c    | 143 ++++++++++++++++++++++---------------------------
>  4 files changed, 66 insertions(+), 85 deletions(-)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 133ea00..2ccfa9a 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -279,9 +279,6 @@ struct vgic_v3_cpu_if {
>  };
>  
>  struct vgic_cpu {
> -	/* per IRQ to LR mapping */
> -	u8		*vgic_irq_lr_map;
> -
>  	/* Pending/active/both interrupts on this VCPU */
>  	DECLARE_BITMAP(	pending_percpu, VGIC_NR_PRIVATE_IRQS);
>  	DECLARE_BITMAP(	active_percpu, VGIC_NR_PRIVATE_IRQS);
> @@ -292,9 +289,6 @@ struct vgic_cpu {
>  	unsigned long   *active_shared;
>  	unsigned long   *pend_act_shared;
>  
> -	/* Bitmap of used/free list registers */
> -	DECLARE_BITMAP(	lr_used, VGIC_V2_MAX_LRS);
> -
>  	/* Number of list registers on this CPU */
>  	int		nr_lr;
>  
> diff --git a/virt/kvm/arm/vgic-v2.c b/virt/kvm/arm/vgic-v2.c
> index f9b9c7c..f723710 100644
> --- a/virt/kvm/arm/vgic-v2.c
> +++ b/virt/kvm/arm/vgic-v2.c
> @@ -144,6 +144,7 @@ static void vgic_v2_enable(struct kvm_vcpu *vcpu)
>  	 * anyway.
>  	 */
>  	vcpu->arch.vgic_cpu.vgic_v2.vgic_vmcr = 0;
> +	vcpu->arch.vgic_cpu.vgic_v2.vgic_elrsr = ~0;
>  
>  	/* Get the show on the road... */
>  	vcpu->arch.vgic_cpu.vgic_v2.vgic_hcr = GICH_HCR_EN;
> diff --git a/virt/kvm/arm/vgic-v3.c b/virt/kvm/arm/vgic-v3.c
> index dff0602..21e5d28 100644
> --- a/virt/kvm/arm/vgic-v3.c
> +++ b/virt/kvm/arm/vgic-v3.c
> @@ -178,6 +178,7 @@ static void vgic_v3_enable(struct kvm_vcpu *vcpu)
>  	 * anyway.
>  	 */
>  	vgic_v3->vgic_vmcr = 0;
> +	vgic_v3->vgic_elrsr = ~0;
>  
>  	/*
>  	 * If we are emulating a GICv3, we do it in an non-GICv2-compatible
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index bc40137..394622c 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -79,7 +79,6 @@
>  #include "vgic.h"
>  
>  static void vgic_retire_disabled_irqs(struct kvm_vcpu *vcpu);
> -static void vgic_retire_lr(int lr_nr, int irq, struct kvm_vcpu *vcpu);
>  static struct vgic_lr vgic_get_lr(const struct kvm_vcpu *vcpu, int lr);
>  static void vgic_set_lr(struct kvm_vcpu *vcpu, int lr, struct vgic_lr lr_desc);
>  
> @@ -647,6 +646,17 @@ bool vgic_handle_cfg_reg(u32 *reg, struct kvm_exit_mmio *mmio,
>  	return false;
>  }
>  
> +static void vgic_sync_lr_elrsr(struct kvm_vcpu *vcpu, int lr,
> +			       struct vgic_lr vlr)
> +{
> +	vgic_ops->sync_lr_elrsr(vcpu, lr, vlr);
> +}
why not renaming this into vgic_set_elrsr. This would be homogeneous
with other virtual interface control register setters?
> +
> +static inline u64 vgic_get_elrsr(struct kvm_vcpu *vcpu)
> +{
> +	return vgic_ops->get_elrsr(vcpu);
> +}
If I am not wrong, each time you manipulate the elrsr you handle the
bitmap. why not directly returning an unsigned long * then (elrsr_ptr)?
> +
>  /**
>   * vgic_unqueue_irqs - move pending/active IRQs from LRs to the distributor
>   * @vgic_cpu: Pointer to the vgic_cpu struct holding the LRs
> @@ -658,9 +668,11 @@ bool vgic_handle_cfg_reg(u32 *reg, struct kvm_exit_mmio *mmio,
>  void vgic_unqueue_irqs(struct kvm_vcpu *vcpu)
>  {
>  	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> +	u64 elrsr = vgic_get_elrsr(vcpu);
> +	unsigned long *elrsr_ptr = u64_to_bitmask(&elrsr);
>  	int i;
>  
> -	for_each_set_bit(i, vgic_cpu->lr_used, vgic_cpu->nr_lr) {
> +	for_each_clear_bit(i, elrsr_ptr, vgic_cpu->nr_lr) {
>  		struct vgic_lr lr = vgic_get_lr(vcpu, i);
>  
>  		/*
> @@ -703,7 +715,7 @@ void vgic_unqueue_irqs(struct kvm_vcpu *vcpu)
>  		 * Mark the LR as free for other use.
>  		 */
>  		BUG_ON(lr.state & LR_STATE_MASK);
> -		vgic_retire_lr(i, lr.irq, vcpu);
> +		vgic_sync_lr_elrsr(vcpu, i, lr);
>  		vgic_irq_clear_queued(vcpu, lr.irq);
>  
>  		/* Finally update the VGIC state. */
> @@ -1011,17 +1023,6 @@ static void vgic_set_lr(struct kvm_vcpu *vcpu, int lr,
>  	vgic_ops->set_lr(vcpu, lr, vlr);
>  }
>  
> -static void vgic_sync_lr_elrsr(struct kvm_vcpu *vcpu, int lr,
> -			       struct vgic_lr vlr)
> -{
> -	vgic_ops->sync_lr_elrsr(vcpu, lr, vlr);
> -}
> -
> -static inline u64 vgic_get_elrsr(struct kvm_vcpu *vcpu)
> -{
> -	return vgic_ops->get_elrsr(vcpu);
> -}
> -
>  static inline u64 vgic_get_eisr(struct kvm_vcpu *vcpu)
>  {
>  	return vgic_ops->get_eisr(vcpu);
> @@ -1062,18 +1063,6 @@ static inline void vgic_enable(struct kvm_vcpu *vcpu)
>  	vgic_ops->enable(vcpu);
>  }
>  
> -static void vgic_retire_lr(int lr_nr, int irq, struct kvm_vcpu *vcpu)
> -{
> -	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> -	struct vgic_lr vlr = vgic_get_lr(vcpu, lr_nr);
> -
> -	vlr.state = 0;
> -	vgic_set_lr(vcpu, lr_nr, vlr);
> -	clear_bit(lr_nr, vgic_cpu->lr_used);
> -	vgic_cpu->vgic_irq_lr_map[irq] = LR_EMPTY;
> -	vgic_sync_lr_elrsr(vcpu, lr_nr, vlr);
> -}
> -
>  /*
>   * An interrupt may have been disabled after being made pending on the
>   * CPU interface (the classic case is a timer running while we're
> @@ -1085,23 +1074,32 @@ static void vgic_retire_lr(int lr_nr, int irq, struct kvm_vcpu *vcpu)
>   */
>  static void vgic_retire_disabled_irqs(struct kvm_vcpu *vcpu)
>  {
> -	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> +	u64 elrsr = vgic_get_elrsr(vcpu);
> +	unsigned long *elrsr_ptr = u64_to_bitmask(&elrsr);
if you agree with above modif I would simply rename elrsr_ptr into elrsr.
>  	int lr;
> +	struct vgic_lr vlr;
why moving this declaration here. I think this can remain in the block.
>  
> -	for_each_set_bit(lr, vgic_cpu->lr_used, vgic->nr_lr) {
> -		struct vgic_lr vlr = vgic_get_lr(vcpu, lr);
> +	for_each_clear_bit(lr, elrsr_ptr, vgic->nr_lr) {
> +		vlr = vgic_get_lr(vcpu, lr);
>  
>  		if (!vgic_irq_is_enabled(vcpu, vlr.irq)) {
> -			vgic_retire_lr(lr, vlr.irq, vcpu);
> -			if (vgic_irq_is_queued(vcpu, vlr.irq))
> -				vgic_irq_clear_queued(vcpu, vlr.irq);
> +			vlr.state = 0;
> +			vgic_set_lr(vcpu, lr, vlr);
> +			vgic_sync_lr_elrsr(vcpu, lr, vlr);
vgic_set_elrsr?

the "if (vgic_irq_is_queued(vcpu, vlr.irq))" check disappeared. This
change might be introduced separately.
> +			vgic_irq_clear_queued(vcpu, vlr.irq);
>  		}
>  	}
>  }
>  
>  static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
> -				 int lr_nr, struct vgic_lr vlr)
I don't think this change of proto is compatible with Marc's "KVM:
arm/arm64: vgic: Allow HW interrupts to be queued to a guest".
I think we need to keep former signature.
> +				 int lr_nr, int sgi_source_id)
>  {
> +	struct vgic_lr vlr;
> +
> +	vlr.state = 0;
> +	vlr.irq = irq;
> +	vlr.source = sgi_source_id;
> +
>  	if (vgic_irq_is_active(vcpu, irq)) {
>  		vlr.state |= LR_STATE_ACTIVE;
>  		kvm_debug("Set active, clear distributor: 0x%x\n", vlr.state);
> @@ -1126,9 +1124,9 @@ static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
>   */
>  bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_source_id, int irq)
>  {
> -	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>  	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> -	struct vgic_lr vlr;
> +	u64 elrsr = vgic_get_elrsr(vcpu);
> +	unsigned long *elrsr_ptr = u64_to_bitmask(&elrsr);
>  	int lr;
>  
>  	/* Sanitize the input... */
> @@ -1138,42 +1136,20 @@ bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_source_id, int irq)
>  
>  	kvm_debug("Queue IRQ%d\n", irq);
>  
> -	lr = vgic_cpu->vgic_irq_lr_map[irq];
> -
> -	/* Do we have an active interrupt for the same CPUID? */
> -	if (lr != LR_EMPTY) {
> -		vlr = vgic_get_lr(vcpu, lr);
> -		if (vlr.source == sgi_source_id) {
> -			kvm_debug("LR%d piggyback for IRQ%d\n", lr, vlr.irq);
> -			BUG_ON(!test_bit(lr, vgic_cpu->lr_used));
> -			vgic_queue_irq_to_lr(vcpu, irq, lr, vlr);
> -			return true;
> -		}
> -	}
> +	lr = find_first_bit(elrsr_ptr, vgic->nr_lr);
>  
> -	/* Try to use another LR for this interrupt */
> -	lr = find_first_zero_bit((unsigned long *)vgic_cpu->lr_used,
> -			       vgic->nr_lr);
>  	if (lr >= vgic->nr_lr)
>  		return false;
>  
>  	kvm_debug("LR%d allocated for IRQ%d %x\n", lr, irq, sgi_source_id);
> -	vgic_cpu->vgic_irq_lr_map[irq] = lr;
> -	set_bit(lr, vgic_cpu->lr_used);
>  
> -	vlr.irq = irq;
> -	vlr.source = sgi_source_id;
> -	vlr.state = 0;
> -	vgic_queue_irq_to_lr(vcpu, irq, lr, vlr);
> +	vgic_queue_irq_to_lr(vcpu, irq, lr, sgi_source_id);
>  
>  	return true;
>  }
>  
>  static bool vgic_queue_hwirq(struct kvm_vcpu *vcpu, int irq)
>  {
> -	if (!vgic_can_sample_irq(vcpu, irq))
> -		return true; /* level interrupt, already queued */
> -
I think that change needs to be introduced in a separate patch as the
other one mentioned above and justified since it affects the state machine.

Best Regards

Eric
>  	if (vgic_queue_irq(vcpu, 0, irq)) {
>  		if (vgic_irq_is_edge(vcpu, irq)) {
>  			vgic_dist_irq_clear_pending(vcpu, irq);
> @@ -1346,29 +1322,44 @@ static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
>  	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>  	u64 elrsr;
>  	unsigned long *elrsr_ptr;
> -	int lr, pending;
> -	bool level_pending;
> +	struct vgic_lr vlr;
> +	int lr_nr;
> +	bool pending;
> +
> +	pending = vgic_process_maintenance(vcpu);
>  
> -	level_pending = vgic_process_maintenance(vcpu);
>  	elrsr = vgic_get_elrsr(vcpu);
>  	elrsr_ptr = u64_to_bitmask(&elrsr);
>  
> -	/* Clear mappings for empty LRs */
> -	for_each_set_bit(lr, elrsr_ptr, vgic->nr_lr) {
> -		struct vgic_lr vlr;
> +	for_each_clear_bit(lr_nr, elrsr_ptr, vgic_cpu->nr_lr) {
> +		vlr = vgic_get_lr(vcpu, lr_nr);
> +
> +		BUG_ON(!(vlr.state & LR_STATE_MASK));
> +		pending = true;
>  
> -		if (!test_and_clear_bit(lr, vgic_cpu->lr_used))
> +		/* Reestablish SGI source for pending and active SGIs */
> +		if (vlr.irq < VGIC_NR_SGIS)
> +			add_sgi_source(vcpu, vlr.irq, vlr.source);
> +
> +		/*
> +		 * If the LR holds a pure active (10) interrupt then keep it
> +		 * in the LR without mirroring this status in the emulation.
> +		 */
> +		if (vlr.state == LR_STATE_ACTIVE)
>  			continue;
>  
> -		vlr = vgic_get_lr(vcpu, lr);
> +		if (vlr.state & LR_STATE_PENDING)
> +			vgic_dist_irq_set_pending(vcpu, vlr.irq);
>  
> -		BUG_ON(vlr.irq >= dist->nr_irqs);
> -		vgic_cpu->vgic_irq_lr_map[vlr.irq] = LR_EMPTY;
> +		/* Mark this LR as empty now. */
> +		vlr.state = 0;
> +		vgic_set_lr(vcpu, lr_nr, vlr);
> +		vgic_sync_lr_elrsr(vcpu, lr_nr, vlr);
>  	}
> +	vgic_update_state(vcpu->kvm);
>  
> -	/* Check if we still have something up our sleeve... */
> -	pending = find_first_zero_bit(elrsr_ptr, vgic->nr_lr);
> -	if (level_pending || pending < vgic->nr_lr)
> +	/* vgic_update_state would not cover only-active IRQs */
> +	if (pending)
>  		set_bit(vcpu->vcpu_id, dist->irq_pending_on_cpu);
>  }
>  
> @@ -1590,11 +1581,9 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
>  	kfree(vgic_cpu->pending_shared);
>  	kfree(vgic_cpu->active_shared);
>  	kfree(vgic_cpu->pend_act_shared);
> -	kfree(vgic_cpu->vgic_irq_lr_map);
>  	vgic_cpu->pending_shared = NULL;
>  	vgic_cpu->active_shared = NULL;
>  	vgic_cpu->pend_act_shared = NULL;
> -	vgic_cpu->vgic_irq_lr_map = NULL;
>  }
>  
>  static int vgic_vcpu_init_maps(struct kvm_vcpu *vcpu, int nr_irqs)
> @@ -1605,18 +1594,14 @@ static int vgic_vcpu_init_maps(struct kvm_vcpu *vcpu, int nr_irqs)
>  	vgic_cpu->pending_shared = kzalloc(sz, GFP_KERNEL);
>  	vgic_cpu->active_shared = kzalloc(sz, GFP_KERNEL);
>  	vgic_cpu->pend_act_shared = kzalloc(sz, GFP_KERNEL);
> -	vgic_cpu->vgic_irq_lr_map = kmalloc(nr_irqs, GFP_KERNEL);
>  
>  	if (!vgic_cpu->pending_shared
>  		|| !vgic_cpu->active_shared
> -		|| !vgic_cpu->pend_act_shared
> -		|| !vgic_cpu->vgic_irq_lr_map) {
> +		|| !vgic_cpu->pend_act_shared) {
>  		kvm_vgic_vcpu_destroy(vcpu);
>  		return -ENOMEM;
>  	}
>  
> -	memset(vgic_cpu->vgic_irq_lr_map, LR_EMPTY, nr_irqs);
> -
>  	/*
>  	 * Store the number of LRs per vcpu, so we don't have to go
>  	 * all the way to the distributor structure to find out. Only
> 

