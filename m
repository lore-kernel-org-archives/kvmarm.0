Return-Path: <SRS0=wAvJ=UQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C996DC31E5D
	for <kvmarm@archiver.kernel.org>; Mon, 17 Jun 2019 18:07:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 57D72208E4
	for <kvmarm@archiver.kernel.org>; Mon, 17 Jun 2019 18:07:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 57D72208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B9F384A50D;
	Mon, 17 Jun 2019 14:07:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H59YltPVqa0D; Mon, 17 Jun 2019 14:07:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A1324A50E;
	Mon, 17 Jun 2019 14:07:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D94874A509
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jun 2019 14:07:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JZumOdqYSvKQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Jun 2019 14:07:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C7534A483
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jun 2019 14:07:01 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E642B28;
 Mon, 17 Jun 2019 11:07:00 -0700 (PDT)
Received: from localhost (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 66E013F246;
 Mon, 17 Jun 2019 11:07:00 -0700 (PDT)
Date: Mon, 17 Jun 2019 19:06:58 +0100
From: Andrew Murray <andrew.murray@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v9 4/5] KVM: arm/arm64: remove pmc->bitmask
Message-ID: <20190617180658.GN20984@e119886-lin.cambridge.arm.com>
References: <20190612190450.7085-1-andrew.murray@arm.com>
 <20190612190450.7085-5-andrew.murray@arm.com>
 <6a8e4fdd-d8cf-f3fb-55cd-2d06805b0eb9@arm.com>
 <20190613093957.GG49779@e119886-lin.cambridge.arm.com>
 <5e18d747-1d82-8eed-ef1c-de86c5b3a7e7@arm.com>
 <20190617154311.GM20984@e119886-lin.cambridge.arm.com>
 <f3ea8075-b395-9fa4-afba-771011f62b59@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <f3ea8075-b395-9fa4-afba-771011f62b59@arm.com>
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

On Mon, Jun 17, 2019 at 05:33:40PM +0100, Suzuki K Poulose wrote:
> 
> 
> On 17/06/2019 16:43, Andrew Murray wrote:
> > On Thu, Jun 13, 2019 at 05:50:43PM +0100, Suzuki K Poulose wrote:
> > > 
> > > 
> > > On 13/06/2019 10:39, Andrew Murray wrote:
> > > > On Thu, Jun 13, 2019 at 08:30:51AM +0100, Julien Thierry wrote:
> 
> > > > > > index ae1e886d4a1a..88ce24ae0b45 100644
> > > > > > --- a/virt/kvm/arm/pmu.c
> > > > > > +++ b/virt/kvm/arm/pmu.c
> > > > > > @@ -47,7 +47,10 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
> > > > > >    		counter += perf_event_read_value(pmc->perf_event, &enabled,
> > > > > >    						 &running);
> > > > > > -	return counter & pmc->bitmask;
> > > > > > +	if (select_idx != ARMV8_PMU_CYCLE_IDX)
> > > > > > +		counter = lower_32_bits(counter);
> > > > > 
> > > > > Shouldn't this depend on PMCR.LC as well? If PMCR.LC is clear we only
> > > > > want the lower 32bits of the cycle counter.
> > > > 
> > > > Yes that's correct. The hunk should look like this:
> > > > 
> > > > -       return counter & pmc->bitmask;
> > > > +       if (!(select_idx == ARMV8_PMU_CYCLE_IDX &&
> > > > +             __vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_LC))
> > > > +               counter = lower_32_bits(counter);
> > > > +
> > > > +       return counter;
> > > 
> > > May be you could add a macro :
> > > 
> > > #define vcpu_pmu_counter_is_64bit(vcpu, idx) ?
> > 
> > Yes I think a helper would be useful - though I'd prefer the name
> > 'kvm_pmu_idx_is_long_cycle_counter'. This seems a little clearer as
> > you could otherwise argue that a chained counter is also 64 bits.
> 
> When you get to add 64bit PMU counter (v8.5), this would be handy. So
> having it de-coupled from the cycle counter may be a good idea. Anyways,
> I leave that to you.

Yes that thought crossed my mind. I'll take your suggestion afterall.

Thanks,

Andrew Murray

> 
> Cheers
> Suzuki
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
