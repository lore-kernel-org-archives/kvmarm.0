From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v7 1/4] arm64: kvm: route synchronous external abort
 exceptions to EL2
Date: Wed, 18 Oct 2017 18:21:48 +0100
Message-ID: <59E78DAC.1090107@arm.com>
References: <1508249689-10350-1-git-send-email-gengdongjiu@huawei.com>
 <1508249689-10350-2-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79A5540D25
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Oct 2017 13:22:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f8NyLQfFtc-i for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Oct 2017 13:22:29 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F12C24078A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Oct 2017 13:22:28 -0400 (EDT)
In-Reply-To: <1508249689-10350-2-git-send-email-gengdongjiu@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dongjiu Geng <gengdongjiu@huawei.com>
Cc: kamensky@cisco.com, kvm@vger.kernel.org, catalin.marinas@arm.com, stephen.boyd@linaro.org, will.deacon@arm.com, mingo@kernel.org, stefan@hello-penguin.com, corbet@lwn.net, linux-doc@vger.kernel.org, linux@armlinux.org.uk, kvmarm@lists.cs.columbia.edu, Dave.Martin@arm.com, wuquanming@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, kristina.martsenko@arm.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dongjiu Geng,

On 17/10/17 15:14, Dongjiu Geng wrote:
> ARMv8.2 adds a new bit HCR_EL2.TEA which controls to
> route synchronous external aborts to EL2, and adds a
> trap control bit HCR_EL2.TERR which controls to
> trap all Non-secure EL1&0 error record accesses to EL2.

The bulk of this patch is about trap-and-emulating these ERR registers, but
that's not reflected in the title:
> KVM: arm64: Emulate RAS error registers and set HCR_EL2's TERR & TEA


> This patch enables the two bits for the guest OS.
> when an synchronous abort is generated in the guest OS,
> it will trap to EL3 firmware, EL3 firmware will check the

*buzz*
This depends on SCR_EL3.EA, which this patch doesn't touch and the normal-world
can't even know about. This is what your system does, the commit message should
be about the change to Linux.

