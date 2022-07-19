Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B3AC43334
	for <kvmarm@archiver.kernel.org>; Tue, 19 Jul 2022 11:26:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F17FE4C976;
	Tue, 19 Jul 2022 07:26:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wzp70WlHlnk1; Tue, 19 Jul 2022 07:26:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A98444C919;
	Tue, 19 Jul 2022 07:26:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B1704C919
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 07:26:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bIFZLzbGO3Hg for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Jul 2022 07:26:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A0DB64C904
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 07:26:27 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 35C02153B;
 Tue, 19 Jul 2022 04:26:27 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 480323F766;
 Tue, 19 Jul 2022 04:26:25 -0700 (PDT)
Date: Tue, 19 Jul 2022 12:26:54 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [kvm-unit-tests PATCH 1/3] arm: pmu: Add missing isb()'s after
 sys register writing
Message-ID: <YtaU/oSBWaBhjKYP@monolith.localdoman>
References: <20220718154910.3923412-1-ricarkol@google.com>
 <20220718154910.3923412-2-ricarkol@google.com>
 <YtWMXYyrEvZDFrAb@monolith.localdoman>
 <YtWc7YbR2d9uEZmX@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YtWc7YbR2d9uEZmX@google.com>
Cc: drjones@redhat.com, kvm@vger.kernel.org, maz@kernel.org,
 oliver.upton@linux.dev, kvmarm@lists.cs.columbia.edu
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

Hi,

On Mon, Jul 18, 2022 at 10:48:29AM -0700, Ricardo Koller wrote:
> On Mon, Jul 18, 2022 at 05:38:23PM +0100, Alexandru Elisei wrote:
> > Hi,
> > 
> > On Mon, Jul 18, 2022 at 08:49:08AM -0700, Ricardo Koller wrote:
> > > There are various pmu tests that require an isb() between enabling
> > > counting and the actual counting. This can lead to count registers
> > > reporting less events than expected; the actual enabling happens after
> > > some events have happened.  For example, some missing isb()'s in the
> > > pmu-sw-incr test lead to the following errors on bare-metal:
> > > 
> > > 	INFO: pmu: pmu-sw-incr: SW_INCR counter #0 has value 4294967280
> > >         PASS: pmu: pmu-sw-incr: PWSYNC does not increment if PMCR.E is unset
> > >         FAIL: pmu: pmu-sw-incr: counter #1 after + 100 SW_INCR
> > >         FAIL: pmu: pmu-sw-incr: counter #0 after + 100 SW_INCR
> > >         INFO: pmu: pmu-sw-incr: counter values after 100 SW_INCR #0=82 #1=98
> > >         PASS: pmu: pmu-sw-incr: overflow on counter #0 after 100 SW_INCR
> > >         SUMMARY: 4 tests, 2 unexpected failures
> > > 
> > > Add the missing isb()'s on all failing tests, plus some others that are
> > > not currently required but might in the future (like an isb() after
> > > clearing the overflow signal in the IRQ handler).
> > 
> > That's rather cryptic. What might require those hypothetical ISBs and why? Why
> > should a test add code for some hypothetical requirement that might, or might
> > not, be implemented?
> 
> Good point, this wasn't very clear. Will add something more specific.
> 
> > 
> > This is pure speculation on my part, were you seeing spurious interrupts that
> > went away after adding the ISB in irq_handler()?
> 
> I didn't see any. But I think it could happen: multiple spurious
> interrupts until the line finally gets cleared.

I agree with you, it takes a finite time for any interrupt controller (in
our case, the GIC) to deassert the interrupt line to the CPU after a device
has deasserted the interrupt line to the interrupt controller. That's why
device drivers are usually robust in dealing with spurious interrupts.

It looks to me that the way irq_handler() treats spurious interrupts might
lead to tests being incorrectly treated as failed, which is going to be a
pain to reproduce and diagnose.

@Eric, was there a particular reason for this approach?

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
