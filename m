From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 1/2] KVM: arm/arm64: Optimize away redundant LR tracking
Date: Thu, 22 Oct 2015 23:42:59 +0200
Message-ID: <20151022214259.GC25602@cbox>
References: <cover.1443796321.git.p.fedin@samsung.com>
 <34d659eff6cda85488561ccd2382b82377b44784.1443796321.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <34d659eff6cda85488561ccd2382b82377b44784.1443796321.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 02, 2015 at 05:44:28PM +0300, Pavel Fedin wrote:
> Currently we use vgic_irq_lr_map in order to track which LRs hold which
> IRQs, and lr_used bitmap in order to track which LRs are used or free.
> 
> vgic_irq_lr_map is actually used only for piggy-back optimization, and
> can be easily replaced by iteration over lr_used. This is good because in
> future, when LPI support is introduced, number of IRQs will grow up to at
> least 16384, while numbers from 1024 to 8192 are never going to be used.
> This would be a huge memory waste.
> 
> In its turn, lr_used is also completely redundant since
> ae705930fca6322600690df9dc1c7d0516145a93 ("arm/arm64: KVM: Keep elrsr/aisr
> in sync with software model"), because together with lr_used we also update
> elrsr. This allows to easily replace lr_used with elrsr, inverting all
> conditions (because in elrsr '1' means 'free').
> 
> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> ---
>  include/kvm/arm_vgic.h |  6 ----
>  virt/kvm/arm/vgic.c    | 74 +++++++++++++++++++-------------------------------
>  2 files changed, 28 insertions(+), 52 deletions(-)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 4e14dac..d908028 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -296,9 +296,6 @@ struct vgic_v3_cpu_if {
>  };
>  
>  struct vgic_cpu {
> -	/* per IRQ to LR mapping */
> -	u8		*vgic_irq_lr_map;
> -
>  	/* Pending/active/both interrupts on this VCPU */
>  	DECLARE_BITMAP(	pending_percpu, VGIC_NR_PRIVATE_IRQS);
>  	DECLARE_BITMAP(	active_percpu, VGIC_NR_PRIVATE_IRQS);
> @@ -309,9 +306,6 @@ struct vgic_cpu {
>  	unsigned long   *active_shared;
>  	unsigned long   *pend_act_shared;
>  
> -	/* Bitmap of used/free list registers */
> -	DECLARE_BITMAP(	lr_used, VGIC_V2_MAX_LRS);
> -
>  	/* Number of list registers on this CPU */
>  	int		nr_lr;
>  
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 6bd1c9b..2f4d25a 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -102,9 +102,10 @@
>  #include "vgic.h"
>  
>  static void vgic_retire_disabled_irqs(struct kvm_vcpu *vcpu);
> -static void vgic_retire_lr(int lr_nr, int irq, struct kvm_vcpu *vcpu);
> +static void vgic_retire_lr(int lr_nr, struct kvm_vcpu *vcpu);
>  static struct vgic_lr vgic_get_lr(const struct kvm_vcpu *vcpu, int lr);
>  static void vgic_set_lr(struct kvm_vcpu *vcpu, int lr, struct vgic_lr lr_desc);
> +static u64 vgic_get_elrsr(struct kvm_vcpu *vcpu);
>  static struct irq_phys_map *vgic_irq_map_search(struct kvm_vcpu *vcpu,
>  						int virt_irq);
>  
> @@ -683,9 +684,11 @@ bool vgic_handle_cfg_reg(u32 *reg, struct kvm_exit_mmio *mmio,
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
> @@ -728,7 +731,7 @@ void vgic_unqueue_irqs(struct kvm_vcpu *vcpu)
>  		 * Mark the LR as free for other use.
>  		 */
>  		BUG_ON(lr.state & LR_STATE_MASK);
> -		vgic_retire_lr(i, lr.irq, vcpu);
> +		vgic_retire_lr(i, vcpu);
>  		vgic_irq_clear_queued(vcpu, lr.irq);
>  
>  		/* Finally update the VGIC state. */
> @@ -1087,15 +1090,12 @@ static inline void vgic_enable(struct kvm_vcpu *vcpu)
>  	vgic_ops->enable(vcpu);
>  }
>  
> -static void vgic_retire_lr(int lr_nr, int irq, struct kvm_vcpu *vcpu)
> +static void vgic_retire_lr(int lr_nr, struct kvm_vcpu *vcpu)
>  {
> -	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>  	struct vgic_lr vlr = vgic_get_lr(vcpu, lr_nr);
>  
>  	vlr.state = 0;
>  	vgic_set_lr(vcpu, lr_nr, vlr);
> -	clear_bit(lr_nr, vgic_cpu->lr_used);
> -	vgic_cpu->vgic_irq_lr_map[irq] = LR_EMPTY;
>  	vgic_sync_lr_elrsr(vcpu, lr_nr, vlr);
>  }
>  
> @@ -1110,14 +1110,15 @@ static void vgic_retire_lr(int lr_nr, int irq, struct kvm_vcpu *vcpu)
>   */
>  static void vgic_retire_disabled_irqs(struct kvm_vcpu *vcpu)
>  {
> -	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> +	u64 elrsr = vgic_get_elrsr(vcpu);
> +	unsigned long *elrsr_ptr = u64_to_bitmask(&elrsr);
>  	int lr;
>  
> -	for_each_set_bit(lr, vgic_cpu->lr_used, vgic->nr_lr) {
> +	for_each_clear_bit(lr, elrsr_ptr, vgic->nr_lr) {
>  		struct vgic_lr vlr = vgic_get_lr(vcpu, lr);
>  
>  		if (!vgic_irq_is_enabled(vcpu, vlr.irq)) {
> -			vgic_retire_lr(lr, vlr.irq, vcpu);
> +			vgic_retire_lr(lr, vcpu);
>  			if (vgic_irq_is_queued(vcpu, vlr.irq))
>  				vgic_irq_clear_queued(vcpu, vlr.irq);
>  		}
> @@ -1169,8 +1170,9 @@ static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
>   */
>  bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_source_id, int irq)
>  {
> -	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>  	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> +	u64 elrsr = vgic_get_elrsr(vcpu);
> +	unsigned long *elrsr_ptr = u64_to_bitmask(&elrsr);
>  	struct vgic_lr vlr;
>  	int lr;
>  
> @@ -1181,28 +1183,22 @@ bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_source_id, int irq)
>  
>  	kvm_debug("Queue IRQ%d\n", irq);
>  
> -	lr = vgic_cpu->vgic_irq_lr_map[irq];
> -
>  	/* Do we have an active interrupt for the same CPUID? */
> -	if (lr != LR_EMPTY) {
> +	for_each_clear_bit(lr, elrsr_ptr, vgic->nr_lr) {
>  		vlr = vgic_get_lr(vcpu, lr);
> -		if (vlr.source == sgi_source_id) {
> +		if (vlr.irq == irq && vlr.source == sgi_source_id) {
>  			kvm_debug("LR%d piggyback for IRQ%d\n", lr, vlr.irq);
> -			BUG_ON(!test_bit(lr, vgic_cpu->lr_used));
>  			vgic_queue_irq_to_lr(vcpu, irq, lr, vlr);
>  			return true;
>  		}
>  	}
>  
>  	/* Try to use another LR for this interrupt */
> -	lr = find_first_zero_bit((unsigned long *)vgic_cpu->lr_used,
> -			       vgic->nr_lr);
> +	lr = find_first_bit(elrsr_ptr, vgic->nr_lr);
>  	if (lr >= vgic->nr_lr)
>  		return false;
>  
>  	kvm_debug("LR%d allocated for IRQ%d %x\n", lr, irq, sgi_source_id);
> -	vgic_cpu->vgic_irq_lr_map[irq] = lr;
> -	set_bit(lr, vgic_cpu->lr_used);
>  
>  	vlr.irq = irq;
>  	vlr.source = sgi_source_id;
> @@ -1243,6 +1239,8 @@ static void __kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
>  	int i, vcpu_id, lr, ret;
>  	int overflow = 0;
>  	int nr_shared = vgic_nr_shared_irqs(dist);
> +	u64 elrsr;
> +	unsigned long *elrsr_ptr;
>  
>  	vcpu_id = vcpu->vcpu_id;
>  
> @@ -1296,13 +1294,11 @@ epilog:
>  		clear_bit(vcpu_id, dist->irq_pending_on_cpu);
>  	}
>  
> -	for (lr = 0; lr < vgic->nr_lr; lr++) {
> -		struct vgic_lr vlr;
> -
> -		if (!test_bit(lr, vgic_cpu->lr_used))
> -			continue;
> +	elrsr = vgic_get_elrsr(vcpu);
> +	elrsr_ptr = u64_to_bitmask(&elrsr);
>  
> -		vlr = vgic_get_lr(vcpu, lr);
> +	for_each_clear_bit(lr, elrsr_ptr, vgic->nr_lr) {
> +		struct vgic_lr vlr = vgic_get_lr(vcpu, lr);
>  
>  		/*
>  		 * If we have a mapping, and the virtual interrupt is
> @@ -1443,7 +1439,6 @@ static int vgic_sync_hwirq(struct kvm_vcpu *vcpu, struct vgic_lr vlr)
>  /* Sync back the VGIC state after a guest run */
>  static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
>  {
> -	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>  	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>  	u64 elrsr;
>  	unsigned long *elrsr_ptr;
> @@ -1456,12 +1451,8 @@ static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
>  
>  	/* Deal with HW interrupts, and clear mappings for empty LRs */
>  	for (lr = 0; lr < vgic->nr_lr; lr++) {
> -		struct vgic_lr vlr;
> -
> -		if (!test_bit(lr, vgic_cpu->lr_used))
> -			continue;

Is there not at least a theoretical change in functionality here?

After this patch, we would consider all LRs, not just those we knew were
set when we entered the VM.

Do we have a guarantee that anything we consider in vgic_sync_hwirq at
this point have had lr_used set?

Thanks,
-Christoffer
