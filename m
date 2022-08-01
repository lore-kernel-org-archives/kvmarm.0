Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1855DC00144
	for <kvmarm@archiver.kernel.org>; Mon,  1 Aug 2022 17:01:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7009D512CF;
	Mon,  1 Aug 2022 13:01:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C7ZH5mHi1Fem; Mon,  1 Aug 2022 13:01:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 437B6512B1;
	Mon,  1 Aug 2022 13:01:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE7B3512AF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Aug 2022 13:01:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id drEjIYeoSsp1 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Aug 2022 13:01:03 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AE8D95125E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Aug 2022 13:01:03 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id EBE6D60FF2;
 Mon,  1 Aug 2022 17:01:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6BBC433D6;
 Mon,  1 Aug 2022 17:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1659373261;
 bh=Z45pVOFSTCFEAx6+Wh45cf+XZc8fZoJvDTaluUAkcUw=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=gAuWrjCVOnV54VoUf6Wk/lvDhyaAiRPvEsrLeiXs42J9SdnIJEBYupOsEHbxSwEr3
 tyDQ03M8Qo6wv0GQtH/DJPZCX3NDiHsskcrScHkAsT4/9AT+xo/lafLwvSSj0i6cW2
 ypDLaBwRMuJAptg7cBj+95zHw3cZtC8Cw88uQk+PiiIHqOgkwIO4/SqSU7KKlSYUR0
 5Dd1o53PsIYZ4X5w31gwcPcq4aor0yiFfSId5NH8ZuhQ+auk1k1slT8pb0/uVZv2K3
 bo6XSXhaZetWr5YcAj4XYDo63jqMeI2y2AV7qZR4H6IvV0zJkuNTf+Je29FbnDvFRO
 7Nrd2wWpDKfzA==
Date: Mon, 1 Aug 2022 18:00:56 +0100
From: Will Deacon <will@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: KVM/arm64: SPE: Translate VA to IPA on a stage 2 fault instead
 of pinning VM memory
Message-ID: <20220801170055.GB26471@willie-the-truck>
References: <Yl6+JWaP+mq2Nc0b@monolith.localdoman>
 <20220419141012.GB6143@willie-the-truck>
 <Yt5nFAscgrRGNGoH@monolith.localdoman>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Yt5nFAscgrRGNGoH@monolith.localdoman>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: maz@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Mon, Jul 25, 2022 at 11:06:24AM +0100, Alexandru Elisei wrote:
> On Tue, Apr 19, 2022 at 03:10:13PM +0100, Will Deacon wrote:
> > On Tue, Apr 19, 2022 at 02:51:05PM +0100, Alexandru Elisei wrote:
> > > The approach I've taken so far in adding support for SPE in KVM [1] relies
> > > on pinning the entire VM memory to avoid SPE triggering stage 2 faults
> > > altogether. I've taken this approach because:
> > > 
> > > 1. SPE reports the guest VA on an stage 2 fault, similar to stage 1 faults,
> > > and at the moment KVM has no way to resolve the VA to IPA translation.  The
> > > AT instruction is not useful here, because PAR_EL1 doesn't report the IPA
> > > in the case of a stage 2 fault on a stage 1 translation table walk.
> > > 
> > > 2. The stage 2 fault is reported asynchronously via an interrupt, which
> > > means there will be a window where profiling is stopped from the moment SPE
> > > triggers the fault and when the PE taks the interrupt. This blackout window
> > > is obviously not present when running on bare metal, as there is no second
> > > stage of address translation being performed.
> > 
> > Are these faults actually recoverable? My memory is a bit hazy here, but I
> > thought SPE buffer data could be written out in whacky ways such that even
> > a bog-standard page fault could result in uncoverable data loss (i.e. DL=1),
> > and so pinning is the only game in town.
> > 
> > A funkier approach might be to defer pinning of the buffer until the SPE is
> > enabled and avoid pinning all of VM memory that way, although I can't
> > immediately tell how flexible the architecture is in allowing you to cache
> > the base/limit values.
> 
> I was investigating this approach, and Mark raised a concern that I think
> might be a showstopper.
> 
> Let's consider this scenario:
> 
> Initial conditions: guest at EL1, profiling disabled (PMBLIMITR_EL1.E = 0,
> PMBSR_EL1.S = 0, PMSCR_EL1.{E0SPE,E1SPE} = {0,0}).
> 
> 1. Guest programs the buffer and enables it (PMBLIMITR_EL1.E = 1).
> 2. Guest programs SPE to enable profiling at **EL0**
> (PMSCR_EL1.{E0SPE,E1SPE} = {1,0}).
> 3. Guest changes the translation table entries for the buffer. The
> architecture allows this.

The architecture also allows MMIO accesses to use writeback addressing
modes, but it doesn't provide a mechanism to virtualise them sensibly.

So I'd prefer that we don't pin all of guest memory just to satisfy a corner
case -- as long as the impact of a guest doing this funny sequence is
constrained to the guest, then I think pinning only what is required is
probably the most pragmatic approach.

Is it ideal? No, of course not, and we should probably try to get the debug
architecture extended to be properly virtualisable, but in the meantime
having major operating systems as guests and being able to use SPE without
pinning seems like a major design goal to me.

In any case, that's just my thinking on this and I defer to Oliver and
Marc on the ultimate decision.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
