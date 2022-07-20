Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47408C43334
	for <kvmarm@archiver.kernel.org>; Wed, 20 Jul 2022 09:20:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C5124CEB9;
	Wed, 20 Jul 2022 05:20:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wCpbs-9mWfPn; Wed, 20 Jul 2022 05:20:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 176124CF4B;
	Wed, 20 Jul 2022 05:20:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59A2E4CF1F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 05:20:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qkXeN4qO616c for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Jul 2022 05:20:31 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E3A824CD0D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 05:20:30 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 8B0EA61A44;
 Wed, 20 Jul 2022 09:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D1AC3411E;
 Wed, 20 Jul 2022 09:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1658308829;
 bh=3GHd8vof4nhssiWUSqwdA2r5vBodnzZ4EUiCJRdlg7M=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=LOxhH2FKf2NgoagsncMJKhZO1A2y4NSot5rdy4FrOTOOeVNQdcyZEi1UkJvQjCd4x
 Caz+XgaFjLzID0JAxjvfcuQs1GaB4L26xyg9FAGuED5Bg0tOP0YdPdmQjMFIxUPzIF
 h1PzFR6sNfrw+gA6ZiwIypFdS501E54t7HjdLdb46YjsVmIj148CevmPZoKm/XAc9I
 KzhRDhiPfw+LHqHrWfhCyIJcjqDdGb4ibqckhnDm85K+C0ir0qQDWvw98I/H0CBIgb
 t62G9/iSp/dQea5u4N8HHBmy1w0W3oGow1LxB7c3BwGExeo3DWQ+NItj9d8dXHA1ny
 bCTpFV/QdBtDA==
Date: Wed, 20 Jul 2022 10:20:23 +0100
From: Will Deacon <will@kernel.org>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2 7/7] arm64/sve: Don't zero non-FPSIMD register state
 on syscall by default
Message-ID: <20220720092022.GB15752@willie-the-truck>
References: <20220620124158.482039-1-broonie@kernel.org>
 <20220620124158.482039-8-broonie@kernel.org>
 <YtbraaDE0eJhRHkx@arm.com> <YtcHkkwiDZTEpWrZ@sirena.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YtcHkkwiDZTEpWrZ@sirena.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Zhang Lei <zhang.lei@jp.fujitsu.com>, Andre Przywara <andre.przywara@arm.com>,
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

On Tue, Jul 19, 2022 at 08:35:46PM +0100, Mark Brown wrote:
> On Tue, Jul 19, 2022 at 06:35:37PM +0100, Catalin Marinas wrote:
> > On Mon, Jun 20, 2022 at 01:41:58PM +0100, Mark Brown wrote:
> 
> > > The documented syscall ABI specifies that the SVE state not shared with
> > > FPSIMD is undefined after a syscall. Currently we implement this by
> > > always flushing this register state to zero, ensuring consistent
> > > behaviour but introducing some overhead in the case where we can return
> > > directly to userspace without otherwise needing to update the register
> > > state. Take advantage of the flexibility offered by the documented ABI
> > > and instead leave the SVE registers untouched in the case where can
> > > return directly to userspace.
> 
> > Do you have some rough numbers to quantify the gain? I suspect the
> > vector length doesn't matter much.
> 
> I got some benchmarking done with fp-pidbench (which like I think I say
> somewhere in the series is a nonsense benchmark but still) which showed
> an IIRC approximately 1% or so win from a similar change that was fairly
> consistent over a few implementations.  Unfortunately I don't yet have
> access to systems that would allow me to benchmark directly and
> nobody's got back with numbers for this specific code, the numbers were
> with some earlier proof of concept work.
> 
> There is some vector length dependency when we move over 128 bits, at
> 128 bits there's no state in the Z registers that isn't shared with the
> V registers so we can and do already skip handling them entirely which
> makes the overhead of zeroing noticably lower, beyond that the cost
> should be stable.  The additional cost for the Z registers was *about*
> the same as that of just doing the P registers IIRC, that does track
> with doing an additional 32 floating point operations.
> 
> 128 bit systems are in general a bit of a special case for optimisation
> due to the reduced extra state.
> 
> > Where does the zeroing happen now? IIRC it's only done on a subsequent
> > trap to SVE and that's a lot more expensive (unless the code has changed
> > since last time I looked).
> 
> At the minute we drop SVE permission for userspace on syscall entry, the
> actual zeroing for the task happens when it next takes a SVE trap prior
> to reenabling SVE for EL0.
> 
> > So if it's the actual subsequent trap that adds the overhead, maybe
> > zeroing the regs while leaving TIF_SVE on won't be that bad.
> 
> Yeah, it's definitely *much* less exciting than the win from avoiding
> the SVE trap.
> 
> > > The sysctl is disabled by default since it is anticipated that the risk
> > > of disruption to userspace is low. As well as being within the
> > > documented ABI this new behaviour mirrors the standard function call ABI
> > > for SVE in the AAPCS which should mean that compiler generated code is
> > > unlikely to rely on the current behaviour, the main risk is from hand
> > > coded assembly which directly invokes syscalls. The new behaviour is
> > > also what is currently implemented by qemu user mode emulation.
> 
> > IIRC both Will and Mark R commented in the past that they'd like the
> > current de-facto ABI to become the official one. I'll let them comment.
> 
> That would be good.  I've not heard anything from Will either directly
> or indirectly.  Mark R has indicated privately directly to me that he
> originally pushed for the currently implemented behaviour and prefers
> it.  Marc Zyngier has previously noted publicly the current behaviour
> being a consideration in the context of discusion of optimisation ideas
> like this one, I was a bit surprised that he commented on an earlier
> patch in the series but not this one.  You have previously pushed back
> on an attempt to document the current ABI, that was the main motivation
> for writing this patch.

I remember discussing this somewhere at some point with somebody, but that's
not a tonne of use!

My opinion is that the observable behaviour is what matters. So if we
documented that the register state is "undefined" but it is in fact always
zero, then we should fix the documentation.

Does that help?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
