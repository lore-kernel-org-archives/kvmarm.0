Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A123BC04A68
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jul 2022 16:06:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B6314C915;
	Wed, 27 Jul 2022 12:06:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GRrfYp8XuLz0; Wed, 27 Jul 2022 12:06:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F28F54C918;
	Wed, 27 Jul 2022 12:06:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 549654C915
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 12:06:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bcAkdTGFn6ZM for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Jul 2022 12:06:34 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 03C7E4C913
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 12:06:33 -0400 (EDT)
Date: Wed, 27 Jul 2022 16:06:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1658937993;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=jn9jHV/s0Q+BX5nI+AoGuNqFTdhYxUJgGjXqeiORd9k=;
 b=jpGfgkrYyGqdsd+Ginq9okV0U8BWrOTA0KenuB+AyMw/dScNca0W1WDwB6BO0FArfy27PS
 hAgSmZRVGx0JifP1hgTbaHdutRghnEEBS4Zf3zUZ6myaeph0QDo1xYaC3Xd/j52vPlhM+h
 HPbgHMNkXXRLgGUBLfutyhQ1EiirmX4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: KVM/arm64: SPE: Translate VA to IPA on a stage 2 fault instead
 of pinning VM memory
Message-ID: <YuFihl0AQvb5w/M3@google.com>
References: <Yl6+JWaP+mq2Nc0b@monolith.localdoman>
 <20220419141012.GB6143@willie-the-truck>
 <Yt5nFAscgrRGNGoH@monolith.localdoman>
 <YuApmZFdZzTi5ROu@google.com> <875yjiyka4.wl-maz@kernel.org>
 <874jz2yja5.wl-maz@kernel.org>
 <YuEVq8Au7YsDLOdI@monolith.localdoman>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YuEVq8Au7YsDLOdI@monolith.localdoman>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Wed, Jul 27, 2022 at 11:38:53AM +0100, Alexandru Elisei wrote:
> Hi Marc,
> 
> On Wed, Jul 27, 2022 at 10:52:34AM +0100, Marc Zyngier wrote:
> > On Wed, 27 Jul 2022 10:30:59 +0100,
> > Marc Zyngier <maz@kernel.org> wrote:
> > > 
> > > On Tue, 26 Jul 2022 18:51:21 +0100,
> > > Oliver Upton <oliver.upton@linux.dev> wrote:
> > > > 
> > > > Doesn't pinning the buffer also imply pinning the stage 1 tables
> > > > responsible for its translation as well? I agree that pinning the buffer
> > > > is likely the best way forward as pinning the whole of guest memory is
> > > > entirely impractical.
> > 
> > Huh, I just realised that you were talking about S1. I don't think we
> > need to do this. As long as the translation falls into a mapped
> > region (pinned or not), we don't need to worry.

Right, but my issue is what happens when a fragment of the S1 becomes
unmapped at S2. We were discussing the idea of faulting once on the
buffer at the beginning of profiling, seems to me that it could just as
easily happen at runtime and get tripped up by what Alex points out
below:

> PMBSR_EL1.DL might be set 1 as a result of stage 2 fault reported by SPE,
> which means the last record written is incomplete. Records have a variable
> size, so it's impossible for KVM to revert to the end of the last known
> good record without parsing the buffer (references here [1]). And even if
> KVM would know the size of a record, there's this bit in the Arm ARM which
> worries me (ARM DDI 0487H.a, page D10-5177):
> 
> "The architecture does not require that a sample record is written
> sequentially by the SPU, only that:
> [..]
> - On a Profiling Buffer management interrupt, PMBSR_EL1.DL indicates
>   whether PMBPTR_EL1 points to the first byte after the last complete
>   sample record."
> 
> So there might be gaps in the buffer, meaning that the entire buffer would
> have to be discarded if DL is set as a result of a stage 2 fault.

Attempting to avoid thrashing with more threads so I'm going to summon back
some context from your original reply, Marc:

> > > > Live migration also throws a wrench in this. IOW, there are still potential
> > > > sources of blackout unattributable to guest manipulation of the SPU.
> > >
> > > Can you chime some light on this? I appreciate that you can't play the
> > > R/O trick on the SPE buffer as it invalidates the above discussion,
> > > but it should be relatively easy to track these pages and never reset
> > > them as clean until the vcpu is stopped. Unless you foresee other
> > > issues?

Right, we can play tricks on pre-copy to avoid write protecting the SPE
buffer. My concern was more around post-copy, where userspace could've
decided to leave the buffer behind and demand it back on the resulting
S2 fault.

> > > To be clear, I don't worry too much about these blind windows. The
> > > architecture doesn't really give us the right tools to make it work
> > > reliably, making this a best effort only. Unless we pin the whole
> > > guest and forego migration and other fault-driven mechanisms.
> > >
> > > Maybe that is a choice we need to give to the user: cheap, fast,
> > > reliable. Pick two.

As long as we crisply document the errata in KVM's virtualized SPE (and
inform the guest), that sounds reasonable. I'm just uneasy about
proceeding with an implementation w/ so many gotchas unless all parties
involved are aware of the quirks.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
