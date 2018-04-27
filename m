From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v3 11/12] KVM: arm/arm64: Implement
 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION
Date: Fri, 27 Apr 2018 21:14:54 +0200
Message-ID: <20180427191454.GO13249@C02W217FHV2R.local>
References: <1523607658-9166-1-git-send-email-eric.auger@redhat.com>
 <1523607658-9166-12-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1523607658-9166-12-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@kernel.org, peter.maydell@linaro.org, andre.przywara@arm.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 13, 2018 at 10:20:57AM +0200, Eric Auger wrote:
> Now all the internals are ready to handle multiple redistributor
> regions, let's allow the userspace to register them.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v2 -> v3:
> - early exit if vgic_v3_rdist_region_from_index() fails
> ---
>  virt/kvm/arm/vgic/vgic-kvm-device.c | 42 +++++++++++++++++++++++++++++++++++--
>  virt/kvm/arm/vgic/vgic-mmio-v3.c    |  4 ++--
>  virt/kvm/arm/vgic/vgic.h            |  9 +++++++-
>  3 files changed, 50 insertions(+), 5 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
> index e7b5a86..00e03d3 100644
> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> @@ -65,7 +65,8 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
>  {
>  	int r = 0;
>  	struct vgic_dist *vgic = &kvm->arch.vgic;
> -	phys_addr_t *addr_ptr, alignment;
> +	phys_addr_t *addr_ptr = NULL;
> +	phys_addr_t alignment;
>  	uint64_t undef_value = VGIC_ADDR_UNDEF;
>  
>  	mutex_lock(&kvm->lock);
> @@ -92,7 +93,7 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
>  		if (r)
>  			break;
>  		if (write) {
> -			r = vgic_v3_set_redist_base(kvm, *addr);
> +			r = vgic_v3_set_redist_base(kvm, 0, *addr, 0);
>  			goto out;
>  		}
>  		rdreg = list_first_entry(&vgic->rd_regions,
> @@ -103,6 +104,42 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
>  			addr_ptr = &rdreg->base;
>  		break;
>  	}
> +	case KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION:
> +	{
> +		struct vgic_redist_region *rdreg;
> +		uint8_t index;
> +
> +		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V3);
> +		if (r)
> +			break;
> +
> +		index = *addr & KVM_VGIC_V3_RDIST_INDEX_MASK;
> +
> +		if (write) {
> +			gpa_t base = *addr & KVM_VGIC_V3_RDIST_BASE_MASK;
> +			uint32_t count = (*addr & KVM_VGIC_V3_RDIST_COUNT_MASK)
> +					>> KVM_VGIC_V3_RDIST_COUNT_SHIFT;
> +			uint8_t flags = (*addr & KVM_VGIC_V3_RDIST_FLAGS_MASK)
> +					>> KVM_VGIC_V3_RDIST_FLAGS_SHIFT;
> +
> +			if (!count || flags)
> +				r = -EINVAL;
> +			else
> +				r = vgic_v3_set_redist_base(kvm, index,
> +							    base, count);
> +			goto out;
> +		}
> +
> +		rdreg = vgic_v3_rdist_region_from_index(kvm, index);
> +		if (!rdreg) {
> +			r = -ENODEV;
> +			goto out;
> +		}
> +
> +		*addr_ptr = rdreg->base & index &
> +			(uint64_t)rdreg->count << KVM_VGIC_V3_RDIST_COUNT_SHIFT;

I still think this is a clear NULL-pointer dereference.  It's also
wrong, as you use & where you want to use |.

You should also change the types you use above.

Could you please have a look at my last reply to this patch (I'm happy
to re-send if it got lost somehow) where I suggest how you can handle
this?

Thanks,
-Christoffer

> +		break;
> +	}
>  	default:
>  		r = -ENODEV;
>  	}
> @@ -674,6 +711,7 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
>  		switch (attr->attr) {
>  		case KVM_VGIC_V3_ADDR_TYPE_DIST:
>  		case KVM_VGIC_V3_ADDR_TYPE_REDIST:
> +		case KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION:
>  			return 0;
>  		}
>  		break;
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index df23e66..f603fdf 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -770,11 +770,11 @@ static int vgic_v3_insert_redist_region(struct kvm *kvm, uint32_t index,
>  	return ret;
>  }
>  
> -int vgic_v3_set_redist_base(struct kvm *kvm, u64 addr)
> +int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 count)
>  {
>  	int ret;
>  
> -	ret = vgic_v3_insert_redist_region(kvm, 0, addr, 0);
> +	ret = vgic_v3_insert_redist_region(kvm, index, addr, count);
>  	if (ret)
>  		return ret;
>  
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 95b8345..0a95b43 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -96,6 +96,13 @@
>  /* we only support 64 kB translation table page size */
>  #define KVM_ITS_L1E_ADDR_MASK		GENMASK_ULL(51, 16)
>  
> +#define KVM_VGIC_V3_RDIST_INDEX_MASK	GENMASK_ULL(11, 0)
> +#define KVM_VGIC_V3_RDIST_FLAGS_MASK	GENMASK_ULL(15, 12)
> +#define KVM_VGIC_V3_RDIST_FLAGS_SHIFT	12
> +#define KVM_VGIC_V3_RDIST_BASE_MASK	GENMASK_ULL(51, 16)
> +#define KVM_VGIC_V3_RDIST_COUNT_MASK	GENMASK_ULL(63, 52)
> +#define KVM_VGIC_V3_RDIST_COUNT_SHIFT	52
> +
>  /* Requires the irq_lock to be held by the caller. */
>  static inline bool irq_is_pending(struct vgic_irq *irq)
>  {
> @@ -201,7 +208,7 @@ int vgic_v3_probe(const struct gic_kvm_info *info);
>  int vgic_v3_map_resources(struct kvm *kvm);
>  int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq);
>  int vgic_v3_save_pending_tables(struct kvm *kvm);
> -int vgic_v3_set_redist_base(struct kvm *kvm, u64 addr);
> +int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 count);
>  int vgic_register_redist_iodev(struct kvm_vcpu *vcpu);
>  bool vgic_v3_check_base(struct kvm *kvm);
>  
> -- 
> 2.5.5
> 
