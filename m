From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 2/5] arm/arm64: KVM: Implement support for unqueueing
 active IRQs
Date: Mon, 9 Mar 2015 15:41:48 +0100
Message-ID: <20150309144148.GD20559@cbox>
References: <1425302944-6276-1-git-send-email-alex.bennee@linaro.org>
 <1425302944-6276-3-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1425302944-6276-3-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 02, 2015 at 01:29:01PM +0000, Alex Benn=E9e wrote:
> From: Christoffer Dall <christoffer.dall@linaro.org>
>=20
> Migrating active interrupts causes the active state to be lost
> completely. This implements some additional bitmaps to track the acti=
ve
> state on the distributor and export this to user space.
>=20
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
>=20
> ---
> AJB:
>    - fixed merge conflicts
>    - moved additional shared bitmaps to be dynamically allocated
>    - make irq_active_on_cpu dynamically allocated as well
>    - in vgic_queue_irq don't queue pending if already active
>    - in __kvm_vgic_flush_hwstate use pr_shared when checking SPIs
>    - vgic: clear active on CPU bit
>    - checkpatch, remove extraneous braces
>    - checkpatch, remove debug, fix overflows
>    - move register access fns to re-factored vgic-v2-emul.c
> v2
>    - doc: unqueue and update_state
>=20
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 7c55dd5..7042251 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -196,6 +196,9 @@ struct vgic_dist {
>  	/* Level-triggered interrupt queued on VCPU interface */
>  	struct vgic_bitmap	irq_queued;
> =20
> +	/* Interrupt was active when unqueue from VCPU interface */
> +	struct vgic_bitmap	irq_active;
> +
>  	/* Interrupt priority. Not used yet. */
>  	struct vgic_bytemap	irq_priority;
> =20
> @@ -236,6 +239,9 @@ struct vgic_dist {
>  	/* Bitmap indicating which CPU has something pending */
>  	unsigned long		*irq_pending_on_cpu;
> =20
> +	/* Bitmap indicating which CPU has active IRQs */
> +	unsigned long		*irq_active_on_cpu;
> +
>  	struct vgic_vm_ops	vm_ops;
>  #endif
>  };
> @@ -269,9 +275,15 @@ struct vgic_cpu {
>  	/* per IRQ to LR mapping */
>  	u8		*vgic_irq_lr_map;
> =20
> -	/* Pending interrupts on this VCPU */
> +	/* Pending/active/both interrupts on this VCPU */
>  	DECLARE_BITMAP(	pending_percpu, VGIC_NR_PRIVATE_IRQS);
> +	DECLARE_BITMAP(	active_percpu, VGIC_NR_PRIVATE_IRQS);
> +	DECLARE_BITMAP(	pend_act_percpu, VGIC_NR_PRIVATE_IRQS);
> +
> +	/* Pending/active/both shared interrupts, dynamically sized */
>  	unsigned long	*pending_shared;
> +	unsigned long   *active_shared;
> +	unsigned long   *pend_act_shared;
> =20
>  	/* Bitmap of used/free list registers */
>  	DECLARE_BITMAP(	lr_used, VGIC_V2_MAX_LRS);
> @@ -311,6 +323,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpui=
d, unsigned int irq_num,
>  			bool level);
>  void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
>  int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
> +int kvm_vgic_vcpu_active_irq(struct kvm_vcpu *vcpu);
>  bool vgic_handle_mmio(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  		      struct kvm_exit_mmio *mmio);
> =20
> diff --git a/virt/kvm/arm/vgic-v2-emul.c b/virt/kvm/arm/vgic-v2-emul.=
c
> index 19c6210..c818662 100644
> --- a/virt/kvm/arm/vgic-v2-emul.c
> +++ b/virt/kvm/arm/vgic-v2-emul.c
> @@ -107,6 +107,22 @@ static bool handle_mmio_clear_pending_reg(struct=
 kvm_vcpu *vcpu,
>  					     vcpu->vcpu_id);
>  }
> =20
> +static bool handle_mmio_set_active_reg(struct kvm_vcpu *vcpu,
> +				       struct kvm_exit_mmio *mmio,
> +				       phys_addr_t offset)
> +{
> +	return vgic_handle_set_active_reg(vcpu->kvm, mmio, offset,
> +					  vcpu->vcpu_id);
> +}
> +
> +static bool handle_mmio_clear_active_reg(struct kvm_vcpu *vcpu,
> +					 struct kvm_exit_mmio *mmio,
> +					 phys_addr_t offset)
> +{
> +	return vgic_handle_clear_active_reg(vcpu->kvm, mmio, offset,
> +					    vcpu->vcpu_id);
> +}
> +
>  static bool handle_mmio_priority_reg(struct kvm_vcpu *vcpu,
>  				     struct kvm_exit_mmio *mmio,
>  				     phys_addr_t offset)
> @@ -344,13 +360,13 @@ static const struct kvm_mmio_range vgic_dist_ra=
nges[] =3D {
>  		.base		=3D GIC_DIST_ACTIVE_SET,
>  		.len		=3D VGIC_MAX_IRQS / 8,
>  		.bits_per_irq	=3D 1,
> -		.handle_mmio	=3D handle_mmio_raz_wi,
> +		.handle_mmio	=3D handle_mmio_set_active_reg,
>  	},
>  	{
>  		.base		=3D GIC_DIST_ACTIVE_CLEAR,
>  		.len		=3D VGIC_MAX_IRQS / 8,
>  		.bits_per_irq	=3D 1,
> -		.handle_mmio	=3D handle_mmio_raz_wi,
> +		.handle_mmio	=3D handle_mmio_clear_active_reg,
>  	},
>  	{
>  		.base		=3D GIC_DIST_PRI,
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 0cc6ab6..bfb6fbb 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -277,6 +277,14 @@ static void vgic_irq_clear_queued(struct kvm_vcp=
u *vcpu, int irq)
>  	vgic_bitmap_set_irq_val(&dist->irq_queued, vcpu->vcpu_id, irq, 0);
>  }
> =20
> +
> +static void vgic_irq_set_active(struct kvm_vcpu *vcpu, int irq)
> +{
> +	struct vgic_dist *dist =3D &vcpu->kvm->arch.vgic;
> +
> +	vgic_bitmap_set_irq_val(&dist->irq_active, vcpu->vcpu_id, irq, 1);
> +}
> +
>  static int vgic_dist_irq_get_level(struct kvm_vcpu *vcpu, int irq)
>  {
>  	struct vgic_dist *dist =3D &vcpu->kvm->arch.vgic;
> @@ -520,6 +528,44 @@ bool vgic_handle_clear_pending_reg(struct kvm *k=
vm,
>  	return false;
>  }
> =20
> +bool vgic_handle_set_active_reg(struct kvm *kvm,
> +				struct kvm_exit_mmio *mmio,
> +				phys_addr_t offset, int vcpu_id)
> +{
> +	u32 *reg;
> +	struct vgic_dist *dist =3D &kvm->arch.vgic;
> +
> +	reg =3D vgic_bitmap_get_reg(&dist->irq_active, vcpu_id, offset);
> +	vgic_reg_access(mmio, reg, offset,
> +			ACCESS_READ_VALUE | ACCESS_WRITE_SETBIT);
> +
> +	if (mmio->is_write) {
> +		vgic_update_state(kvm);
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +bool vgic_handle_clear_active_reg(struct kvm *kvm,
> +				  struct kvm_exit_mmio *mmio,
> +				  phys_addr_t offset, int vcpu_id)
> +{
> +	u32 *reg;
> +	struct vgic_dist *dist =3D &kvm->arch.vgic;
> +
> +	reg =3D vgic_bitmap_get_reg(&dist->irq_active, vcpu_id, offset);
> +	vgic_reg_access(mmio, reg, offset,
> +			ACCESS_READ_VALUE | ACCESS_WRITE_CLEARBIT);
> +
> +	if (mmio->is_write) {
> +		vgic_update_state(kvm);
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
>  static u32 vgic_cfg_expand(u16 val)
>  {
>  	u32 res =3D 0;
> @@ -588,16 +634,12 @@ bool vgic_handle_cfg_reg(u32 *reg, struct kvm_e=
xit_mmio *mmio,
>  }
> =20
>  /**
> - * vgic_unqueue_irqs - move pending IRQs from LRs to the distributor
> + * vgic_unqueue_irqs - move pending/active IRQs from LRs to the dist=
ributor
>   * @vgic_cpu: Pointer to the vgic_cpu struct holding the LRs
>   *
> - * Move any pending IRQs that have already been assigned to LRs back=
 to the
> + * Move any IRQs that have already been assigned to LRs back to the
>   * emulated distributor state so that the complete emulated state ca=
n be read
>   * from the main emulation structures without investigating the LRs.
> - *
> - * Note that IRQs in the active state in the LRs get their pending s=
tate moved
> - * to the distributor but the active state stays in the LRs, because=
 we don't
> - * track the active state on the distributor side.
>   */
>  void vgic_unqueue_irqs(struct kvm_vcpu *vcpu)
>  {
> @@ -613,12 +655,22 @@ void vgic_unqueue_irqs(struct kvm_vcpu *vcpu)
>  		 * 01: pending
>  		 * 10: active
>  		 * 11: pending and active
> -		 *
> -		 * If the LR holds only an active interrupt (not pending) then
> -		 * just leave it alone.
>  		 */
> -		if ((lr.state & LR_STATE_MASK) =3D=3D LR_STATE_ACTIVE)
> -			continue;
> +		BUG_ON(!(lr.state & LR_STATE_MASK));
> +
> +		/* Reestablish SGI source for pending and active IRQs */
> +		if (lr.irq < VGIC_NR_SGIS)
> +			add_sgi_source(vcpu, lr.irq, lr.source);
> +
> +		/*
> +		 * If the LR holds an active (10) or a pending and active (11)
> +		 * interrupt then move this state to the distributor tracking

if you respin:                         the active state

> +		 * bit.
> +		 */
> +		if (lr.state & LR_STATE_ACTIVE) {
> +			vgic_irq_set_active(vcpu, lr.irq);
> +			lr.state &=3D ~LR_STATE_ACTIVE;
> +		}
> =20
>  		/*
>  		 * Reestablish the pending state on the distributor and the
> @@ -626,21 +678,19 @@ void vgic_unqueue_irqs(struct kvm_vcpu *vcpu)
>  		 * is fine, then we are only setting a few bits that were
>  		 * already set.
>  		 */
> -		vgic_dist_irq_set_pending(vcpu, lr.irq);
> -		if (lr.irq < VGIC_NR_SGIS)
> -			add_sgi_source(vcpu, lr.irq, lr.source);
> -		lr.state &=3D ~LR_STATE_PENDING;
> +		if (lr.state & LR_STATE_PENDING) {
> +			vgic_dist_irq_set_pending(vcpu, lr.irq);
> +			lr.state &=3D ~LR_STATE_PENDING;
> +		}
> +
>  		vgic_set_lr(vcpu, i, lr);
> =20
>  		/*
> -		 * If there's no state left on the LR (it could still be
> -		 * active), then the LR does not hold any useful info and can
> -		 * be marked as free for other use.
> +		 * Marked the LR as free for other use.

if you respin:     Mark the

>  		 */
> -		if (!(lr.state & LR_STATE_MASK)) {
> -			vgic_retire_lr(i, lr.irq, vcpu);
> -			vgic_irq_clear_queued(vcpu, lr.irq);
> -		}
> +		BUG_ON(lr.state & LR_STATE_MASK);
> +		vgic_retire_lr(i, lr.irq, vcpu);
> +		vgic_irq_clear_queued(vcpu, lr.irq);
> =20
>  		/* Finally update the VGIC state. */
>  		vgic_update_state(vcpu->kvm);
> @@ -804,6 +854,36 @@ static int vgic_nr_shared_irqs(struct vgic_dist =
*dist)
>  	return dist->nr_irqs - VGIC_NR_PRIVATE_IRQS;
>  }
> =20
> +static int compute_active_for_cpu(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_dist *dist =3D &vcpu->kvm->arch.vgic;
> +	unsigned long *active, *enabled, *act_percpu, *act_shared;
> +	unsigned long active_private, active_shared;
> +	int nr_shared =3D vgic_nr_shared_irqs(dist);
> +	int vcpu_id;
> +
> +	vcpu_id =3D vcpu->vcpu_id;
> +	act_percpu =3D vcpu->arch.vgic_cpu.active_percpu;
> +	act_shared =3D vcpu->arch.vgic_cpu.active_shared;
> +
> +	active =3D vgic_bitmap_get_cpu_map(&dist->irq_active, vcpu_id);
> +	enabled =3D vgic_bitmap_get_cpu_map(&dist->irq_enabled, vcpu_id);
> +	bitmap_and(act_percpu, active, enabled, VGIC_NR_PRIVATE_IRQS);
> +
> +	active =3D vgic_bitmap_get_shared_map(&dist->irq_active);
> +	enabled =3D vgic_bitmap_get_shared_map(&dist->irq_enabled);
> +	bitmap_and(act_shared, active, enabled, nr_shared);
> +	bitmap_and(act_shared, act_shared,
> +		   vgic_bitmap_get_shared_map(&dist->irq_spi_target[vcpu_id]),
> +		   nr_shared);
> +
> +	active_private =3D find_first_bit(act_percpu, VGIC_NR_PRIVATE_IRQS)=
;
> +	active_shared =3D find_first_bit(act_shared, nr_shared);
> +
> +	return (active_private < VGIC_NR_PRIVATE_IRQS ||
> +		active_shared < nr_shared);
> +}
> +
>  static int compute_pending_for_cpu(struct kvm_vcpu *vcpu)
>  {
>  	struct vgic_dist *dist =3D &vcpu->kvm->arch.vgic;
> @@ -835,7 +915,7 @@ static int compute_pending_for_cpu(struct kvm_vcp=
u *vcpu)
> =20
>  /*
>   * Update the interrupt state and determine which CPUs have pending
> - * interrupts. Must be called with distributor lock held.
> + * or active interrupts. Must be called with distributor lock held.
>   */
>  void vgic_update_state(struct kvm *kvm)
>  {
> @@ -849,10 +929,13 @@ void vgic_update_state(struct kvm *kvm)
>  	}
> =20
>  	kvm_for_each_vcpu(c, vcpu, kvm) {
> -		if (compute_pending_for_cpu(vcpu)) {
> -			pr_debug("CPU%d has pending interrupts\n", c);
> +		if (compute_pending_for_cpu(vcpu))
>  			set_bit(c, dist->irq_pending_on_cpu);
> -		}
> +
> +		if (compute_active_for_cpu(vcpu))
> +			set_bit(c, dist->irq_active_on_cpu);
> +		else
> +			clear_bit(c, dist->irq_active_on_cpu);
>  	}
>  }
> =20
> @@ -1030,39 +1113,49 @@ static void __kvm_vgic_flush_hwstate(struct k=
vm_vcpu *vcpu)
>  {
>  	struct vgic_cpu *vgic_cpu =3D &vcpu->arch.vgic_cpu;
>  	struct vgic_dist *dist =3D &vcpu->kvm->arch.vgic;
> +	unsigned long *pa_percpu, *pa_shared;
>  	int i, vcpu_id;
>  	int overflow =3D 0;
> +	int nr_shared =3D vgic_nr_shared_irqs(dist);
> =20
>  	vcpu_id =3D vcpu->vcpu_id;
> =20
> +	pa_percpu =3D vcpu->arch.vgic_cpu.pend_act_percpu;
> +	pa_shared =3D vcpu->arch.vgic_cpu.pend_act_shared;
> +
> +	bitmap_or(pa_percpu, vgic_cpu->pending_percpu, vgic_cpu->active_per=
cpu,
> +		  VGIC_NR_PRIVATE_IRQS);
> +	bitmap_or(pa_shared, vgic_cpu->pending_shared, vgic_cpu->active_sha=
red,
> +		  nr_shared);
>  	/*
>  	 * We may not have any pending interrupt, or the interrupts
>  	 * may have been serviced from another vcpu. In all cases,
>  	 * move along.
>  	 */
> -	if (!kvm_vgic_vcpu_pending_irq(vcpu)) {
> -		pr_debug("CPU%d has no pending interrupt\n", vcpu_id);
> +	if (!kvm_vgic_vcpu_pending_irq(vcpu) && !kvm_vgic_vcpu_active_irq(v=
cpu))
>  		goto epilog;
> -	}
> =20
>  	/* SGIs */
> -	for_each_set_bit(i, vgic_cpu->pending_percpu, VGIC_NR_SGIS) {
> +	for_each_set_bit(i, pa_percpu, VGIC_NR_SGIS) {
>  		if (!queue_sgi(vcpu, i))
>  			overflow =3D 1;
>  	}
> =20
>  	/* PPIs */
> -	for_each_set_bit_from(i, vgic_cpu->pending_percpu, VGIC_NR_PRIVATE_=
IRQS) {
> +	for_each_set_bit_from(i, pa_percpu, VGIC_NR_PRIVATE_IRQS) {
>  		if (!vgic_queue_hwirq(vcpu, i))
>  			overflow =3D 1;
>  	}
> =20
>  	/* SPIs */
> -	for_each_set_bit(i, vgic_cpu->pending_shared, vgic_nr_shared_irqs(d=
ist)) {
> +	for_each_set_bit(i, pa_shared, nr_shared) {
>  		if (!vgic_queue_hwirq(vcpu, i + VGIC_NR_PRIVATE_IRQS))
>  			overflow =3D 1;
>  	}

meh, these changes will now produce a quite strange result if one
bisects at this specific patch, since we will be setting pending
interrupts to active....  I thought it was more clear as one patch
containing the changes to vgic_queue_... imho.

Thoughts?

> =20
> +
> +
> +
>  epilog:
>  	if (overflow) {
>  		vgic_enable_underflow(vcpu);
> @@ -1209,6 +1302,17 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu =
*vcpu)
>  	return test_bit(vcpu->vcpu_id, dist->irq_pending_on_cpu);
>  }
> =20
> +int kvm_vgic_vcpu_active_irq(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_dist *dist =3D &vcpu->kvm->arch.vgic;
> +
> +	if (!irqchip_in_kernel(vcpu->kvm))
> +		return 0;
> +
> +	return test_bit(vcpu->vcpu_id, dist->irq_active_on_cpu);
> +}
> +
> +
>  void vgic_kick_vcpus(struct kvm *kvm)
>  {
>  	struct kvm_vcpu *vcpu;
> @@ -1381,8 +1485,12 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vc=
pu)
>  	struct vgic_cpu *vgic_cpu =3D &vcpu->arch.vgic_cpu;
> =20
>  	kfree(vgic_cpu->pending_shared);
> +	kfree(vgic_cpu->active_shared);
> +	kfree(vgic_cpu->pend_act_shared);
>  	kfree(vgic_cpu->vgic_irq_lr_map);
>  	vgic_cpu->pending_shared =3D NULL;
> +	vgic_cpu->active_shared =3D NULL;
> +	vgic_cpu->pend_act_shared =3D NULL;
>  	vgic_cpu->vgic_irq_lr_map =3D NULL;
>  }
> =20
> @@ -1392,9 +1500,14 @@ static int vgic_vcpu_init_maps(struct kvm_vcpu=
 *vcpu, int nr_irqs)
> =20
>  	int sz =3D (nr_irqs - VGIC_NR_PRIVATE_IRQS) / 8;
>  	vgic_cpu->pending_shared =3D kzalloc(sz, GFP_KERNEL);
> +	vgic_cpu->active_shared =3D kzalloc(sz, GFP_KERNEL);
> +	vgic_cpu->pend_act_shared =3D kzalloc(sz, GFP_KERNEL);
>  	vgic_cpu->vgic_irq_lr_map =3D kmalloc(nr_irqs, GFP_KERNEL);
> =20
> -	if (!vgic_cpu->pending_shared || !vgic_cpu->vgic_irq_lr_map) {
> +	if (!vgic_cpu->pending_shared
> +		|| !vgic_cpu->active_shared
> +		|| !vgic_cpu->pend_act_shared
> +		|| !vgic_cpu->vgic_irq_lr_map) {
>  		kvm_vgic_vcpu_destroy(vcpu);
>  		return -ENOMEM;
>  	}
> @@ -1447,10 +1560,12 @@ void kvm_vgic_destroy(struct kvm *kvm)
>  	kfree(dist->irq_spi_mpidr);
>  	kfree(dist->irq_spi_target);
>  	kfree(dist->irq_pending_on_cpu);
> +	kfree(dist->irq_active_on_cpu);
>  	dist->irq_sgi_sources =3D NULL;
>  	dist->irq_spi_cpu =3D NULL;
>  	dist->irq_spi_target =3D NULL;
>  	dist->irq_pending_on_cpu =3D NULL;
> +	dist->irq_active_on_cpu =3D NULL;
>  	dist->nr_cpus =3D 0;
>  }
> =20
> @@ -1486,6 +1601,7 @@ int vgic_init(struct kvm *kvm)
>  	ret |=3D vgic_init_bitmap(&dist->irq_pending, nr_cpus, nr_irqs);
>  	ret |=3D vgic_init_bitmap(&dist->irq_soft_pend, nr_cpus, nr_irqs);
>  	ret |=3D vgic_init_bitmap(&dist->irq_queued, nr_cpus, nr_irqs);
> +	ret |=3D vgic_init_bitmap(&dist->irq_active, nr_cpus, nr_irqs);
>  	ret |=3D vgic_init_bitmap(&dist->irq_cfg, nr_cpus, nr_irqs);
>  	ret |=3D vgic_init_bytemap(&dist->irq_priority, nr_cpus, nr_irqs);
> =20
> @@ -1498,10 +1614,13 @@ int vgic_init(struct kvm *kvm)
>  				       GFP_KERNEL);
>  	dist->irq_pending_on_cpu =3D kzalloc(BITS_TO_LONGS(nr_cpus) * sizeo=
f(long),
>  					   GFP_KERNEL);
> +	dist->irq_active_on_cpu =3D kzalloc(BITS_TO_LONGS(nr_cpus) * sizeof=
(long),
> +					   GFP_KERNEL);
>  	if (!dist->irq_sgi_sources ||
>  	    !dist->irq_spi_cpu ||
>  	    !dist->irq_spi_target ||
> -	    !dist->irq_pending_on_cpu) {
> +	    !dist->irq_pending_on_cpu ||
> +	    !dist->irq_active_on_cpu) {
>  		ret =3D -ENOMEM;
>  		goto out;
>  	}
> diff --git a/virt/kvm/arm/vgic.h b/virt/kvm/arm/vgic.h
> index 1e83bdf..1e5a381 100644
> --- a/virt/kvm/arm/vgic.h
> +++ b/virt/kvm/arm/vgic.h
> @@ -107,6 +107,14 @@ bool vgic_handle_set_pending_reg(struct kvm *kvm=
, struct kvm_exit_mmio *mmio,
>  bool vgic_handle_clear_pending_reg(struct kvm *kvm, struct kvm_exit_=
mmio *mmio,
>  				   phys_addr_t offset, int vcpu_id);
> =20
> +bool vgic_handle_set_active_reg(struct kvm *kvm,
> +				struct kvm_exit_mmio *mmio,
> +				phys_addr_t offset, int vcpu_id);
> +
> +bool vgic_handle_clear_active_reg(struct kvm *kvm,
> +				  struct kvm_exit_mmio *mmio,
> +				  phys_addr_t offset, int vcpu_id);
> +
>  bool vgic_handle_cfg_reg(u32 *reg, struct kvm_exit_mmio *mmio,
>  			 phys_addr_t offset);
> =20
> --=20
> 2.3.0
>=20
