Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA5AC04A68
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jul 2022 11:56:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 869C94C3AE;
	Wed, 27 Jul 2022 07:56:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gbNf2I4Xycc2; Wed, 27 Jul 2022 07:56:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 143C04C38A;
	Wed, 27 Jul 2022 07:56:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E513D4C38A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 07:56:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 33VLZczPhVK2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Jul 2022 07:56:42 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 602C04C371
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 07:56:42 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1A3BED6E;
 Wed, 27 Jul 2022 04:56:42 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A15EF3F73B;
 Wed, 27 Jul 2022 04:56:40 -0700 (PDT)
Date: Wed, 27 Jul 2022 12:57:16 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: KVM/arm64: SPE: Translate VA to IPA on a stage 2 fault instead
 of pinning VM memory
Message-ID: <YuEoCw/EBceUv2c4@monolith.localdoman>
References: <Yl6+JWaP+mq2Nc0b@monolith.localdoman>
 <20220419141012.GB6143@willie-the-truck>
 <Yt5nFAscgrRGNGoH@monolith.localdoman>
 <YuApmZFdZzTi5ROu@google.com>
 <YuERKEjJh1qsZf8x@monolith.localdoman>
 <04dea801e298374fb783bf0760b15241@kernel.org>
 <YuEW/zEjnddcRFad@monolith.localdoman>
 <2d1f87576ce17b8c72bfac522e2aa101@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2d1f87576ce17b8c72bfac522e2aa101@kernel.org>
Cc: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Wed, Jul 27, 2022 at 12:08:11PM +0100, Marc Zyngier wrote:
> On 2022-07-27 11:44, Alexandru Elisei wrote:
> > On Wed, Jul 27, 2022 at 11:29:03AM +0100, Marc Zyngier wrote:
> > > On 2022-07-27 11:19, Alexandru Elisei wrote:
> > > > Hi Oliver,
> > > >
> > > > Thank you for the help, replies below.
> > > >
> > > > On Tue, Jul 26, 2022 at 10:51:21AM -0700, Oliver Upton wrote:
> > > > > Hi Alex,
> > > > >
> > > > > On Mon, Jul 25, 2022 at 11:06:24AM +0100, Alexandru Elisei wrote:
> > > > >
> > > > > [...]
> > > > >
> > > > > > > A funkier approach might be to defer pinning of the buffer until the SPE is
> > > > > > > enabled and avoid pinning all of VM memory that way, although I can't
> > > > > > > immediately tell how flexible the architecture is in allowing you to cache
> > > > > > > the base/limit values.
> > > > > >
> > > > > > I was investigating this approach, and Mark raised a concern that I think
> > > > > > might be a showstopper.
> > > > > >
> > > > > > Let's consider this scenario:
> > > > > >
> > > > > > Initial conditions: guest at EL1, profiling disabled (PMBLIMITR_EL1.E = 0,
> > > > > > PMBSR_EL1.S = 0, PMSCR_EL1.{E0SPE,E1SPE} = {0,0}).
> > > > > >
> > > > > > 1. Guest programs the buffer and enables it (PMBLIMITR_EL1.E = 1).
> > > > > > 2. Guest programs SPE to enable profiling at **EL0**
> > > > > > (PMSCR_EL1.{E0SPE,E1SPE} = {1,0}).
> > > > > > 3. Guest changes the translation table entries for the buffer. The
> > > > > > architecture allows this.
> > > > > > 4. Guest does an ERET to EL0, thus enabling profiling.
> > > > > >
> > > > > > Since KVM cannot trap the ERET to EL0, it will be impossible for KVM to pin
> > > > > > the buffer at stage 2 when profiling gets enabled at EL0.
> > > > >
> > > > > Not saying we necessarily should, but this is possible with FGT no?
> > > >
> > > > It doesn't look to me like FEAT_FGT offers any knobs to trap ERET from
> > > > EL1.
> > > 
> > > See HFGITR.ERET.
> > 
> > Ah, so that's the register, thanks!
> > 
> > I stil am not sure that having FEAT_SPE, an Armv8.3 extension, depend on
> > FEAT_FGT, an Armv8.6 extension, is the best idea. Do you know of any
> > machines
> > that have FEAT_SPE and FEAT_FGT?
> 
> None. Both are pretty niche, and the combination is nowhere
> to be seen at the moment.

That was also my impression.

> 
> > On the plus side, KVM could enable the trap only in the case above, and
> > disable
> > it after the ERET is trapped, so it should be relatively cheap to use.
> 
> This feels pretty horrible. Nothing says *when* will EL1
> alter the PTs. It could take tons of EL1->EL1 exceptions
> before returning to EL0. And the change could happen after
> an EL1->EL0->EL1 transition. At which point do you stop?

ERET trapping is enabled When PMBLIMITR_EL1.E = 1, PMSCR_EL1.{E0SPE,E1SPE}
= {1,0}. The first guest ERET from EL1 to EL0 enables profiling, at which
point the buffer is pinned and ERET trapping is disabled.

Guest messing with the translation tables while profiling is enabled is the
guest's problem because that's not permitted by the architecture. Any stage
2 dabt taken when the buffer is pinned would be injected back into the
guest as an SPE external abort (or something equivalent). Stage 1 dabts are
entirely the guest's problem to solve and would be injected back regardless
of the status of the buffer.

Yes, I agree, there could be a lot of ERETs from EL1 to EL1 before the ERET
to EL0; those ERETs would be uselessly trapped.

The above is a moot point anyway, because I believe we both agree that
having SPE emulation depend on FEAT_FGT is best to be avoided.

Thanks,
Alex

> 
> If you want to rely on ERET for that, you need to trap
> ERET all the time, because all ERETs to EL0 will be
> suspect. And doing that to handle such a corner case feels
> pretty horrible.
> 
>         M.
> -- 
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
