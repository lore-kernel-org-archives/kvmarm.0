Return-Path: <SRS0=uW/I=UL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AE6FC31E48
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jun 2019 14:30:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F2D2E208CA
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jun 2019 14:30:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F2D2E208CA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B7434A519;
	Wed, 12 Jun 2019 10:30:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V25TYej93wXm; Wed, 12 Jun 2019 10:30:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 54A3C4A51A;
	Wed, 12 Jun 2019 10:30:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E320F4A518
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jun 2019 10:30:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ftWCCJqJOTXX for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Jun 2019 10:30:42 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 72C984A4EA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jun 2019 10:30:42 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F387D2B;
 Wed, 12 Jun 2019 07:30:41 -0700 (PDT)
Received: from localhost (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 753743F557;
 Wed, 12 Jun 2019 07:30:41 -0700 (PDT)
Date: Wed, 12 Jun 2019 15:30:39 +0100
From: Andrew Murray <andrew.murray@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v8 5/6] KVM: arm/arm64: remove pmc->bitmask
Message-ID: <20190612143039.GE49779@e119886-lin.cambridge.arm.com>
References: <20190522153019.18645-1-andrew.murray@arm.com>
 <20190522153019.18645-6-andrew.murray@arm.com>
 <7f84fcac-ee73-d076-f0e3-3b214912daaf@arm.com>
 <20190522162608.GF8268@e119886-lin.cambridge.arm.com>
 <036304c6-d5a8-5b36-48e1-1e919c55fc4c@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <036304c6-d5a8-5b36-48e1-1e919c55fc4c@arm.com>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu,
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

On Mon, Jun 10, 2019 at 01:54:35PM +0100, Suzuki K Poulose wrote:
> 
> 
> On 22/05/2019 17:26, Andrew Murray wrote:
> > On Wed, May 22, 2019 at 05:07:31PM +0100, Marc Zyngier wrote:
> > > On 22/05/2019 16:30, Andrew Murray wrote:
> > > > We currently use pmc->bitmask to determine the width of the pmc - however
> > > > it's superfluous as the pmc index already describes if the pmc is a cycle
> > > > counter or event counter. The architecture clearly describes the widths of
> > > > these counters.
> > > > 
> > > > Let's remove the bitmask to simplify the code.
> > > > 
> > > > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > > > ---
> > > >   include/kvm/arm_pmu.h |  1 -
> > > >   virt/kvm/arm/pmu.c    | 15 +++++----------
> > > >   2 files changed, 5 insertions(+), 11 deletions(-)
> > > > 
> > > > diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> > > > index b73f31baca52..2f0e28dc5a9e 100644
> > > > --- a/include/kvm/arm_pmu.h
> > > > +++ b/include/kvm/arm_pmu.h
> > > > @@ -28,7 +28,6 @@
> > > >   struct kvm_pmc {
> > > >   	u8 idx;	/* index into the pmu->pmc array */
> > > >   	struct perf_event *perf_event;
> > > > -	u64 bitmask;
> > > >   };
> 
> 
> > > > -
> > > > -	if (val & ARMV8_PMU_PMCR_LC) {
> > > > -		pmc = &pmu->pmc[ARMV8_PMU_CYCLE_IDX];
> > > > -		pmc->bitmask = 0xffffffffffffffffUL;
> > > > -	}
> > > >   }
> 
> ...
> 
> > > >   static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u64 select_idx)
> > > > @@ -420,7 +415,7 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
> > > >   	counter = kvm_pmu_get_counter_value(vcpu, select_idx);
> > > >   	/* The initial sample period (overflow count) of an event. */
> > > > -	attr.sample_period = (-counter) & pmc->bitmask;
> > > > +	attr.sample_period = (-counter) & GENMASK(31, 0);
> > > 
> > > Isn't this the one case where the bitmask actually matters? If we're
> > > dealing with the cycle counter, it shouldn't be truncated, right?
> > 
> > Ah yes, that should be conditional on idx as well.
> 
> The mask for Cycle counter also depends on the PMCR.LC field set by the
> guest, isn't it ? So unless we correlate that with the idx, we could be
> passing in wrong results ?

Yes that's right, I misread the description of LC - it's RES1 for AArch64
but of course this doesn't stop a 32 bit host kernel. I'll update this.

Thanks,

Andrew Murray

> 
> Suzuki
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
