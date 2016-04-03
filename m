From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 03/12] KVM: arm64: Introduce new MMIO region for the
 ITS base address
Date: Sun, 3 Apr 2016 12:08:37 +0200
Message-ID: <20160403100837.GD5261@cbox>
References: <1458958450-19662-1-git-send-email-andre.przywara@arm.com>
 <1458958450-19662-4-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1458958450-19662-4-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Mar 26, 2016 at 02:14:01AM +0000, Andre Przywara wrote:
> The ARM GICv3 ITS controller requires a separate register frame to
> cover ITS specific registers. Add a new VGIC address type and store
> the address in a field in the vgic_dist structure.
> Provide a function to check whether userland has provided the address,
> so ITS functionality can be guarded by that check.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  Documentation/virtual/kvm/devices/arm-vgic.txt |  9 +++++++++
>  arch/arm64/include/uapi/asm/kvm.h              |  2 ++
>  include/kvm/vgic/vgic.h                        |  5 +++++
>  virt/kvm/arm/vgic/vgic.c                       | 10 ++++++++++
>  virt/kvm/arm/vgic/vgic_init.c                  |  1 +
>  virt/kvm/arm/vgic/vgic_kvm_device.c            |  7 +++++++
>  6 files changed, 34 insertions(+)
> 
> diff --git a/Documentation/virtual/kvm/devices/arm-vgic.txt b/Documentation/virtual/kvm/devices/arm-vgic.txt
> index 59541d4..087e2d9 100644
> --- a/Documentation/virtual/kvm/devices/arm-vgic.txt
> +++ b/Documentation/virtual/kvm/devices/arm-vgic.txt
> @@ -39,6 +39,15 @@ Groups:
>        Only valid for KVM_DEV_TYPE_ARM_VGIC_V3.
>        This address needs to be 64K aligned.
>  
> +    KVM_VGIC_V3_ADDR_TYPE_ITS (rw, 64-bit)
> +      Base address in the guest physical address space of the GICv3 ITS
> +      control register frame. The ITS allows MSI(-X) interrupts to be
> +      injected into guests. This extension is optional, if the kernel

s/optional, if/optional. If/

> +      does not support the ITS, the call returns -ENODEV.
> +      This memory is solely for the guest to access the ITS control

s/memory/address region/ ?

> +      registers and does not cover the ITS translation register.
> +      Only valid for KVM_DEV_TYPE_ARM_VGIC_V3.
> +      This address needs to be 64K aligned and the region covers 64 KByte.

s/KByte/KBytes/
...or you could you 64K both places in this line.

>  
>    KVM_DEV_ARM_VGIC_GRP_DIST_REGS
>    Attributes:
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index f209ea1..c2b257d 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -87,9 +87,11 @@ struct kvm_regs {
>  /* Supported VGICv3 address types  */
>  #define KVM_VGIC_V3_ADDR_TYPE_DIST	2
>  #define KVM_VGIC_V3_ADDR_TYPE_REDIST	3
> +#define KVM_VGIC_V3_ADDR_TYPE_ITS	4
>  
>  #define KVM_VGIC_V3_DIST_SIZE		SZ_64K
>  #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
> +#define KVM_VGIC_V3_ITS_SIZE		SZ_64K
>  
>  #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
>  #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
> index 7c1d145..11344e6 100644
> --- a/include/kvm/vgic/vgic.h
> +++ b/include/kvm/vgic/vgic.h
> @@ -135,6 +135,9 @@ struct vgic_dist {
>  		gpa_t			vgic_redist_base;
>  	};
>  
> +	/* The base address of the ITS control register frame */
> +	gpa_t			vgic_its_base;
> +
>  	/* distributor enabled */
>  	u32			enabled;
>  
> @@ -253,4 +256,6 @@ static inline int kvm_vgic_get_max_vcpus(void)
>  	return kvm_vgic_global_state.max_gic_vcpus;
>  }
>  
> +bool vgic_has_its(struct kvm *kvm);
> +
>  #endif /* __ASM_ARM_KVM_VGIC_VGIC_H */
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index 65395af..1de2478 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -612,3 +612,13 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, u32 intid)
>  
>  	return map_is_active;
>  }
> +
> +bool vgic_has_its(struct kvm *kvm)
> +{
> +	struct vgic_dist *dist = &kvm->arch.vgic;
> +
> +	if (dist->vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
> +		return false;
> +
> +	return !IS_VGIC_ADDR_UNDEF(dist->vgic_its_base);
> +}
> diff --git a/virt/kvm/arm/vgic/vgic_init.c b/virt/kvm/arm/vgic/vgic_init.c
> index ac655b5..2301e03 100644
> --- a/virt/kvm/arm/vgic/vgic_init.c
> +++ b/virt/kvm/arm/vgic/vgic_init.c
> @@ -132,6 +132,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
>  	kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;
>  	kvm->arch.vgic.vgic_cpu_base = VGIC_ADDR_UNDEF;
>  	kvm->arch.vgic.vgic_redist_base = VGIC_ADDR_UNDEF;
> +	kvm->arch.vgic.vgic_its_base = VGIC_ADDR_UNDEF;
>  
>  out_unlock:
>  	for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
> diff --git a/virt/kvm/arm/vgic/vgic_kvm_device.c b/virt/kvm/arm/vgic/vgic_kvm_device.c
> index 7f78a16..3ec2ac3 100644
> --- a/virt/kvm/arm/vgic/vgic_kvm_device.c
> +++ b/virt/kvm/arm/vgic/vgic_kvm_device.c
> @@ -109,6 +109,12 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
>  		block_size = KVM_VGIC_V3_REDIST_SIZE;
>  		alignment = SZ_64K;
>  		break;
> +	case KVM_VGIC_V3_ADDR_TYPE_ITS:
> +		type_needed = KVM_DEV_TYPE_ARM_VGIC_V3;
> +		addr_ptr = &vgic->vgic_its_base;
> +		block_size = KVM_VGIC_V3_ITS_SIZE;
> +		alignment = SZ_64K;
> +		break;
>  #endif
>  	default:
>  		r = -ENODEV;
> @@ -495,6 +501,7 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
>  		switch (attr->attr) {
>  		case KVM_VGIC_V3_ADDR_TYPE_DIST:
>  		case KVM_VGIC_V3_ADDR_TYPE_REDIST:
> +		case KVM_VGIC_V3_ADDR_TYPE_ITS:
>  			return 0;
>  		}
>  		break;
> -- 
> 2.7.3
> 
