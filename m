Return-Path: <SRS0=F0YX=TY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EFF6C072B5
	for <kvmarm@archiver.kernel.org>; Fri, 24 May 2019 11:36:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9A9BC217F9
	for <kvmarm@archiver.kernel.org>; Fri, 24 May 2019 11:36:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9A9BC217F9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 09A2D4A380;
	Fri, 24 May 2019 07:36:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DYmWTWdyIhbB; Fri, 24 May 2019 07:36:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CCA54A4A9;
	Fri, 24 May 2019 07:36:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35A574A380
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 May 2019 07:36:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rC09q39PfGfA for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 May 2019 07:36:28 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FCAC4A2E7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 May 2019 07:36:28 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F26B2374;
 Fri, 24 May 2019 04:36:27 -0700 (PDT)
Received: from [10.1.197.45] (e112298-lin.cambridge.arm.com [10.1.197.45])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E50BB3F703;
 Fri, 24 May 2019 04:36:25 -0700 (PDT)
Subject: Re: [PATCH v2 05/15] arm64: KVM: add access handler for SPE system
 registers
To: Sudeep Holla <sudeep.holla@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
References: <20190523103502.25925-1-sudeep.holla@arm.com>
 <20190523103502.25925-6-sudeep.holla@arm.com>
From: Julien Thierry <julien.thierry@arm.com>
Message-ID: <c45323a8-92e4-e406-381b-2084e222a870@arm.com>
Date: Fri, 24 May 2019 12:36:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190523103502.25925-6-sudeep.holla@arm.com>
Content-Language: en-US
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>,
 linux-kernel@vger.kernel.org
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

Hi Sudeep,

