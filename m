From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC 8/9] arm64/kvm: context-switch PAC registers
Date: Fri, 7 Apr 2017 16:41:29 +0100
Message-ID: <973af0d9-f7bc-24ee-567d-23e0e487b970@arm.com>
References: <1491232765-32501-1-git-send-email-mark.rutland@arm.com>
 <1491232765-32501-9-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1491232765-32501-9-git-send-email-mark.rutland@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, catalin.marinas@arm.com, christoffer.dall@linaro.org, jiong.wang@arm.com, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, suzuki.poulose@arm.com, will.deacon@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Mark,

On 03/04/17 16:19, Mark Rutland wrote:
> If we have pointer authentication support, a guest may wish to use it.
> This patch adds the infrastructure to allow it to do so.
> 
> This is sufficient for basic testing, but not for real-world usage. A
> guest will still see pointer authentication support advertised in the ID
> registers, and we will need to trap accesses to these to provide
> santized values.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 15 +++++++++++++
>  arch/arm64/include/asm/kvm_host.h    | 12 ++++++++++
>  arch/arm64/kvm/hyp/sysreg-sr.c       | 43 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 70 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index f5ea0ba..0c3cb43 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -28,6 +28,8 @@
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_mmio.h>
>  #include <asm/ptrace.h>
> +#include <asm/cpucaps.h>
> +#include <asm/cpufeature.h>
>  #include <asm/cputype.h>
>  #include <asm/virt.h>
>  
> @@ -49,6 +51,19 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
>  		vcpu->arch.hcr_el2 |= HCR_E2H;
>  	if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
>  		vcpu->arch.hcr_el2 &= ~HCR_RW;
> +
> +	/*
> +	 * Address auth and generic auth share the same enable bits, so we have
> +	 * to ensure both are uniform before we can enable support in a guest.
> +	 * Until we have the infrastructure to detect uniform absence of a
> +	 * feature, only permit the case when both are supported.
> +	 *
> +	 * Note that a guest will still see the feature in ID_AA64_ISAR1 until
> +	 * we introduce code to emulate the ID registers.
> +	 */
> +	if (cpus_have_const_cap(ARM64_HAS_ADDRESS_AUTH) &&
> +	    cpus_have_const_cap(ARM64_HAS_GENERIC_AUTH))
> +		vcpu->arch.hcr_el2 |= (HCR_API | HCR_APK);

Instead of unconditionally allowing the guest to access this feature...

>  }
>  
>  static inline unsigned long vcpu_get_hcr(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index e7705e7..b25f710 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -133,6 +133,18 @@ enum vcpu_sysreg {
>  	PMSWINC_EL0,	/* Software Increment Register */
>  	PMUSERENR_EL0,	/* User Enable Register */
>  
> +	/* Pointer Authentication Registers */
> +	APIAKEYLO_EL1,
> +	APIAKEYHI_EL1,
> +	APIBKEYLO_EL1,
> +	APIBKEYHI_EL1,
> +	APDAKEYLO_EL1,
> +	APDAKEYHI_EL1,
> +	APDBKEYLO_EL1,
> +	APDBKEYHI_EL1,
> +	APGAKEYLO_EL1,
> +	APGAKEYHI_EL1,
> +
>  	/* 32bit specific registers. Keep them at the end of the range */
>  	DACR32_EL2,	/* Domain Access Control Register */
>  	IFSR32_EL2,	/* Instruction Fault Status Register */
> diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> index 9341376..3440b42 100644
> --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> @@ -18,6 +18,8 @@
>  #include <linux/compiler.h>
>  #include <linux/kvm_host.h>
>  
> +#include <asm/cpucaps.h>
> +#include <asm/cpufeature.h>
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_hyp.h>
>  
> @@ -31,6 +33,24 @@ static void __hyp_text __sysreg_do_nothing(struct kvm_cpu_context *ctxt) { }
>   * pstate, and guest must save everything.
>   */
>  
> +#define __save_ap_key(regs, key) \
> +	regs[key ## KEYLO_EL1] = read_sysreg_s(SYS_ ## key ## KEYLO_EL1); \
> +	regs[key ## KEYHI_EL1] = read_sysreg_s(SYS_ ## key ## KEYHI_EL1)
> +
> +static void __hyp_text __sysreg_save_ap_keys(struct kvm_cpu_context *ctxt)
> +{
> +	if (cpus_have_const_cap(ARM64_HAS_ADDRESS_AUTH)) {
> +		__save_ap_key(ctxt->sys_regs, APIA);
> +		__save_ap_key(ctxt->sys_regs, APIB);
> +		__save_ap_key(ctxt->sys_regs, APDA);
> +		__save_ap_key(ctxt->sys_regs, APDB);
> +	}
> +
> +	if (cpus_have_const_cap(ARM64_HAS_GENERIC_AUTH)) {
> +		__save_ap_key(ctxt->sys_regs, APGA);
> +	}
> +}
> +

...which immediately translates in quite a bit of sysreg churn on both
host and guest (specially given that these are not banked by exception
level), could we make it a bit more lazy instead?

Even an "enable on first use" would be good, given that it is likely
that we'll have non PAC-enabled VMs for quite a while.

Thoughts?

	M.
-- 
Jazz is not dead. It just smells funny...
