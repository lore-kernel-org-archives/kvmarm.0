From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v8 12/17] KVM: arm64: connect LPIs to the VGIC emulation
Date: Mon, 11 Jul 2016 17:20:37 +0100
Message-ID: <5783C755.3000404@arm.com>
References: <20160705112309.28877-1-andre.przywara@arm.com>
 <20160705112309.28877-13-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160705112309.28877-13-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 05/07/16 12:23, Andre Przywara wrote:
> LPIs are dynamically created (mapped) at guest runtime and their
> actual number can be quite high, but is mostly assigned using a very
> sparse allocation scheme. So arrays are not an ideal data structure
> to hold the information.
> We use a spin-lock protected linked list to hold all mapped LPIs,
> represented by their struct vgic_irq. This lock is grouped between the
> ap_list_lock and the vgic_irq lock in our locking order.
> Also we store a pointer to that struct vgic_irq in our struct its_itte,
> so we can easily access it.
> Eventually we call our new vgic_its_get_lpi() from vgic_get_irq(), so
> the VGIC code gets transparently access to LPIs.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/kvm/arm_vgic.h        |  6 ++++++
>  virt/kvm/arm/vgic/vgic-init.c |  3 +++
>  virt/kvm/arm/vgic/vgic-its.c  | 32 +++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-v3.c   |  2 ++
>  virt/kvm/arm/vgic/vgic.c      | 48 +++++++++++++++++++++++++++++++++++--------
>  virt/kvm/arm/vgic/vgic.h      |  7 +++++++
>  6 files changed, 90 insertions(+), 8 deletions(-)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 17d3929..5aff85c 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -77,6 +77,7 @@ enum vgic_irq_config {
>  
>  struct vgic_irq {
>  	spinlock_t irq_lock;		/* Protects the content of the struct */
> +	struct list_head lpi_entry;	/* Used to link all LPIs together */

Maybe name that field consistently with the one that just follows?

>  	struct list_head ap_list;
>  
>  	struct kvm_vcpu *vcpu;		/* SGIs and PPIs: The VCPU
> @@ -185,6 +186,11 @@ struct vgic_dist {
>  	 * GICv3 spec: 6.1.2 "LPI Configuration tables"
>  	 */
>  	u64			propbaser;
> +
> +	/* Protects the lpi_list and the count value below. */
> +	spinlock_t		lpi_list_lock;
> +	struct list_head	lpi_list_head;
> +	int			lpi_list_count;
>  };
>  
>  struct vgic_v2_cpu_if {
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index ac3c1a5..535e713 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -157,6 +157,9 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
>  	struct kvm_vcpu *vcpu0 = kvm_get_vcpu(kvm, 0);
>  	int i;
>  
> +	INIT_LIST_HEAD(&dist->lpi_list_head);
> +	spin_lock_init(&dist->lpi_list_lock);
> +
>  	dist->spis = kcalloc(nr_spis, sizeof(struct vgic_irq), GFP_KERNEL);
>  	if (!dist->spis)
>  		return  -ENOMEM;
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index a9336a4..1e2e649 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -33,6 +33,31 @@
>  #include "vgic.h"
>  #include "vgic-mmio.h"
>  
> +/*
> + * Iterate over the VM's list of mapped LPIs to find the one with a
> + * matching interrupt ID and return a reference to the IRQ structure.
> + */
> +struct vgic_irq *vgic_its_get_lpi(struct kvm *kvm, u32 intid)

Why is this in the ITS code? This shouldn't be made a first class API,
but instead kept close to the vgic_get_irq() code.

> +{
> +	struct vgic_dist *dist = &kvm->arch.vgic;
> +	struct vgic_irq *irq = NULL;
> +
> +	spin_lock(&dist->lpi_list_lock);
> +	list_for_each_entry(irq, &dist->lpi_list_head, lpi_entry) {
> +		if (irq->intid != intid)
> +			continue;
> +
> +		kref_get(&irq->refcount);

Please add a comment stating that the refcount is incremented, and that
vgic_put_irq() is to be called to drop the reference. And moving the
function away (as well as making it static) will remove aly doubt about
its use.

> +		goto out_unlock;
> +	}
> +	irq = NULL;
> +
> +out_unlock:
> +	spin_unlock(&dist->lpi_list_lock);
> +
> +	return irq;
> +}
> +
>  struct its_device {
>  	struct list_head dev_list;
>  
> @@ -56,11 +81,17 @@ struct its_collection {
>  struct its_itte {
>  	struct list_head itte_list;
>  
> +	struct vgic_irq *irq;
>  	struct its_collection *collection;
>  	u32 lpi;
>  	u32 event_id;
>  };
>  
> +/* To be used as an iterator this macro misses the enclosing parentheses */
> +#define for_each_lpi_its(dev, itte, its) \
> +	list_for_each_entry(dev, &(its)->device_list, dev_list) \
> +		list_for_each_entry(itte, &(dev)->itt_head, itte_list)

Where is this macro used? Please move it in the appropriate patch.

> +
>  #define CBASER_ADDRESS(x)	((x) & GENMASK_ULL(51, 12))
>  
>  static unsigned long vgic_mmio_read_its_ctlr(struct kvm *vcpu,
> @@ -144,6 +175,7 @@ static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
>  static void its_free_itte(struct kvm *kvm, struct its_itte *itte)
>  {
>  	list_del(&itte->itte_list);
> +	vgic_put_irq(kvm, itte->irq);

Who does the "get"? Where is it populated?

>  	kfree(itte);
>  }
>  
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index 6f8f31f..0506543 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -81,6 +81,8 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
>  		else
>  			intid = val & GICH_LR_VIRTUALID;
>  		irq = vgic_get_irq(vcpu->kvm, vcpu, intid);
> +		if (!irq)	/* An LPI could have been unmapped. */
> +			continue;
>  
>  		spin_lock(&irq->irq_lock);
>  
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index a5d9a10..72b2516 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -36,7 +36,8 @@ struct vgic_global __section(.hyp.text) kvm_vgic_global_state;
>   * its->cmd_lock (mutex)
>   *   its->its_lock (mutex)
>   *     vgic_cpu->ap_list_lock
> - *       vgic_irq->irq_lock
> + *       kvm->lpi_list_lock
> + *         vgic_irq->irq_lock
>   *
>   * If you need to take multiple locks, always take the upper lock first,
>   * then the lower ones, e.g. first take the its_lock, then the irq_lock.
> @@ -69,23 +70,54 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
>  		return irq;
>  	}
>  
> -	/* LPIs are not yet covered */
> -	if (intid >= VGIC_MIN_LPI)
> +	if (intid < VGIC_MIN_LPI) {
> +		WARN(1, "Looking up struct vgic_irq for reserved INTID");
>  		return NULL;
> +	}
>  
> -	WARN(1, "Looking up struct vgic_irq for reserved INTID");
> -	return NULL;
> +	/* LPIs */
> +	return vgic_its_get_lpi(kvm, intid);
>  }
>  
> -/* The refcount should never drop to 0 at the moment. */
> +/*
> + * We can't do anything in here, because we lack the kvm pointer to
> + * lock and remove the item from the lpi_list. So we keep this function
> + * empty and use the return value of kref_put() to trigger the freeing.
> + */
>  static void vgic_irq_release(struct kref *ref)
>  {
> -	WARN_ON(1);
> +}
> +
> +static void __vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq, bool locked)
> +{
> +	struct vgic_dist *dist;
> +
> +	if (!kref_put(&irq->refcount, vgic_irq_release))
> +		return;
> +
> +	if (irq->intid < VGIC_MIN_LPI)
> +		return;
> +
> +	dist = &kvm->arch.vgic;
> +
> +	if (!locked)
> +		spin_lock(&dist->lpi_list_lock);
> +	list_del(&irq->lpi_entry);
> +	dist->lpi_list_count--;
> +	if (!locked)
> +		spin_unlock(&dist->lpi_list_lock);
> +
> +	kfree(irq);
> +}
> +
> +void vgic_put_irq_locked(struct kvm *kvm, struct vgic_irq *irq)
> +{
> +	__vgic_put_irq(kvm, irq, true);
>  }
>  
>  void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
>  {
> -	kref_put(&irq->refcount, vgic_irq_release);
> +	__vgic_put_irq(kvm, irq, false);
>  }

The usual idiom in the kernel is to have __vgic_put_irq() to always work
on locked irqs, and vgic_put_irq() to explicitly take the lock (and call
__vgic_put_irq). Please follow that rule, as it helps people unfamiliar
with the code to understand it more easily.

Also, the "locked" version isn't used in this patch. Maybe move it where
it is actually used?

>  
>  /**
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 9dc7207..eef9ec1 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -39,6 +39,7 @@ struct vgic_vmcr {
>  struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
>  			      u32 intid);
>  void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq);
> +void vgic_put_irq_locked(struct kvm *kvm, struct vgic_irq *irq);
>  bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq);
>  void vgic_kick_vcpus(struct kvm *kvm);
>  
> @@ -77,6 +78,7 @@ int vgic_v3_map_resources(struct kvm *kvm);
>  int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
>  bool vgic_has_its(struct kvm *kvm);
>  int kvm_vgic_register_its_device(void);
> +struct vgic_irq *vgic_its_get_lpi(struct kvm *kvm, u32 intid);
>  #else
>  static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
>  {
> @@ -138,6 +140,11 @@ static inline int kvm_vgic_register_its_device(void)
>  {
>  	return -ENODEV;
>  }
> +
> +static inline struct vgic_irq *vgic_its_get_lpi(struct kvm *kvm, u32 intid)
> +{
> +	return NULL;
> +}
>  #endif
>  
>  int kvm_register_vgic_device(unsigned long type);
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
