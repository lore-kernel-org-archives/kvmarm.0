From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 07/21] arm64: KVM: Implement 32bit system register
 save/restore
Date: Tue, 1 Dec 2015 16:52:53 +0100
Message-ID: <20151201155253.GA10478@cbox>
References: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com>
 <1448650215-15218-8-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA32C499E8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2015 10:50:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8x42Lbb61nPd for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Dec 2015 10:50:58 -0500 (EST)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E734F498AB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2015 10:50:57 -0500 (EST)
Received: by wmvv187 with SMTP id v187so213435695wmv.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Dec 2015 07:52:21 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1448650215-15218-8-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Nov 27, 2015 at 06:50:01PM +0000, Marc Zyngier wrote:
> Implement the 32bit system register save restore as a direct
> translation of the assembly code version.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/hyp/hyp.h       |  2 ++
>  arch/arm64/kvm/hyp/sysreg-sr.c | 41 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 43 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
> index 087d3a5..4639330 100644
> --- a/arch/arm64/kvm/hyp/hyp.h
> +++ b/arch/arm64/kvm/hyp/hyp.h
> @@ -38,6 +38,8 @@ void __timer_restore_state(struct kvm_vcpu *vcpu);
>  
>  void __sysreg_save_state(struct kvm_cpu_context *ctxt);
>  void __sysreg_restore_state(struct kvm_cpu_context *ctxt);
> +void __sysreg32_save_state(struct kvm_vcpu *vcpu);
> +void __sysreg32_restore_state(struct kvm_vcpu *vcpu);
>  
>  #endif /* __ARM64_KVM_HYP_H__ */
>  
> diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> index add8fcb..3f81a4d 100644
> --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> @@ -88,3 +88,44 @@ void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
>  	write_sysreg(ctxt->gp_regs.elr_el1,	elr_el1);
>  	write_sysreg(ctxt->gp_regs.spsr[KVM_SPSR_EL1], spsr_el1);
>  }
> +
> +void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
> +{
> +	if (!(read_sysreg(hcr_el2) & HCR_RW)) {

nit: I would probably invert the check and return early.

> +		u64 *spsr = vcpu->arch.ctxt.gp_regs.spsr;
> +		u64 *sysreg = vcpu->arch.ctxt.sys_regs;
> +
> +		spsr[KVM_SPSR_ABT] = read_sysreg(spsr_abt);
> +		spsr[KVM_SPSR_UND] = read_sysreg(spsr_und);
> +		spsr[KVM_SPSR_IRQ] = read_sysreg(spsr_irq);
> +		spsr[KVM_SPSR_FIQ] = read_sysreg(spsr_fiq);
> +
> +		sysreg[DACR32_EL2] = read_sysreg(dacr32_el2);
> +		sysreg[IFSR32_EL2] = read_sysreg(ifsr32_el2);
> +
> +		if (!(read_sysreg(cptr_el2) & CPTR_EL2_TFP))
> +			sysreg[FPEXC32_EL2] = read_sysreg(fpexc32_el2);
> +
> +		if (vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY)
> +			sysreg[DBGVCR32_EL2] = read_sysreg(dbgvcr32_el2);
> +	}
> +}
> +
> +void __hyp_text __sysreg32_restore_state(struct kvm_vcpu *vcpu)
> +{
> +	if (!(read_sysreg(hcr_el2) & HCR_RW)) {

same here

> +		u64 *spsr = vcpu->arch.ctxt.gp_regs.spsr;
> +		u64 *sysreg = vcpu->arch.ctxt.sys_regs;
> +
> +		write_sysreg(spsr[KVM_SPSR_ABT], spsr_abt);
> +		write_sysreg(spsr[KVM_SPSR_UND], spsr_und);
> +		write_sysreg(spsr[KVM_SPSR_IRQ], spsr_irq);
> +		write_sysreg(spsr[KVM_SPSR_FIQ], spsr_fiq);
> +			                         

nit: white space

> +		write_sysreg(sysreg[DACR32_EL2], dacr32_el2);
> +		write_sysreg(sysreg[IFSR32_EL2], ifsr32_el2);
> +
> +		if (vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY)
> +			write_sysreg(sysreg[DBGVCR32_EL2], dbgvcr32_el2);
> +	}
> +}
> -- 
> 2.1.4
> 

Otherwise:

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
