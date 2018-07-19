From: Andrew Jones <drjones@redhat.com>
Subject: Re: [RFC PATCH 11/16] KVM: arm64/sve: System register context switch
 and access support
Date: Thu, 19 Jul 2018 13:11:17 +0200
Message-ID: <20180719111117.qztdqqhco7klvfhz@kamzik.brq.redhat.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-12-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC04049F8C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 06:58:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9638FA9OaBKr for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Jul 2018 06:58:15 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 038B940196
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 06:58:15 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1529593060-542-12-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 21, 2018 at 03:57:35PM +0100, Dave Martin wrote:
> This patch adds the necessary support for context switching ZCR_EL1
> for each vcpu.
> 
> The ID_AA64PFR0_EL1 emulation code is updated to expose the
> presence of SVE to the guest if appropriate, and ioctl() access to
> ZCR_EL1 is also added.
> 
> In the context switch code itself, ZCR_EL1 is context switched if
> the host is SVE-capable, irrespectively for now of whether SVE is
> exposed to the guest or not.  Adding a dynamic vcpu_has_sve() check
> may lose as much performance as would be gained in this simple
> case.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/include/asm/sysreg.h   |  3 +++
>  arch/arm64/kvm/hyp/sysreg-sr.c    |  5 +++++
>  arch/arm64/kvm/sys_regs.c         | 14 +++++++++-----
>  4 files changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 609d08b..f331abf 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -111,6 +111,7 @@ enum vcpu_sysreg {
>  	SCTLR_EL1,	/* System Control Register */
>  	ACTLR_EL1,	/* Auxiliary Control Register */
>  	CPACR_EL1,	/* Coprocessor Access Control */
> +	ZCR_EL1,	/* SVE Control */
>  	TTBR0_EL1,	/* Translation Table Base Register 0 */
>  	TTBR1_EL1,	/* Translation Table Base Register 1 */
>  	TCR_EL1,	/* Translation Control Register */
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index a8f8481..6476dbd 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -416,6 +416,9 @@
>  #define SYS_ICH_LR14_EL2		__SYS__LR8_EL2(6)
>  #define SYS_ICH_LR15_EL2		__SYS__LR8_EL2(7)
>  
> +/* VHE encodings for architectural EL0/1 system registers */
> +#define SYS_ZCR_EL12			sys_reg(3, 5, 1, 2, 0)
> +
>  /* Common SCTLR_ELx flags. */
>  #define SCTLR_ELx_EE    (1 << 25)
>  #define SCTLR_ELx_IESB	(1 << 21)
> diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> index 35bc168..0f4046a 100644
> --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> @@ -21,6 +21,7 @@
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_hyp.h>
> +#include <asm/sysreg.h>
>  
>  /*
>   * Non-VHE: Both host and guest must save everything.
> @@ -57,6 +58,8 @@ static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
>  	ctxt->sys_regs[SCTLR_EL1]	= read_sysreg_el1(sctlr);
>  	ctxt->sys_regs[ACTLR_EL1]	= read_sysreg(actlr_el1);
>  	ctxt->sys_regs[CPACR_EL1]	= read_sysreg_el1(cpacr);
> +	if (system_supports_sve()) /* implies has_vhe() */
> +		ctxt->sys_regs[ZCR_EL1]	= read_sysreg_s(SYS_ZCR_EL12);
>  	ctxt->sys_regs[TTBR0_EL1]	= read_sysreg_el1(ttbr0);
>  	ctxt->sys_regs[TTBR1_EL1]	= read_sysreg_el1(ttbr1);
>  	ctxt->sys_regs[TCR_EL1]		= read_sysreg_el1(tcr);
> @@ -129,6 +132,8 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
>  	write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	sctlr);
>  	write_sysreg(ctxt->sys_regs[ACTLR_EL1],	  	actlr_el1);
>  	write_sysreg_el1(ctxt->sys_regs[CPACR_EL1],	cpacr);
> +	if (system_supports_sve()) /* implies has_vhe() */
> +		write_sysreg_s(ctxt->sys_regs[ZCR_EL1],	SYS_ZCR_EL12);

I feel like the ZCR_EL12 save/restores are out of place, as these
functions are shared by non-VHE and VHE. Maybe they should be
moved to the VHE callers?

Thanks,
drew
