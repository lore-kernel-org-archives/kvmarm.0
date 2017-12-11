From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 20/36] KVM: arm64: Don't save the host ELR_EL2 and
 SPSR_EL2 on VHE systems
Date: Mon, 11 Dec 2017 10:44:59 +0000
Message-ID: <a5d687f6-478f-7436-58c0-932a4eaa466c@arm.com>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
 <20171207170630.592-21-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EFF849D5E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Dec 2017 05:41:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JE-zgBhxdpAq for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Dec 2017 05:41:37 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DCCF449D14
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Dec 2017 05:41:36 -0500 (EST)
In-Reply-To: <20171207170630.592-21-christoffer.dall@linaro.org>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 07/12/17 17:06, Christoffer Dall wrote:
> On non-VHE systems we need to save the ELR_EL2 and SPSR_EL2 so that we
> can return to the host in EL1 in the same state and location where we
> issued a hypercall to EL2, but these registers don't contain anything
> important on VHE, because all of the host runs in EL2.  Therefore,

If I may refine the rational: ELR_EL2 and SPSR_EL2 are not useful here
because we never enter a guest as a result of an exception entry that
would be directly handled by KVM. The kernel entry code already saves
ELR_EL1/SPSR_EL1 on exception entry, which is enough.

> factor out these registers into separate save/restore functions, making
> it easy to exclude them from the VHE world-switch path later on.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm64/kvm/hyp/sysreg-sr.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> index a12112494f75..479de0f0dd07 100644
> --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> @@ -71,6 +71,10 @@ static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
>  	ctxt->gp_regs.sp_el1		= read_sysreg(sp_el1);
>  	ctxt->gp_regs.elr_el1		= read_sysreg_el1(elr);
>  	ctxt->gp_regs.spsr[KVM_SPSR_EL1]= read_sysreg_el1(spsr);
> +}
> +
> +static void __hyp_text __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
> +{
>  	ctxt->gp_regs.regs.pc		= read_sysreg_el2(elr);
>  	ctxt->gp_regs.regs.pstate	= read_sysreg_el2(spsr);
>  }
> @@ -80,6 +84,7 @@ void __hyp_text __sysreg_save_state_nvhe(struct kvm_cpu_context *ctxt)
>  	__sysreg_save_el1_state(ctxt);
>  	__sysreg_save_common_state(ctxt);
>  	__sysreg_save_user_state(ctxt);
> +	__sysreg_save_el2_return_state(ctxt);
>  }
>  
>  void sysreg_save_host_state_vhe(struct kvm_cpu_context *ctxt)
> @@ -93,6 +98,7 @@ void sysreg_save_guest_state_vhe(struct kvm_cpu_context *ctxt)
>  	__sysreg_save_el1_state(ctxt);
>  	__sysreg_save_common_state(ctxt);
>  	__sysreg_save_user_state(ctxt);
> +	__sysreg_save_el2_return_state(ctxt);
>  }
>  
>  static void __hyp_text __sysreg_restore_common_state(struct kvm_cpu_context *ctxt)
> @@ -137,6 +143,11 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
>  	write_sysreg(ctxt->gp_regs.sp_el1,		sp_el1);
>  	write_sysreg_el1(ctxt->gp_regs.elr_el1,		elr);
>  	write_sysreg_el1(ctxt->gp_regs.spsr[KVM_SPSR_EL1],spsr);
> +}
> +
> +static void __hyp_text
> +__sysreg_restore_el2_return_state(struct kvm_cpu_context *ctxt)
> +{
>  	write_sysreg_el2(ctxt->gp_regs.regs.pc,		elr);
>  	write_sysreg_el2(ctxt->gp_regs.regs.pstate,	spsr);
>  }
> @@ -146,6 +157,7 @@ void __hyp_text __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt)
>  	__sysreg_restore_el1_state(ctxt);
>  	__sysreg_restore_common_state(ctxt);
>  	__sysreg_restore_user_state(ctxt);
> +	__sysreg_restore_el2_return_state(ctxt);
>  }
>  
>  void sysreg_restore_host_state_vhe(struct kvm_cpu_context *ctxt)
> @@ -159,6 +171,7 @@ void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt)
>  	__sysreg_restore_el1_state(ctxt);
>  	__sysreg_restore_common_state(ctxt);
>  	__sysreg_restore_user_state(ctxt);
> +	__sysreg_restore_el2_return_state(ctxt);
>  }
>  
>  static void __hyp_text __fpsimd32_save_state(struct kvm_cpu_context *ctxt)
> 

Otherwise:

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
