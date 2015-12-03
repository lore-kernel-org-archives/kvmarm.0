From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 1/3] KVM/arm/arm64: add hooks for armv7 fp/simd lazy
 switch support
Date: Thu, 03 Dec 2015 15:46:06 +0000
Message-ID: <566063BE.7080005@arm.com>
References: <1447539130-4613-1-git-send-email-m.smarduch@samsung.com> <1447539130-4613-2-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1447539130-4613-2-git-send-email-m.smarduch@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Mario Smarduch <m.smarduch@samsung.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, antonios.motakis@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 14/11/15 22:12, Mario Smarduch wrote:
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
> index 3df1e97..f1bf551 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -107,6 +107,12 @@ struct kvm_vcpu_arch {
>  	/* Interrupt related fields */
>  	u32 irq_lines;		/* IRQ and FIQ levels */
>  
> +	/* fp/simd dirty flag true if guest accessed register file */
> +	bool    vfp_dirty;

I think we do not need this bool, because it is already represented by
the state of the trapping bits.

> +
> +	/* Save host FPEXC register to later restore on vcpu put */
> +	u32	host_fpexc;
> +
>  	/* Exception Information */
>  	struct kvm_vcpu_fault_info fault;
>  
> diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
> index 871b826..9f79712 100644
> --- a/arch/arm/kernel/asm-offsets.c
> +++ b/arch/arm/kernel/asm-offsets.c
> @@ -186,6 +186,8 @@ int main(void)
>    DEFINE(VCPU_CPSR,		offsetof(struct kvm_vcpu, arch.regs.usr_regs.ARM_cpsr));
>    DEFINE(VCPU_HCR,		offsetof(struct kvm_vcpu, arch.hcr));
>    DEFINE(VCPU_IRQ_LINES,	offsetof(struct kvm_vcpu, arch.irq_lines));
> +  DEFINE(VCPU_VFP_DIRTY,	offsetof(struct kvm_vcpu, arch.vfp_dirty));
> +  DEFINE(VCPU_VFP_HOST_FPEXC,	offsetof(struct kvm_vcpu, arch.host_fpexc));
>    DEFINE(VCPU_HSR,		offsetof(struct kvm_vcpu, arch.fault.hsr));
>    DEFINE(VCPU_HxFAR,		offsetof(struct kvm_vcpu, arch.fault.hxfar));
>    DEFINE(VCPU_HPFAR,		offsetof(struct kvm_vcpu, arch.fault.hpfar));
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
