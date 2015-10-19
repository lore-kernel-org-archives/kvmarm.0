From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 1/2] KVM/arm: add hooks for armv7 fp/simd lazy switch
 support
Date: Mon, 19 Oct 2015 10:53:32 +0200
Message-ID: <20151019085332.GA24104@cbox>
References: <1443311009-4811-1-git-send-email-m.smarduch@samsung.com>
 <1443311009-4811-2-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1443311009-4811-2-git-send-email-m.smarduch@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, antonios.motakis@huawei.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Sep 26, 2015 at 04:43:28PM -0700, Mario Smarduch wrote:
> This patch adds vcpu fields to track lazy state, save host FPEXC, and 
> offsets to fields.
> 
> Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
> ---
>  arch/arm/include/asm/kvm_host.h | 6 ++++++
>  arch/arm/kernel/asm-offsets.c   | 2 ++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index dcba0fa..194a8ef 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -111,6 +111,12 @@ struct kvm_vcpu_arch {
>  	/* Interrupt related fields */
>  	u32 irq_lines;		/* IRQ and FIQ levels */
>  
> +	/* Track fp/simd lazy switch state */
> +	u32 vfp_lazy;

so is this a flags field or basically a boolean?  If the latter, what is
does it mean when the field is true vs. false?

> +
> +	/* Save host FPEXC register to restore on vcpu put */
> +	u32 saved_fpexc;

is this only the host's state?  If so, why not name it host_fpexc?

Thanks,
-Christoffer

> +
>  	/* Exception Information */
>  	struct kvm_vcpu_fault_info fault;
>  
> diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
> index 871b826..e1c3a41 100644
> --- a/arch/arm/kernel/asm-offsets.c
> +++ b/arch/arm/kernel/asm-offsets.c
> @@ -186,6 +186,8 @@ int main(void)
>    DEFINE(VCPU_CPSR,		offsetof(struct kvm_vcpu, arch.regs.usr_regs.ARM_cpsr));
>    DEFINE(VCPU_HCR,		offsetof(struct kvm_vcpu, arch.hcr));
>    DEFINE(VCPU_IRQ_LINES,	offsetof(struct kvm_vcpu, arch.irq_lines));
> +  DEFINE(VCPU_VFP_LAZY,		offsetof(struct kvm_vcpu, arch.vfp_lazy));
> +  DEFINE(VCPU_VFP_FPEXC,	offsetof(struct kvm_vcpu, arch.saved_fpexc));
>    DEFINE(VCPU_HSR,		offsetof(struct kvm_vcpu, arch.fault.hsr));
>    DEFINE(VCPU_HxFAR,		offsetof(struct kvm_vcpu, arch.fault.hxfar));
>    DEFINE(VCPU_HPFAR,		offsetof(struct kvm_vcpu, arch.fault.hpfar));
> -- 
> 1.9.1
> 
