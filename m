From: Christoffer Dall <cdall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 05/11] arm64: KVM: Stop save/restoring host tpidr_el1 on
 VHE
Date: Tue, 6 Jun 2017 22:00:03 +0200
Message-ID: <20170606200003.GP9464@cbox>
References: <20170515174400.29735-1-james.morse@arm.com>
 <20170515174400.29735-6-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170515174400.29735-6-james.morse-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, May 15, 2017 at 06:43:53PM +0100, James Morse wrote:
> Now that a VHE host uses tpidr_el2 for the cpu offset we no longer
> need KVM to save/restore tpidr_el1. Move this from the 'common' code
> into the non-vhe code. While we're at it, on VHE we don't need to
> save the ELR or SPSR as kernel_entry in entry.S will have pushed these
> onto the kernel stack, and will restore them from there. Move these
> to the non-vhe code as we need them to get back to the host.
> 
> Finally remove the always-copy-tpidr we hid in the stage2 setup
> code, cpufeature's enable callback will do this for VHE, we only
> need KVM to do it for non-vhe. Add the copy into kvm-init instead.
> 

Reviewed-by: Christoffer Dall <cdall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

> Signed-off-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
> ---
>  arch/arm64/kvm/hyp-init.S      |  4 ++++
>  arch/arm64/kvm/hyp/s2-setup.c  |  3 ---
>  arch/arm64/kvm/hyp/sysreg-sr.c | 16 ++++++++--------
>  3 files changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
> index 839425c24b1c..b8219801bb28 100644
> --- a/arch/arm64/kvm/hyp-init.S
> +++ b/arch/arm64/kvm/hyp-init.S
> @@ -119,6 +119,10 @@ __do_hyp_init:
>  	kern_hyp_va	x2
>  	msr	vbar_el2, x2
>  
> +	/* copy tpidr_el1 into tpidr_el2 for use by HYP */
> +	mrs	x1, tpidr_el1
> +	msr	tpidr_el2, x1
> +
>  	/* Hello, World! */
>  	eret
>  ENDPROC(__kvm_hyp_init)
> diff --git a/arch/arm64/kvm/hyp/s2-setup.c b/arch/arm64/kvm/hyp/s2-setup.c
> index eb401dbb285e..b81f4091c909 100644
> --- a/arch/arm64/kvm/hyp/s2-setup.c
> +++ b/arch/arm64/kvm/hyp/s2-setup.c
> @@ -84,8 +84,5 @@ u32 __hyp_text __init_stage2_translation(void)
>  
>  	write_sysreg(val, vtcr_el2);
>  
> -	/* copy tpidr_el1 into tpidr_el2 for use by HYP */
> -	write_sysreg(read_sysreg(tpidr_el1), tpidr_el2);
> -
>  	return parange;
>  }
> diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> index 934137647837..c54cc2afb92b 100644
> --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> @@ -27,8 +27,8 @@ static void __hyp_text __sysreg_do_nothing(struct kvm_cpu_context *ctxt) { }
>  /*
>   * Non-VHE: Both host and guest must save everything.
>   *
> - * VHE: Host must save tpidr*_el[01], actlr_el1, mdscr_el1, sp0, pc,
> - * pstate, and guest must save everything.
> + * VHE: Host must save tpidr*_el0, actlr_el1, mdscr_el1, sp_el0,
> + * and guest must save everything.
>   */
>  
>  static void __hyp_text __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
> @@ -36,11 +36,8 @@ static void __hyp_text __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
>  	ctxt->sys_regs[ACTLR_EL1]	= read_sysreg(actlr_el1);
>  	ctxt->sys_regs[TPIDR_EL0]	= read_sysreg(tpidr_el0);
>  	ctxt->sys_regs[TPIDRRO_EL0]	= read_sysreg(tpidrro_el0);
> -	ctxt->sys_regs[TPIDR_EL1]	= read_sysreg(tpidr_el1);
>  	ctxt->sys_regs[MDSCR_EL1]	= read_sysreg(mdscr_el1);
>  	ctxt->gp_regs.regs.sp		= read_sysreg(sp_el0);
> -	ctxt->gp_regs.regs.pc		= read_sysreg_el2(elr);
> -	ctxt->gp_regs.regs.pstate	= read_sysreg_el2(spsr);
>  }
>  
>  static void __hyp_text __sysreg_save_state(struct kvm_cpu_context *ctxt)
> @@ -62,10 +59,13 @@ static void __hyp_text __sysreg_save_state(struct kvm_cpu_context *ctxt)
>  	ctxt->sys_regs[AMAIR_EL1]	= read_sysreg_el1(amair);
>  	ctxt->sys_regs[CNTKCTL_EL1]	= read_sysreg_el1(cntkctl);
>  	ctxt->sys_regs[PAR_EL1]		= read_sysreg(par_el1);
> +	ctxt->sys_regs[TPIDR_EL1]	= read_sysreg(tpidr_el1);
>  
>  	ctxt->gp_regs.sp_el1		= read_sysreg(sp_el1);
>  	ctxt->gp_regs.elr_el1		= read_sysreg_el1(elr);
>  	ctxt->gp_regs.spsr[KVM_SPSR_EL1]= read_sysreg_el1(spsr);
> +	ctxt->gp_regs.regs.pc		= read_sysreg_el2(elr);
> +	ctxt->gp_regs.regs.pstate	= read_sysreg_el2(spsr);
>  }
>  
>  static hyp_alternate_select(__sysreg_call_save_host_state,
> @@ -89,11 +89,8 @@ static void __hyp_text __sysreg_restore_common_state(struct kvm_cpu_context *ctx
>  	write_sysreg(ctxt->sys_regs[ACTLR_EL1],	  actlr_el1);
>  	write_sysreg(ctxt->sys_regs[TPIDR_EL0],	  tpidr_el0);
>  	write_sysreg(ctxt->sys_regs[TPIDRRO_EL0], tpidrro_el0);
> -	write_sysreg(ctxt->sys_regs[TPIDR_EL1],	  tpidr_el1);
>  	write_sysreg(ctxt->sys_regs[MDSCR_EL1],	  mdscr_el1);
>  	write_sysreg(ctxt->gp_regs.regs.sp,	  sp_el0);
> -	write_sysreg_el2(ctxt->gp_regs.regs.pc,	  elr);
> -	write_sysreg_el2(ctxt->gp_regs.regs.pstate, spsr);
>  }
>  
>  static void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
> @@ -115,10 +112,13 @@ static void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
>  	write_sysreg_el1(ctxt->sys_regs[AMAIR_EL1],	amair);
>  	write_sysreg_el1(ctxt->sys_regs[CNTKCTL_EL1], 	cntkctl);
>  	write_sysreg(ctxt->sys_regs[PAR_EL1],		par_el1);
> +	write_sysreg(ctxt->sys_regs[TPIDR_EL1],		tpidr_el1);
>  
>  	write_sysreg(ctxt->gp_regs.sp_el1,		sp_el1);
>  	write_sysreg_el1(ctxt->gp_regs.elr_el1,		elr);
>  	write_sysreg_el1(ctxt->gp_regs.spsr[KVM_SPSR_EL1],spsr);
> +	write_sysreg_el2(ctxt->gp_regs.regs.pc,		elr);
> +	write_sysreg_el2(ctxt->gp_regs.regs.pstate,	spsr);
>  }
>  
>  static hyp_alternate_select(__sysreg_call_restore_host_state,
> -- 
> 2.10.1
> 
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
