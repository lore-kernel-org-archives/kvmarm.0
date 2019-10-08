Return-Path: <SRS0=tYEe=YB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63A2EC4360C
	for <kvmarm@archiver.kernel.org>; Tue,  8 Oct 2019 19:52:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E1FC021835
	for <kvmarm@archiver.kernel.org>; Tue,  8 Oct 2019 19:52:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E1FC021835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 624114A904;
	Tue,  8 Oct 2019 15:52:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wTV9VDSxN2Jp; Tue,  8 Oct 2019 15:52:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 262C54A901;
	Tue,  8 Oct 2019 15:52:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 62B384A900
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Oct 2019 15:52:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xkw8uWH3ga-x for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Oct 2019 15:52:52 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 245644A8F9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Oct 2019 15:52:52 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C8D1515BE;
 Tue,  8 Oct 2019 12:52:51 -0700 (PDT)
Received: from localhost (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4C7243F68E;
 Tue,  8 Oct 2019 12:52:51 -0700 (PDT)
Date: Tue, 8 Oct 2019 20:52:49 +0100
From: Andrew Murray <andrew.murray@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 4/5] arm64: perf: Add reload-on-overflow capability
Message-ID: <20191008195248.GJ42880@e119886-lin.cambridge.arm.com>
References: <20191008160128.8872-1-maz@kernel.org>
 <20191008160128.8872-5-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191008160128.8872-5-maz@kernel.org>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Tue, Oct 08, 2019 at 05:01:27PM +0100, Marc Zyngier wrote:
> As KVM uses perf as a way to emulate an ARMv8 PMU, it needs to
> be able to change the sample period as part of the overflow
> handling (once an overflow has taken place, the following
> overflow point is the overflow of the virtual counter).
> 
> Deleting and recreating the in-kernel event is difficult, as
> we're in interrupt context. Instead, we can teach the PMU driver
> a new trick, which is to stop the event before the overflow handling,
> and reprogram it once it has been handled. This would give KVM
> the opportunity to adjust the next sample period. This feature
> is gated on a new flag that can get set by KVM in a subsequent
> patch.
> 
> Whilst we're at it, move the CHAINED flag from the KVM emulation
> to the perf_event.h file and adjust the PMU code accordingly.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/perf_event.h | 4 ++++
>  arch/arm64/kernel/perf_event.c      | 8 +++++++-
>  virt/kvm/arm/pmu.c                  | 4 +---
>  3 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/perf_event.h b/arch/arm64/include/asm/perf_event.h
> index 2bdbc79bbd01..8b6b38f2db8e 100644
> --- a/arch/arm64/include/asm/perf_event.h
> +++ b/arch/arm64/include/asm/perf_event.h
> @@ -223,4 +223,8 @@ extern unsigned long perf_misc_flags(struct pt_regs *regs);
>  	(regs)->pstate = PSR_MODE_EL1h;	\
>  }
>  
> +/* Flags used by KVM, among others */
> +#define PERF_ATTR_CFG1_CHAINED_EVENT	(1U << 0)
> +#define PERF_ATTR_CFG1_RELOAD_EVENT	(1U << 1)
> +
>  #endif
> diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
> index a0b4f1bca491..98907c9e5508 100644
> --- a/arch/arm64/kernel/perf_event.c
> +++ b/arch/arm64/kernel/perf_event.c
> @@ -322,7 +322,7 @@ PMU_FORMAT_ATTR(long, "config1:0");
>  
>  static inline bool armv8pmu_event_is_64bit(struct perf_event *event)
>  {
> -	return event->attr.config1 & 0x1;
> +	return event->attr.config1 & PERF_ATTR_CFG1_CHAINED_EVENT;

I'm pleased to see this be replaced with a define, it helps readers see the
link between this and the KVM driver.

>  }
>  
>  static struct attribute *armv8_pmuv3_format_attrs[] = {
> @@ -736,8 +736,14 @@ static irqreturn_t armv8pmu_handle_irq(struct arm_pmu *cpu_pmu)
>  		if (!armpmu_event_set_period(event))
>  			continue;
>  
> +		if (event->attr.config1 & PERF_ATTR_CFG1_RELOAD_EVENT)
> +			cpu_pmu->pmu.stop(event, PERF_EF_RELOAD);

I believe PERF_EF_RELOAD is only intended to be used in the stop calls. I'd
suggest that you replace it with PERF_EF_UPDATE instead, this tells the PMU
to update the counter with the latest value from the hardware. (Though the
ARM PMU driver always does this regardless to the flag anyway).

Thanks,

Andrew Murray

> +
>  		if (perf_event_overflow(event, &data, regs))
>  			cpu_pmu->disable(event);
> +
> +		if (event->attr.config1 & PERF_ATTR_CFG1_RELOAD_EVENT)
> +			cpu_pmu->pmu.start(event, PERF_EF_RELOAD);
>  	}
>  	armv8pmu_start(cpu_pmu);
>  
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index f291d4ac3519..25a483a04beb 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -15,8 +15,6 @@
>  
>  static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx);
>  
> -#define PERF_ATTR_CFG1_KVM_PMU_CHAINED 0x1
> -
>  /**
>   * kvm_pmu_idx_is_64bit - determine if select_idx is a 64bit counter
>   * @vcpu: The vcpu pointer
> @@ -570,7 +568,7 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>  		 */
>  		attr.sample_period = (-counter) & GENMASK(63, 0);
>  		if (kvm_pmu_counter_is_enabled(vcpu, pmc->idx + 1))
> -			attr.config1 |= PERF_ATTR_CFG1_KVM_PMU_CHAINED;
> +			attr.config1 |= PERF_ATTR_CFG1_CHAINED_EVENT;
>  
>  		event = perf_event_create_kernel_counter(&attr, -1, current,
>  							 kvm_pmu_perf_overflow,
> -- 
> 2.20.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