On 23/05/2019 11:34, Sudeep Holla wrote:
> SPE Profiling Buffer owning EL is configurable and when MDCR_EL2.E2PB
> is configured to provide buffer ownership to EL1, the control registers
> are trapped.
> 
> Add access handlers for the Statistical Profiling Extension(SPE)
> Profiling Buffer controls registers. This is need to support profiling
> using SPE in the guests.
> 
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 13 ++++++++++++
>  arch/arm64/kvm/sys_regs.c         | 35 +++++++++++++++++++++++++++++++
>  include/kvm/arm_spe.h             | 15 +++++++++++++
>  3 files changed, 63 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 611a4884fb6c..559aa6931291 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -147,6 +147,19 @@ enum vcpu_sysreg {
>  	MDCCINT_EL1,	/* Monitor Debug Comms Channel Interrupt Enable Reg */
>  	DISR_EL1,	/* Deferred Interrupt Status Register */
>  
> +	/* Statistical Profiling Extension Registers */
> +
> +	PMSCR_EL1,
> +	PMSICR_EL1,
> +	PMSIRR_EL1,
> +	PMSFCR_EL1,
> +	PMSEVFR_EL1,
> +	PMSLATFR_EL1,
> +	PMSIDR_EL1,
> +	PMBLIMITR_EL1,
> +	PMBPTR_EL1,
> +	PMBSR_EL1,
> +
>  	/* Performance Monitors Registers */
>  	PMCR_EL0,	/* Control Register */
>  	PMSELR_EL0,	/* Event Counter Selection Register */
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 857b226bcdde..dbf5056828d3 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -646,6 +646,30 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  	__vcpu_sys_reg(vcpu, PMCR_EL0) = val;
>  }
>  
> +static bool access_pmsb_val(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			    const struct sys_reg_desc *r)
> +{
> +	if (p->is_write)
> +		vcpu_write_sys_reg(vcpu, p->regval, r->reg);
> +	else
> +		p->regval = vcpu_read_sys_reg(vcpu, r->reg);
> +
> +	return true;
> +}
> +
> +static void reset_pmsb_val(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +{
> +	if (!kvm_arm_support_spe_v1()) {
> +		__vcpu_sys_reg(vcpu, r->reg) = 0;
> +		return;
> +	}
> +
> +	if (r->reg == PMSIDR_EL1)

If only PMSIDR_EL1 has a non-zero reset value, it feels a bit weird to
share the reset function for all these registers.

I would suggest only having a reset_pmsidr() function, and just use
reset_val() with sys_reg_desc->val set to 0 for all the others.

> +		__vcpu_sys_reg(vcpu, r->reg) = read_sysreg_s(SYS_PMSIDR_EL1);
> +	else
> +		__vcpu_sys_reg(vcpu, r->reg) = 0;
> +}
> +
>  static bool check_pmu_access_disabled(struct kvm_vcpu *vcpu, u64 flags)
>  {
>  	u64 reg = __vcpu_sys_reg(vcpu, PMUSERENR_EL0);
> @@ -1513,6 +1537,17 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	{ SYS_DESC(SYS_FAR_EL1), access_vm_reg, reset_unknown, FAR_EL1 },
>  	{ SYS_DESC(SYS_PAR_EL1), NULL, reset_unknown, PAR_EL1 },
>  
> +	{ SYS_DESC(SYS_PMSCR_EL1), access_pmsb_val, reset_pmsb_val, PMSCR_EL1 },
> +	{ SYS_DESC(SYS_PMSICR_EL1), access_pmsb_val, reset_pmsb_val, PMSICR_EL1 },
> +	{ SYS_DESC(SYS_PMSIRR_EL1), access_pmsb_val, reset_pmsb_val, PMSIRR_EL1 },
> +	{ SYS_DESC(SYS_PMSFCR_EL1), access_pmsb_val, reset_pmsb_val, PMSFCR_EL1 },
> +	{ SYS_DESC(SYS_PMSEVFR_EL1), access_pmsb_val, reset_pmsb_val, PMSEVFR_EL1},
> +	{ SYS_DESC(SYS_PMSLATFR_EL1), access_pmsb_val, reset_pmsb_val, PMSLATFR_EL1 },
> +	{ SYS_DESC(SYS_PMSIDR_EL1), access_pmsb_val, reset_pmsb_val, PMSIDR_EL1 },
> +	{ SYS_DESC(SYS_PMBLIMITR_EL1), access_pmsb_val, reset_pmsb_val, PMBLIMITR_EL1 },
> +	{ SYS_DESC(SYS_PMBPTR_EL1), access_pmsb_val, reset_pmsb_val, PMBPTR_EL1 },
> +	{ SYS_DESC(SYS_PMBSR_EL1), access_pmsb_val, reset_pmsb_val, PMBSR_EL1 },
> +
>  	{ SYS_DESC(SYS_PMINTENSET_EL1), access_pminten, reset_unknown, PMINTENSET_EL1 },
>  	{ SYS_DESC(SYS_PMINTENCLR_EL1), access_pminten, NULL, PMINTENSET_EL1 },
>  
> diff --git a/include/kvm/arm_spe.h b/include/kvm/arm_spe.h
> index 8c96bdfad6ac..2440ff02f747 100644
> --- a/include/kvm/arm_spe.h
> +++ b/include/kvm/arm_spe.h
> @@ -8,6 +8,7 @@
>  
>  #include <uapi/linux/kvm.h>
>  #include <linux/kvm_host.h>
> +#include <linux/cpufeature.h>
>  
>  struct kvm_spe {
>  	int irq;
> @@ -15,4 +16,18 @@ struct kvm_spe {
>  	bool created; /* SPE KVM instance is created, may not be ready yet */
>  };
>  
> +#ifdef CONFIG_KVM_ARM_SPE
> +
> +static inline bool kvm_arm_support_spe_v1(void)
> +{
> +	u64 dfr0 = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
> +
> +	return !!cpuid_feature_extract_unsigned_field(dfr0,
> +						      ID_AA64DFR0_PMSVER_SHIFT);
> +}
> +#else
> +
> +#define kvm_arm_support_spe_v1()	(false)
> +#endif /* CONFIG_KVM_ARM_SPE */
> +
>  #endif /* __ASM_ARM_KVM_SPE_H */
> 

Cheers,

-- 
Julien Thierry
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
