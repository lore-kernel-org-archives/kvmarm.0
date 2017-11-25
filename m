From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [PATCH 28/37] KVM: arm64: Move common VHE/non-VHE trap config in
 separate functions
Date: Sat, 25 Nov 2017 13:43:47 +0300
Message-ID: <20171125104347.cco323qjucrgmryz@yury-thinkpad>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-29-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 532FD49D92
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Nov 2017 05:41:22 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BroaSKfF9LY8 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 25 Nov 2017 05:41:21 -0500 (EST)
Received: from NAM01-SN1-obe.outbound.protection.outlook.com
 (mail-sn1nam01on0040.outbound.protection.outlook.com [104.47.32.40])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D568149D6D
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Nov 2017 05:41:20 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20171012104141.26902-29-christoffer.dall@linaro.org>
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

On Thu, Oct 12, 2017 at 12:41:32PM +0200, Christoffer Dall wrote:
> As we are about to be more lazy with some of the trap configuration
> register read/writes for VHE systems, move the logic that is currently
> shared between VHE and non-VHE into a separate function which can be
> called from either the world-switch path or from vcpu_load/vcpu_put.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm64/kvm/hyp/switch.c | 70 +++++++++++++++++++++++++--------------------
>  1 file changed, 39 insertions(+), 31 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 6a12504..c587416 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -23,6 +23,43 @@
>  #include <asm/kvm_hyp.h>
>  #include <asm/fpsimd.h>
>  
> +static void __hyp_text __activate_traps_common(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * We are about to set CPTR_EL2.TFP to trap all floating point
> +	 * register accesses to EL2, however, the ARM ARM clearly states that

ARM ARM: typo?

> +	 * traps are only taken to EL2 if the operation would not otherwise
> +	 * trap to EL1.  Therefore, always make sure that for 32-bit guests,
> +	 * we set FPEXC.EN to prevent traps to EL1, when setting the TFP bit.
> +	 * If FP/ASIMD is not implemented, FPEXC is UNDEFINED and any access to
> +	 * it will cause an exception.
> +	 */
> +	if (vcpu_el1_is_32bit(vcpu) && system_supports_fpsimd() &&
> +	    !vcpu->arch.guest_vfp_loaded) {
> +		write_sysreg(1 << 30, fpexc32_el2);
> +		isb();
> +	}
> +	write_sysreg(vcpu->arch.hcr_el2, hcr_el2);
> +
> +	/* Trap on AArch32 cp15 c15 (impdef sysregs) accesses (EL1 or EL0) */
> +	write_sysreg(1 << 15, hstr_el2);
> +	/*
> +	 * Make sure we trap PMU access from EL0 to EL2. Also sanitize
> +	 * PMSELR_EL0 to make sure it never contains the cycle
> +	 * counter, which could make a PMXEVCNTR_EL0 access UNDEF at
> +	 * EL1 instead of being trapped to EL2.
> +	 */
> +	write_sysreg(0, pmselr_el0);
> +	write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
> +	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
> +}
> +
> +static void __hyp_text __deactivate_traps_common(void)
> +{
> +	write_sysreg(0, hstr_el2);
> +	write_sysreg(0, pmuserenr_el0);
> +}
> +
>  static void __hyp_text __activate_traps_vhe(struct kvm_vcpu *vcpu)
>  {
>  	u64 val;
> @@ -57,35 +94,7 @@ static hyp_alternate_select(__activate_traps_arch,
>  
>  static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
>  {
> -	u64 val;
> -
> -	/*
> -	 * We are about to set CPTR_EL2.TFP to trap all floating point
> -	 * register accesses to EL2, however, the ARM ARM clearly states that
> -	 * traps are only taken to EL2 if the operation would not otherwise
> -	 * trap to EL1.  Therefore, always make sure that for 32-bit guests,
> -	 * we set FPEXC.EN to prevent traps to EL1, when setting the TFP bit.
> -	 * If FP/ASIMD is not implemented, FPEXC is UNDEFINED and any access to
> -	 * it will cause an exception.
> -	 */
> -	val = vcpu->arch.hcr_el2;
> -	if (vcpu_el1_is_32bit(vcpu) && system_supports_fpsimd() &&
> -	    !vcpu->arch.guest_vfp_loaded) {
> -		write_sysreg(1 << 30, fpexc32_el2);
> -		isb();
> -	}
> -	write_sysreg(val, hcr_el2);
> -	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
> -	write_sysreg(1 << 15, hstr_el2);
> -	/*
> -	 * Make sure we trap PMU access from EL0 to EL2. Also sanitize
> -	 * PMSELR_EL0 to make sure it never contains the cycle
> -	 * counter, which could make a PMXEVCNTR_EL0 access UNDEF at
> -	 * EL1 instead of being trapped to EL2.
> -	 */
> -	write_sysreg(0, pmselr_el0);
> -	write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
> -	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
> +	__activate_traps_common(vcpu);
>  	__activate_traps_arch()(vcpu);
>  }
>  
> @@ -131,9 +140,8 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
>  	if (vcpu->arch.hcr_el2 & HCR_VSE)
>  		vcpu->arch.hcr_el2 = read_sysreg(hcr_el2);
>  
> +	__deactivate_traps_common();
>  	__deactivate_traps_arch()();
> -	write_sysreg(0, hstr_el2);
> -	write_sysreg(0, pmuserenr_el0);
>  }
>  
>  static inline void __hyp_text __activate_vm(struct kvm_vcpu *vcpu)
> -- 
> 2.9.0
