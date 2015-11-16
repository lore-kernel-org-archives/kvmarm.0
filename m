From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 15/21] arm64: KVM: Add panic handling
Date: Mon, 16 Nov 2015 14:16:29 +0000
Message-ID: <20151116141629.GH20696@leverpostej>
References: <1447679519-17888-1-git-send-email-marc.zyngier@arm.com>
 <1447679519-17888-16-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1447679519-17888-16-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <marc.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 06d3e20..cdc2a96 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -140,3 +140,38 @@ int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
>  
>  	return exit_code;
>  }
> +
> +static const char *__hyp_panic_string = "HYP panic:\nPS:%08x PC:%p ESR:%p\nFAR:%p HPFAR:%p PAR:%p\nVCPU:%p\n";

I assume that if [1] goes in we'll update this to match.

> +
> +void __hyp_text __noreturn __hyp_panic(void)
> +{
> +	u64 spsr = read_sysreg(spsr_el2);
> +	u64 elr = read_sysreg(elr_el2);
> +	u64 par = read_sysreg(par_el1);
> +
> +	if (read_sysreg(vttbr_el2)) {
> +		struct kvm_vcpu *vcpu;
> +		struct kvm_cpu_context *host_ctxt;
> +
> +		vcpu = (struct kvm_vcpu *)read_sysreg(tpidr_el2);
> +		host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> +		__deactivate_traps(vcpu);
> +		__deactivate_vm(vcpu);
> +		__sysreg_restore_state(host_ctxt);
> +
> +		write_sysreg(host_ctxt->gp_regs.sp_el1, sp_el1);

__sysreg_restore_state restores the host sp_el1, no?

> +	}
> +
> +	/* Call panic for real */
> +	while (1) {
> +		unsigned long str_va = (unsigned long)__hyp_panic_string;
> +
> +		str_va -= HYP_PAGE_OFFSET;
> +		str_va += PAGE_OFFSET;
> +		__hyp_do_panic(str_va,
> +			       spsr,  elr,
> +			       read_sysreg(esr_el2),   read_sysreg(far_el2),
> +			       read_sysreg(hpfar_el2), par,
> +			       read_sysreg(tpidr_el2));
> +	}
> +}

I think the while (1) here is confusing.

Can we not jsut declare str_va at the start of the function and get rid
of the loop?

Thanks,
Mark.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2015-November/385199.html
