From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 09/13] KVM: arm64: handle pending bit for LPIs in ITS
 emulation
Date: Tue, 09 Jun 2015 17:59:06 +0200
Message-ID: <55770D4A.9090801@linaro.org>
References: <1432893209-27313-1-git-send-email-andre.przywara@arm.com> <1432893209-27313-10-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1432893209-27313-10-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 05/29/2015 11:53 AM, Andre Przywara wrote:
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
>  virt/kvm/arm/its-emul.c     | 66 +++++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/its-emul.h     |  3 ++
>  virt/kvm/arm/vgic-v3-emul.c |  2 ++
>  virt/kvm/arm/vgic.c         | 68 +++++++++++++++++++++++++++++++++------------
>  5 files changed, 124 insertions(+), 17 deletions(-)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index fa17df6..de19c34 100644
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
> index f0f4a9c..f75fb9e 100644
> --- a/virt/kvm/arm/its-emul.c
> +++ b/virt/kvm/arm/its-emul.c
> @@ -50,8 +50,26 @@ struct its_itte {
>  	struct its_collection *collection;
>  	u32 lpi;
>  	u32 event_id;
> +	bool enabled;
> +	unsigned long *pending;
allocated in later patch. does not ease the review of the life cycle but
I guess it is accepted/acceptable.

Isn't it somehow redundant to have a bitmap here where the collection
already indicates the target cpu id on which the LPI is pending?

Eric
>  };
>  
> +#define for_each_lpi(dev, itte, kvm) \
> +	list_for_each_entry(dev, &(kvm)->arch.vgic.its.device_list, dev_list) \
> +		list_for_each_entry(itte, &(dev)->itt, itte_list)
> +
> +static struct its_itte *find_itte_by_lpi(struct kvm *kvm, int lpi)
> +{
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
>  /* distributor lock is hold by the VGIC MMIO handler */
> @@ -145,6 +163,54 @@ static bool handle_mmio_gits_idregs(struct kvm_vcpu *vcpu,
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
> +		clear_bit(vcpu->vcpu_id, itte->pending);
> +
> +		ret &= vgic_queue_irq(vcpu, 0, itte->lpi);
> +	}
> +
> +	spin_unlock(&its->lock);
> +	return ret;
> +}
> +
> +/* is called with the distributor lock held by the caller */
> +void vits_unqueue_lpi(struct kvm_vcpu *vcpu, int lpi)
> +{
> +	struct vgic_its *its = &vcpu->kvm->arch.vgic.its;
> +	struct its_itte *itte;
> +
> +	spin_lock(&its->lock);
> +
> +	/* Find the right ITTE and put the pending state back in there */
> +	itte = find_itte_by_lpi(vcpu->kvm, lpi);
> +	if (itte)
> +		set_bit(vcpu->vcpu_id, itte->pending);
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
> index fa81c4b..66640c2fa 100644
> --- a/virt/kvm/arm/vgic-v3-emul.c
> +++ b/virt/kvm/arm/vgic-v3-emul.c
> @@ -901,6 +901,8 @@ void vgic_v3_init_emulation(struct kvm *kvm)
>  	dist->vm_ops.init_model = vgic_v3_init_model;
>  	dist->vm_ops.destroy_model = vgic_v3_destroy_model;
>  	dist->vm_ops.map_resources = vgic_v3_map_resources;
> +	dist->vm_ops.queue_lpis = vits_queue_lpis;
> +	dist->vm_ops.unqueue_lpi = vits_unqueue_lpi;
>  
>  	kvm->arch.max_vcpus = KVM_MAX_VCPUS;
>  }
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 0a9236d..9f7b05f 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -97,6 +97,20 @@ static bool queue_sgi(struct kvm_vcpu *vcpu, int irq)
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
> @@ -1149,25 +1163,33 @@ static void vgic_retire_disabled_irqs(struct kvm_vcpu *vcpu)
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
> @@ -1179,7 +1201,6 @@ static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
>   */
>  bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_source_id, int irq)
>  {
> -	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>  	u64 elrsr = vgic_get_elrsr(vcpu);
>  	unsigned long *elrsr_ptr = u64_to_bitmask(&elrsr);
>  	int lr;
> @@ -1187,7 +1208,6 @@ bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_source_id, int irq)
>  	/* Sanitize the input... */
>  	BUG_ON(sgi_source_id & ~7);
>  	BUG_ON(sgi_source_id && irq >= VGIC_NR_SGIS);
> -	BUG_ON(irq >= dist->nr_irqs);
>  
>  	kvm_debug("Queue IRQ%d\n", irq);
>  
> @@ -1267,8 +1287,12 @@ static void __kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
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
> @@ -1389,6 +1413,16 @@ static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
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
> +		}
> +
>  		BUG_ON(!(vlr.state & LR_STATE_MASK));
>  		pending = true;
>  
> @@ -1413,7 +1447,7 @@ static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
>  	}
>  	vgic_update_state(vcpu->kvm);
>  
> -	/* vgic_update_state would not cover only-active IRQs */
> +	/* vgic_update_state would not cover only-active IRQs or LPIs */
>  	if (pending)
>  		set_bit(vcpu->vcpu_id, dist->irq_pending_on_cpu);
>  }
> 

