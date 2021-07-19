Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD0EC12002
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 15:54:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E1E94613F2
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 15:54:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E1E94613F2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CD0D4A1B0;
	Mon, 19 Jul 2021 11:54:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7-zRNuthxpLg; Mon, 19 Jul 2021 11:54:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D27F14A126;
	Mon, 19 Jul 2021 11:54:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F341B49F8F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 11:54:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j109Jo36vE82 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 11:54:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A887140895
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 11:54:06 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2F1551FB;
 Mon, 19 Jul 2021 08:54:06 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A29CE3F73D;
 Mon, 19 Jul 2021 08:54:03 -0700 (PDT)
Subject: Re: [PATCH v2 1/4] KVM: arm64: Narrow PMU sysreg reset values to
 architectural requirements
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20210719123902.1493805-1-maz@kernel.org>
 <20210719123902.1493805-2-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <171cca9d-2a6e-248c-8502-feba8ebbe55e@arm.com>
Date: Mon, 19 Jul 2021 16:55:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210719123902.1493805-2-maz@kernel.org>
Content-Language: en-US
Cc: kernel-team@android.com, Russell King <rmk+kernel@armlinux.org.uk>,
 Russell King <linux@arm.linux.org.uk>, Robin Murphy <robin.murphy@arm.com>
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

On 7/19/21 1:38 PM, Marc Zyngier wrote:
> A number of the PMU sysregs expose reset values that are not
> compliant with the architecture (set bits in the RES0 ranges,
> for example).
>
> This in turn has the effect that we need to pointlessly mask
> some register fields when using them.
>
> Let's start by making sure we don't have illegal values in the
> shadow registers at reset time. This affects all the registers
> that dedicate one bit per counter, the counters themselves,
> PMEVTYPERn_EL0 and PMSELR_EL0.
>
> Reported-by: Alexandre Chartre <alexandre.chartre@oracle.com>
> Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
> Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 43 ++++++++++++++++++++++++++++++++++++---
>  1 file changed, 40 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index f6f126eb6ac1..96bdfa0e68b2 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -603,6 +603,41 @@ static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
>  	return REG_HIDDEN;
>  }
>  
> +static void reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +{
> +	u64 n, mask = BIT(ARMV8_PMU_CYCLE_IDX);
> +
> +	/* No PMU available, any PMU reg may UNDEF... */
> +	if (!kvm_arm_support_pmu_v3())
> +		return;
> +
> +	n = read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
> +	n &= ARMV8_PMU_PMCR_N_MASK;
> +	if (n)
> +		mask |= GENMASK(n - 1, 0);

Hm... seems to be missing the cycle counter.

Thanks,

Alex

> +
> +	reset_unknown(vcpu, r);
> +	__vcpu_sys_reg(vcpu, r->reg) &= mask;
> +}
> +
> +static void reset_pmevcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +{
> +	reset_unknown(vcpu, r);
> +	__vcpu_sys_reg(vcpu, r->reg) &= GENMASK(31, 0);
> +}
> +
> +static void reset_pmevtyper(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +{
> +	reset_unknown(vcpu, r);
> +	__vcpu_sys_reg(vcpu, r->reg) &= ARMV8_PMU_EVTYPE_MASK;
> +}
> +
> +static void reset_pmselr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +{
> +	reset_unknown(vcpu, r);
> +	__vcpu_sys_reg(vcpu, r->reg) &= ARMV8_PMU_COUNTER_MASK;
> +}
> +
>  static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  {
>  	u64 pmcr, val;
> @@ -944,16 +979,18 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  	  trap_wcr, reset_wcr, 0, 0,  get_wcr, set_wcr }
>  
>  #define PMU_SYS_REG(r)						\
> -	SYS_DESC(r), .reset = reset_unknown, .visibility = pmu_visibility
> +	SYS_DESC(r), .reset = reset_pmu_reg, .visibility = pmu_visibility
>  
>  /* Macro to expand the PMEVCNTRn_EL0 register */
>  #define PMU_PMEVCNTR_EL0(n)						\
>  	{ PMU_SYS_REG(SYS_PMEVCNTRn_EL0(n)),				\
> +	  .reset = reset_pmevcntr,					\
>  	  .access = access_pmu_evcntr, .reg = (PMEVCNTR0_EL0 + n), }
>  
>  /* Macro to expand the PMEVTYPERn_EL0 register */
>  #define PMU_PMEVTYPER_EL0(n)						\
>  	{ PMU_SYS_REG(SYS_PMEVTYPERn_EL0(n)),				\
> +	  .reset = reset_pmevtyper,					\
>  	  .access = access_pmu_evtyper, .reg = (PMEVTYPER0_EL0 + n), }
>  
>  static bool undef_access(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> @@ -1595,13 +1632,13 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	{ PMU_SYS_REG(SYS_PMSWINC_EL0),
>  	  .access = access_pmswinc, .reg = PMSWINC_EL0 },
>  	{ PMU_SYS_REG(SYS_PMSELR_EL0),
> -	  .access = access_pmselr, .reg = PMSELR_EL0 },
> +	  .access = access_pmselr, .reset = reset_pmselr, .reg = PMSELR_EL0 },
>  	{ PMU_SYS_REG(SYS_PMCEID0_EL0),
>  	  .access = access_pmceid, .reset = NULL },
>  	{ PMU_SYS_REG(SYS_PMCEID1_EL0),
>  	  .access = access_pmceid, .reset = NULL },
>  	{ PMU_SYS_REG(SYS_PMCCNTR_EL0),
> -	  .access = access_pmu_evcntr, .reg = PMCCNTR_EL0 },
> +	  .access = access_pmu_evcntr, .reset = reset_unknown, .reg = PMCCNTR_EL0 },
>  	{ PMU_SYS_REG(SYS_PMXEVTYPER_EL0),
>  	  .access = access_pmu_evtyper, .reset = NULL },
>  	{ PMU_SYS_REG(SYS_PMXEVCNTR_EL0),
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
