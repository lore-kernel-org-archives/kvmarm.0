Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D734CC433EF
	for <kvmarm@archiver.kernel.org>; Wed,  2 Feb 2022 11:39:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D32B49DFF;
	Wed,  2 Feb 2022 06:39:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RmzaDLbbetUN; Wed,  2 Feb 2022 06:39:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 07C4249E36;
	Wed,  2 Feb 2022 06:39:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C1B749DFF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Feb 2022 06:39:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RIAMavniZ3zT for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Feb 2022 06:39:54 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DBE6412AF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Feb 2022 06:39:54 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D5BDB1FB;
 Wed,  2 Feb 2022 03:39:53 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 171DD3F40C;
 Wed,  2 Feb 2022 03:39:50 -0800 (PST)
Date: Wed, 2 Feb 2022 11:40:04 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v6 03/64] KVM: arm64: nv: Reset VCPU to EL2 registers if
 VCPU nested virt is set
Message-ID: <YfpteeR6460x31ZJ@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-4-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-4-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Chase Conklin <chase.conklin@arm.com>, kvmarm@lists.cs.columbia.edu,
 mihai.carabas@oracle.com,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 "Russell King \(Oracle\)" <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org
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

On Fri, Jan 28, 2022 at 12:18:11PM +0000, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@arm.com>
> 
> Reset the VCPU with PSTATE.M = EL2h when the nested virtualization
> feature is enabled on the VCPU.

Looks good to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

> 
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> [maz: rework register reset not to use empty data structures]
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/reset.c | 29 ++++++++++++++++++++++++-----
>  1 file changed, 24 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index ecc40c8cd6f6..d19a9aad2d85 100644
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
> @@ -188,12 +192,19 @@ static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
>  	unsigned long i;
>  
>  	is32bit = vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT);
> -	if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1) && is32bit)
> -		return false;
> +	if (is32bit) {
> +		/* The HW must obviously support AArch32 at EL1 */
> +		if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1))
> +			return false;
>  
> -	/* MTE is incompatible with AArch32 */
> -	if (kvm_has_mte(vcpu->kvm) && is32bit)
> -		return false;
> +		/* MTE is incompatible with AArch32 */
> +		if (kvm_has_mte(vcpu->kvm))
> +			return false;
> +
> +		/* NV is incompatible with AArch32 */
> +		if (vcpu_has_nv(vcpu))
> +			return false;
> +	}
>  
>  	/* Check that the vcpus are either all 32bit or all 64bit */
>  	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
> @@ -265,10 +276,18 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  		goto out;
>  	}
>  
> +	if (vcpu_has_nv(vcpu) &&
> +	    vcpu_has_feature(vcpu, KVM_ARM_VCPU_SVE)) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
>  	switch (vcpu->arch.target) {
>  	default:
>  		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
>  			pstate = VCPU_RESET_PSTATE_SVC;
> +		} else if (vcpu_has_nv(vcpu)) {
> +			pstate = VCPU_RESET_PSTATE_EL2;
>  		} else {
>  			pstate = VCPU_RESET_PSTATE_EL1;
>  		}
> -- 
> 2.30.2
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
