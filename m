From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: Re: [PATCH v10 15/21] KVM: ARM64: Add access handler for PMUSERENR
 register
Date: Fri, 29 Jan 2016 21:17:33 +0800
Message-ID: <56AB666D.6090200@linaro.org>
References: <1453866709-20324-1-git-send-email-zhaoshenglong@huawei.com>
 <1453866709-20324-16-git-send-email-zhaoshenglong@huawei.com>
 <20160128195814.GF16453@hawk.localdomain> <56AB16B6.8060208@huawei.com>
 <20160129110840.GA4340@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86D414053F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Jan 2016 08:12:11 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IGa2r0U0Oswr for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Jan 2016 08:12:10 -0500 (EST)
Received: from mail-pf0-f171.google.com (mail-pf0-f171.google.com
 [209.85.192.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 290C040402
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Jan 2016 08:12:09 -0500 (EST)
Received: by mail-pf0-f171.google.com with SMTP id x125so42506587pfb.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Jan 2016 05:17:16 -0800 (PST)
In-Reply-To: <20160129110840.GA4340@hawk.localdomain>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>, Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 2016/1/29 19:08, Andrew Jones wrote:
> On Fri, Jan 29, 2016 at 03:37:26PM +0800, Shannon Zhao wrote:
>> >
>> >
>> >On 2016/1/29 3:58, Andrew Jones wrote:
>>> > >On Wed, Jan 27, 2016 at 11:51:43AM +0800, Shannon Zhao wrote:
>>>>> > >> >From: Shannon Zhao<shannon.zhao@linaro.org>
>>>>> > >> >
>>>>> > >> >This register resets as unknown in 64bit mode while it resets as zero
>>>>> > >> >in 32bit mode. Here we choose to reset it as zero for consistency.
>>>>> > >> >
>>>>> > >> >PMUSERENR_EL0 holds some bits which decide whether PMU registers can be
>>>>> > >> >accessed from EL0. Add some check helpers to handle the access from EL0.
>>>>> > >> >
>>>>> > >> >When these bits are zero, only reading PMUSERENR will trap to EL2 and
>>>>> > >> >writing PMUSERENR or reading/writing other PMU registers will trap to
>>>>> > >> >EL1 other than EL2 when HCR.TGE==0. To current KVM configuration
>>>>> > >> >(HCR.TGE==0) there is no way to get these traps. Here we write 0xf to
>>>>> > >> >physical PMUSERENR register on VM entry, so that it will trap PMU access
>>>>> > >> >from EL0 to EL2. Within the register access handler we check the real
>>>>> > >> >value of guest PMUSERENR register to decide whether this access is
>>>>> > >> >allowed. If not allowed, return false to inject UND to guest.
>>>>> > >> >
>>>>> > >> >Signed-off-by: Shannon Zhao<shannon.zhao@linaro.org>
>>>>> > >> >---
>>>>> > >> >  arch/arm64/include/asm/pmu.h |   9 ++++
>>>>> > >> >  arch/arm64/kvm/hyp/hyp.h     |   1 +
>>>>> > >> >  arch/arm64/kvm/hyp/switch.c  |   3 ++
>>>>> > >> >  arch/arm64/kvm/sys_regs.c    | 100 ++++++++++++++++++++++++++++++++++++++++---
>>>>> > >> >  4 files changed, 107 insertions(+), 6 deletions(-)
>>>>> > >> >
>>>>> > >> >diff --git a/arch/arm64/include/asm/pmu.h b/arch/arm64/include/asm/pmu.h
>>>>> > >> >index 6f14a01..eb3dc88 100644
>>>>> > >> >--- a/arch/arm64/include/asm/pmu.h
>>>>> > >> >+++ b/arch/arm64/include/asm/pmu.h
>>>>> > >> >@@ -69,4 +69,13 @@
>>>>> > >> >  #define	ARMV8_EXCLUDE_EL0	(1 << 30)
>>>>> > >> >  #define	ARMV8_INCLUDE_EL2	(1 << 27)
>>>>> > >> >
>>>>> > >> >+/*
>>>>> > >> >+ * PMUSERENR: user enable reg
>>>>> > >> >+ */
>>>>> > >> >+#define ARMV8_USERENR_MASK	0xf		/* Mask for writable bits */
>>>>> > >> >+#define ARMV8_USERENR_EN	(1 << 0) /* PMU regs can be accessed at EL0 */
>>>>> > >> >+#define ARMV8_USERENR_SW	(1 << 1) /* PMSWINC can be written at EL0 */
>>>>> > >> >+#define ARMV8_USERENR_CR	(1 << 2) /* Cycle counter can be read at EL0 */
>>>>> > >> >+#define ARMV8_USERENR_ER	(1 << 3) /* Event counter can be read at EL0 */
>>>>> > >> >+
>>>>> > >> >  #endif /* __ASM_PMU_H */
>>>>> > >> >diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
>>>>> > >> >index fb27517..9a28b7bd8 100644
>>>>> > >> >--- a/arch/arm64/kvm/hyp/hyp.h
>>>>> > >> >+++ b/arch/arm64/kvm/hyp/hyp.h
>>>>> > >> >@@ -22,6 +22,7 @@
>>>>> > >> >  #include <linux/kvm_host.h>
>>>>> > >> >  #include <asm/kvm_mmu.h>
>>>>> > >> >  #include <asm/sysreg.h>
>>>>> > >> >+#include <asm/pmu.h>
>>>>> > >> >
>>>>> > >> >  #define __hyp_text __section(.hyp.text) notrace
>>>>> > >> >
>>>>> > >> >diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
>>>>> > >> >index ca8f5a5..1a7d679 100644
>>>>> > >> >--- a/arch/arm64/kvm/hyp/switch.c
>>>>> > >> >+++ b/arch/arm64/kvm/hyp/switch.c
>>>>> > >> >@@ -37,6 +37,8 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
>>>>> > >> >  	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
>>>>> > >> >  	write_sysreg(1 << 15, hstr_el2);
>>>>> > >> >  	write_sysreg(CPTR_EL2_TTA | CPTR_EL2_TFP, cptr_el2);
>>>>> > >> >+	/* Make sure we trap PMU access from EL0 to EL2 */
>>>>> > >> >+	write_sysreg(ARMV8_USERENR_MASK, pmuserenr_el0);
>>>>> > >> >  	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
>>>>> > >> >  }
>>>>> > >> >
>>>>> > >> >@@ -45,6 +47,7 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
>>>>> > >> >  	write_sysreg(HCR_RW, hcr_el2);
>>>>> > >> >  	write_sysreg(0, hstr_el2);
>>>>> > >> >  	write_sysreg(read_sysreg(mdcr_el2) & MDCR_EL2_HPMN_MASK, mdcr_el2);
>>>>> > >> >+	write_sysreg(0, pmuserenr_el0);
>>>>> > >> >  	write_sysreg(0, cptr_el2);
>>>>> > >> >  }
>>>>> > >> >
>>>>> > >> >diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>>>> > >> >index eefc60a..084e527 100644
>>>>> > >> >--- a/arch/arm64/kvm/sys_regs.c
>>>>> > >> >+++ b/arch/arm64/kvm/sys_regs.c
>>>>> > >> >@@ -453,6 +453,37 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>>>>> > >> >  	vcpu_sys_reg(vcpu, PMCR_EL0) = val;
>>>>> > >> >  }
>>>>> > >> >
>>>>> > >> >+static bool pmu_access_el0_disabled(struct kvm_vcpu *vcpu)
>>>>> > >> >+{
>>>>> > >> >+	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
>>>>> > >> >+
>>>>> > >> >+	return !((reg & ARMV8_USERENR_EN) || vcpu_mode_priv(vcpu));
>>>>> > >> >+}
>>>>> > >> >+
>>>>> > >> >+static bool pmu_write_swinc_el0_disabled(struct kvm_vcpu *vcpu)
>>>>> > >> >+{
>>>>> > >> >+	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
>>>>> > >> >+
>>>>> > >> >+	return !((reg & (ARMV8_USERENR_SW | ARMV8_USERENR_EN))
>>>>> > >> >+		 || vcpu_mode_priv(vcpu));
>>>>> > >> >+}
>>>>> > >> >+
>>>>> > >> >+static bool pmu_access_cycle_counter_el0_disabled(struct kvm_vcpu *vcpu)
>>>>> > >> >+{
>>>>> > >> >+	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
>>>>> > >> >+
>>>>> > >> >+	return !((reg & (ARMV8_USERENR_CR | ARMV8_USERENR_EN))
>>>>> > >> >+		 || vcpu_mode_priv(vcpu));
>>>>> > >> >+}
>>>>> > >> >+
>>>>> > >> >+static bool pmu_access_event_counter_el0_disabled(struct kvm_vcpu *vcpu)
>>>>> > >> >+{
>>>>> > >> >+	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
>>>>> > >> >+
>>>>> > >> >+	return !((reg & (ARMV8_USERENR_ER | ARMV8_USERENR_EN))
>>>>> > >> >+		 || vcpu_mode_priv(vcpu));
>>>>> > >> >+}
>>>>> > >> >+
>>>>> > >> >  static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>>>>> > >> >  			const struct sys_reg_desc *r)
>>>>> > >> >  {
>>>>> > >> >@@ -461,6 +492,9 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>>>>> > >> >  	if (!kvm_arm_pmu_v3_ready(vcpu))
>>>>> > >> >  		return trap_raz_wi(vcpu, p, r);
>>>>> > >> >
>>>>> > >> >+	if (pmu_access_el0_disabled(vcpu))
>>>>> > >> >+		return false;
>>> > >Based on the function name I'm not sure I like embedding vcpu_mode_priv.
>>> > >It seems a condition like
>>> > >
>>> > >   if (!vcpu_mode_priv(vcpu) && !pmu_access_el0_enabled(vcpu))
>>> > >       return false;
>>> > >
>> >
>> >I don't think so. The return vlaue of pmu_access_el0_enabled doesn't
>> >make sense if it doesn't check vcpu mode and it doesn't reflect the
>> >meaning of the function name because if pmu_access_el0_enabled returns
>> >false which should mean the EL0 access is disabled but actually the vcpu
>> >mode might not be EL0.
> I think it always makes sense to simply check if some bit or bits are
> set in some register, without having the answer mixed up with other
> state.
But the final result is what we want.

> Actually, maybe we should just drop these helpers and check the
> register for the appropriate bits directly whenever needed,
>
>    pmuserenr_el0 = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
>    restricted = !vcpu_mode_priv(vcpu) && !(pmuserenr_el0 & ARMV8_USERENR_EN);
>    ...
>
>    if (restricted && !(pmuserenr_el0 & ARMV8_USERENR_CR))
>       return false;
>
>
I would say no. Since this will add a lot of duplicated codes that's why 
we add helpers to factor them out.

> Or whatever... I won't complain about this anymore.
>

Thanks,
-- 
Shannon
