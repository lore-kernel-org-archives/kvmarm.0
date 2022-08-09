Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD76C19F2D
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 18:44:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BD2C4CB00;
	Tue,  9 Aug 2022 14:44:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id grhmzbawb8i5; Tue,  9 Aug 2022 14:44:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 790E04CAF3;
	Tue,  9 Aug 2022 14:44:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C4F24CAF3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 14:44:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VW8KFGoenMT5 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 14:44:26 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A074B4CAD9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 14:44:26 -0400 (EDT)
Date: Tue, 9 Aug 2022 13:43:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1660070665;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=+401aRRlxdNPmc7JT1r6yfCUVKOWpta+WEQhHbjPeGY=;
 b=CGOg/lXkILaS03pHyWoWnpeWRziCG3WdcoHPt50JH4/m3vDCffbiEZS5EBsvwQEc07aPYw
 Yicrs+OPJdiYwYGcLnnwxTDNn3ZwTLGynD5xPyJ/Rvvn4GH4LYvCVZbHbsqeeRLTlAl4zA
 dMKp1ndbN9SC2ShF5oWnK91cyLMwwgE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: KVM/arm64: SPE: Translate VA to IPA on a stage 2 fault instead
 of pinning VM memory
Message-ID: <YvKq1IK7T/nGSKpt@google.com>
References: <Yl6+JWaP+mq2Nc0b@monolith.localdoman>
 <20220419141012.GB6143@willie-the-truck>
 <Yt5nFAscgrRGNGoH@monolith.localdoman>
 <20220801170055.GB26471@willie-the-truck>
 <YujzE33aPSD22wvY@monolith.localdoman>
 <Yul8UBoDcy6GQddq@google.com>
 <YvJowFt+U/qCqNVV@monolith.localdoman>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YvJowFt+U/qCqNVV@monolith.localdoman>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: maz@kernel.org, Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

Hi Alex,

On Tue, Aug 09, 2022 at 03:01:36PM +0100, Alexandru Elisei wrote:

[...]

> > > To summarize the approaches we've discussed so far:
> > > 
> > > 1. Pinning the entire guest memory
> > > - Heavy handed and not ideal.
> > > - Tried this approach in v5 of the SPE series [1], patches #2-#12.
> > > 
> > > 2. Mapping the guest SPE buffer on demand, page by page, as a result of stage 2
> > > faults reported by SPE.
> > > - Not feasible, because the entire contents of the buffer must be discarded is
> > >   PMBSR_EL1.DL is set to 1 when taking the fault.
> > > - Requires KVM to walk the guest's stage 1 tables, because SPE reports the VA,
> > >   not the IPA.
> > > 
> > > 3. Pinning the guest SPE buffer when profiling becomes enabled*:
> > > - There is the corner case described above, when profiling becomes enabled as a
> > >   result of an ERET to EL0. This can happen when the buffer is enabled and
> > >   PMSCR_EL1.{E0SPE,E1SPE} = {1,0};
> > > - The previous buffer is unpinned when a new buffer is pinned, to avoid SPE
> > >   stage 2 faults when draining the buffer, which is performed with profiling
> > >   disabled.
> > > - Also requires KVM to walk the guest's stage 1 tables.
> > > 
> > > 4. Pin the entire guest SPE buffer after the first stage 2 fault reported by
> > > SPE.
> > > - Gets rid of the corner case at 3.
> > > - Same approach to buffer unpinning as 3.
> > > - Introduces a blackout window before the first record is written.
> > > - Also requires KVM to walk the guest's stage 1 tables.
> > > 
> > > As for the corner case at 3, I proposed either:
> > > 
> > > a) Mandate that guest operating systems must never modify the buffer
> > > translation entries if the buffer is enabled and
> > > PMSCR_EL1.{E0SPE,E1SPE} = {1,0}.
> > > 
> > > b) Pin the entire buffer as a result of the first stage 2 fault reported by SPE,
> > > but **only** for this corner case. For all other cases, the buffer is pinned
> > > when profiling becomes enabled, to eliminate the blackout window. Guest
> > > operating systems can be modified to not change the translation entries for the
> > > buffer if this blackout window is not desirable.
> > > 
> > > Pinning as a result of the **first** stage 2 fault should work, because there
> > > are no prior records that would have to be discarded if PMSBR_EL1.DL = 1.
> > > 
> > > I hope I haven't missed anything. Thoughts and suggestions more than welcome.
> > 
> > Thanks Alex for pulling together all of the context here.
> > 
> > Unless there's any other strong opinions on the topic, it seems to me
> > that option #4 (pin on S2 fault) is probably the best approach for
> > the initial implementation. No amount of tricks in KVM can work around
> > the fact that SPE has some serious issues w.r.t. virtualization. With
> > that, we should probably document the behavior of SPE as a known erratum
> > of KVM.
> > 
> > If folks complain about EL1 profile blackout, eagerly pinning when
> > profiling is enabled could layer on top quite easily by treating it as
> > a synthetic S2 fault and triggering the implementation of #4. Having
> 
> I'm not sure I follow, I understand what you mean by "treating it as a
> synthetic S2 fault", would you mind elaborating?

