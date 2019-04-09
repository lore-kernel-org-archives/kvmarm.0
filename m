Return-Path: <SRS0=N2lg=SL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF2CEC10F0E
	for <kvmarm@archiver.kernel.org>; Tue,  9 Apr 2019 11:00:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 57E0D20883
	for <kvmarm@archiver.kernel.org>; Tue,  9 Apr 2019 11:00:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 57E0D20883
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC47C4A3BF;
	Tue,  9 Apr 2019 07:00:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7CQsyNIg8I6a; Tue,  9 Apr 2019 07:00:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DD764A445;
	Tue,  9 Apr 2019 07:00:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24F524A3BF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Apr 2019 07:00:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NVWW-GJWHRss for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Apr 2019 07:00:33 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 90AEB4A380
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Apr 2019 07:00:33 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EFD47A78;
 Tue,  9 Apr 2019 04:00:32 -0700 (PDT)
Received: from localhost (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 862203F59C;
 Tue,  9 Apr 2019 04:00:32 -0700 (PDT)
Date: Tue, 9 Apr 2019 12:00:30 +0100
From: Andrew Murray <andrew.murray@arm.com>
To: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v12 8/8] arm64: docs: document perf event attributes
Message-ID: <20190409110030.GB25919@e119886-lin.cambridge.arm.com>
References: <20190328103731.27264-1-andrew.murray@arm.com>
 <20190328103731.27264-9-andrew.murray@arm.com>
 <20190404162128.GD27577@fuggles.cambridge.arm.com>
 <20190404193350.GP53702@e119886-lin.cambridge.arm.com>
 <20190405124308.GD3100@fuggles.cambridge.arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190405124308.GD3100@fuggles.cambridge.arm.com>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Cc: Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190409110030.vKHbTDnBmTBUMRf2EOHm-GFyA5BmTn9YGIDX3rYCztk@z>

On Fri, Apr 05, 2019 at 01:43:08PM +0100, Will Deacon wrote:
> On Thu, Apr 04, 2019 at 08:33:51PM +0100, Andrew Murray wrote:
> > On Thu, Apr 04, 2019 at 05:21:28PM +0100, Will Deacon wrote:
> > > On Thu, Mar 28, 2019 at 10:37:31AM +0000, Andrew Murray wrote:
> > > > +exclude_kernel
> > > > +--------------
> > > > +
> > > > +This attribute excludes the kernel.
> > > > +
> > > > +The kernel runs at EL2 with VHE and EL1 without. Guest kernels always run
> > > > +at EL1.
> > > > +
> > > > +This attribute will exclude EL1 and additionally EL2 on a VHE system.
> > > 
> > > I find this last sentence a bit confusing, because it can be read to imply
> > > that if you don't set exclude_kernel and you're in a guest on a VHE system,
> > > then you can profile EL2.
> > 
> > Yes this could be misleading.
> > 
> > However from the perspective of the guest, when exclude_kernel is not set we
> > do indeed allow the guest to program it's PMU with ARMV8_PMU_INCLUDE_EL2 - and
> > thus the statement above is correct in terms of what the kernel believes it is
> > doing.
> > 
> > I think these statements are less confusing if we treat the exception levels
> > as those 'detected' by the running context (e.g. consider the impact of nested
> > virt here) - and we if ignore what the hypervisor (KVM) does outside (e.g.
> > stops counting upon switching between guest/host, translating PMU filters in
> > kvm_pmu_set_counter_event_type etc, etc). This then makes this document useful
> > for those wishing to change this logic (which is the intent) rather than those
> > trying to understand how we filter for EL levels as seen bare-metal.
> > 
> > With regards to the example you gave (exclude_kernel, EL2) - yes we want the
> > kernel to believe it can count EL2 - because one day we may want to update
> > KVM to allow the guest to count it's hypervisor overhead (e.g. host kernel
> > time associated with the guest).
> 
> If we were to support this in the future, then exclude_hv will suddenly
> start meaning something in a guest, so this could be considered to be an ABI
> break.
> 
> > I could write some preface that describes this outlook. Alternatively I could
> > just spell out what happens on a guest, e.g.
> > 
> > "For the host this attribute will exclude EL1 and additionally EL2 on a VHE
> > system.
> > 
> > For the guest this attribute will exclude EL1."
> > 
> > Though I'm less comfortable with this, as the last statement "For the guest this
> > attribute will exclude EL1." describes the product of both
> > kvm_pmu_set_counter_event_type and armv8pmu_set_event_filter which is confusing
> > to work out and also makes an assumption that we don't have nested virt (true
> > for now at least) and also reasons about bare-metal EL levels which probably
> > aren't that useful for someone changing this logic or understanding what the
> > flags do for there performance analysis.
> > 
> > Do you have a preference for how this is improved?
> 
> I think you should be explicit about what is counted. If we don't count EL2
> when profiling in a guest (regardless of the exclude_*) flags, then we
> should say that. By not documenting this we don't actually buy ourselves
> room to change things in future, we should have an emergent behaviour which
> isn't covered by our docs.

OK no problem, I'll update this.

Andrew Murray

> 
> Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
