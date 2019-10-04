Return-Path: <SRS0=I38I=X5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D8EEC4360C
	for <kvmarm@archiver.kernel.org>; Fri,  4 Oct 2019 08:56:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A9C8A2070B
	for <kvmarm@archiver.kernel.org>; Fri,  4 Oct 2019 08:56:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A9C8A2070B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EADBC4A65E;
	Fri,  4 Oct 2019 04:56:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UwqGWefK9khm; Fri,  4 Oct 2019 04:55:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C272F4A5BD;
	Fri,  4 Oct 2019 04:55:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 516D14A5A9
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Oct 2019 04:55:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e67pLpy0ntCC for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Oct 2019 04:55:58 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C5774A590
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Oct 2019 04:55:58 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7F5621597;
 Fri,  4 Oct 2019 01:55:57 -0700 (PDT)
Received: from localhost (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 046B13F739;
 Fri,  4 Oct 2019 01:55:56 -0700 (PDT)
Date: Fri, 4 Oct 2019 09:55:55 +0100
From: Andrew Murray <andrew.murray@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: pmu: Fix cycle counter truncation on counter
 stop
Message-ID: <20191004085554.GQ42880@e119886-lin.cambridge.arm.com>
References: <20191003172400.21157-1-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191003172400.21157-1-maz@kernel.org>
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

On Thu, Oct 03, 2019 at 06:24:00PM +0100, Marc Zyngier wrote:
> When a counter is disabled, its value is sampled before the event
> is being disabled, and the value written back in the shadow register.
> 
> In that process, the value gets truncated to 32bit, which is adequate

Doh, that shouldn't have happened.

> for any counter but the cycle counter, which can be configured to
> hold a 64bit value. This obviously results in a corrupted counter,
> and things like "perf record -e cycles" not working at all when
> run in a guest...
> 
> Make the truncation conditional on the counter not being 64bit.
> 
> Fixes: 80f393a23be6 ("KVM: arm/arm64: Support chained PMU counters")
> Cc: Andrew Murray <andrew.murray@arm.com>
> Reported-by: Julien Thierry Julien Thierry <julien.thierry.kdev@gmail.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  virt/kvm/arm/pmu.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index 362a01886bab..d716aef2bae9 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -206,9 +206,11 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
>  		__vcpu_sys_reg(vcpu, reg) = lower_32_bits(counter);
>  		__vcpu_sys_reg(vcpu, reg + 1) = upper_32_bits(counter);
>  	} else {
> +		if (!kvm_pmu_idx_is_64bit(vcpu, pmc->idx))
> +			counter = lower_32_bits(counter);
>  		reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
>  		       ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
> -		__vcpu_sys_reg(vcpu, reg) = lower_32_bits(counter);
> +		__vcpu_sys_reg(vcpu, reg) = counter;

The other uses of lower_32_bits look OK to me.

Reviewed-by: Andrew Murray <andrew.murray@arm.com>

As a side note, I'm not convinced that the implementation (or perhaps the
use of) kvm_pmu_idx_is_64bit is correct:

static bool kvm_pmu_idx_is_64bit(struct kvm_vcpu *vcpu, u64 select_idx)
{
        return (select_idx == ARMV8_PMU_CYCLE_IDX &&
                __vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_LC);
}

We shouldn't truncate the value of a cycle counter to 32 bits just because
_PMCR_LC is unset. We should only be interested in _PMCR_LC when setting
the sample_period.

If you agree this is wrong, I'll spin a change.

Though unsetting _PMCR_LC is deprecated so I can't imagine this causes any
issue.

Thanks,

Andrew Murray

>  	}
>  
>  	kvm_pmu_release_perf_event(pmc);
> -- 
> 2.20.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
