Return-Path: <SRS0=HUCa=TW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DA2CC282CE
	for <kvmarm@archiver.kernel.org>; Wed, 22 May 2019 16:26:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F0F3E20675
	for <kvmarm@archiver.kernel.org>; Wed, 22 May 2019 16:26:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F0F3E20675
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6009D4A4A9;
	Wed, 22 May 2019 12:26:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kswj67RNeinu; Wed, 22 May 2019 12:26:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 047C84A4AA;
	Wed, 22 May 2019 12:26:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 05BA44A4A4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 May 2019 12:26:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vMFRzJUfYVNy for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 May 2019 12:26:11 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 90DC54A321
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 May 2019 12:26:11 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 06EFF341;
 Wed, 22 May 2019 09:26:11 -0700 (PDT)
Received: from localhost (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 93A4B3F5AF;
 Wed, 22 May 2019 09:26:10 -0700 (PDT)
Date: Wed, 22 May 2019 17:26:08 +0100
From: Andrew Murray <andrew.murray@arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v8 5/6] KVM: arm/arm64: remove pmc->bitmask
Message-ID: <20190522162608.GF8268@e119886-lin.cambridge.arm.com>
References: <20190522153019.18645-1-andrew.murray@arm.com>
 <20190522153019.18645-6-andrew.murray@arm.com>
 <7f84fcac-ee73-d076-f0e3-3b214912daaf@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <7f84fcac-ee73-d076-f0e3-3b214912daaf@arm.com>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Wed, May 22, 2019 at 05:07:31PM +0100, Marc Zyngier wrote:
> On 22/05/2019 16:30, Andrew Murray wrote:
> > We currently use pmc->bitmask to determine the width of the pmc - however
> > it's superfluous as the pmc index already describes if the pmc is a cycle
> > counter or event counter. The architecture clearly describes the widths of
> > these counters.
> > 
> > Let's remove the bitmask to simplify the code.
> > 
> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > ---
> >  include/kvm/arm_pmu.h |  1 -
> >  virt/kvm/arm/pmu.c    | 15 +++++----------
> >  2 files changed, 5 insertions(+), 11 deletions(-)
> > 
> > diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> > index b73f31baca52..2f0e28dc5a9e 100644
> > --- a/include/kvm/arm_pmu.h
> > +++ b/include/kvm/arm_pmu.h
> > @@ -28,7 +28,6 @@
> >  struct kvm_pmc {
> >  	u8 idx;	/* index into the pmu->pmc array */
> >  	struct perf_event *perf_event;
> > -	u64 bitmask;
> >  };
> >  
> >  struct kvm_pmu {
> > diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> > index ae1e886d4a1a..c4e2bc213617 100644
> > --- a/virt/kvm/arm/pmu.c
> > +++ b/virt/kvm/arm/pmu.c
> > @@ -47,7 +47,10 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
> >  		counter += perf_event_read_value(pmc->perf_event, &enabled,
> >  						 &running);
> >  
> > -	return counter & pmc->bitmask;
> > +	if (select_idx != ARMV8_PMU_CYCLE_IDX)
> > +		counter = lower_32_bits(counter);
> > +
> > +	return counter;
> >  }
> >  
> >  /**
> > @@ -113,7 +116,6 @@ void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu)
> >  	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
> >  		kvm_pmu_stop_counter(vcpu, &pmu->pmc[i]);
> >  		pmu->pmc[i].idx = i;
> > -		pmu->pmc[i].bitmask = 0xffffffffUL;
> >  	}
> >  }
> >  
> > @@ -348,8 +350,6 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
> >   */
> >  void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
> >  {
> > -	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> > -	struct kvm_pmc *pmc;
> >  	u64 mask;
> >  	int i;
> >  
> > @@ -368,11 +368,6 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
> >  		for (i = 0; i < ARMV8_PMU_CYCLE_IDX; i++)
> >  			kvm_pmu_set_counter_value(vcpu, i, 0);
> >  	}
> > -
> > -	if (val & ARMV8_PMU_PMCR_LC) {
> > -		pmc = &pmu->pmc[ARMV8_PMU_CYCLE_IDX];
> > -		pmc->bitmask = 0xffffffffffffffffUL;
> > -	}
> >  }
> >  
> >  static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u64 select_idx)
> > @@ -420,7 +415,7 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
> >  
> >  	counter = kvm_pmu_get_counter_value(vcpu, select_idx);
> >  	/* The initial sample period (overflow count) of an event. */
> > -	attr.sample_period = (-counter) & pmc->bitmask;
> > +	attr.sample_period = (-counter) & GENMASK(31, 0);
> 
> Isn't this the one case where the bitmask actually matters? If we're
> dealing with the cycle counter, it shouldn't be truncated, right?

Ah yes, that should be conditional on idx as well. 

Thanks,

Andrew Murray

> 
> >  
> >  	event = perf_event_create_kernel_counter(&attr, -1, current,
> >  						 kvm_pmu_perf_overflow, pmc);
> > 
> 
> Thanks,
> 
> 	M.
> -- 
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
