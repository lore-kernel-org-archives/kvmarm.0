From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v5 17/22] KVM: arm64: vgic-its: Collection table
 save/restore
Date: Fri, 28 Apr 2017 03:44:48 -0700
Message-ID: <20170428104448.GB1439@lvm>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-18-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1492164934-988-18-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, marc.zyngier@arm.com, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 14, 2017 at 12:15:29PM +0200, Eric Auger wrote:
> The save path copies the collection entries into guest RAM
> at the GPA specified in the BASER register. This obviously
> requires the BASER to be set. The last written element is a
> dummy collection table entry.
> 
> We do not index by collection ID as the collection entry
> can fit into 8 bytes while containing the collection ID.
> 
> On restore path we re-allocate the collection objects.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> v4 -> v5:
> - add macros for field encoding/decoding
> - use abi->cte_esz
> - rename flush into save
> - check the target_addr is valid
> 
> v3 -> v4:
> - replaced u64 *ptr by gpa_t gpa
> - check the collection does not exist before allocating it
> 
> v1 -> v2:
> - reword commit message and directly use 8 as entry size
> - no kvm parameter anymore
> - add helper for flush/restore cte
> - table size computed here
> - add le64/cpu conversions
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 109 ++++++++++++++++++++++++++++++++++++++++++-
>  virt/kvm/arm/vgic/vgic.h     |   9 ++++
>  2 files changed, 116 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index c22b35d..484e541 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1785,13 +1785,97 @@ static int vgic_its_restore_device_tables(struct vgic_its *its)
>  	return -ENXIO;
>  }
>  
> +static int vgic_its_save_cte(struct vgic_its *its,
> +			     struct its_collection *collection,
> +			     gpa_t gpa, int esz)
> +{
> +	u64 val;
> +	int ret;
> +
> +	val = (1ULL << KVM_ITS_CTE_VALID_SHIFT |
> +	       ((u64)collection->target_addr << KVM_ITS_CTE_RDBASE_SHIFT) |
> +	       collection->collection_id);
> +	val = cpu_to_le64(val);
> +	ret = kvm_write_guest(its->dev->kvm, gpa, &val, esz);
> +	return ret;
> +}
> +
> +static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa,
> +				int esz, bool *valid)
> +{
> +	struct its_collection *collection;
> +	struct kvm *kvm = its->dev->kvm;
> +	u32 target_addr;
> +	u32 coll_id;
> +	u64 val;
> +	int ret;
> +
> +	*valid = false;

I don't see why you need this.

> +
> +	ret = kvm_read_guest(kvm, gpa, &val, esz);

hmm, we better not have an esz larger than sizeof(u64) here then.

> +	if (ret)
> +		return ret;
> +	val = le64_to_cpu(val);
> +	*valid = val & KVM_ITS_CTE_VALID_MASK;
> +
> +	if (!*valid)
> +		return 0;

I think this would be nicer with just a bool on the stack and then set
*valid = in the end of the function.  Alternatively, you could just have
the return value return > 0 when there are more entries.

> +
> +	target_addr = (u32)(val >> KVM_ITS_CTE_RDBASE_SHIFT);
> +	coll_id = val & KVM_ITS_CTE_ICID_MASK;
> +
> +	if (target_addr >= atomic_read(&kvm->online_vcpus))
> +		return -EINVAL;
> +
> +	collection = find_collection(its, coll_id);
> +	if (collection)
> +		return -EEXIST;
> +	ret = vgic_its_alloc_collection(its, &collection, coll_id);
> +	if (ret)
> +		return ret;
> +	collection->target_addr = target_addr;
> +	return 0;
> +}
> +
>  /**
>   * vgic_its_save_collection_table - Save the collection table into
>   * guest RAM
>   */
>  static int vgic_its_save_collection_table(struct vgic_its *its)
>  {
> -	return -ENXIO;
> +	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
> +	struct its_collection *collection;
> +	u64 val;
> +	gpa_t gpa;
> +	size_t max_size, filled = 0;
> +	int ret, cte_esz = abi->cte_esz;
> +
> +	gpa = BASER_ADDRESS(its->baser_coll_table);
> +	if (!gpa)
> +		return 0;
> +
> +	max_size = GITS_BASER_NR_PAGES(its->baser_coll_table) * SZ_64K;
> +
> +	list_for_each_entry(collection, &its->collection_list, coll_list) {
> +		if (filled == max_size)
> +			return -ENOSPC;
> +		ret = vgic_its_save_cte(its, collection, gpa, cte_esz);
> +		if (ret)
> +			return ret;
> +		gpa += cte_esz;
> +		filled += cte_esz;
> +	}
> +
> +	if (filled == max_size)
> +		return 0;
> +
> +	/*
> +	 * table is not fully filled, add a last dummy element
> +	 * with valid bit unset
> +	 */
> +	val = 0;
> +	ret = kvm_write_guest(its->dev->kvm, gpa, &val, cte_esz);
> +	return ret;
>  }
>  
>  /**
> @@ -1801,7 +1885,28 @@ static int vgic_its_save_collection_table(struct vgic_its *its)
>   */
>  static int vgic_its_restore_collection_table(struct vgic_its *its)
>  {
> -	return -ENXIO;
> +	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
> +	size_t max_size, read = 0;
> +	gpa_t gpa;
> +	int ret, cte_esz = abi->cte_esz;
> +
> +	gpa = BASER_ADDRESS(its->baser_coll_table);
> +
> +	if (!gpa)
> +		return 0;

I don't understand this check.

Don't you want to do do
	if (!(its->baser_coll_table) & GITS_BASER_VALID)
		return 0;

Or what am I missing?

Thanks,
-Christoffer

> +
> +	max_size = GITS_BASER_NR_PAGES(its->baser_coll_table) * SZ_64K;
> +
> +	while (read < max_size) {
> +		bool valid;
> +
> +		ret = vgic_its_restore_cte(its, gpa, cte_esz, &valid);
> +		if (!valid || ret)
> +			break;
> +		gpa += cte_esz;
> +		read += cte_esz;
> +	}
> +	return ret;
>  }
>  
>  /**
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index b87f1c6..56e57c1 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -73,6 +73,15 @@
>  				      KVM_REG_ARM_VGIC_SYSREG_CRM_MASK | \
>  				      KVM_REG_ARM_VGIC_SYSREG_OP2_MASK)
>  
> +/*
> + * As per Documentation/virtual/kvm/devices/arm-vgic-its.txt,
> + * below macros are defined for ITS table entry encoding.
> + */
> +#define KVM_ITS_CTE_VALID_SHIFT		63
> +#define KVM_ITS_CTE_VALID_MASK		BIT_ULL(63)
> +#define KVM_ITS_CTE_RDBASE_SHIFT	16
> +#define KVM_ITS_CTE_ICID_MASK		GENMASK_ULL(15, 0)
> +
>  static inline bool irq_is_pending(struct vgic_irq *irq)
>  {
>  	if (irq->config == VGIC_CONFIG_EDGE)
> -- 
> 2.5.5
> 
