Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C51BEC19F29
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jul 2022 11:08:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 499934C469;
	Wed, 27 Jul 2022 07:08:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JKFdH3X3W3wV; Wed, 27 Jul 2022 07:08:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2956C4C450;
	Wed, 27 Jul 2022 07:08:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 729FD4C450
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 07:08:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ppfAGeZ4eqxF for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Jul 2022 07:08:15 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4CD554C44F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 07:08:15 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 61B57618DE;
 Wed, 27 Jul 2022 11:08:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC34EC433D6;
 Wed, 27 Jul 2022 11:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1658920093;
 bh=/jm3uoWxQ93coGguDiiUwoPxQE3ySaLLej5txbbt3lA=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=MciHgpjfW0CO6bUDMqxKlYFXhwrd/djSZf1DeInnqKp3jQ6R3fY+FGPOr5Re9I3Ik
 A4PpWkVyGsCzcImxpqGXYBsMm7OIG8A0gufWfuEJbjCcr4rpU5qzVF1cWHBGkaGxab
 sCykimfoGGoZC3kGPntUWlGSgOw338ySgSHd8qylz12J40iegFGxCiR1VIGt3ELHDj
 VKclQMb3Rl5y4i9S6WxLjiX6DAv0A/ydaT2N/Rp673SgUCvj0jBS4U8eKxHDzhAnYP
 FKN2jBZ6nUX1FvI9HjcqWWqhtd6rQPAFBvM2PA52u8szadGP5KKjFZj/HMxpH/L/i7
 bDwsEzAMl0C6Q==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oGetf-00ANZ2-HE;
 Wed, 27 Jul 2022 12:08:11 +0100
MIME-Version: 1.0
Date: Wed, 27 Jul 2022 12:08:11 +0100
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: KVM/arm64: SPE: Translate VA to IPA on a stage 2 fault instead of
 pinning VM memory
In-Reply-To: <YuEW/zEjnddcRFad@monolith.localdoman>
References: <Yl6+JWaP+mq2Nc0b@monolith.localdoman>
 <20220419141012.GB6143@willie-the-truck>
 <Yt5nFAscgrRGNGoH@monolith.localdoman> <YuApmZFdZzTi5ROu@google.com>
 <YuERKEjJh1qsZf8x@monolith.localdoman>
 <04dea801e298374fb783bf0760b15241@kernel.org>
 <YuEW/zEjnddcRFad@monolith.localdoman>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <2d1f87576ce17b8c72bfac522e2aa101@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com,
 linux-arm-kernel@lists.infradead.org, will@kernel.org,
 kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2022-07-27 11:44, Alexandru Elisei wrote:
> On Wed, Jul 27, 2022 at 11:29:03AM +0100, Marc Zyngier wrote:
>> On 2022-07-27 11:19, Alexandru Elisei wrote:
>> > Hi Oliver,
>> >
>> > Thank you for the help, replies below.
>> >
>> > On Tue, Jul 26, 2022 at 10:51:21AM -0700, Oliver Upton wrote:
>> > > Hi Alex,
>> > >
>> > > On Mon, Jul 25, 2022 at 11:06:24AM +0100, Alexandru Elisei wrote:
>> > >
>> > > [...]
>> > >
>> > > > > A funkier approach might be to defer pinning of the buffer until the SPE is
>> > > > > enabled and avoid pinning all of VM memory that way, although I can't
>> > > > > immediately tell how flexible the architecture is in allowing you to cache
>> > > > > the base/limit values.
>> > > >
>> > > > I was investigating this approach, and Mark raised a concern that I think
>> > > > might be a showstopper.
>> > > >
>> > > > Let's consider this scenario:
>> > > >
>> > > > Initial conditions: guest at EL1, profiling disabled (PMBLIMITR_EL1.E = 0,
>> > > > PMBSR_EL1.S = 0, PMSCR_EL1.{E0SPE,E1SPE} = {0,0}).
>> > > >
>> > > > 1. Guest programs the buffer and enables it (PMBLIMITR_EL1.E = 1).
>> > > > 2. Guest programs SPE to enable profiling at **EL0**
>> > > > (PMSCR_EL1.{E0SPE,E1SPE} = {1,0}).
>> > > > 3. Guest changes the translation table entries for the buffer. The
>> > > > architecture allows this.
>> > > > 4. Guest does an ERET to EL0, thus enabling profiling.
>> > > >
>> > > > Since KVM cannot trap the ERET to EL0, it will be impossible for KVM to pin
>> > > > the buffer at stage 2 when profiling gets enabled at EL0.
>> > >
>> > > Not saying we necessarily should, but this is possible with FGT no?
>> >
>> > It doesn't look to me like FEAT_FGT offers any knobs to trap ERET from
>> > EL1.
>> 
>> See HFGITR.ERET.
> 
> Ah, so that's the register, thanks!
> 
> I stil am not sure that having FEAT_SPE, an Armv8.3 extension, depend 
> on
> FEAT_FGT, an Armv8.6 extension, is the best idea. Do you know of any 
> machines
> that have FEAT_SPE and FEAT_FGT?

None. Both are pretty niche, and the combination is nowhere
to be seen at the moment.

> On the plus side, KVM could enable the trap only in the case above, and 
> disable
> it after the ERET is trapped, so it should be relatively cheap to use.

This feels pretty horrible. Nothing says *when* will EL1
alter the PTs. It could take tons of EL1->EL1 exceptions
before returning to EL0. And the change could happen after
an EL1->EL0->EL1 transition. At which point do you stop?

If you want to rely on ERET for that, you need to trap
ERET all the time, because all ERETs to EL0 will be
suspect. And doing that to handle such a corner case feels
pretty horrible.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
