From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 1/2] add hooks for armv8 fp/simd lazy switch
Date: Mon, 26 Oct 2015 15:32:45 +0100
Message-ID: <20151026143245.GC20298@cbox>
References: <1444098794-19244-1-git-send-email-m.smarduch@samsung.com>
 <1444098794-19244-2-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1444098794-19244-2-git-send-email-m.smarduch@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, antonios.motakis@huawei.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 05, 2015 at 07:33:13PM -0700, Mario Smarduch wrote:
> This patch adds hooks to support fp/simd lazy switch. A vcpu flag to track
> fp/simd state, and flag offset in vcpu structure.
> 
> Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 3 +++
>  arch/arm64/kernel/asm-offsets.c   | 1 +
>  2 files changed, 4 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 4562459..03f25d0 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -157,6 +157,9 @@ struct kvm_vcpu_arch {
>  	/* Interrupt related fields */
>  	u64 irq_lines;		/* IRQ and FIQ levels */
>  
> +	/* Track fp/simd lazy switch */
> +	u32 vfp_lazy;
> +


like for the 32-bit patch set I think this could have a more meaningful
name with more clearly defined semantics, e.g. vfp_host_dirty.  You
could also call it vfp_flags like the debug flags and define a specific
flag for your use...

Thanks,
-Christoffer


>  	/* Cache some mmu pages needed inside spinlock regions */
>  	struct kvm_mmu_memory_cache mmu_page_cache;
>  
> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
> index 8d89cf8..8311da4 100644
> --- a/arch/arm64/kernel/asm-offsets.c
> +++ b/arch/arm64/kernel/asm-offsets.c
> @@ -124,6 +124,7 @@ int main(void)
>    DEFINE(VCPU_HCR_EL2,		offsetof(struct kvm_vcpu, arch.hcr_el2));
>    DEFINE(VCPU_MDCR_EL2,	offsetof(struct kvm_vcpu, arch.mdcr_el2));
>    DEFINE(VCPU_IRQ_LINES,	offsetof(struct kvm_vcpu, arch.irq_lines));
> +  DEFINE(VCPU_VFP_LAZY,         offsetof(struct kvm_vcpu, arch.vfp_lazy));
>    DEFINE(VCPU_HOST_CONTEXT,	offsetof(struct kvm_vcpu, arch.host_cpu_context));
>    DEFINE(VCPU_HOST_DEBUG_STATE, offsetof(struct kvm_vcpu, arch.host_debug_state));
>    DEFINE(VCPU_TIMER_CNTV_CTL,	offsetof(struct kvm_vcpu, arch.timer_cpu.cntv_ctl));
> -- 
> 1.9.1
> 
