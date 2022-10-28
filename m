Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC957C38A02
	for <kvmarm@archiver.kernel.org>; Fri, 28 Oct 2022 15:31:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 303F94B602;
	Fri, 28 Oct 2022 11:31:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XXti4rP2rI0d; Fri, 28 Oct 2022 11:31:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F22A4B633;
	Fri, 28 Oct 2022 11:31:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A86FC4B492
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2022 11:31:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pnY2-95CxbY2 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Oct 2022 11:31:11 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 13AD14B4D7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2022 11:31:11 -0400 (EDT)
Date: Fri, 28 Oct 2022 17:31:07 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1666971068;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=mKCuPt/8IWceQBTjesPE2RI/v342KHoVYNbvb2oGIP8=;
 b=cuKEiP9Bg1x9GoVMbysf+C4/1aQCs1sFDPgLKeGi1NcRcVmD1tizMDcG4TCF2SodD0+zks
 0IHvBXJOV1lpsQirhekOgTB/NZ+SS2OflLj+ppq03FQectutagyp4FGQ9NPMhw6C0g1t6K
 enOBU6s4b7+eDXJ6Hl+hiUMtz8U15yY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [kvm-unit-tests PATCH v4 0/4] arm: pmu: Fixes for bare metal
Message-ID: <20221028153107.ul5uexzwuwefes6a@kamzik>
References: <20220811185210.234711-1-ricarkol@google.com>
 <20221028114041.5symayccvdgkqaor@kamzik>
 <86fsf8dmap.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <86fsf8dmap.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
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

On Fri, Oct 28, 2022 at 04:01:50PM +0100, Marc Zyngier wrote:
> Hi Drew,
> 
> On Fri, 28 Oct 2022 12:40:41 +0100,
> Andrew Jones <andrew.jones@linux.dev> wrote:
> > 
> > On Thu, Aug 11, 2022 at 11:52:06AM -0700, Ricardo Koller wrote:
> > > There are some tests that fail when running on bare metal (including a
> > > passthrough prototype).  There are three issues with the tests.  The
> > > first one is that there are some missing isb()'s between enabling event
> > > counting and the actual counting. This wasn't an issue on KVM as
> > > trapping on registers served as context synchronization events. The
> > > second issue is that some tests assume that registers reset to 0.  And
> > > finally, the third issue is that overflowing the low counter of a
> > > chained event sets the overflow flag in PMVOS and some tests fail by
> > > checking for it not being set.
> > > 
> > > Addressed all comments from the previous version:
> > > https://lore.kernel.org/kvmarm/YvPsBKGbHHQP+0oS@google.com/T/#mb077998e2eb9fb3e15930b3412fd7ba2fb4103ca
> > > - add pmu_reset() for 32-bit arm [Andrew]
> > > - collect r-b from Alexandru
> > > 
> > > Thanks!
> > > Ricardo
> > > 
> > > Ricardo Koller (4):
> > >   arm: pmu: Add missing isb()'s after sys register writing
> > >   arm: pmu: Add reset_pmu() for 32-bit arm
> > >   arm: pmu: Reset the pmu registers before starting some tests
> > >   arm: pmu: Check for overflow in the low counter in chained counters
> > >     tests
> > > 
> > >  arm/pmu.c | 72 ++++++++++++++++++++++++++++++++++++++++++-------------
> > >  1 file changed, 55 insertions(+), 17 deletions(-)
> > >
> > 
> > Hi all,
> > 
> > Please refresh my memory. Does this series work on current platforms? Or
> > was it introducing new test failures which may be in the test, as opposed
> > to KVM? If they work on most platforms, but not on every platform, then
> > have we identified what triggers them to fail and whether that should be
> > fixed or just worked-around? I'm sorry I still can't help out with the
> > testing as I haven't yet had time to setup the Rpi that Mark Rutland gave
> > me in Dublin.
> 
> This series does show that KVM is buggy, and I have patches out to fix
> it [1]. The patches should work on anything, really.
> 
> > I know this series has been rotting on arm/queue for months, so I'll be
> > happy to merge it if the consensus is to do so. I can also drop it, or
> > some of the patches, if that's the consensus.
> 
> I'd be very happy to see these patches being merged.

Thanks for the information, Marc. I've gone ahead and merged the tests.
What's the worst than can happen :-)  Anyway, I agree that when the tests
start failing in CIs, then they're doing their job. If your pending series
can't be applied right away, then the CIs can likely be taught to
temporarily ignore the known failures.

Thanks,
drew

> 
> Thanks,
> 
> 	M.
> 
> [1] https://lore.kernel.org/r/20221028105402.2030192-1-maz@kernel.org
> 
> -- 
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
