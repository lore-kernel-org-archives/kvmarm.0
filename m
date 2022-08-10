Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F9ADC3F6B0
	for <kvmarm@archiver.kernel.org>; Wed, 10 Aug 2022 07:18:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3E034D5BE;
	Wed, 10 Aug 2022 03:18:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fFcJ8UWiUW47; Wed, 10 Aug 2022 03:18:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 983E94D5D4;
	Wed, 10 Aug 2022 03:18:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36FE54D5BE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 03:18:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g4CbbR3Yxem9 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Aug 2022 03:17:59 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0E7D64D5D4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 03:17:59 -0400 (EDT)
Date: Wed, 10 Aug 2022 02:17:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1660115878;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=4H6aplbdkM4J5SGx/3gsDNjblU9QVtypMaeGnaAIAsc=;
 b=Kg0/4Sk1YnCkQ/m1F3VPGNCCGYkUYC+3E74SiJobSJy96DnV3wqQc27acsaWcCNHYXI6l8
 niUBIRVXi0zUfFRrJQ2PmaglNZqAnasR8nTowkmZpU6q5VZLwu3YBjyI0SrwWIpXApjeAc
 xvnPg6HGSLtzeSVIx3UjtAS5QaJrb1k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 4/9] KVM: arm64: PMU: Add counter_index_to_*reg() helpers
Message-ID: <YvNboA7nla0NcKwa@google.com>
References: <20220805135813.2102034-1-maz@kernel.org>
 <20220805135813.2102034-5-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220805135813.2102034-5-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

On Fri, Aug 05, 2022 at 02:58:08PM +0100, Marc Zyngier wrote:
> In order to reduce the boilerplate code, add two helpers returning
> the counter register index (resp. the event register) in the vcpu
> register file from the counter index.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

> ---
>  arch/arm64/kvm/pmu-emul.c | 27 +++++++++++++++------------
>  1 file changed, 15 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 0ab6f59f433c..9be485d23416 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -75,6 +75,16 @@ static struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
>  	return container_of(vcpu_arch, struct kvm_vcpu, arch);
>  }
>  
> +static u32 counter_index_to_reg(u64 idx)
> +{
> +	return (idx == ARMV8_PMU_CYCLE_IDX) ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + idx;
> +}
> +
> +static u32 counter_index_to_evtreg(u64 idx)
> +{
> +	return (idx == ARMV8_PMU_CYCLE_IDX) ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + idx;
> +}
> +
>  /**
>   * kvm_pmu_get_counter_value - get PMU counter value
>   * @vcpu: The vcpu pointer
> @@ -89,8 +99,7 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
>  	if (!kvm_vcpu_has_pmu(vcpu))
>  		return 0;
>  
> -	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
> -		? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
> +	reg = counter_index_to_reg(select_idx);
>  	counter = __vcpu_sys_reg(vcpu, reg);
>  
>  	/*
> @@ -120,8 +129,7 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
>  	if (!kvm_vcpu_has_pmu(vcpu))
>  		return;
>  
> -	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
> -	      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
> +	reg = counter_index_to_reg(select_idx);
>  	__vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
>  
>  	/* Recreate the perf event to reflect the updated sample_period */
> @@ -156,10 +164,7 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
>  
>  	counter = kvm_pmu_get_counter_value(vcpu, pmc->idx);
>  
> -	if (pmc->idx == ARMV8_PMU_CYCLE_IDX)
> -		reg = PMCCNTR_EL0;
> -	else
> -		reg = PMEVCNTR0_EL0 + pmc->idx;
> +	reg = counter_index_to_reg(pmc->idx);
>  
>  	if (!kvm_pmu_idx_is_64bit(vcpu, pmc->idx))
>  		counter = lower_32_bits(counter);
> @@ -540,8 +545,7 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>  	struct perf_event_attr attr;
>  	u64 eventsel, counter, reg, data;
>  
> -	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
> -	      ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + pmc->idx;
> +	reg = counter_index_to_evtreg(select_idx);
>  	data = __vcpu_sys_reg(vcpu, reg);
>  
>  	kvm_pmu_stop_counter(vcpu, pmc);
> @@ -627,8 +631,7 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>  	mask &= ~ARMV8_PMU_EVTYPE_EVENT;
>  	mask |= kvm_pmu_event_mask(vcpu->kvm);
>  
> -	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
> -	      ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + select_idx;
> +	reg = counter_index_to_evtreg(select_idx);
>  
>  	__vcpu_sys_reg(vcpu, reg) = data & mask;
>  
> -- 
> 2.34.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
