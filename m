Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DE12C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jul 2022 10:05:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A80B4D6C5;
	Mon, 25 Jul 2022 06:05:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qOxl0mfmcjwu; Mon, 25 Jul 2022 06:05:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31D2E4D72E;
	Mon, 25 Jul 2022 06:05:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59CC94D6C5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jul 2022 06:05:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VbBsmmrSitCc for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Jul 2022 06:05:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B32474D62B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jul 2022 06:05:47 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AAB562B;
 Mon, 25 Jul 2022 03:05:47 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D176C3F73D;
 Mon, 25 Jul 2022 03:05:45 -0700 (PDT)
Date: Mon, 25 Jul 2022 11:06:24 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Will Deacon <will@kernel.org>
Subject: Re: KVM/arm64: SPE: Translate VA to IPA on a stage 2 fault instead
 of pinning VM memory
Message-ID: <Yt5nFAscgrRGNGoH@monolith.localdoman>
References: <Yl6+JWaP+mq2Nc0b@monolith.localdoman>
 <20220419141012.GB6143@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220419141012.GB6143@willie-the-truck>
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

Hi,

On Tue, Apr 19, 2022 at 03:10:13PM +0100, Will Deacon wrote:
> On Tue, Apr 19, 2022 at 02:51:05PM +0100, Alexandru Elisei wrote:
> > The approach I've taken so far in adding support for SPE in KVM [1] relies
> > on pinning the entire VM memory to avoid SPE triggering stage 2 faults
> > altogether. I've taken this approach because:
> > 
> > 1. SPE reports the guest VA on an stage 2 fault, similar to stage 1 faults,
> > and at the moment KVM has no way to resolve the VA to IPA translation.  The
> > AT instruction is not useful here, because PAR_EL1 doesn't report the IPA
> > in the case of a stage 2 fault on a stage 1 translation table walk.
> > 
> > 2. The stage 2 fault is reported asynchronously via an interrupt, which
> > means there will be a window where profiling is stopped from the moment SPE
> > triggers the fault and when the PE taks the interrupt. This blackout window
> > is obviously not present when running on bare metal, as there is no second
> > stage of address translation being performed.
> 
> Are these faults actually recoverable? My memory is a bit hazy here, but I
> thought SPE buffer data could be written out in whacky ways such that even
> a bog-standard page fault could result in uncoverable data loss (i.e. DL=1),
> and so pinning is the only game in town.
> 
> A funkier approach might be to defer pinning of the buffer until the SPE is
> enabled and avoid pinning all of VM memory that way, although I can't
> immediately tell how flexible the architecture is in allowing you to cache
> the base/limit values.

I was investigating this approach, and Mark raised a concern that I think
might be a showstopper.

Let's consider this scenario:

Initial conditions: guest at EL1, profiling disabled (PMBLIMITR_EL1.E = 0,
PMBSR_EL1.S = 0, PMSCR_EL1.{E0SPE,E1SPE} = {0,0}).

1. Guest programs the buffer and enables it (PMBLIMITR_EL1.E = 1).
2. Guest programs SPE to enable profiling at **EL0**
(PMSCR_EL1.{E0SPE,E1SPE} = {1,0}).
3. Guest changes the translation table entries for the buffer. The
architecture allows this.
4. Guest does an ERET to EL0, thus enabling profiling.

Since KVM cannot trap the ERET to EL0, it will be impossible for KVM to pin
the buffer at stage 2 when profiling gets enabled at EL0.

I can see two solutions here:

a. Accept the limitation (and advertise it in the documentation) that if
someone wants to use SPE when running as a Linux guest, the kernel used by
the guest must not change the buffer translation table entries after the
buffer has been enabled (PMBLIMITR_EL1.E = 1). Linux already does that, so
running a Linux guest should not be a problem. I don't know how other OSes
do it (but I can find out). We could also phrase it that the buffer
translation table entries can be changed after enabling the buffer, but
only if profiling happens at EL1. But that sounds very arbitrary.

b. Pin the buffer after the stage 2 DABT that SPE will report in the
situation above. This means that there is a blackout window, but will
happen only once after each time the guest reprograms the buffer. I don't
know if this is acceptable. We could say that this if this blackout window
is not acceptable, then the guest kernel shouldn't change the translation
table entries after enabling the buffer.

Or drop the approach of pinning the buffer and go back to pinning the
entire memory of the VM.

Any thoughts on this? I would very much prefer to try to pin only the
buffer.

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
