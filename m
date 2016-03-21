From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] kvm: arm64: Disable compiler instrumentation for
 hypervisor code
Date: Mon, 21 Mar 2016 14:01:19 +0100
Message-ID: <20160321130119.GB16859@cbox>
References: <1458558017-6414-1-git-send-email-catalin.marinas@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1458558017-6414-1-git-send-email-catalin.marinas@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 21, 2016 at 11:00:17AM +0000, Catalin Marinas wrote:
> With the recent rewrite of the arm64 KVM hypervisor code in C, enabling
> certain options like KASAN would allow the compiler to generate memory
> accesses or function calls to addresses not mapped at EL2. This patch
> disables the compiler instrumentation on the arm64 hypervisor code for
> gcov-based profiling (GCOV_KERNEL), undefined behaviour sanity checker
> (UBSAN) and kernel address sanitizer (KASAN).
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: <stable@vger.kernel.org> # 4.5+

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

Applied, thanks.
-Christoffer

> ---
> 
> A better fix, at least for KASAN, would be nice but that's a lot more
> intrusive as we need to map the KASAN shadow into the EL2 space. In the
> meantime, especially since it needs backporting to 4.5, this patch would
> solve KASAN getting stuck with KVM (similar to what we do for EFI_STUB).
> 
>  arch/arm64/kvm/hyp/Makefile | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
> index 826032bc3945..acde4782621a 100644
> --- a/arch/arm64/kvm/hyp/Makefile
> +++ b/arch/arm64/kvm/hyp/Makefile
> @@ -12,3 +12,7 @@ obj-$(CONFIG_KVM_ARM_HOST) += switch.o
>  obj-$(CONFIG_KVM_ARM_HOST) += fpsimd.o
>  obj-$(CONFIG_KVM_ARM_HOST) += tlb.o
>  obj-$(CONFIG_KVM_ARM_HOST) += hyp-entry.o
> +
> +GCOV_PROFILE	:= n
> +KASAN_SANITIZE	:= n
> +UBSAN_SANITIZE	:= n
