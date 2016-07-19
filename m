From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] arm64: KVM: VHE: Context switch MDSCR_EL1
Date: Tue, 19 Jul 2016 14:25:04 +0200
Message-ID: <d1313d99-31dd-e799-7f5b-fb03f928cefd@redhat.com>
References: <1468918664-19130-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1468918664-19130-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Tirumalesh Chalamarla <Tirumalesh.Chalamarla@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu



On 19/07/2016 10:57, Marc Zyngier wrote:
> The kprobe enablement work has uncovered that changes made by
> a guest to MDSCR_EL1 were propagated to the host when VHE was
> enabled, leading to unexpected exception being delivered.
> 
> Moving this register to the list of registers that are always
> context-switched fixes the issue.
> 
> Reported-by: Tirumalesh Chalamarla <Tirumalesh.Chalamarla@cavium.com>
> Tested-by: Tirumalesh Chalamarla <Tirumalesh.Chalamarla@cavium.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/hyp/sysreg-sr.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> index 0f7c40e..a327e35 100644
> --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> @@ -27,8 +27,8 @@ static void __hyp_text __sysreg_do_nothing(struct kvm_cpu_context *ctxt) { }
>  /*
>   * Non-VHE: Both host and guest must save everything.
>   *
> - * VHE: Host must save tpidr*_el[01], actlr_el1, sp0, pc, pstate, and
> - * guest must save everything.
> + * VHE: Host must save tpidr*_el[01], actlr_el1, mdscr_el1, sp0, pc,
> + * pstate, and guest must save everything.
>   */
>  
>  static void __hyp_text __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
> @@ -37,6 +37,7 @@ static void __hyp_text __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
>  	ctxt->sys_regs[TPIDR_EL0]	= read_sysreg(tpidr_el0);
>  	ctxt->sys_regs[TPIDRRO_EL0]	= read_sysreg(tpidrro_el0);
>  	ctxt->sys_regs[TPIDR_EL1]	= read_sysreg(tpidr_el1);
> +	ctxt->sys_regs[MDSCR_EL1]	= read_sysreg(mdscr_el1);
>  	ctxt->gp_regs.regs.sp		= read_sysreg(sp_el0);
>  	ctxt->gp_regs.regs.pc		= read_sysreg_el2(elr);
>  	ctxt->gp_regs.regs.pstate	= read_sysreg_el2(spsr);
> @@ -61,7 +62,6 @@ static void __hyp_text __sysreg_save_state(struct kvm_cpu_context *ctxt)
>  	ctxt->sys_regs[AMAIR_EL1]	= read_sysreg_el1(amair);
>  	ctxt->sys_regs[CNTKCTL_EL1]	= read_sysreg_el1(cntkctl);
>  	ctxt->sys_regs[PAR_EL1]		= read_sysreg(par_el1);
> -	ctxt->sys_regs[MDSCR_EL1]	= read_sysreg(mdscr_el1);
>  
>  	ctxt->gp_regs.sp_el1		= read_sysreg(sp_el1);
>  	ctxt->gp_regs.elr_el1		= read_sysreg_el1(elr);
> @@ -90,6 +90,7 @@ static void __hyp_text __sysreg_restore_common_state(struct kvm_cpu_context *ctx
>  	write_sysreg(ctxt->sys_regs[TPIDR_EL0],	  tpidr_el0);
>  	write_sysreg(ctxt->sys_regs[TPIDRRO_EL0], tpidrro_el0);
>  	write_sysreg(ctxt->sys_regs[TPIDR_EL1],	  tpidr_el1);
> +	write_sysreg(ctxt->sys_regs[MDSCR_EL1],		mdscr_el1);
>  	write_sysreg(ctxt->gp_regs.regs.sp,	  sp_el0);
>  	write_sysreg_el2(ctxt->gp_regs.regs.pc,	  elr);
>  	write_sysreg_el2(ctxt->gp_regs.regs.pstate, spsr);
> @@ -114,7 +115,6 @@ static void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
>  	write_sysreg_el1(ctxt->sys_regs[AMAIR_EL1],	amair);
>  	write_sysreg_el1(ctxt->sys_regs[CNTKCTL_EL1], 	cntkctl);
>  	write_sysreg(ctxt->sys_regs[PAR_EL1],		par_el1);
> -	write_sysreg(ctxt->sys_regs[MDSCR_EL1],		mdscr_el1);
>  
>  	write_sysreg(ctxt->gp_regs.sp_el1,		sp_el1);
>  	write_sysreg_el1(ctxt->gp_regs.elr_el1,		elr);
> 

Can you add Fixes and Cc: stable headers?  Thanks,

Paolo
