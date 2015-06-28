From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 10/13] KVM: arm64: sync LPI properties and status between
 guest and KVM
Date: Sun, 28 Jun 2015 21:33:03 +0200
Message-ID: <20150628193303.GK28244@cbox>
References: <1432893209-27313-1-git-send-email-andre.przywara@arm.com>
 <1432893209-27313-11-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1432893209-27313-11-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, May 29, 2015 at 10:53:26AM +0100, Andre Przywara wrote:
> The properties and status of the GICv3 LPIs are hold in tables in
> (guest) memory. To achieve reasonable performance, we cache this
> data in our own data structures, so we need to sync those two views
> from time to time. This behaviour is well described in the GICv3 spec
> and is also exercised by hardware, so the sync points are well known.
> 
> Provide functions that read the guest memory and store the
> information from the property and status table in the kernel.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  virt/kvm/arm/its-emul.c | 140 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 140 insertions(+)
> 
> diff --git a/virt/kvm/arm/its-emul.c b/virt/kvm/arm/its-emul.c
> index f75fb9e..afd440e 100644
> --- a/virt/kvm/arm/its-emul.c
> +++ b/virt/kvm/arm/its-emul.c
> @@ -50,6 +50,7 @@ struct its_itte {
>  	struct its_collection *collection;
>  	u32 lpi;
>  	u32 event_id;
> +	u8 priority;
>  	bool enabled;
>  	unsigned long *pending;
>  };
> @@ -70,7 +71,140 @@ static struct its_itte *find_itte_by_lpi(struct kvm *kvm, int lpi)
>  	return NULL;
>  }
>  
> +#define LPI_PROP_ENABLE_BIT(p)	((p) & LPI_PROP_ENABLED)
> +#define LPI_PROP_PRIORITY(p)	((p) & 0xfc)
> +
> +/* stores the priority and enable bit for a given LPI */
> +static void update_lpi_property(struct kvm *kvm, struct its_itte *itte, u8 prop)
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
> +#define PROPBASE_TSIZE(x) (1U << (x & 0x1f))
> +
> +/*
> + * Scan the whole LPI property table and put the LPI configuration
> + * data in our own data structures. This relies on the LPI being
> + * mapped before.
> + * We scan from two sides:
> + * 1) for each byte in the table we care for the ones being enabled
> + * 2) for each mapped LPI we look into the table to spot LPIs being disabled
> + * Must be called with the ITS lock held.
> + */
> +static bool its_update_lpi_properties(struct kvm *kvm)
> +{
> +	struct vgic_dist *dist = &kvm->arch.vgic;
> +	u8 *prop;
> +	u32 tsize;
> +	gpa_t propbase;
> +	int lpi = GIC_LPI_OFFSET;
> +	struct its_itte *itte;
> +	struct its_device *device;
> +	int ret;
> +
> +	propbase = BASER_BASE_ADDRESS(dist->propbaser);
> +	tsize = PROPBASE_TSIZE(dist->propbaser);
> +
> +	prop = kmalloc(CHUNK_SIZE, GFP_KERNEL);
> +	if (!prop)
> +		return false;
> +
> +	while (tsize > 0) {
> +		int chunksize = min(tsize, CHUNK_SIZE);
> +
> +		ret = kvm_read_guest(kvm, propbase, prop, chunksize);
> +		if (ret) {
> +			kfree(prop);
> +			break;
> +		}
> +
> +		/*
> +		 * Updating the status for all allocated LPIs. We catch
> +		 * those LPIs that get disabled. We really don't care
> +		 * about unmapped LPIs, as they need to be updated
> +		 * later manually anyway once they get mapped.
> +		 */
> +		for_each_lpi(device, itte, kvm) {
> +			/*
> +			 * Is the LPI covered by that part of the table we
> +			 * are currently looking at?
> +			 */
> +			if (itte->lpi < lpi)
> +				continue;
> +			if (itte->lpi >= lpi + chunksize)
> +				continue;
> +
> +			update_lpi_property(kvm, itte,
> +					    prop[itte->lpi - lpi]);
> +		}
> +		tsize -= chunksize;
> +		lpi += chunksize;
> +		propbase += chunksize;
> +	}
> +
> +	kfree(prop);
> +	return true;
> +}
> +
> +/*
> + * Scan the whole LPI pending table and sync the pending bit in there
> + * with our own data structures. This relies on the LPI being
> + * mapped before.
> + * Must be called with the ITS lock held.
> + */
> +static bool its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> +	unsigned long *pendmask;
> +	u32 nr_lpis;
> +	gpa_t pendbase;
> +	int lpi = GIC_LPI_OFFSET;
> +	struct its_itte *itte;
> +	struct its_device *device;
> +	int ret;
> +	int lpi_bit, nr_bits;
> +
> +	pendbase = BASER_BASE_ADDRESS(dist->pendbaser[vcpu->vcpu_id]);
> +	nr_lpis = GIC_LPI_OFFSET;
> +
> +	pendmask = kmalloc(CHUNK_SIZE, GFP_KERNEL);
> +	if (!pendmask)
> +		return false;
> +
> +	while (nr_lpis > 0) {
> +		nr_bits = min(nr_lpis, CHUNK_SIZE * 8);
> +
> +		ret = kvm_read_guest(vcpu->kvm, pendbase, pendmask,
> +				     nr_bits / 8);
> +		if (ret)
> +			break;
> +
> +		for_each_lpi(device, itte, vcpu->kvm) {
> +			lpi_bit = itte->lpi - lpi;
> +			if (lpi_bit < 0)
> +				continue;
> +			if (lpi_bit >= nr_bits)
> +				continue;
> +			if (test_bit(lpi_bit, pendmask))
> +				set_bit(vcpu->vcpu_id, itte->pending);
> +			else
> +				clear_bit(vcpu->vcpu_id, itte->pending);
> +		}
> +		nr_lpis -= nr_bits;
> +		lpi += nr_bits;
> +		pendbase += nr_bits / 8;
> +	}
> +
> +	kfree(pendmask);
> +	return true;
> +}
>  
>  /* distributor lock is hold by the VGIC MMIO handler */
>  static bool handle_mmio_misc_gits(struct kvm_vcpu *vcpu,
> @@ -350,6 +484,12 @@ static const struct vgic_io_range vgicv3_its_ranges[] = {
>  
>  void vgic_enable_lpis(struct kvm_vcpu *vcpu)
>  {
> +	struct vgic_its *its = &vcpu->kvm->arch.vgic.its;
> +
> +	spin_lock(&its->lock);
> +	its_update_lpi_properties(vcpu->kvm);
> +	its_sync_lpi_pending_table(vcpu);

looks like you're doing a lot of kmalloc(, GFP_KERNEL) and
__copy_from_user while holding spinlocks here???

-Christoffer

> +	spin_unlock(&its->lock);
>  }
>  
>  int vits_init(struct kvm *kvm)
> -- 
> 2.3.5
> 
