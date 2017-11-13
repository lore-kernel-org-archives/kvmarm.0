From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 26/37] KVM: arm64: Prepare to handle traps on deferred
 AArch32 sysregs
Date: Mon, 13 Nov 2017 20:07:01 +0100
Message-ID: <20171113190701.7vgkady36c6keshh@hawk.localdomain>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-27-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EC4849D1A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 14:04:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Px+2KaTjEHzL for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Nov 2017 14:04:55 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 57D9F406BB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 14:04:55 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20171012104141.26902-27-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 12, 2017 at 12:41:30PM +0200, Christoffer Dall wrote:
> Handle accesses to any AArch32 EL1 system registers where we can defer
> saving and restoring them to vcpu_load and vcpu_put, and which are
> stored in special EL2 registers only used support 32-bit guests.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm64/kvm/inject_fault.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> index f4513fc..02990f5 100644
> --- a/arch/arm64/kvm/inject_fault.c
> +++ b/arch/arm64/kvm/inject_fault.c
> @@ -59,9 +59,18 @@ static void vcpu_set_elr_el1(struct kvm_vcpu *vcpu, u64 val)
>  /* Set the SPSR for the current mode */
>  static void vcpu_set_spsr(struct kvm_vcpu *vcpu, u64 val)
>  {
> -	if (vcpu_mode_is_32bit(vcpu))
> +	if (vcpu_mode_is_32bit(vcpu)) {
> +		if (vcpu->arch.sysregs_loaded_on_cpu)
> +			__sysreg32_save_state(vcpu);
> +
>  		*vcpu_spsr32(vcpu) = val;
>  
> +		if (vcpu->arch.sysregs_loaded_on_cpu)
> +			__sysreg32_restore_state(vcpu);
> +
> +		return;

Is this a fix? I don't understand why it's necessary now, but it wasn't
before.

> +	}
> +
>  	if (vcpu->arch.sysregs_loaded_on_cpu)
>  		write_sysreg_el1(val, spsr);
>  	else
> @@ -129,11 +138,13 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt,
>  	 *   IFAR:  mapped to FAR_EL1
>  	 *   DFSR:  mapped to ESR_EL1
>  	 *   TTBCR: mapped to TCR_EL1
> +	 *   IFSR:  stored in IFSR32_EL2
>  	 */
>  	if (vcpu->arch.sysregs_loaded_on_cpu) {
>  		vcpu->arch.ctxt.sys_regs[FAR_EL1] = read_sysreg_el1(far);
>  		vcpu->arch.ctxt.sys_regs[ESR_EL1] = read_sysreg_el1(esr);
>  		vcpu->arch.ctxt.sys_regs[TCR_EL1] = read_sysreg_el1(tcr);
> +		vcpu->arch.ctxt.sys_regs[IFSR32_EL2] = read_sysreg(ifsr32_el2);
>  	}
>  
>  	if (is_pabt) {
> @@ -161,6 +172,7 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt,
>  	if (vcpu->arch.sysregs_loaded_on_cpu) {
>  		write_sysreg_el1(vcpu->arch.ctxt.sys_regs[FAR_EL1], far);
>  		write_sysreg_el1(vcpu->arch.ctxt.sys_regs[ESR_EL1], esr);
> +		write_sysreg(vcpu->arch.ctxt.sys_regs[IFSR32_EL2], ifsr32_el2);

This appears to be a fix. Why not squash it into the patch that
save/restore the other registers?

>  	}
>  }
>  
> -- 
> 2.9.0
>

Thanks,
drew
