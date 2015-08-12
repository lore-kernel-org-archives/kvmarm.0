From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v2 04/15] KVM: arm/arm64: extend arch CAP checks to allow
 per-VM capabilities
Date: Wed, 12 Aug 2015 14:26:34 +0200
Message-ID: <55CB3B7A.3070300@linaro.org>
References: <1436538111-4294-1-git-send-email-andre.przywara@arm.com> <1436538111-4294-5-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1436538111-4294-5-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, marc.zyngier@arm.com, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu
Cc: Pavel Fedin <p.fedin@samsung.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Reviewed-by: Eric Auger <eric.auger@linaro.org>

Best Regards

Eric

On 07/10/2015 04:21 PM, Andre Przywara wrote:
> KVM capabilities can be a per-VM property, though ARM/ARM64 currently
> does not pass on the VM pointer to the architecture specific
> capability handlers.
> Add a "struct kvm*" parameter to those function to later allow proper
> per-VM capability reporting.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arch/arm/include/asm/kvm_host.h   | 2 +-
>  arch/arm/kvm/arm.c                | 2 +-
>  arch/arm64/include/asm/kvm_host.h | 2 +-
>  arch/arm64/kvm/reset.c            | 2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index e896d2c..56cac05 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -213,7 +213,7 @@ static inline void __cpu_init_hyp_mode(phys_addr_t boot_pgd_ptr,
>  	kvm_call_hyp((void*)hyp_stack_ptr, vector_ptr, pgd_ptr);
>  }
>  
> -static inline int kvm_arch_dev_ioctl_check_extension(long ext)
> +static inline int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
>  {
>  	return 0;
>  }
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index bc738d2..7c65353 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -196,7 +196,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		r = KVM_MAX_VCPUS;
>  		break;
>  	default:
> -		r = kvm_arch_dev_ioctl_check_extension(ext);
> +		r = kvm_arch_dev_ioctl_check_extension(kvm, ext);
>  		break;
>  	}
>  	return r;
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 2709db2..8d78a72 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -47,7 +47,7 @@
>  
>  int __attribute_const__ kvm_target_cpu(void);
>  int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
> -int kvm_arch_dev_ioctl_check_extension(long ext);
> +int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext);
>  
>  struct kvm_arch {
>  	/* The VMID generation used for the virt. memory system */
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 0b43265..866502b 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -56,7 +56,7 @@ static bool cpu_has_32bit_el1(void)
>  	return !!(pfr0 & 0x20);
>  }
>  
> -int kvm_arch_dev_ioctl_check_extension(long ext)
> +int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
>  {
>  	int r;
>  
> 