Assuming approach #4 is implemented, we will already have an SPE fault
handler that walks stage-1 and pins the buffer. At that point,
implementing approach #3 would be relatively easy. When EL1 sets
PMSCR_EL1.E1SPE, call the SPE fault handler on the GVA of the buffer.

> > said that I don't believe it is a hard requirement for enabling some
> > flavor of SPE for guests.
> > 
> > Walking guest S1 in KVM doesn't sound too exciting although it'll need to
> > be done eventually.
> > 
> > Do you feel like this is an OK route forward, or have I missed
> > something?
> 
> I've been giving this some thought, and I prefer approach #3 because with
> #4, pinning the buffer as a result of a stage 2 fault reported by SPE, it
> will be impossible to distinguish between a valid stage 2 fault (a fault
> caused by the guest reprogramming the buffer and enabling profiling) and
> KVM messing something up when pinning the buffer. I believe this to be
> important, as experience has shown me that pinning the buffer at stage 2 is
> not trivial and there isn't a mechanism today in Linux to do that
> (explanation and examples here [1]).

How does eagerly pinning avoid stage-2 aborts, though? As you note in
[1], page pinning does not avoid the possibility of the MMU notifiers
being called on a given range. Want to make sure I'm following, what
is your suggestion for approach #3 to handle the profile buffer when
only enabled at EL0?

> With approach #4, it would be impossible to figure out if the results of a
> profiling operations inside a guest are representative of the workload or
> not, because those SPE stage 2 faults triggered by a bug in KVM can happen
> multiple times per profiling session, introducing multiple blackout windows
> that can skew the results.
> 
> If you're proposing that the blackout window when the first record is
> written be documented as an erratum for KVM, then why no got a step further
> and document as an erratum that changing the buffer translation tables
> after the buffer has been enabled will lead to an SPE Serror? That will
> allow us to always pin the buffer when profiling is enabled.

Ah, there are certainly more errata in virtualizing SPE beyond what I
had said :) Preserving the stage-1 translations while profiling is
active is a good recommendation, although I'm not sure that we've
completely eliminated the risk of stage-2 faults. 

It seems impossible to blame the guest for all stage-2 faults that happen
in the middle of a profiling session. In addition to host mm driven changes
to stage-2, live migration is a busted as well. You'd need to build out
stage-2 on the target before resuming the guest and guarantee that the
appropriate pages have been demanded from the source (in case of post-copy).

So, are we going to inject an SError for stage-2 faults outside of guest
control as well? An external abort reported as an SPE buffer management
event seems to be gracefully handled by the Linux driver, but that behavior
is disallowed by SPEv1p3.

To sum up the point I'm getting at: I agree that there are ways to
reduce the risk of stage-2 faults in the middle of profiling, but I
don't believe the current architecture allows KVM to virtualize the
feature to the letter of the specification.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
