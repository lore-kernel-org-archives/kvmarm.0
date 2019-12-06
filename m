Return-Path: <SRS0=eeW8=Z4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C429C2BD09
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 16:02:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CD3422173E
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 16:02:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD3422173E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FD5F4A5A0;
	Fri,  6 Dec 2019 11:02:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ekhfc6s0df-z; Fri,  6 Dec 2019 11:02:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A1C44AF0C;
	Fri,  6 Dec 2019 11:02:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EA0F4AF0C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Dec 2019 11:02:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4Vw0tQENcVP1 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Dec 2019 11:02:38 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E32114A5A0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Dec 2019 11:02:37 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6DB2431B;
 Fri,  6 Dec 2019 08:02:37 -0800 (PST)
Received: from localhost (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B20C23F718;
 Fri,  6 Dec 2019 08:02:36 -0800 (PST)
Date: Fri, 6 Dec 2019 16:02:35 +0000
From: Andrew Murray <andrew.murray@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [RFC 2/3] KVM: arm64: pmu: Fix chained SW_INCR counters
Message-ID: <20191206160234.GP18399@e119886-lin.cambridge.arm.com>
References: <20191204204426.9628-1-eric.auger@redhat.com>
 <20191204204426.9628-3-eric.auger@redhat.com>
 <561ac6df385e977cc51d51a8ab28ee49@www.loen.fr>
 <2b30c1ca-3bc0-9f73-4bea-ee42bb74cbac@redhat.com>
 <15507faca89a980056df7119e105e82a@www.loen.fr>
 <20191206152141.GN18399@e119886-lin.cambridge.arm.com>
 <ea510414e337a4cab8ed9df737959368@www.loen.fr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <ea510414e337a4cab8ed9df737959368@www.loen.fr>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 eric.auger.pro@gmail.com
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

On Fri, Dec 06, 2019 at 03:35:03PM +0000, Marc Zyngier wrote:
> On 2019-12-06 15:21, Andrew Murray wrote:
> > On Thu, Dec 05, 2019 at 02:52:26PM +0000, Marc Zyngier wrote:
> > > On 2019-12-05 14:06, Auger Eric wrote:
> > > > Hi Marc,


> > > > >
> > > > > I think the whole function is a bit of a mess, and could be
> > > better
> > > > > structured to treat 64bit counters as a first class citizen.
> > > > >
> > > > > I'm suggesting something along those lines, which tries to
> > > > > streamline things a bit and keep the flow uniform between the
> > > > > two word sizes. IMHO, it helps reasonning about it and gives
> > > > > scope to the ARMv8.5 full 64bit counters... It is of course
> > > > > completely untested.
> > > >
> > > > Looks OK to me as well. One remark though, don't we need to test
> > > if the
> > > > n+1th reg is enabled before incrementing it?
> > 
> > Indeed - we don't want to indicate an overflow on a disabled counter.
> > 
> > 
> > > 
> > > Hmmm. I'm not sure. I think we should make sure that we don't flag
> > > a counter as being chained if the odd counter is disabled, rather
> > > than checking it here. As long as the odd counter is not chained
> > > *and* enabled, we shouldn't touch it.
> > 
> > Does this mean that we don't care if the low counter is enabled or not
> > when deciding if the pair is chained?
> > 
> > I would find the code easier to follow if we had an explicit 'is the
> > high counter enabled here' check (at the point of deciding where to
> > put the overflow).
> 
> Sure. But the point is that we're spreading that kind of checks all over
> the map, and that we don't have a way to even reason about the state of
> a 64bit counter. Doesn't it strike you as being mildly broken?
> 

Yup! To the point where I can't trust the function names and have to look
at what the code does...


> > > @@ -645,7 +647,8 @@ static void kvm_pmu_update_pmc_chained(struct
> > > kvm_vcpu
> > > *vcpu, u64 select_idx)
> > >  	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> > >  	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> > > 
> > > -	if (kvm_pmu_idx_has_chain_evtype(vcpu, pmc->idx)) {
> > > +	if (kvm_pmu_idx_has_chain_evtype(vcpu, pmc->idx) &&
> > > +	    kvm_pmu_counter_is_enabled(vcpu, pmc->idx)) {
> > 
> > I.e. here we don't care what the state of enablement is for the low
> > counter.
> > 
> > Also at present, this may break the following use-case
> > 
> >  - User creates and uses a pair of chained counters
> >  - User disables odd/high counter
> >  - User reads values of both counters
> >  - User rewrites CHAIN event to odd/high counter OR user re-enables
> > just the even/low counter
> >  - User reads value of both counters <- this may now different to the
> > last read
> 
> Hey, I didn't say it was perfect ;-). But for sure we can't let the
> PMU bitrot more than it already has, and I'm not sure this is heading
> the right way.

I think we're aligned here. To me this code is becoming very fragile, difficult
for me to make sense of and is stretching the abstractions we've made. This is
why it is difficult to enhance it without breaking something. It's why I felt it
was safer to add 'an extra check' in the SWINCR than to risk touching something
that I didn't have the confidence I could be sure was correct. 


> 
> I'm certainly going to push back on new PMU features until we can properly
> reason about 64bit counters as a top-level entity (as opposed to a bunch
> of discrete counters).

Thanks,

Andrew Murray

> 
> Thanks,
> 
>         M.
> -- 
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
