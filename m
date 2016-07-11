From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v8 13/17] KVM: arm64: read initial LPI pending table
Date: Mon, 11 Jul 2016 17:50:47 +0100
Message-ID: <5783CE67.2070202@arm.com>
References: <20160705112309.28877-1-andre.przywara@arm.com>
 <20160705112309.28877-14-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160705112309.28877-14-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 05/07/16 12:23, Andre Przywara wrote:
> The LPI pending status for a GICv3 redistributor is held in a table
> in (guest) memory. To achieve reasonable performance, we cache this
> data in our struct vgic_irq. The initial pending state must be read
> from guest memory upon enabling LPIs for this redistributor.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 81 ++++++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic.h     |  6 ++++
>  2 files changed, 87 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 1e2e649..29bb4fe 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -93,6 +93,81 @@ struct its_itte {
>  		list_for_each_entry(itte, &(dev)->itt_head, itte_list)
>  
>  #define CBASER_ADDRESS(x)	((x) & GENMASK_ULL(51, 12))
> +#define PENDBASER_ADDRESS(x)	((x) & GENMASK_ULL(51, 16))

52 bits again. Pick a side!

> +
> +static int vgic_its_copy_lpi_list(struct kvm *kvm, u32 **intid_ptr)
> +{
> +	struct vgic_dist *dist = &kvm->arch.vgic;
> +	struct vgic_irq *irq;
> +	u32 *intids;
> +	int irq_count = dist->lpi_list_count, i = 0;
> +
> +	/*
> +	 * We use the current value of the list length, which may change
> +	 * after the kmalloc. We don't care, because the guest shouldn't
> +	 * change anything while the command handling is still running,
> +	 * and in the worst case we would miss a new IRQ, which one wouldn't
> +	 * expect to be covered by this command anyway.
> +	 */
> +	intids = kmalloc_array(irq_count, sizeof(intids[0]), GFP_KERNEL);
> +	if (!intids)
> +		return -ENOMEM;
> +
> +	spin_lock(&dist->lpi_list_lock);
> +	list_for_each_entry(irq, &dist->lpi_list_head, lpi_entry) {
> +		if (kref_get_unless_zero(&irq->refcount)) {
> +			intids[i] = irq->intid;
> +			vgic_put_irq_locked(kvm, irq);

This is ugly. You know you're not going to free the irq, since it was at
least one when you did kref_get_unless_zero(). Why not doing a simple
kref_put (possibly in a macro so that you can hide the dummy release
function)?

> +		}
> +		if (i++ == irq_count)
> +			break;
> +	}
> +	spin_unlock(&dist->lpi_list_lock);
> +
> +	*intid_ptr = intids;
> +	return irq_count;
> +}
> +
> +/*
> + * Scan the whole LPI pending table and sync the pending bit in there
> + * with our own data structures. This relies on the LPI being
> + * mapped before.
> + */
> +static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
> +{
> +	gpa_t pendbase = PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
> +	struct vgic_irq *irq;
> +	u8 pendmask;
> +	int ret = 0;
> +	u32 *intids;
> +	int nr_irqs, i;
> +
> +	nr_irqs = vgic_its_copy_lpi_list(vcpu->kvm, &intids);
> +	if (nr_irqs < 0)
> +		return nr_irqs;
> +
> +	for (i = 0; i < nr_irqs; i++) {
> +		int byte_offset, bit_nr;
> +
> +		byte_offset = intids[i] / BITS_PER_BYTE;
> +		bit_nr = intids[i] % BITS_PER_BYTE;
> +
> +		ret = kvm_read_guest(vcpu->kvm, pendbase + byte_offset,
> +				     &pendmask, 1);

How about having a small cache of the last read offset and data? If LPIs
are contiguously allocated, you save yourself quite a few (expensive)
userspace accesses.

> +		if (ret) {
> +			kfree(intids);
> +			return ret;
> +		}
> +
> +		irq = vgic_get_irq(vcpu->kvm, NULL, intids[i]);
> +		spin_lock(&irq->irq_lock);
> +		irq->pending = pendmask & (1U << bit_nr);
> +		vgic_queue_irq_unlock(vcpu->kvm, irq);
> +		vgic_put_irq(vcpu->kvm, irq);
> +	}
> +
> +	return ret;
> +}
>  
>  static unsigned long vgic_mmio_read_its_ctlr(struct kvm *vcpu,
>  					     struct vgic_its *its,
> @@ -415,6 +490,12 @@ static struct vgic_register_region its_registers[] = {
>  		VGIC_ACCESS_32bit),
>  };
>  
> +/* This is called on setting the LPI enable bit in the redistributor. */
> +void vgic_enable_lpis(struct kvm_vcpu *vcpu)
> +{
> +	its_sync_lpi_pending_table(vcpu);
> +}
> +
>  static int vgic_its_register(struct kvm *kvm, struct vgic_its *its)
>  {
>  	struct vgic_io_device *iodev = &its->iodev;
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index eef9ec1..4a9165f 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -25,6 +25,7 @@
>  #define IS_VGIC_ADDR_UNDEF(_x)  ((_x) == VGIC_ADDR_UNDEF)
>  
>  #define INTERRUPT_ID_BITS_SPIS	10
> +#define INTERRUPT_ID_BITS_ITS	16

Do we have plan for a userspace-accessible property for this? I can
imagine userspace willing to have bigger LPI space...

>  #define VGIC_PRI_BITS		5
>  
>  #define vgic_irq_is_sgi(intid) ((intid) < VGIC_NR_SGIS)
> @@ -79,6 +80,7 @@ int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
>  bool vgic_has_its(struct kvm *kvm);
>  int kvm_vgic_register_its_device(void);
>  struct vgic_irq *vgic_its_get_lpi(struct kvm *kvm, u32 intid);
> +void vgic_enable_lpis(struct kvm_vcpu *vcpu);
>  #else
>  static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
>  {
> @@ -145,6 +147,10 @@ static inline struct vgic_irq *vgic_its_get_lpi(struct kvm *kvm, u32 intid)
>  {
>  	return NULL;
>  }
> +
> +static inline void vgic_enable_lpis(struct kvm_vcpu *vcpu)
> +{
> +}
>  #endif
>  
>  int kvm_register_vgic_device(unsigned long type);
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
