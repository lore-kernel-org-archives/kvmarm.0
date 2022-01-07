Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 591CAC433EF
	for <kvmarm@archiver.kernel.org>; Sat,  8 Jan 2022 11:38:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8ED9449EC4;
	Sat,  8 Jan 2022 06:38:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id m5SCCCi1kmAq; Sat,  8 Jan 2022 06:38:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E4F449ECE;
	Sat,  8 Jan 2022 06:38:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07C494B27B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jan 2022 16:55:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f1Ir0Xk5IC-O for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Jan 2022 16:55:48 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ACB1D4B273
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jan 2022 16:55:48 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1304A113E;
 Fri,  7 Jan 2022 13:55:48 -0800 (PST)
Received: from localhost.localdomain (unknown [10.122.33.8])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7A0643F66F;
 Fri,  7 Jan 2022 13:55:47 -0800 (PST)
From: Chase Conklin <chase.conklin@arm.com>
To: maz@kernel.org
Subject: Re: [PATCH v5 08/69] KVM: arm64: nv: Reset VCPU to EL2 registers if
 VCPU nested virt is set
Date: Fri,  7 Jan 2022 15:54:01 -0600
Message-Id: <20220107215401.61828-1-chase.conklin@arm.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211129200150.351436-9-maz@kernel.org>
References: <20211129200150.351436-9-maz@kernel.org>
MIME-Version: 1.0
X-Mailman-Approved-At: Sat, 08 Jan 2022 06:38:34 -0500
Cc: kernel-team@android.com, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, kvmarm@lists.cs.columbia.edu,
 gankulkarni@os.amperecomputing.com, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On Mon Nov 29 15:00:49 EST 2021, Marc Zyngier <maz@kernel.org> wrote:
> From: Christoffer Dall <christoffer.dall at arm.com>
>
> Reset the VCPU with PSTATE.M = EL2h when the nested virtualization
> feature is enabled on the VCPU.
>
> Signed-off-by: Christoffer Dall <christoffer.dall at arm.com>
> [maz: rework register reset not to use empty data structures]
> Signed-off-by: Marc Zyngier <maz at kernel.org>
> ---
>  arch/arm64/kvm/reset.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 426bd7fbc3fd..38a7182819fb 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -27,6 +27,7 @@
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_mmu.h>
> +#include <asm/kvm_nested.h>
>  #include <asm/virt.h>
>  
>  /* Maximum phys_shift supported for any VM on this host */
> @@ -38,6 +39,9 @@ static u32 kvm_ipa_limit;
>  #define VCPU_RESET_PSTATE_EL1	(PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT | \
>  				 PSR_F_BIT | PSR_D_BIT)
>  
> +#define VCPU_RESET_PSTATE_EL2	(PSR_MODE_EL2h | PSR_A_BIT | PSR_I_BIT | \
> +				 PSR_F_BIT | PSR_D_BIT)
> +
>  #define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
>  				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
>  
> @@ -176,8 +180,8 @@ static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
>  	if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1) && is32bit)
>  		return false;
>  
> -	/* MTE is incompatible with AArch32 */
> -	if (kvm_has_mte(vcpu->kvm) && is32bit)
> +	/* MTE and NV are incompatible with AArch32 */
> +	if ((kvm_has_mte(vcpu->kvm) || nested_virt_in_use(vcpu)) && is32bit)
>  		return false;

Should something similar be done for SVE? I see from the ID register emulation
that SVE is hidden from the guest but there isn't anything in
kvm_vcpu_enable_sve() that checks if NV is in use. That means it's possible to
have both nested_virt_in_use(vcpu) and vcpu_has_sve(vcpu) be true
simultaneously. If that happens, the FPSIMD fixup can get confused

	/*
	 * Don't handle SVE traps for non-SVE vcpus here. This
	 * includes NV guests for the time being.
	 */
	if (!sve_guest && (esr_ec != ESR_ELx_EC_FP_ASIMD ||
			   guest_hyp_fpsimd_traps_enabled(vcpu)))
		return false;

and incorrectly restore the wrong context instead of forwarding a FPSIMD trap to
the guest hypervisor.

Thanks,
Chase

>  	/* Check that the vcpus are either all 32bit or all 64bit */
> @@ -255,6 +259,8 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  	default:
>  		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
>  			pstate = VCPU_RESET_PSTATE_SVC;
> +		} else if (nested_virt_in_use(vcpu)) {
> +			pstate = VCPU_RESET_PSTATE_EL2;
>  		} else {
>  			pstate = VCPU_RESET_PSTATE_EL1;
>  		}
> -- 
> 2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
