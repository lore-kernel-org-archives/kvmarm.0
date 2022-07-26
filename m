Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31EA0C3F6B0
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jul 2022 17:51:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 742894C852;
	Tue, 26 Jul 2022 13:51:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Utkiy0iv+jzF; Tue, 26 Jul 2022 13:51:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 327814C867;
	Tue, 26 Jul 2022 13:51:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C05784C861
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 13:51:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4JV6puz-bdLe for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jul 2022 13:51:28 -0400 (EDT)
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 798434C826
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 13:51:28 -0400 (EDT)
Date: Tue, 26 Jul 2022 10:51:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1658857887;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=OFOfoXl3zEfeVlgbwtYDBuwQbWx4XqMWyRDwVaLsCxU=;
 b=uhXixPrJ1v82f8m4M0HRE1A8VygfoC+9xjXbxlngwjCK6D0/IlLdav6Siom+xCTIcJFgPP
 SuguGjP8B59u8zFJ3+AqY0ASexsKWSdy/xHBLUkC/rqpvtT6Q+UYYQ2DMFYMcJrRLHmneJ
 majEyl3oEcA72Zo8te/D6EwqWTk/H0M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: KVM/arm64: SPE: Translate VA to IPA on a stage 2 fault instead
 of pinning VM memory
Message-ID: <YuApmZFdZzTi5ROu@google.com>
References: <Yl6+JWaP+mq2Nc0b@monolith.localdoman>
 <20220419141012.GB6143@willie-the-truck>
 <Yt5nFAscgrRGNGoH@monolith.localdoman>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Yt5nFAscgrRGNGoH@monolith.localdoman>
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

On Mon, Jul 25, 2022 at 11:06:24AM +0100, Alexandru Elisei wrote:

[...]

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
> 4. Guest does an ERET to EL0, thus enabling profiling.
> 
> Since KVM cannot trap the ERET to EL0, it will be impossible for KVM to pin
> the buffer at stage 2 when profiling gets enabled at EL0.

Not saying we necessarily should, but this is possible with FGT no?

> I can see two solutions here:
> 
> a. Accept the limitation (and advertise it in the documentation) that if
> someone wants to use SPE when running as a Linux guest, the kernel used by
> the guest must not change the buffer translation table entries after the
> buffer has been enabled (PMBLIMITR_EL1.E = 1). Linux already does that, so
> running a Linux guest should not be a problem. I don't know how other OSes
> do it (but I can find out). We could also phrase it that the buffer
> translation table entries can be changed after enabling the buffer, but
> only if profiling happens at EL1. But that sounds very arbitrary.
> 
> b. Pin the buffer after the stage 2 DABT that SPE will report in the
> situation above. This means that there is a blackout window, but will
> happen only once after each time the guest reprograms the buffer. I don't
> know if this is acceptable. We could say that this if this blackout window
> is not acceptable, then the guest kernel shouldn't change the translation
> table entries after enabling the buffer.
> 
> Or drop the approach of pinning the buffer and go back to pinning the
> entire memory of the VM.
> 
> Any thoughts on this? I would very much prefer to try to pin only the
> buffer.

Doesn't pinning the buffer also imply pinning the stage 1 tables
responsible for its translation as well? I agree that pinning the buffer
is likely the best way forward as pinning the whole of guest memory is
entirely impractical.

I'm also a bit confused on how we would manage to un-pin memory on the
way out with this. The guest is free to muck with the stage 1 and could
cause the SPU to spew a bunch of stage 2 aborts if it wanted to be
annoying. One way to tackle it would be to only allow a single
root-to-target walk to be pinned by a vCPU at a time. Any time a new
stage 2 abort comes from the SPU, we un-pin the old walk and pin the new
one instead.

Live migration also throws a wrench in this. IOW, there are still potential
sources of blackout unattributable to guest manipulation of the SPU.

Going to think on this some more..

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
