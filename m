From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2] KVM: arm/arm64: vgic-new: fix overlap check for
 device addresses
Date: Thu, 12 May 2016 21:43:03 +0200
Message-ID: <20160512194303.GV27623@cbox>
References: <5731DF3C.6020201@arm.com>
 <1462900726-14666-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1462900726-14666-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 10, 2016 at 06:18:46PM +0100, Andre Przywara wrote:
> When userland sets the base addresses for the GIC register frames,
> the kernel tries to make sure that the regions for the distributor and
> the one for the CPU interface or the redistributors do not overlap.
> Currently this check only works properly for GICv2.
> For a GICv3 we need the number of VCPUs to compute the size of the
> redistributor region, which we only know for sure at init time.
> So move the overlap check from kvm_vgic_addr() to the model specific
> map_resources() implementation.
> This also allows us to simplify the existing checking code a bit.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Hi,
> 
> so another rework, now hopefully really covering GICv3 properly.
> For consistency I also moved the GICv2 check to init time. This is
> a slightly different behaviour, but shouldn't make a difference, as
> the init call can fail as well - for instance if no addresses have been
> set up at all.
> 
> Cheers,
> Andre.
> 
>  virt/kvm/arm/vgic/vgic-kvm-device.c | 50 ++++++++-----------------------------
>  virt/kvm/arm/vgic/vgic-v2.c         | 22 ++++++++++++++++
>  virt/kvm/arm/vgic/vgic-v3.c         | 27 ++++++++++++++++++++
>  3 files changed, 60 insertions(+), 39 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
> index 2122ff2..9e736a7 100644
> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> @@ -19,43 +19,19 @@
>  #include <asm/kvm_mmu.h>
>  #include "vgic.h"
>  
> -/* common helpers */
> -
> -static int vgic_ioaddr_overlap(struct kvm *kvm)
> -{
> -	phys_addr_t dist = kvm->arch.vgic.vgic_dist_base;
> -	phys_addr_t cpu = kvm->arch.vgic.vgic_cpu_base;
> -
> -	if (IS_VGIC_ADDR_UNDEF(dist) || IS_VGIC_ADDR_UNDEF(cpu))
> -		return 0;
> -	if ((dist <= cpu && dist + KVM_VGIC_V2_DIST_SIZE > cpu) ||
> -	    (cpu <= dist && cpu + KVM_VGIC_V2_CPU_SIZE > dist))
> -		return -EBUSY;
> -	return 0;
> -}
> -
> -static int vgic_ioaddr_assign(struct kvm *kvm, phys_addr_t *ioaddr,
> -			      phys_addr_t addr, phys_addr_t size)
> +static int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
> +			     phys_addr_t addr, phys_addr_t alignment)
>  {
> -	int ret;
> -
>  	if (addr & ~KVM_PHYS_MASK)
>  		return -E2BIG;
>  
> -	if (addr & (SZ_4K - 1))
> +	if (!IS_ALIGNED(addr, alignment))
>  		return -EINVAL;
>  
>  	if (!IS_VGIC_ADDR_UNDEF(*ioaddr))
>  		return -EEXIST;
> -	if (addr + size < addr)
> -		return -EINVAL;
> -
> -	*ioaddr = addr;
> -	ret = vgic_ioaddr_overlap(kvm);
> -	if (ret)
> -		*ioaddr = VGIC_ADDR_UNDEF;
>  
> -	return ret;
> +	return 0;
>  }
>  
>  /**
> @@ -70,40 +46,38 @@ static int vgic_ioaddr_assign(struct kvm *kvm, phys_addr_t *ioaddr,
>   * interface in the VM physical address space.  These addresses are properties
>   * of the emulated core/SoC and therefore user space initially knows this
>   * information.
> + * Check them for sanity (alignment, double assignment). We can't check for
> + * overlapping regions in case of a virtual GICv3 here, since we don't know
> + * the number of VCPUs yet, so we defer this check to map_resources().
>   */
>  int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
>  {
>  	int r = 0;
>  	struct vgic_dist *vgic = &kvm->arch.vgic;
>  	int type_needed;
> -	phys_addr_t *addr_ptr, block_size;
> -	phys_addr_t alignment;
> +	phys_addr_t *addr_ptr, alignment;
>  
>  	mutex_lock(&kvm->lock);
>  	switch (type) {
>  	case KVM_VGIC_V2_ADDR_TYPE_DIST:
>  		type_needed = KVM_DEV_TYPE_ARM_VGIC_V2;
>  		addr_ptr = &vgic->vgic_dist_base;
> -		block_size = KVM_VGIC_V2_DIST_SIZE;
>  		alignment = SZ_4K;
>  		break;
>  	case KVM_VGIC_V2_ADDR_TYPE_CPU:
>  		type_needed = KVM_DEV_TYPE_ARM_VGIC_V2;
>  		addr_ptr = &vgic->vgic_cpu_base;
> -		block_size = KVM_VGIC_V2_CPU_SIZE;
>  		alignment = SZ_4K;
>  		break;
>  #ifdef CONFIG_KVM_ARM_VGIC_V3
>  	case KVM_VGIC_V3_ADDR_TYPE_DIST:
>  		type_needed = KVM_DEV_TYPE_ARM_VGIC_V3;
>  		addr_ptr = &vgic->vgic_dist_base;
> -		block_size = KVM_VGIC_V3_DIST_SIZE;
>  		alignment = SZ_64K;
>  		break;
>  	case KVM_VGIC_V3_ADDR_TYPE_REDIST:
>  		type_needed = KVM_DEV_TYPE_ARM_VGIC_V3;
>  		addr_ptr = &vgic->vgic_redist_base;
> -		block_size = KVM_VGIC_V3_REDIST_SIZE;
>  		alignment = SZ_64K;
>  		break;
>  #endif
> @@ -118,11 +92,9 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
>  	}
>  
>  	if (write) {
> -		if (!IS_ALIGNED(*addr, alignment))
> -			r = -EINVAL;
> -		else
> -			r = vgic_ioaddr_assign(kvm, addr_ptr,
> -					       *addr, block_size);
> +		r = vgic_check_ioaddr(kvm, addr_ptr, *addr, alignment);
> +		if (!r)
> +			*addr_ptr = *addr;
>  	} else {
>  		*addr = *addr_ptr;
>  	}
> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> index 4493593..fe6e3bd 100644
> --- a/virt/kvm/arm/vgic/vgic-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-v2.c
> @@ -225,6 +225,22 @@ void vgic_v2_enable(struct kvm_vcpu *vcpu)
>  	vcpu->arch.vgic_cpu.vgic_v2.vgic_hcr = GICH_HCR_EN;
>  }
>  
> +/* check for overlapping regions and for regions crossing the end of memory */
> +static bool vgic_check_addresses(gpa_t dist_base, gpa_t cpu_base)
> +{
> +	if (dist_base + KVM_VGIC_V2_DIST_SIZE < dist_base)
> +		return false;
> +	if (cpu_base + KVM_VGIC_V2_CPU_SIZE < cpu_base)
> +		return false;
> +
> +	if (dist_base + KVM_VGIC_V2_DIST_SIZE <= cpu_base)
> +		return true;
> +	if (cpu_base + KVM_VGIC_V2_CPU_SIZE <= dist_base)
> +		return true;
> +
> +	return false;
> +}
> +
>  int vgic_v2_map_resources(struct kvm *kvm)
>  {
>  	struct vgic_dist *dist = &kvm->arch.vgic;
> @@ -240,6 +256,12 @@ int vgic_v2_map_resources(struct kvm *kvm)
>  		goto out;
>  	}
>  
> +	if (!vgic_check_addresses(dist->vgic_dist_base, dist->vgic_cpu_base)) {
> +		kvm_err("VGIC CPU and dist frames overlap\n");
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
>  	/*
>  	 * Initialize the vgic if this hasn't already been done on demand by
>  	 * accessing the vgic state from userspace.
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index 6d7422f..fa444a7 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -221,6 +221,27 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
>  	vgic_v3->vgic_hcr = ICH_HCR_EN;
>  }
>  
> +/* check for overlapping regions and for regions crossing the end of memory */
> +static bool vgic_check_addresses(struct kvm *kvm)
> +{
> +	struct vgic_dist *d = &kvm->arch.vgic;
> +	gpa_t redist_size = KVM_VGIC_V3_REDIST_SIZE;
> +
> +	redist_size = KVM_VGIC_V3_REDIST_SIZE * atomic_read(&kvm->online_vcpus);

this looks horrible IMHO, you can fit the full calculations on exactly
80 chars, which must be a sign of what was supposed to happen ;)

> +
> +	if (d->vgic_dist_base + KVM_VGIC_V3_DIST_SIZE < d->vgic_dist_base)
> +		return false;
> +	if (d->vgic_redist_base + redist_size < d->vgic_redist_base)
> +		return false;
> +
> +	if (d->vgic_dist_base + KVM_VGIC_V3_DIST_SIZE <= d->vgic_redist_base)
> +		return true;
> +	if (d->vgic_redist_base + redist_size <= d->vgic_dist_base)
> +		return true;
> +
> +	return false;
> +}
> +
>  int vgic_v3_map_resources(struct kvm *kvm)
>  {
>  	int ret = 0;
> @@ -236,6 +257,12 @@ int vgic_v3_map_resources(struct kvm *kvm)
>  		goto out;
>  	}
>  
> +	if (!vgic_check_addresses(kvm)) {
> +		kvm_err("VGIC redist and dist frames overlap\n");
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
>  	/*
>  	 * For a VGICv3 we require the userland to explicitly initialize
>  	 * the VGIC before we need to use it.
> -- 
> 2.7.3
> 

I would have named the check_addresses functions with the specific vgic
version, but anyhow:

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
