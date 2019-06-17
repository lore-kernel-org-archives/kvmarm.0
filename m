Return-Path: <SRS0=wAvJ=UQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 820A5C31E5B
	for <kvmarm@archiver.kernel.org>; Mon, 17 Jun 2019 19:25:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2267A2085A
	for <kvmarm@archiver.kernel.org>; Mon, 17 Jun 2019 19:25:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2267A2085A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 842CC4A506;
	Mon, 17 Jun 2019 15:25:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vQA7YStKw5pe; Mon, 17 Jun 2019 15:25:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DE704A4F0;
	Mon, 17 Jun 2019 15:25:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FDA34A4FA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jun 2019 15:24:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UhrLN7xbJwFg for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Jun 2019 15:24:57 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FAD74A4C1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jun 2019 15:24:57 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C9F482B;
 Mon, 17 Jun 2019 12:24:56 -0700 (PDT)
Received: from localhost (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4A64B3F246;
 Mon, 17 Jun 2019 12:24:56 -0700 (PDT)
Date: Mon, 17 Jun 2019 20:24:54 +0100
From: Andrew Murray <andrew.murray@arm.com>
To: Xiang Zheng <zhengxiang9@huawei.com>
Subject: Re: [PATCH] KVM: ARM64: Update perf event when setting PMU count value
Message-ID: <20190617192454.GO20984@e119886-lin.cambridge.arm.com>
References: <20190519100559.7188-1-zhengxiang9@huawei.com>
 <20190521164445.GW8268@e119886-lin.cambridge.arm.com>
 <482838e5-64a4-ef99-2e51-4b58e18ba4b4@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <482838e5-64a4-ef99-2e51-4b58e18ba4b4@huawei.com>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

On Wed, Jun 12, 2019 at 09:47:05PM +0800, Xiang Zheng wrote:
> 
> On 2019/5/22 0:44, Andrew Murray wrote:
> > On Sun, May 19, 2019 at 06:05:59PM +0800, Xiang Zheng wrote:
> >> Guest will adjust the sample period and set PMU counter value when
> >> it takes a long time to handle the PMU interrupts.
> >>
> >> However, we don't have a corresponding change on the virtual PMU
> >> which is emulated via a perf event. It could cause a large number
> >> of PMU interrupts injected to guest. Then guest will get hang for
> >> handling these interrupts.
> > 
> > Yes this is indeed an issue. I believe I've addressed this in my 'chained
> > pmu' series - the relevant patch is here...
> > 
> > https://lists.cs.columbia.edu/pipermail/kvmarm/2019-May/035933.html
> > 
> > Some other comments below.
> > 
> 
> Sorry for that I didn't notice your patches...
> I will test your patch series.

Thanks.

> 
> >>
> >> So update the sample_period of perf event if the counter value is
> >> changed to avoid this case.
> >>
> >> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
> >> ---
> >>  virt/kvm/arm/pmu.c | 54 +++++++++++++++++++++++++++++++++++++++++++++---------
> >>  1 file changed, 45 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> >> index 1c5b76c..cbad3ec 100644
> >> --- a/virt/kvm/arm/pmu.c
> >> +++ b/virt/kvm/arm/pmu.c
> >> @@ -24,6 +24,11 @@
> >>  #include <kvm/arm_pmu.h>
> >>  #include <kvm/arm_vgic.h>
> >>  
> >> +static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc);
> >> +static struct perf_event *kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu,
> >> +						    struct kvm_pmc *pmc,
> >> +						    struct perf_event_attr *attr);
> >> +
> >>  /**
> >>   * kvm_pmu_get_counter_value - get PMU counter value
> >>   * @vcpu: The vcpu pointer
> >> @@ -57,11 +62,29 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
> >>   */
> >>  void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
> >>  {
> >> -	u64 reg;
> >> +	u64 reg, counter, old_sample_period;
> >> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> >> +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> >> +	struct perf_event *event;
> >> +	struct perf_event_attr attr;
> >>  
> >>  	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
> >>  	      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
> >>  	__vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
> >> +
> >> +	if (pmc->perf_event) {
> >> +		attr = pmc->perf_event->attr;
> >> +		old_sample_period = attr.sample_period;
> >> +		counter = kvm_pmu_get_counter_value(vcpu, select_idx);
> >> +		attr.sample_period = (-counter) & pmc->bitmask;
> >> +		if (attr.sample_period == old_sample_period)
> >> +			return;
> > 
> > I'd be interested to know how often this would evaluate to true.
> > 
> 
> I have counted it while running my test script, the result shows that there are 1552288
> times evaluated to true and 8294235 times not.
> 
> I think different testcases may produce different results.

You may find that this occurs more often when you are using pinned events, e.g.
when the counter is pinned to a process. When this happens perf stops and starts
the counter each time the process is switched in/out. The ARM pmu
(drivers/perf/arm_pmu.c) resets the period each time the counter is restarted
(armpmu_start), and thus rewrites the same value to the hardware counter (I think).

If you run "perf stat -e instructions" you'll probably find the number reduces.

I guess there is a balance between doing unnecessary work (recreating the kernel
event) and code complexity here. However there is scope for similar optimisations
such as not recreating the event when someone writes the same event type 
(kvm_pmu_set_counter_event_type).

> 
> >> +
> >> +		kvm_pmu_stop_counter(vcpu, pmc);
> >> +		event = kvm_pmu_create_perf_event(vcpu, pmc, &attr);
> > 
> > I'm not sure it's necessary to change the prototype of kvm_pmu_create_perf_event
> > as this function will recalculate the sample period based on the updated counter
> > value anyway.
> > 
> 
> In this patch, kvm_pmu_create_perf_event() will not recalculate the sample period. Maybe
> you confuse it with your patch.:)

Yes sorry!

Thanks,

Andrew Murray

> 
> > Thanks,
> > 
> > Andrew Murray
> > 
> >> +		if (event)
> >> +			pmc->perf_event = event;
> >> +	}
> >>  }
> >>  
> >>  /**
> >> @@ -303,6 +326,24 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
> >>  	}
> >>  }
> >>  
> >> +static struct perf_event *kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu,
> >> +						    struct kvm_pmc *pmc,
> >> +						    struct perf_event_attr *attr)
> >> +{
> >> +	struct perf_event *event;
> >> +
> >> +	event = perf_event_create_kernel_counter(attr, -1, current,
> >> +						 kvm_pmu_perf_overflow, pmc);
> >> +
> >> +	if (IS_ERR(event)) {
> >> +		pr_err_once("kvm: pmu event creation failed %ld\n",
> >> +			    PTR_ERR(event));
> >> +		return NULL;
> >> +	}
> >> +
> >> +	return event;
> >> +}
> >> +
> >>  /**
> >>   * kvm_pmu_software_increment - do software increment
> >>   * @vcpu: The vcpu pointer
> >> @@ -416,15 +457,10 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
> >>  	/* The initial sample period (overflow count) of an event. */
> >>  	attr.sample_period = (-counter) & pmc->bitmask;
> >>  
> >> -	event = perf_event_create_kernel_counter(&attr, -1, current,
> >> -						 kvm_pmu_perf_overflow, pmc);
> >> -	if (IS_ERR(event)) {
> >> -		pr_err_once("kvm: pmu event creation failed %ld\n",
> >> -			    PTR_ERR(event));
> >> -		return;
> >> -	}
> >> +	event = kvm_pmu_create_perf_event(vcpu, pmc, &attr);
> >>  
> >> -	pmc->perf_event = event;
> >> +	if (event)
> >> +		pmc->perf_event = event;
> >>  }
> >>  
> >>  bool kvm_arm_support_pmu_v3(void)
> >> -- 
> >> 1.8.3.1
> >>
> >>
> >> _______________________________________________
> >> kvmarm mailing list
> >> kvmarm@lists.cs.columbia.edu
> >> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> > 
> > .
> > 
> -- 
> 
> Thanks,
> Xiang
> 
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
