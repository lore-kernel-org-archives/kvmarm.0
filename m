From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PULL 2/4] arm64: KVM: Only force FPEXC32_EL2.EN if trapping
 FPSIMD
Date: Tue, 4 Sep 2018 12:39:54 +0100
Message-ID: <20180904113952.GB17801@e103592.cambridge.arm.com>
References: <20180903134516.17796-1-christoffer.dall@arm.com>
 <20180903134516.17796-3-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 760E24A1E6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Sep 2018 07:40:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VOKL1NNZDh33 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Sep 2018 07:39:59 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68E0A40A6E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Sep 2018 07:39:59 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180903134516.17796-3-christoffer.dall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Sep 03, 2018 at 03:45:14PM +0200, Christoffer Dall wrote:
> From: Marc Zyngier <marc.zyngier@arm.com>
> 
> If trapping FPSIMD in the context of an AArch32 guest, it is critical
> to set FPEXC32_EL2.EN to 1 so that the trapping is taken to EL2 and
> not EL1.
> 
> Conversely, it is just as critical *not* to set FPEXC32_EL2.EN to 1
> if we're not going to trap FPSIMD, as we then corrupt the existing
> VFP state.
> 
> Moving the call to __activate_traps_fpsimd32 to the point where we
> know for sure that we are going to trap ensures that we don't set that
> bit spuriously.


Hmmm, this looks like a viable fix but actually the way the code is
structured is a bit confusing here.

It looks like some unnecessary functionality has been inherited from
arch/arm here: for a 32-bit host, FPEXC controls FPSIMD trapping even
at Hyp, so we need to handle it specially in order for the Hyp FPSIMD
context switching code to run without generating additional traps.

For a 64-bit host, this doesn't apply: FPEXC32_EL2 is just guest
context and doesn't affect EL2 execution.

The wrinkle this patch fixes is that implicit reads of FPEXC by
the guest are in effect not trappable, so if this register is wrongly
configured for the guest, spurious traps to EL1 may occur that are
not architecturally expected by the guest, which is precisely the
problem that Alexander hit.  I missed this issue in my previous
refactoring...


So, maybe FPEXC32_EL2 should just be treated as another guest system
register that must be eagerly switched.

This would also avoid the double write of FPEXC32_EL2 that we currently
do (once when enabling traps, then again when writing the correct guest
value after a trap is taken), and the isb() can be removed too since
host FPSIMD accesses won't trap on arm64 irrespective of FPEXC32_EL2.


I'll try to cook up a cleanup patch to apply on top, but it can be
treated as non-urgent.

Cheers
---Dave

> 
> Fixes: e6b673b741ea ("KVM: arm64: Optimise FPSIMD handling to reduce guest/host thrashing")
> Cc: Dave Martin <dave.martin@arm.com>
> Reported-by: Alexander Graf <agraf@suse.de>
> Tested-by: Alexander Graf <agraf@suse.de>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> ---
>  arch/arm64/kvm/hyp/switch.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index d496ef579859..ca46153d7915 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -98,8 +98,10 @@ static void activate_traps_vhe(struct kvm_vcpu *vcpu)
>  	val = read_sysreg(cpacr_el1);
>  	val |= CPACR_EL1_TTA;
>  	val &= ~CPACR_EL1_ZEN;
> -	if (!update_fp_enabled(vcpu))
> +	if (!update_fp_enabled(vcpu)) {
>  		val &= ~CPACR_EL1_FPEN;
> +		__activate_traps_fpsimd32(vcpu);
> +	}
>  
>  	write_sysreg(val, cpacr_el1);
>  
> @@ -114,8 +116,10 @@ static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
>  
>  	val = CPTR_EL2_DEFAULT;
>  	val |= CPTR_EL2_TTA | CPTR_EL2_TZ;
> -	if (!update_fp_enabled(vcpu))
> +	if (!update_fp_enabled(vcpu)) {
>  		val |= CPTR_EL2_TFP;
> +		__activate_traps_fpsimd32(vcpu);
> +	}
>  
>  	write_sysreg(val, cptr_el2);
>  }
> @@ -129,7 +133,6 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
>  	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN) && (hcr & HCR_VSE))
>  		write_sysreg_s(vcpu->arch.vsesr_el2, SYS_VSESR_EL2);
>  
> -	__activate_traps_fpsimd32(vcpu);
>  	if (has_vhe())
>  		activate_traps_vhe(vcpu);
>  	else
> -- 
> 2.18.0
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
