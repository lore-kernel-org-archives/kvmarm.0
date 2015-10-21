From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v3 13/16] KVM: arm64: sync LPI configuration and pending
 tables
Date: Wed, 21 Oct 2015 14:29:24 +0300
Message-ID: <010d01d10bf3$bdbfff10$393ffd30$@samsung.com>
References: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
 <1444229726-31559-14-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <1444229726-31559-14-git-send-email-andre.przywara@arm.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Andre Przywara' <andre.przywara@arm.com>, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: eric.auger@linaro.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> -----Original Message-----
> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On Behalf Of Andre Przywara
> Sent: Wednesday, October 07, 2015 5:55 PM
> To: marc.zyngier@arm.com; christoffer.dall@linaro.org
> Cc: eric.auger@linaro.org; p.fedin@samsung.com; kvmarm@lists.cs.columbia.edu; linux-arm-
> kernel@lists.infradead.org; kvm@vger.kernel.org
> Subject: [PATCH v3 13/16] KVM: arm64: sync LPI configuration and pending tables
> 
> The LPI configuration and pending tables of the GICv3 LPIs are held
> in tables in (guest) memory. To achieve reasonable performance, we
> cache this data in our own data structures, so we need to sync those
> two views from time to time. This behaviour is well described in the
> GICv3 spec and is also exercised by hardware, so the sync points are
> well known.
> 
> Provide functions that read the guest memory and store the
> information from the configuration and pending tables in the kernel.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Changelog v2..v3:
> - rework functions to avoid propbaser/pendbaser accesses inside lock
> 
>  include/kvm/arm_vgic.h  |   2 +
>  virt/kvm/arm/its-emul.c | 133 ++++++++++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/its-emul.h |   3 ++
>  3 files changed, 138 insertions(+)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 035911f..4ea023c 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -179,6 +179,8 @@ struct vgic_its {
>  	int			cwriter;
>  	struct list_head	device_list;
>  	struct list_head	collection_list;
> +	/* memory used for buffering guest's memory */
> +	void			*buffer_page;
>  };
> 
>  struct vgic_dist {
> diff --git a/virt/kvm/arm/its-emul.c b/virt/kvm/arm/its-emul.c
> index 8349970..7a8c5db 100644
> --- a/virt/kvm/arm/its-emul.c
> +++ b/virt/kvm/arm/its-emul.c
> @@ -59,6 +59,7 @@ struct its_itte {
>  	struct its_collection *collection;
>  	u32 lpi;
>  	u32 event_id;
> +	u8 priority;
>  	bool enabled;
>  	unsigned long *pending;
>  };
> @@ -80,8 +81,124 @@ static struct its_itte *find_itte_by_lpi(struct kvm *kvm, int lpi)
>  	return NULL;
>  }
> 
> +#define LPI_PROP_ENABLE_BIT(p)	((p) & LPI_PROP_ENABLED)
> +#define LPI_PROP_PRIORITY(p)	((p) & 0xfc)
> +
> +/* stores the priority and enable bit for a given LPI */
> +static void update_lpi_config(struct kvm *kvm, struct its_itte *itte, u8 prop)
> +{
> +	itte->priority = LPI_PROP_PRIORITY(prop);
> +	itte->enabled  = LPI_PROP_ENABLE_BIT(prop);
> +}
> +
> +#define GIC_LPI_OFFSET 8192
> +
> +/* We scan the table in chunks the size of the smallest page size */
> +#define CHUNK_SIZE 4096U
> +
>  #define BASER_BASE_ADDRESS(x) ((x) & 0xfffffffff000ULL)
> 
> +static int nr_idbits_propbase(u64 propbaser)
> +{
> +	int nr_idbits = (1U << (propbaser & 0x1f)) + 1;
> +
> +	return max(nr_idbits, INTERRUPT_ID_BITS_ITS);
> +}
> +
> +/*
> + * Scan the whole LPI configuration table and put the LPI configuration
> + * data in our own data structures. This relies on the LPI being
> + * mapped before.
> + */
> +static bool its_update_lpis_configuration(struct kvm *kvm, u64 prop_base_reg)
> +{
> +	struct vgic_dist *dist = &kvm->arch.vgic;
> +	u8 *prop = dist->its.buffer_page;
> +	u32 tsize;
> +	gpa_t propbase;
> +	int lpi = GIC_LPI_OFFSET;
> +	struct its_itte *itte;
> +	struct its_device *device;
> +	int ret;
> +
> +	propbase = BASER_BASE_ADDRESS(prop_base_reg);
> +	tsize = nr_idbits_propbase(prop_base_reg);
> +
> +	while (tsize > 0) {
> +		int chunksize = min(tsize, CHUNK_SIZE);
> +
> +		ret = kvm_read_guest(kvm, propbase, prop, chunksize);
> +		if (ret)
> +			return false;

 I think it would be more convenient to return 'ret' here, and 0 on success. I see that currently nobody consumes the error code,
but with live migration this may change. And the same in its_sync_lpi_pending_table().

> +
> +		spin_lock(&dist->its.lock);
> +		/*
> +		 * Updating the status for all allocated LPIs. We catch
> +		 * those LPIs that get disabled. We really don't care
> +		 * about unmapped LPIs, as they need to be updated
> +		 * later manually anyway once they get mapped.
> +		 */
> +		for_each_lpi(device, itte, kvm) {
> +			if (itte->lpi < lpi || itte->lpi >= lpi + chunksize)
> +				continue;
> +
> +			update_lpi_config(kvm, itte, prop[itte->lpi - lpi]);
> +		}
> +		spin_unlock(&dist->its.lock);
> +		tsize -= chunksize;
> +		lpi += chunksize;
> +		propbase += chunksize;
> +	}
> +
> +	return true;
> +}
> +
> +/*
> + * Scan the whole LPI pending table and sync the pending bit in there
> + * with our own data structures. This relies on the LPI being
> + * mapped before.
> + */
> +static bool its_sync_lpi_pending_table(struct kvm_vcpu *vcpu, u64 base_addr_reg)
> +{
> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> +	unsigned long *pendmask = dist->its.buffer_page;
> +	u32 nr_lpis = VITS_NR_LPIS;
> +	gpa_t pendbase;
> +	int lpi = 0;
> +	struct its_itte *itte;
> +	struct its_device *device;
> +	int ret;
> +	int lpi_bit, nr_bits;
> +
> +	pendbase = BASER_BASE_ADDRESS(base_addr_reg);
> +
> +	while (nr_lpis > 0) {
> +		nr_bits = min(nr_lpis, CHUNK_SIZE * 8);
> +
> +		ret = kvm_read_guest(vcpu->kvm, pendbase, pendmask,
> +				     nr_bits / 8);
> +		if (ret)
> +			return false;
> +
> +		spin_lock(&dist->its.lock);
> +		for_each_lpi(device, itte, vcpu->kvm) {
> +			lpi_bit = itte->lpi - lpi;
> +			if (lpi_bit < 0 || lpi_bit >= nr_bits)
> +				continue;
> +			if (test_bit(lpi_bit, pendmask))
> +				__set_bit(vcpu->vcpu_id, itte->pending);
> +			else
> +				__clear_bit(vcpu->vcpu_id, itte->pending);
> +		}
> +		spin_unlock(&dist->its.lock);
> +		nr_lpis -= nr_bits;
> +		lpi += nr_bits;
> +		pendbase += nr_bits / 8;
> +	}
> +
> +	return true;
> +}
> +
>  /* The distributor lock is held by the VGIC MMIO handler. */
>  static bool handle_mmio_misc_gits(struct kvm_vcpu *vcpu,
>  				  struct kvm_exit_mmio *mmio,
> @@ -418,6 +535,17 @@ static const struct vgic_io_range vgicv3_its_ranges[] = {
>  /* This is called on setting the LPI enable bit in the redistributor. */
>  void vgic_enable_lpis(struct kvm_vcpu *vcpu)
>  {
> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> +	u64 prop_base_reg, pend_base_reg;
> +
> +	pend_base_reg = dist->pendbaser[vcpu->vcpu_id];
> +	prop_base_reg = dist->propbaser;
> +	spin_unlock(&dist->lock);
> +
> +	its_update_lpis_configuration(vcpu->kvm, prop_base_reg);
> +	its_sync_lpi_pending_table(vcpu, pend_base_reg);
> +
> +	spin_lock(&dist->lock);
>  }
> 
>  int vits_init(struct kvm *kvm)
> @@ -429,6 +557,10 @@ int vits_init(struct kvm *kvm)
>  	if (!dist->pendbaser)
>  		return -ENOMEM;
> 
> +	its->buffer_page = kmalloc(CHUNK_SIZE, GFP_KERNEL);
> +	if (!its->buffer_page)
> +		return -ENOMEM;
> +
>  	spin_lock_init(&its->lock);
> 
>  	INIT_LIST_HEAD(&its->device_list);
> @@ -474,6 +606,7 @@ void vits_destroy(struct kvm *kvm)
>  		kfree(container_of(cur, struct its_collection, coll_list));
>  	}
> 
> +	kfree(its->buffer_page);
>  	kfree(dist->pendbaser);
> 
>  	its->enabled = false;
> diff --git a/virt/kvm/arm/its-emul.h b/virt/kvm/arm/its-emul.h
> index cc5d5ff..cbc3877 100644
> --- a/virt/kvm/arm/its-emul.h
> +++ b/virt/kvm/arm/its-emul.h
> @@ -29,6 +29,9 @@
> 
>  #include "vgic.h"
> 
> +#define INTERRUPT_ID_BITS_ITS 16
> +#define VITS_NR_LPIS (1U << INTERRUPT_ID_BITS_ITS)
> +
>  void vgic_enable_lpis(struct kvm_vcpu *vcpu);
>  int vits_init(struct kvm *kvm);
>  void vits_destroy(struct kvm *kvm);
> --
> 2.5.1

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


