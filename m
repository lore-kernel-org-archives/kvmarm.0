Return-Path: <SRS0=PUN/=2O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12150C2D0D0
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 12:57:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8FFA32071A
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 12:56:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8FFA32071A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 317C44AF5A;
	Tue, 24 Dec 2019 07:56:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qQtEyjw5y01S; Tue, 24 Dec 2019 07:56:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B91834AF3A;
	Tue, 24 Dec 2019 07:56:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7401A4AF0B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 07:56:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tO4BGUIUuzYv for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Dec 2019 07:56:54 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 288414AF21
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 07:56:54 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CC4991FB;
 Tue, 24 Dec 2019 04:56:53 -0800 (PST)
Received: from localhost (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 446093F534;
 Tue, 24 Dec 2019 04:56:53 -0800 (PST)
Date: Tue, 24 Dec 2019 12:56:51 +0000
From: Andrew Murray <andrew.murray@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 00/18] arm64: KVM: add SPE profiling support
Message-ID: <20191224125651.GM42593@e119886-lin.cambridge.arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
 <f023f5529361cc1e2d799daa70f196c2@www.loen.fr>
 <864kxsim8d.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <864kxsim8d.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Sun, Dec 22, 2019 at 12:22:10PM +0000, Marc Zyngier wrote:
> On Sat, 21 Dec 2019 10:48:16 +0000,
> Marc Zyngier <maz@kernel.org> wrote:
> > 
> > [fixing email addresses]
> > 
> > Hi Andrew,
> > 
> > On 2019-12-20 14:30, Andrew Murray wrote:
> > > This series implements support for allowing KVM guests to use the Arm
> > > Statistical Profiling Extension (SPE).
> > 
> > Thanks for this. In future, please Cc me and Will on email addresses
> > we can actually read.
> > 
> > > It has been tested on a model to ensure that both host and guest can
> > > simultaneously use SPE with valid data. E.g.
> > > 
> > > $ perf record -e arm_spe/ts_enable=1,pa_enable=1,pct_enable=1/ \
> > >         dd if=/dev/zero of=/dev/null count=1000
> > > $ perf report --dump-raw-trace > spe_buf.txt
> > > 
> > > As we save and restore the SPE context, the guest can access the SPE
> > > registers directly, thus in this version of the series we remove the
> > > trapping and emulation.
> > > 
> > > In the previous series of this support, when KVM SPE isn't
> > > supported (e.g. via CONFIG_KVM_ARM_SPE) we were able to return a
> > > value of 0 to all reads of the SPE registers - as we can no longer
> > > do this there isn't a mechanism to prevent the guest from using
> > > SPE - thus I'm keen for feedback on the best way of resolving
> > > this.
> > 
> > Surely there is a way to conditionally trap SPE registers, right? You
> > should still be able to do this if SPE is not configured for a given
> > guest (as we do for other feature such as PtrAuth).
> > 
> > > It appears necessary to pin the entire guest memory in order to
> > > provide guest SPE access - otherwise it is possible for the guest
> > > to receive Stage-2 faults.
> > 
> > Really? How can the guest receive a stage-2 fault? This doesn't fit
> > what I understand of the ARMv8 exception model. Or do you mean a SPE
> > interrupt describing a S2 fault?

Yes the latter.


> > 
> > And this is not just pinning the memory either. You have to ensure that
> > all S2 page tables are created ahead of SPE being able to DMA to guest
> > memory. This may have some impacts on the THP code...
> > 
> > I'll have a look at the actual series ASAP (but that's not very soon).
> 
> I found some time to go through the series, and there is clearly a lot
> of work left to do:
> 
> - There so nothing here to handle memory pinning whatsoever. If it
>   works, it is only thanks to some side effect.
> 
> - The missing trapping is deeply worrying. Given that this is an
>   optional feature, you cannot just let the guest do whatever it wants
>   in an uncontrolled manner.

Yes I'll add this.


> 
> - The interrupt handling is busted. You mix concepts picked from both
>   the PMU and the timer code, while the SPE device doesn't behave like
>   any of these two (it is neither a fully emulated device, nor a
>   device that is exclusively owned by a guest at any given time).
> 
> I expect some level of discussion on the list including at least Will
> and myself before you respin this.

Thanks for the quick feedback.

Andrew Murray

> 
> 	M.
> 
> -- 
> Jazz is not dead, it just smells funny.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
