Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB8B4C04A68
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jul 2022 10:43:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F3634BB41;
	Wed, 27 Jul 2022 06:43:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fpi-01szQ+Qe; Wed, 27 Jul 2022 06:43:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E15F24C366;
	Wed, 27 Jul 2022 06:43:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E2FC4C2EC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 06:43:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8spYQgvpW+g7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Jul 2022 06:43:36 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A23CB4C23E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 06:43:36 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8ADA215BF;
 Wed, 27 Jul 2022 03:43:36 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EE9C93F70D;
 Wed, 27 Jul 2022 03:43:34 -0700 (PDT)
Date: Wed, 27 Jul 2022 11:44:15 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: KVM/arm64: SPE: Translate VA to IPA on a stage 2 fault instead
 of pinning VM memory
Message-ID: <YuEW/zEjnddcRFad@monolith.localdoman>
References: <Yl6+JWaP+mq2Nc0b@monolith.localdoman>
 <20220419141012.GB6143@willie-the-truck>
 <Yt5nFAscgrRGNGoH@monolith.localdoman>
 <YuApmZFdZzTi5ROu@google.com>
 <YuERKEjJh1qsZf8x@monolith.localdoman>
 <04dea801e298374fb783bf0760b15241@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <04dea801e298374fb783bf0760b15241@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On Wed, Jul 27, 2022 at 11:29:03AM +0100, Marc Zyngier wrote:
> On 2022-07-27 11:19, Alexandru Elisei wrote:
> > Hi Oliver,
> > 
> > Thank you for the help, replies below.
> > 
> > On Tue, Jul 26, 2022 at 10:51:21AM -0700, Oliver Upton wrote:
> > > Hi Alex,
> > > 
> > > On Mon, Jul 25, 2022 at 11:06:24AM +0100, Alexandru Elisei wrote:
> > > 
> > > [...]
> > > 
> > > > > A funkier approach might be to defer pinning of the buffer until the SPE is
> > > > > enabled and avoid pinning all of VM memory that way, although I can't
> > > > > immediately tell how flexible the architecture is in allowing you to cache
> > > > > the base/limit values.
> > > >
> > > > I was investigating this approach, and Mark raised a concern that I think
> > > > might be a showstopper.
> > > >
> > > > Let's consider this scenario:
> > > >
> > > > Initial conditions: guest at EL1, profiling disabled (PMBLIMITR_EL1.E = 0,
> > > > PMBSR_EL1.S = 0, PMSCR_EL1.{E0SPE,E1SPE} = {0,0}).
> > > >
> > > > 1. Guest programs the buffer and enables it (PMBLIMITR_EL1.E = 1).
> > > > 2. Guest programs SPE to enable profiling at **EL0**
> > > > (PMSCR_EL1.{E0SPE,E1SPE} = {1,0}).
> > > > 3. Guest changes the translation table entries for the buffer. The
> > > > architecture allows this.
> > > > 4. Guest does an ERET to EL0, thus enabling profiling.
> > > >
> > > > Since KVM cannot trap the ERET to EL0, it will be impossible for KVM to pin
> > > > the buffer at stage 2 when profiling gets enabled at EL0.
> > > 
> > > Not saying we necessarily should, but this is possible with FGT no?
> > 
> > It doesn't look to me like FEAT_FGT offers any knobs to trap ERET from
> > EL1.
> 
> See HFGITR.ERET.

Ah, so that's the register, thanks!

I stil am not sure that having FEAT_SPE, an Armv8.3 extension, depend on
FEAT_FGT, an Armv8.6 extension, is the best idea. Do you know of any machines
that have FEAT_SPE and FEAT_FGT?

On the plus side, KVM could enable the trap only in the case above, and disable
it after the ERET is trapped, so it should be relatively cheap to use.

Thanks,
Alex

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
