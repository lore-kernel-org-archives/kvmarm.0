From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH] arm64: KVM: Turn kvm_ksym_ref into a NOP on VHE
Date: Fri, 18 Mar 2016 17:41:19 +0000
Message-ID: <56EC3DBF.1060600@arm.com>
References: <1458321959-11728-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1458321959-11728-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 18/03/16 17:25, Marc Zyngier wrote:
> When running with VHE, there is no need to translate kernel pointers
> to the EL2 memory space, since we're already there (and we have a much
> saner memory map to start with).
>
> Unfortunately, kvm_ksym_ref is getting in the way, and the first
> call into the "hypervisor" section is going to end up in fireworks,
> since we're now branching into nowhereland. Meh.
>
> A potential solution is to test if VHE is engaged or not, and only
> perform the translation in the negative case. With this in place,
> VHE is able to run again.
>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>   arch/arm64/include/asm/kvm_asm.h | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 226f49d..282f907 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -26,7 +26,13 @@
>   #define KVM_ARM64_DEBUG_DIRTY_SHIFT	0
>   #define KVM_ARM64_DEBUG_DIRTY		(1 << KVM_ARM64_DEBUG_DIRTY_SHIFT)
>
> -#define kvm_ksym_ref(sym)		phys_to_virt((u64)&sym - kimage_voffset)
> +#define kvm_ksym_ref(sym)						\
> +	({								\
> +		void *val = sym;					\
> +		if (!is_kernel_in_hyp_mode())				\
> +			val = phys_to_virt((u64)&sym - kimage_voffset);	\

Is it definitely OK to evaluate sym twice here?

Robin.

> +		val;							\
> +	 })
>
>   #ifndef __ASSEMBLY__
>   struct kvm;
>