(I've said this before)


> HCR_EL2.TEA value to decide to jump to hypervisor or host
> OS. Enabling HCR_EL2.TERR makes error record access
> from guest trap to EL2.
> 
> Add some minimal emulation for RAS-Error-Record registers.
> In the emulation, ERRIDR_EL1 and ERRSELR_EL1 are zero.
> Then, the others ERX* registers are RAZ/WI.

> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index fe39e68..47983db 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -47,6 +47,13 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
>  	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
>  	if (is_kernel_in_hyp_mode())
>  		vcpu->arch.hcr_el2 |= HCR_E2H;
> +	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN)) {

This ARM64_HAS_RAS_EXTN isn't in mainline, nor is it added by your series. I
know where it comes from, but other reviewers may not. If you have dependencies
on another series, please call them out in the cover letter.

This is the first cpus_have_const_cap() user in this header file, it probably needs:
#include <asm/cpufeature.h>


> +		/* route synchronous external abort exceptions to EL2 */
> +		vcpu->arch.hcr_el2 |= HCR_TEA;
> +		/* trap error record accesses */
> +		vcpu->arch.hcr_el2 |= HCR_TERR;
> +	}
> +
>  	if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
>  		vcpu->arch.hcr_el2 &= ~HCR_RW;
>  }
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index d686300..af55b3bc 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -105,6 +105,8 @@ enum vcpu_sysreg {
>  	TTBR1_EL1,	/* Translation Table Base Register 1 */
>  	TCR_EL1,	/* Translation Control Register */
>  	ESR_EL1,	/* Exception Syndrome Register */

> +	ERRIDR_EL1,     /* Error Record ID Register */

Page 39 of [0]: 'ERRIDR_EL1 is a 64-bit read-only ...'.


> +	ERRSELR_EL1,    /* Error Record Select Register */

We're emulating these as RAZ/WI, do we really need to allocate
vcpu->arch.ctxt.sys_regs space for them? If we always return 0 for ERRIDR, then
we don't need to keep ERRSELR as 'the value read back [..] is UNKNOWN'.

I think we only need space for these once their value needs to be migrated,
user-space doesn't need to know they exist until then.


>  	AFSR0_EL1,	/* Auxiliary Fault Status Register 0 */
>  	AFSR1_EL1,	/* Auxiliary Fault Status Register 1 */
>  	FAR_EL1,	/* Fault Address Register */

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 2e070d3..a74617b 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -775,6 +775,36 @@ static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  	return true;
>  }
>  
> +static bool access_error_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			 const struct sys_reg_desc *r)
> +{
> +	/* accessing ERRIDR_EL1 */
> +	if (r->CRm == 3 && r->Op2 == 0) {
> +		if (p->is_write)
> +			vcpu_sys_reg(vcpu, ERRIDR_EL1) = 0;

As above, this register is read-only.


> +		return trap_raz_wi(vcpu, p, r);

If we can get rid of the vcpu storage this just becomes trap_raz_wi() .


> +	}
> +
> +	/* accessing ERRSELR_EL1 */
> +	if (r->CRm == 3 && r->Op2 == 1) {
> +		if (p->is_write)
> +			vcpu_sys_reg(vcpu, ERRSELR_EL1) = 0;
> +
> +		return trap_raz_wi(vcpu, p, r);
> +	}

Same here.


> +
> +	/*
> +	 * If ERRSELR_EL1.SEL is greater than or equal to ERRIDR_EL1.NUM,
> +	 * the ERX* registers are RAZ/WI.
> +	 */
> +	if ((vcpu_sys_reg(vcpu, ERRSELR_EL1) & 0xff) >=
> +			(vcpu_sys_reg(vcpu, ERRIDR_EL1) && 0xff))
> +		return trap_raz_wi(vcpu, p, r);

The trick here is ERRIDR_EL1 is read only, KVM can choose how many records it
emulates. Let's pick zero:
> Zero indicates no records can be accessed through the Error Record System
> registers.

Which lets us collapse this entire function down to trap_raz_wi().


I agree we will need this code once we need to allow user-space to populate
values for these registers. (and I bet no-one will want to do that until we get
kernel-first support)


> +	return true;
> +}
> +
>  static bool access_pmswinc(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  			   const struct sys_reg_desc *r)
>  {
> @@ -953,6 +983,16 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	{ SYS_DESC(SYS_AFSR0_EL1), access_vm_reg, reset_unknown, AFSR0_EL1 },
>  	{ SYS_DESC(SYS_AFSR1_EL1), access_vm_reg, reset_unknown, AFSR1_EL1 },
>  	{ SYS_DESC(SYS_ESR_EL1), access_vm_reg, reset_unknown, ESR_EL1 },
> +
> +	{ SYS_DESC(SYS_ERRIDR_EL1), access_error_reg, reset_val, ERRIDR_EL1, 0 },
> +	{ SYS_DESC(SYS_ERRSELR_EL1), access_error_reg, reset_val, ERRSELR_EL1, 0 },
> +	{ SYS_DESC(SYS_ERXFR_EL1), access_error_reg },
> +	{ SYS_DESC(SYS_ERXCTLR_EL1), access_error_reg },
> +	{ SYS_DESC(SYS_ERXSTATUS_EL1), access_error_reg },
> +	{ SYS_DESC(SYS_ERXADDR_EL1), access_error_reg },
> +	{ SYS_DESC(SYS_ERXMISC0_EL1), access_error_reg },
> +	{ SYS_DESC(SYS_ERXMISC1_EL1), access_error_reg },

Why can't we just make all these trap_raz_wi()?


>  	{ SYS_DESC(SYS_FAR_EL1), access_vm_reg, reset_unknown, FAR_EL1 },
>  	{ SYS_DESC(SYS_PAR_EL1), NULL, reset_unknown, PAR_EL1 },


I'll make these changes and then repost this as part of the RAS+IESB series it
depends on.


Thanks!

James


[0]
https://static.docs.arm.com/ddi0587/a/RAS%20Extension-release%20candidate_march_29.pdf
