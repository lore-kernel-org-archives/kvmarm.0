From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v2 11/15] KVM: arm64: handle pending bit for LPIs in ITS
 emulation
Date: Fri, 14 Aug 2015 13:58:37 +0200
Message-ID: <55CDD7ED.90008@linaro.org>
References: <1436538111-4294-1-git-send-email-andre.przywara@arm.com> <1436538111-4294-12-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1436538111-4294-12-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, marc.zyngier@arm.com, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu
Cc: Pavel Fedin <p.fedin@samsung.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 07/10/2015 04:21 PM, Andre Przywara wrote:
> As the actual LPI number in a guest can be quite high, but is mostly
> assigned using a very sparse allocation scheme, bitmaps and arrays
> for storing the virtual interrupt status are a waste of memory.
> We use our equivalent of the "Interrupt Translation Table Entry"
> (ITTE) to hold this extra status information for a virtual LPI.
> As the normal VGIC code cannot use it's fancy bitmaps to manage
> pending interrupts, we provide a hook in the VGIC code to let the
> ITS emulation handle the list register queueing itself.
> LPIs are located in a separate number range (>=8192), so
> distinguishing them is easy. With LPIs being only edge-triggered, we
> get away with a less complex IRQ handling.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/kvm/arm_vgic.h      |  2 ++
>  virt/kvm/arm/its-emul.c     | 71 ++++++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/its-emul.h     |  3 ++
>  virt/kvm/arm/vgic-v3-emul.c |  2 ++
>  virt/kvm/arm/vgic.c         | 72 ++++++++++++++++++++++++++++++++++-----------
>  5 files changed, 133 insertions(+), 17 deletions(-)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 1648668..2a67a10 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -147,6 +147,8 @@ struct vgic_vm_ops {
>  	int	(*init_model)(struct kvm *);
>  	void	(*destroy_model)(struct kvm *);
>  	int	(*map_resources)(struct kvm *, const struct vgic_params *);
> +	bool	(*queue_lpis)(struct kvm_vcpu *);
> +	void	(*unqueue_lpi)(struct kvm_vcpu *, int irq);
>  };
>  
>  struct vgic_io_device {
> diff --git a/virt/kvm/arm/its-emul.c b/virt/kvm/arm/its-emul.c
> index 7f217fa..b9c40d7 100644
> --- a/virt/kvm/arm/its-emul.c
> +++ b/virt/kvm/arm/its-emul.c
> @@ -50,8 +50,26 @@ struct its_itte {
>  	struct its_collection *collection;
>  	u32 lpi;
>  	u32 event_id;
> +	bool enabled;
> +	unsigned long *pending;
>  };
>  
> +#define for_each_lpi(dev, itte, kvm) \
> +	list_for_each_entry(dev, &(kvm)->arch.vgic.its.device_list, dev_list) \
> +		list_for_each_entry(itte, &(dev)->itt, itte_list)
> +
You have a checkpatch error here:

ERROR: Macros with complex values should be enclosed in parentheses
#52: FILE: virt/kvm/arm/its-emul.c:57:
+#define for_each_lpi(dev, itte, kvm) \
+	list_for_each_entry(dev, &(kvm)->arch.vgic.its.device_list, dev_list) \
+		list_for_each_entry(itte, &(dev)->itt, itte_list)

> +static struct its_itte *find_itte_by_lpi(struct kvm *kvm, int lpi)
> +{
can't we have the same LPI present in different interrupt translation
tables? I don't know it is a sensible setting but I did not succeed in
finding it was not possible.
> +	struct its_device *device;
> +	struct its_itte *itte;
> +
> +	for_each_lpi(device, itte, kvm) {
> +		if (itte->lpi == lpi)
> +			return itte;
> +	}
> +	return NULL;
> +}
> +
>  #define BASER_BASE_ADDRESS(x) ((x) & 0xfffffffff000ULL)
>  
>  /* The distributor lock is held by the VGIC MMIO handler. */
> @@ -145,6 +163,59 @@ static bool handle_mmio_gits_idregs(struct kvm_vcpu *vcpu,
>  	return false;
>  }
>  
> +/*
> + * Find all enabled and pending LPIs and queue them into the list
> + * registers.
> + * The dist lock is held by the caller.
> + */
> +bool vits_queue_lpis(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_its *its = &vcpu->kvm->arch.vgic.its;
> +	struct its_device *device;
> +	struct its_itte *itte;
> +	bool ret = true;
> +
> +	if (!vgic_has_its(vcpu->kvm))
> +		return true;
> +	if (!its->enabled || !vcpu->kvm->arch.vgic.lpis_enabled)
> +		return true;
> +
> +	spin_lock(&its->lock);
> +	for_each_lpi(device, itte, vcpu->kvm) {
> +		if (!itte->enabled || !test_bit(vcpu->vcpu_id, itte->pending))
> +			continue;
> +
> +		if (!itte->collection)
> +			continue;
> +
> +		if (itte->collection->target_addr != vcpu->vcpu_id)
> +			continue;
> +
> +		__clear_bit(vcpu->vcpu_id, itte->pending);
> +
> +		ret &= vgic_queue_irq(vcpu, 0, itte->lpi);
what if the vgic_queue_irq fails since no LR can be found, the
itte->pending was cleared so we forget that LPI? shouldn't we restore
the pending state in ITT? in vgic_queue_hwirq the state change only is
performed if the vgic_queue_irq succeeds
> +	}
> +
> +	spin_unlock(&its->lock);
> +	return ret;
> +}
> +
> +/* Called with the distributor lock held by the caller. */
> +void vits_unqueue_lpi(struct kvm_vcpu *vcpu, int lpi)
I was a bit confused by the name of the function, with regard to
existing vgic_unqueue_irqs which restores the states in accordance to
what we have in LR. Wouldn't it make sense to call it
vits_lpi_set_pending(vcpu, lpi) or something that looks more similar to
vgic_dist_irq_set_pending setter which I think it mirrors.

> +{
> +	struct vgic_its *its = &vcpu->kvm->arch.vgic.its;
> +	struct its_itte *itte;
> +
> +	spin_lock(&its->lock);
> +
> +	/* Find the right ITTE and put the pending state back in there */
> +	itte = find_itte_by_lpi(vcpu->kvm, lpi);
> +	if (itte)
> +		__set_bit(vcpu->vcpu_id, itte->pending);
> +
> +	spin_unlock(&its->lock);
> +}
> +
>  static int vits_handle_command(struct kvm_vcpu *vcpu, u64 *its_cmd)
>  {
>  	return -ENODEV;
> diff --git a/virt/kvm/arm/its-emul.h b/virt/kvm/arm/its-emul.h
> index 472a6d0..cc5d5ff 100644
> --- a/virt/kvm/arm/its-emul.h
> +++ b/virt/kvm/arm/its-emul.h
> @@ -33,4 +33,7 @@ void vgic_enable_lpis(struct kvm_vcpu *vcpu);
>  int vits_init(struct kvm *kvm);
>  void vits_destroy(struct kvm *kvm);
>  
> +bool vits_queue_lpis(struct kvm_vcpu *vcpu);
> +void vits_unqueue_lpi(struct kvm_vcpu *vcpu, int irq);
> +
>  #endif
> diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
> index 49be3c3..4132c26 100644
> --- a/virt/kvm/arm/vgic-v3-emul.c
> +++ b/virt/kvm/arm/vgic-v3-emul.c
> @@ -948,6 +948,8 @@ void vgic_v3_init_emulation(struct kvm *kvm)
>  	dist->vm_ops.init_model = vgic_v3_init_model;
>  	dist->vm_ops.destroy_model = vgic_v3_destroy_model;
>  	dist->vm_ops.map_resources = vgic_v3_map_resources;
> +	dist->vm_ops.queue_lpis = vits_queue_lpis;
> +	dist->vm_ops.unqueue_lpi = vits_unqueue_lpi;
>  
>  	dist->vgic_dist_base = VGIC_ADDR_UNDEF;
>  	dist->vgic_redist_base = VGIC_ADDR_UNDEF;
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 49ee92b..9dfd094 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -95,6 +95,20 @@ static bool queue_sgi(struct kvm_vcpu *vcpu, int irq)
>  	return vcpu->kvm->arch.vgic.vm_ops.queue_sgi(vcpu, irq);
>  }
>  
> +static bool vgic_queue_lpis(struct kvm_vcpu *vcpu)
> +{
> +	if (vcpu->kvm->arch.vgic.vm_ops.queue_lpis)
> +		return vcpu->kvm->arch.vgic.vm_ops.queue_lpis(vcpu);
> +	else
> +		return true;
> +}
> +
> +static void vgic_unqueue_lpi(struct kvm_vcpu *vcpu, int irq)
> +{
> +	if (vcpu->kvm->arch.vgic.vm_ops.unqueue_lpi)
> +		vcpu->kvm->arch.vgic.vm_ops.unqueue_lpi(vcpu, irq);
> +}
> +
>  int kvm_vgic_map_resources(struct kvm *kvm)
>  {
>  	return kvm->arch.vgic.vm_ops.map_resources(kvm, vgic);
> @@ -1135,6 +1149,10 @@ static void vgic_retire_disabled_irqs(struct kvm_vcpu *vcpu)
>  	for_each_clear_bit(lr, elrsr_ptr, vgic->nr_lr) {
>  		vlr = vgic_get_lr(vcpu, lr);
>  
> +		/* We don't care about LPIs here */
> +		if (vlr.irq >= 8192)
> +			continue;
> +
>  		if (!vgic_irq_is_enabled(vcpu, vlr.irq)) {
>  			vlr.state = 0;
>  			vgic_set_lr(vcpu, lr, vlr);
> @@ -1147,25 +1165,33 @@ static void vgic_retire_disabled_irqs(struct kvm_vcpu *vcpu)
>  static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
>  				 int lr_nr, int sgi_source_id)
>  {
> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>  	struct vgic_lr vlr;
>  
>  	vlr.state = 0;
>  	vlr.irq = irq;
>  	vlr.source = sgi_source_id;
>  
> -	if (vgic_irq_is_active(vcpu, irq)) {
> -		vlr.state |= LR_STATE_ACTIVE;
> -		kvm_debug("Set active, clear distributor: 0x%x\n", vlr.state);
> -		vgic_irq_clear_active(vcpu, irq);
> -		vgic_update_state(vcpu->kvm);
> -	} else if (vgic_dist_irq_is_pending(vcpu, irq)) {
> -		vlr.state |= LR_STATE_PENDING;
> -		kvm_debug("Set pending: 0x%x\n", vlr.state);
> -	}
> -
> -	if (!vgic_irq_is_edge(vcpu, irq))
> -		vlr.state |= LR_EOI_INT;
> +	/* We care only about state for SGIs/PPIs/SPIs, not for LPIs */
> +	if (irq < dist->nr_irqs) {
> +		if (vgic_irq_is_active(vcpu, irq)) {
> +			vlr.state |= LR_STATE_ACTIVE;
> +			kvm_debug("Set active, clear distributor: 0x%x\n",
> +				  vlr.state);
> +			vgic_irq_clear_active(vcpu, irq);
> +			vgic_update_state(vcpu->kvm);
> +		} else if (vgic_dist_irq_is_pending(vcpu, irq)) {
> +			vlr.state |= LR_STATE_PENDING;
> +			kvm_debug("Set pending: 0x%x\n", vlr.state);
> +		}
>  
> +		if (!vgic_irq_is_edge(vcpu, irq))
> +			vlr.state |= LR_EOI_INT;
> +	} else {
> +		/* If this is an LPI, it can only be pending */
> +		if (irq >= 8192)
> +			vlr.state |= LR_STATE_PENDING;
> +	}
>  	vgic_set_lr(vcpu, lr_nr, vlr);
>  	vgic_sync_lr_elrsr(vcpu, lr_nr, vlr);
>  }
> @@ -1177,7 +1203,6 @@ static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
>   */
>  bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_source_id, int irq)
>  {
> -	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>  	u64 elrsr = vgic_get_elrsr(vcpu);
>  	unsigned long *elrsr_ptr = u64_to_bitmask(&elrsr);
>  	int lr;
> @@ -1185,7 +1210,6 @@ bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_source_id, int irq)
>  	/* Sanitize the input... */
>  	BUG_ON(sgi_source_id & ~7);
>  	BUG_ON(sgi_source_id && irq >= VGIC_NR_SGIS);
> -	BUG_ON(irq >= dist->nr_irqs);
Is it safe to remove that check. What if it is attempted to inject an
SPI larger than supported. I think you should refine the check but not
remove it.
>  
>  	kvm_debug("Queue IRQ%d\n", irq);
>  
> @@ -1265,8 +1289,12 @@ static void __kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
>  			overflow = 1;
>  	}
>  
> -
> -
> +	/*
> +	 * LPIs are not mapped in our bitmaps, so we leave the iteration
> +	 * to the ITS emulation code.
> +	 */
> +	if (!vgic_queue_lpis(vcpu))
> +		overflow = 1;
>  
>  epilog:
>  	if (overflow) {
> @@ -1387,6 +1415,16 @@ static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
>  	for_each_clear_bit(lr_nr, elrsr_ptr, vgic_cpu->nr_lr) {
>  		vlr = vgic_get_lr(vcpu, lr_nr);
>  
> +		/* LPIs are handled separately */
> +		if (vlr.irq >= 8192) {
> +			/* We just need to take care about still pending LPIs */
> +			if (vlr.state & LR_STATE_PENDING) {
> +				vgic_unqueue_lpi(vcpu, vlr.irq);
> +				pending = true;
> +			}
> +			continue;
don't we need to reset the LR & update elrsr?
> +		}
> +
>  		BUG_ON(!(vlr.state & LR_STATE_MASK));
>  		pending = true;
>  
> @@ -1411,7 +1449,7 @@ static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
>  	}
>  	vgic_update_state(vcpu->kvm);
>  
> -	/* vgic_update_state would not cover only-active IRQs */
> +	/* vgic_update_state would not cover only-active IRQs or LPIs */
>  	if (pending)
>  		set_bit(vcpu->vcpu_id, dist->irq_pending_on_cpu);
>  }
> 

