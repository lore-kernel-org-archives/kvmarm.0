From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v2 13/17] kvm: arm/arm64: Allow tuning the physical
 address size for VM
Date: Wed, 25 Apr 2018 17:10:12 +0100
Message-ID: <81e98b32-8c13-3688-209f-2d51b2237748@arm.com>
References: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
 <1522156531-28348-14-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1522156531-28348-14-git-send-email-suzuki.poulose@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: mark.rutland@arm.com, peter.maydell@linaro.org, ard.biesheuvel@linaro.org, cdall@kernel.org, kvm@vger.kernel.org, rkrcmar@redhat.com, marc.zyngier@arm.com, catalin.marinas@arm.com, punit.agrawal@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Suzuki,

On 27/03/18 14:15, Suzuki K Poulose wrote:
> Allow specifying the physical address size for a new VM via
> the kvm_type argument for KVM_CREATE_VM ioctl. This allows
> us to finalise the stage2 page table format as early as possible
> and hence perform the right checks on the memory slots without
> complication. The size is encoded as Log2(PA_Siz) in the bits[7:0]

s/PA_Siz/PA_Size/.

> of the type field and can encode more information in the future if
> required.
> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <cdall@kernel.org>
> Cc: Peter Maydel <peter.maydell@linaro.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   arch/arm/include/asm/kvm_mmu.h   |  2 ++
>   arch/arm64/include/asm/kvm_mmu.h |  2 ++
>   include/uapi/linux/kvm.h         | 10 ++++++++++
>   virt/kvm/arm/arm.c               | 24 ++++++++++++++++++++++--
>   4 files changed, 36 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
> index 50896da..3f13827 100644
> --- a/arch/arm/include/asm/kvm_mmu.h
> +++ b/arch/arm/include/asm/kvm_mmu.h
> @@ -323,6 +323,8 @@ static inline u32 kvm_get_ipa_limit(void)
>   	return KVM_PHYS_SHIFT;
>   }
>   
> +static inline void kvm_config_stage2(struct kvm *kvm, u32 ipa_shift) {}
> +
>   #endif	/* !__ASSEMBLY__ */
>   
>   #endif /* __ARM_KVM_MMU_H__ */
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index a4c8c00..bb458bf 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -416,5 +416,7 @@ static inline u32 kvm_get_ipa_limit(void)
>   	return KVM_PHYS_SHIFT;
>   }
>   
> +static inline void kvm_config_stage2(struct kvm *kvm, u32 ipa_shift) {}
> +
>   #endif /* __ASSEMBLY__ */
>   #endif /* __ARM64_KVM_MMU_H__ */
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index b737ee1..67b09b0 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -740,6 +740,16 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_S390_SIE_PAGE_OFFSET 1
>   
>   /*
> + * On arm/arm64, machine type can be used to request the physical
> + * address size for the VM. Bits [7-0] have been reserved for the
> + * PA size shift (i.e, log2(PA-Size)). For backward compatibility,

I would s/PA-Size/PA_Size/ to avoid the impression that it is a 
substraction.

> + * value 0 implies the default IPA size, which is 40bits.
> + */
> +#define KVM_VM_TYPE_ARM_PHYS_SHIFT_MASK	0xff
> +#define KVM_VM_TYPE_ARM_PHYS_SHIFT(x)		\
> +	((x) & KVM_VM_TYPE_ARM_PHYS_SHIFT_MASK)
> +
> +/*
>    * ioctls for /dev/kvm fds:
>    */
>   #define KVM_GET_API_VERSION       _IO(KVMIO,   0x00)
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 53bb05c..13eb66f 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -110,6 +110,25 @@ void kvm_arch_check_processor_compat(void *rtn)
>   }
>   
>   
> +static int kvm_arch_config_vm(struct kvm *kvm, unsigned long type)
> +{
> +	u32 ipa_shift = (u32)type & KVM_VM_TYPE_ARM_PHYS_SHIFT_MASK;

How about using KVM_VM_TYPE_ARM_PHYS_SHIFT(type) directly here?

I am not entirely sure whether the cast is necessary. If it is, then I 
think you want to add it in KVM_VM_TYPE_ARM_PHYS_SHIFT(...) as well.

> +
> +	/*
> +	 * Make sure the size, if specified, is within the range of
> +	 * default size and supported maximum limit.
> +	 */
> +	if (ipa_shift) {
> +		if (ipa_shift < KVM_PHYS_SHIFT || ipa_shift > kvm_ipa_limit)
> +			return -EINVAL;
> +	} else {
> +		ipa_shift = KVM_PHYS_SHIFT;
> +	}
> +
> +	kvm_config_stage2(kvm, ipa_shift);
> +	return 0;
> +}
> +
>   /**
>    * kvm_arch_init_vm - initializes a VM data structure
>    * @kvm:	pointer to the KVM struct
> @@ -118,8 +137,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   {
>   	int ret, cpu;
>   
> -	if (type)
> -		return -EINVAL;
> +	ret = kvm_arch_config_vm(kvm, type);
> +	if (ret)
> +		return ret;
>   
>   	kvm->arch.last_vcpu_ran = alloc_percpu(typeof(*kvm->arch.last_vcpu_ran));
>   	if (!kvm->arch.last_vcpu_ran)
> 

Cheers,

-- 
Julien Grall
