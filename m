From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 15/21] KVM: arm64: Set an impdef ESR for
 Virtual-SError using VSESR_EL2.
Date: Mon, 30 Oct 2017 08:59:51 +0100
Message-ID: <20171030075951.GT2166@lvm>
References: <20171019145807.23251-1-james.morse@arm.com>
 <20171019145807.23251-16-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 09E4B49D1A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Oct 2017 03:58:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VGaKnk6OcWob for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Oct 2017 03:58:29 -0400 (EDT)
Received: from mail-lf0-f65.google.com (mail-lf0-f65.google.com
 [209.85.215.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E6556406D0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Oct 2017 03:58:28 -0400 (EDT)
Received: by mail-lf0-f65.google.com with SMTP id k40so13841707lfi.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Oct 2017 01:00:01 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20171019145807.23251-16-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Julien Thierry <julien.thierry@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, linux-arm-kernel@lists.infradead.org, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 19, 2017 at 03:58:01PM +0100, James Morse wrote:
> Prior to v8.2's RAS Extensions, the HCR_EL2.VSE 'virtual SError' feature
> generated an SError with an implementation defined ESR_EL1.ISS, because we
> had no mechanism to specify the ESR value.
> 
> On Juno this generates an all-zero ESR, the most significant bit 'ISV'
> is clear indicating the remainder of the ISS field is invalid.
> 
> With the RAS Extensions we have a mechanism to specify this value, and the
> most significant bit has a new meaning: 'IDS - Implementation Defined
> Syndrome'. An all-zero SError ESR now means: 'RAS error: Uncategorized'
> instead of 'no valid ISS'.
> 
> Add KVM support for the VSESR_EL2 register to specify an ESR value when
> HCR_EL2.VSE generates a virtual SError. Change kvm_inject_vabt() to
> specify an implementation-defined value.
> 
> We only need to restore the VSESR_EL2 value when HCR_EL2.VSE is set, KVM
> save/restores this bit during __deactivate_traps() and hardware clears the
> bit once the guest has consumed the virtual-SError.
> 
> Future patches may add an API (or KVM CAP) to pend a virtual SError with
> a specified ESR.
> 
> Cc: Dongjiu Geng <gengdongjiu@huawei.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
>  arch/arm64/include/asm/kvm_emulate.h |  5 +++++
>  arch/arm64/include/asm/kvm_host.h    |  3 +++
>  arch/arm64/include/asm/sysreg.h      |  1 +
>  arch/arm64/kvm/hyp/switch.c          |  4 ++++
>  arch/arm64/kvm/inject_fault.c        | 13 ++++++++++++-
>  5 files changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index e5df3fce0008..8a7a838eb17a 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -61,6 +61,11 @@ static inline void vcpu_set_hcr(struct kvm_vcpu *vcpu, unsigned long hcr)
>  	vcpu->arch.hcr_el2 = hcr;
>  }
>  
> +static inline void vcpu_set_vsesr(struct kvm_vcpu *vcpu, u64 vsesr)
> +{
> +	vcpu->arch.vsesr_el2 = vsesr;
> +}
> +
>  static inline unsigned long *vcpu_pc(const struct kvm_vcpu *vcpu)
>  {
>  	return (unsigned long *)&vcpu_gp_regs(vcpu)->regs.pc;
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index a0e2f7962401..28a4de85edee 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -277,6 +277,9 @@ struct kvm_vcpu_arch {
>  
>  	/* Detect first run of a vcpu */
>  	bool has_run_once;
> +
> +	/* Virtual SError ESR to restore when HCR_EL2.VSE is set */
> +	u64 vsesr_el2;
>  };
>  
>  #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 427c36bc5dd6..a493e93de296 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -253,6 +253,7 @@
>  
>  #define SYS_DACR32_EL2			sys_reg(3, 4, 3, 0, 0)
>  #define SYS_IFSR32_EL2			sys_reg(3, 4, 5, 0, 1)
> +#define SYS_VSESR_EL2			sys_reg(3, 4, 5, 2, 3)
>  #define SYS_FPEXC32_EL2			sys_reg(3, 4, 5, 3, 0)
>  
>  #define __SYS__AP0Rx_EL2(x)		sys_reg(3, 4, 12, 8, x)
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 945e79c641c4..af37658223a0 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -86,6 +86,10 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
>  		isb();
>  	}
>  	write_sysreg(val, hcr_el2);
> +
> +	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN) && (val & HCR_VSE))
> +		write_sysreg_s(vcpu->arch.vsesr_el2, SYS_VSESR_EL2);
> +

Just a heads up: If my optimization work gets merged, that will
eventually move stuff like this in to load/put hooks for system
registers, but I can deal with this easily, also adding a direct write
in pend_guest_serror when moving the logic around.

However, if we start architecting something more complex, it would be
good to keep in mind how to maintain minimum work on the switching path
after we've optimized the hypervisor.

>  	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
>  	write_sysreg(1 << 15, hstr_el2);
>  	/*
> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> index da6a8cfa54a0..52f7f66f1356 100644
> --- a/arch/arm64/kvm/inject_fault.c
> +++ b/arch/arm64/kvm/inject_fault.c
> @@ -232,14 +232,25 @@ void kvm_inject_undefined(struct kvm_vcpu *vcpu)
>  		inject_undef64(vcpu);
>  }
>  
> +static void pend_guest_serror(struct kvm_vcpu *vcpu, u64 esr)
> +{
> +	vcpu_set_vsesr(vcpu, esr);
> +	vcpu_set_hcr(vcpu, vcpu_get_hcr(vcpu) | HCR_VSE);
> +}
> +
>  /**
>   * kvm_inject_vabt - inject an async abort / SError into the guest
>   * @vcpu: The VCPU to receive the exception
>   *
>   * It is assumed that this code is called from the VCPU thread and that the
>   * VCPU therefore is not currently executing guest code.
> + *
> + * Systems with the RAS Extensions specify an imp-def ESR (ISV/IDS = 1) with
> + * the remaining ISS all-zeros so that this error is not interpreted as an
> + * uncatagorized RAS error. Without the RAS Extensions we can't specify an ESR

nit: uncategorized

> + * value, so the CPU generates an imp-def value.
>   */
>  void kvm_inject_vabt(struct kvm_vcpu *vcpu)
>  {
> -	vcpu_set_hcr(vcpu, vcpu_get_hcr(vcpu) | HCR_VSE);
> +	pend_guest_serror(vcpu, ESR_ELx_ISV);
>  }
> -- 
> 2.13.3
> 

Otherwise:

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
