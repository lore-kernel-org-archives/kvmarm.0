From: Christopher Covington <cov@codeaurora.org>
Subject: Re: [PATCH v4 17/21] KVM: ARM64: Add helper to handle PMCR
 register bits
Date: Mon, 02 Nov 2015 16:20:40 -0500
Message-ID: <5637D3A8.1040500@codeaurora.org>
References: <1446186123-11548-1-git-send-email-zhaoshenglong@huawei.com>
 <1446186123-11548-18-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4358497BD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2015 16:17:35 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6kwVdxWmOIaL for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Nov 2015 16:17:34 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7C5CA49013
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2015 16:17:34 -0500 (EST)
In-Reply-To: <1446186123-11548-18-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 10/30/2015 02:21 AM, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> According to ARMv8 spec, when writing 1 to PMCR.E, all counters are
> enabled by PMCNTENSET, while writing 0 to PMCR.E, all counters are
> disabled. When writing 1 to PMCR.P, reset all event counters, not
> including PMCCNTR, to zero. When writing 1 to PMCR.C, reset PMCCNTR to
> zero.

> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index ae21089..11d1bfb 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -121,6 +121,56 @@ void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val)
>  }
>  
>  /**
> + * kvm_pmu_handle_pmcr - handle PMCR register
> + * @vcpu: The vcpu pointer
> + * @val: the value guest writes to PMCR register
> + */
> +void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u32 val)
> +{
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +	struct kvm_pmc *pmc;
> +	u32 enable;
> +	int i;
> +
> +	if (val & ARMV8_PMCR_E) {
> +		if (!vcpu_mode_is_32bit(vcpu))
> +			enable = vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
> +		else
> +			enable = vcpu_cp15(vcpu, c9_PMCNTENSET);
> +
> +		kvm_pmu_enable_counter(vcpu, enable, true);
> +	} else
> +		kvm_pmu_disable_counter(vcpu, 0xffffffffUL);

Nit: If using braces on one side of if-else, please use them on the other.
(Search for "braces in both branches" in Documentation/CodingStyle.)

> +
> +	if (val & ARMV8_PMCR_C) {
> +		pmc = &pmu->pmc[ARMV8_MAX_COUNTERS - 1];
> +		if (pmc->perf_event)
> +			local64_set(&pmc->perf_event->count, 0);
> +		if (!vcpu_mode_is_32bit(vcpu))
> +			vcpu_sys_reg(vcpu, PMCCNTR_EL0) = 0;
> +		else
> +			vcpu_cp15(vcpu, c9_PMCCNTR) = 0;
> +	}
> +
> +	if (val & ARMV8_PMCR_P) {
> +		for (i = 0; i < ARMV8_MAX_COUNTERS - 1; i++) {
> +			pmc = &pmu->pmc[i];
> +			if (pmc->perf_event)
> +				local64_set(&pmc->perf_event->count, 0);
> +			if (!vcpu_mode_is_32bit(vcpu))
> +				vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = 0;
> +			else
> +				vcpu_cp15(vcpu, c14_PMEVCNTR0 + i) = 0;
> +		}
> +	}
> +
> +	if (val & ARMV8_PMCR_LC) {
> +		pmc = &pmu->pmc[ARMV8_MAX_COUNTERS - 1];
> +		pmc->bitmask = 0xffffffffffffffffUL;
> +	}
> +}
> +
> +/**
>   * kvm_pmu_overflow_clear - clear PMU overflow interrupt
>   * @vcpu: The vcpu pointer
>   * @val: the value guest writes to PMOVSCLR register
> 


-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
