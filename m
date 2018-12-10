From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v3 6/8] arm64: KVM: Add synchronization on translation
 regime change for erratum 1165522
Date: Mon, 10 Dec 2018 11:15:37 +0100
Message-ID: <20181210101537.GJ30263@e113682-lin.lund.arm.com>
References: <20181206173126.139877-1-marc.zyngier@arm.com>
 <20181206173126.139877-7-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DC864A2E7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Dec 2018 05:15:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MK3k-UHiLjNs for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Dec 2018 05:15:40 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3FBF4A2E5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Dec 2018 05:15:40 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181206173126.139877-7-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Dec 06, 2018 at 05:31:24PM +0000, Marc Zyngier wrote:
> In order to ensure that slipping HCR_EL2.TGE is done at the right
> time when switching translation regime, let insert the required ISBs
> that will be patched in when erratum 1165522 is detected.
> 
> Take this opportunity to add the missing include of asm/alternative.h
> which was getting there by pure luck.
> 
> Reviewed-by: James Morse <james.morse@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/include/asm/kvm_hyp.h |  8 ++++++++
>  arch/arm64/kvm/hyp/switch.c      | 19 +++++++++++++++++++
>  2 files changed, 27 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index 23aca66767f9..a80a7ef57325 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -20,6 +20,7 @@
>  
>  #include <linux/compiler.h>
>  #include <linux/kvm_host.h>
> +#include <asm/alternative.h>
>  #include <asm/sysreg.h>
>  
>  #define __hyp_text __section(.hyp.text) notrace
> @@ -163,6 +164,13 @@ static __always_inline void __hyp_text __load_guest_stage2(struct kvm *kvm)
>  {
>  	write_sysreg(kvm->arch.vtcr, vtcr_el2);
>  	write_sysreg(kvm->arch.vttbr, vttbr_el2);
> +
> +	/*
> +	 * ARM erratum 1165522 requires the actual execution of the above
> +	 * before we can switch to the EL1/EL0 translation regime used by
> +	 * the guest.
> +	 */
> +	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_1165522));
>  }
>  
>  #endif /* __ARM64_KVM_HYP_H__ */
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index a8fa61c68c32..31ee0bfc432f 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -143,6 +143,14 @@ static void deactivate_traps_vhe(void)
>  {
>  	extern char vectors[];	/* kernel exception vectors */
>  	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
> +
> +	/*
> +	 * ARM erratum 1165522 requires the actual execution of the above
> +	 * before we can switch to the EL2/EL0 translation regime used by
> +	 * the host.
> +	 */
> +	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_1165522));
> +
>  	write_sysreg(CPACR_EL1_DEFAULT, cpacr_el1);
>  	write_sysreg(vectors, vbar_el1);
>  }
> @@ -499,6 +507,17 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>  
>  	sysreg_save_host_state_vhe(host_ctxt);
>  
> +	/*
> +	 * ARM erratum 1165522 requires us to configure both stage 1 and
> +	 * stage 2 translation for the guest context before we clear
> +	 * HCR_EL2.TGE.
> +	 *
> +	 * We have already configured the guest's stage 1 translation in
> +	 * kvm_vcpu_load_sysregs above.  We must now call __activate_vm
> +	 * before __activate_traps, because __activate_vm configures
> +	 * stage 2 translation, and __activate_traps clear HCR_EL2.TGE
> +	 * (among other things).
> +	 */
>  	__activate_vm(vcpu->kvm);
>  	__activate_traps(vcpu);
>  
> -- 
> 2.19.2
> 

Acked-by: Christoffer Dall <christoffer.dall@arm.com>
