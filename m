Return-Path: <SRS0=MuL5=YA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C36C5C4740A
	for <kvmarm@archiver.kernel.org>; Mon,  7 Oct 2019 08:48:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4BE3E2084B
	for <kvmarm@archiver.kernel.org>; Mon,  7 Oct 2019 08:48:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4BE3E2084B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C3254A81D;
	Mon,  7 Oct 2019 04:48:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zSCM6AybJ9PV; Mon,  7 Oct 2019 04:48:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5268D4A842;
	Mon,  7 Oct 2019 04:48:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B072B4A842
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Oct 2019 04:48:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PhorrGuncBrU for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Oct 2019 04:48:03 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7783A4A840
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Oct 2019 04:48:03 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A681A1570;
 Mon,  7 Oct 2019 01:48:02 -0700 (PDT)
Received: from localhost (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 29A753F68E;
 Mon,  7 Oct 2019 01:48:02 -0700 (PDT)
Date: Mon, 7 Oct 2019 09:48:00 +0100
From: Andrew Murray <andrew.murray@arm.com>
To: maz@kernel.org
Subject: Re: [PATCH 1/3] KVM: arm64: pmu: Fix cycle counter truncation
Message-ID: <20191007084800.GW42880@e119886-lin.cambridge.arm.com>
References: <20191006104636.11194-1-maz@kernel.org>
 <20191006104636.11194-2-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191006104636.11194-2-maz@kernel.org>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
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

On Sun, Oct 06, 2019 at 11:46:34AM +0100, maz@kernel.org wrote:
> From: Marc Zyngier <maz@kernel.org>
> 
> When a counter is disabled, its value is sampled before the event
> is being disabled, and the value written back in the shadow register.
> 
> In that process, the value gets truncated to 32bit, which is adequate
> for any counter but the cycle counter (defined as a 64bit counter).
> 
> This obviously results in a corrupted counter, and things like
> "perf record -e cycles" not working at all when run in a guest...
> A similar, but less critical bug exists in kvm_pmu_get_counter_value.
> 
> Make the truncation conditional on the counter not being the cycle
> counter, which results in a minor code reorganisation.
> 
> Fixes: 80f393a23be6 ("KVM: arm/arm64: Support chained PMU counters")
> Cc: Andrew Murray <andrew.murray@arm.com>
> Reported-by: Julien Thierry <julien.thierry.kdev@gmail.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---

Reviewed-by: Andrew Murray <andrew.murray@arm.com>

>  virt/kvm/arm/pmu.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index 362a01886bab..c30c3a74fc7f 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -146,8 +146,7 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
>  	if (kvm_pmu_pmc_is_chained(pmc) &&
>  	    kvm_pmu_idx_is_high_counter(select_idx))
>  		counter = upper_32_bits(counter);
> -
> -	else if (!kvm_pmu_idx_is_64bit(vcpu, select_idx))
> +	else if (select_idx != ARMV8_PMU_CYCLE_IDX)
>  		counter = lower_32_bits(counter);
>  
>  	return counter;
> @@ -193,7 +192,7 @@ static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
>   */
>  static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
>  {
> -	u64 counter, reg;
> +	u64 counter, reg, val;
>  
>  	pmc = kvm_pmu_get_canonical_pmc(pmc);
>  	if (!pmc->perf_event)
> @@ -201,16 +200,19 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
>  
>  	counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
>  
> -	if (kvm_pmu_pmc_is_chained(pmc)) {
> -		reg = PMEVCNTR0_EL0 + pmc->idx;
> -		__vcpu_sys_reg(vcpu, reg) = lower_32_bits(counter);
> -		__vcpu_sys_reg(vcpu, reg + 1) = upper_32_bits(counter);
> +	if (pmc->idx == ARMV8_PMU_CYCLE_IDX) {
> +		reg = PMCCNTR_EL0;
> +		val = counter;
>  	} else {
> -		reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
> -		       ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
> -		__vcpu_sys_reg(vcpu, reg) = lower_32_bits(counter);
> +		reg = PMEVCNTR0_EL0 + pmc->idx;
> +		val = lower_32_bits(counter);
>  	}
>  
> +	__vcpu_sys_reg(vcpu, reg) = val;
> +
> +	if (kvm_pmu_pmc_is_chained(pmc))
> +		__vcpu_sys_reg(vcpu, reg + 1) = upper_32_bits(counter);
> +
>  	kvm_pmu_release_perf_event(pmc);
>  }
>  
> -- 
> 2.20.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
